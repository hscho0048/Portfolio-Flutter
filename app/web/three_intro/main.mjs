import * as THREE from "three";
import { GLTFLoader } from "three/addons/loaders/GLTFLoader.js";
import { RoomEnvironment } from "three/addons/environments/RoomEnvironment.js";

const ASSETS = {
  glass: "./glass_tiles_v6.glb",
  hero: "./hero_rig_idle_walk.glb",
};

const canvas = document.querySelector("#scene");
const status = document.querySelector("#status");
const HERO_GROUND_Y = -1.55;

const scene = new THREE.Scene();
scene.background = new THREE.Color(0xf7faf6);
scene.fog = new THREE.FogExp2(0xf7faf6, 0.012);

const camera = new THREE.PerspectiveCamera(42, 1, 0.1, 80);
camera.position.set(0, 1.45, 14.2);
camera.lookAt(0, 1.05, 0.8);

const renderer = new THREE.WebGLRenderer({
  canvas,
  antialias: true,
  powerPreference: "high-performance",
});
renderer.outputColorSpace = THREE.SRGBColorSpace;
renderer.toneMapping = THREE.ACESFilmicToneMapping;
renderer.toneMappingExposure = 1.05;
renderer.shadowMap.enabled = true;
renderer.shadowMap.type = THREE.PCFSoftShadowMap;

const pmrem = new THREE.PMREMGenerator(renderer);
scene.environment = pmrem.fromScene(new RoomEnvironment(), 0.04).texture;

const loader = new GLTFLoader();
const clock = new THREE.Clock();
const raycaster = new THREE.Raycaster();
const pointer = new THREE.Vector2(0, 0);
const targetPosition = new THREE.Vector3(0, HERO_GROUND_Y, 3.2);
const previousPosition = new THREE.Vector3();

let floorPivot;
let glassPivot;
let heroPivot;
let mixer;
let idleAction;
let walkAction;
let activeAction;
let hoveredTile;
const glassTileGroups = [];
const hoverTargets = [];

addLighting();
loadScene();
resize();
animate();

window.addEventListener("resize", resize);
window.addEventListener("pointermove", updatePointerTarget, { passive: true });
window.addEventListener("pointerdown", updatePointerTarget, { passive: true });

function addLighting() {
  const hemi = new THREE.HemisphereLight(0xcff7ed, 0x18221e, 1.25);
  scene.add(hemi);

  const key = new THREE.DirectionalLight(0xffffff, 3.4);
  key.position.set(-4.2, 6.2, 4.6);
  key.castShadow = true;
  key.shadow.mapSize.set(2048, 2048);
  key.shadow.camera.near = 0.5;
  key.shadow.camera.far = 18;
  key.shadow.camera.left = -5;
  key.shadow.camera.right = 5;
  key.shadow.camera.top = 5;
  key.shadow.camera.bottom = -4;
  scene.add(key);

  const rim = new THREE.PointLight(0x9fffe9, 3.8, 8);
  rim.position.set(2.8, 1.8, 4.2);
  scene.add(rim);
}

async function loadScene() {
  try {
    const [glassGltf, heroGltf] = await Promise.all([
      loader.loadAsync(ASSETS.glass),
      loader.loadAsync(ASSETS.hero),
    ]);

    addGlassTiles(glassGltf.scene);
    addHero(heroGltf);
    status.classList.add("is-hidden");
  } catch (error) {
    console.error(error);
    status.textContent = "Load failed";
  }
}

function addGlassTiles(model) {
  glassPivot = new THREE.Group();
  glassPivot.position.set(0, 1.65, -1.2);
  scene.add(glassPivot);

  const floorParts = [];
  model.traverse((child) => {
    if (child.name === "Floor_Shadow" || child.material?.name === "Mat_Floor") {
      floorParts.push(child);
    }
  });
  floorParts.forEach((part) => part.removeFromParent());
  addFloorPlate(floorParts);

  centerModel(model);
  fitModel(model, { maxWidth: 6.2, maxHeight: 3.35 });
  groupHoverTiles(model);

  model.traverse((child) => {
    if (!child.isMesh) return;
    child.material = Array.isArray(child.material)
      ? child.material.map(tuneGlassMaterial)
      : tuneGlassMaterial(child.material);
    child.castShadow = false;
    child.receiveShadow = false;
    child.renderOrder = 0;
  });

  glassPivot.add(model);
}

function addFloorPlate(parts) {
  floorPivot = new THREE.Group();
  floorPivot.position.set(0, HERO_GROUND_Y, 5.35);
  floorPivot.scale.set(0.24, 0.145, 0.2);
  scene.add(floorPivot);

  parts.forEach((part) => {
    part.position.set(0, 0, 0);
    part.rotation.set(0, 0, 0);
    part.scale.set(1, 1, 1);
    part.material = new THREE.MeshStandardMaterial({
      color: 0x9fb3a9,
      transparent: true,
      opacity: 0.52,
      roughness: 0.76,
      metalness: 0,
      side: THREE.DoubleSide,
    });
    part.castShadow = false;
    part.receiveShadow = true;
    floorPivot.add(part);
  });
}

function addHero(gltf) {
  heroPivot = new THREE.Group();
  heroPivot.position.copy(targetPosition);
  scene.add(heroPivot);

  const model = gltf.scene;
  centerModel(model);
  fitModel(model, { maxHeight: 1.85 });
  placeModelOnGround(model);
  model.rotation.y = -Math.PI / 2;

  model.traverse((child) => {
    if (!child.isMesh) return;
    child.castShadow = true;
    child.receiveShadow = false;
    if (child.material) {
      child.material = child.material.clone();
      child.material.roughness = Math.min(child.material.roughness ?? 0.55, 0.62);
      child.material.envMapIntensity = 1.2;
    }
  });

  heroPivot.add(model);
  setupAnimations(gltf, model);
}

function setupAnimations(gltf, model) {
  if (!gltf.animations.length) return;

  mixer = new THREE.AnimationMixer(model);
  const clips = gltf.animations;
  const idleClip = clips.find((clip) => /idle/i.test(clip.name)) ?? clips[0];
  const walkClip =
    clips.find((clip) => /walk|run/i.test(clip.name)) ?? clips[1] ?? idleClip;

  idleAction = mixer.clipAction(idleClip);
  walkAction = mixer.clipAction(walkClip);
  idleAction.timeScale = 1;
  walkAction.timeScale = 1.75;

  idleAction.play();
  activeAction = idleAction;
}

function updatePointerTarget(event) {
  pointer.x = (event.clientX / window.innerWidth) * 2 - 1;
  pointer.y = -(event.clientY / window.innerHeight) * 2 + 1;

  const xLimit = window.innerWidth < 720 ? 1.7 : 3.35;
  targetPosition.set(
    THREE.MathUtils.clamp(pointer.x * xLimit, -xLimit, xLimit),
    HERO_GROUND_Y,
    THREE.MathUtils.clamp(3.55 - pointer.y * 1.9, 1.85, 5.85),
  );
  updateHoverTarget();
}

function animate() {
  requestAnimationFrame(animate);

  const delta = Math.min(clock.getDelta(), 0.033);
  const elapsed = clock.elapsedTime;

  if (mixer) mixer.update(delta);
  updateHero(delta);
  updateGlass(elapsed, delta);
  updateCamera(delta);
  updateHoverTarget();

  renderer.render(scene, camera);
}

function updateHero(delta) {
  if (!heroPivot) return;

  previousPosition.copy(heroPivot.position);
  heroPivot.position.lerp(targetPosition, 1 - Math.exp(-delta * 11));

  const movement = heroPivot.position.clone().sub(previousPosition);
  const isWalking = heroPivot.position.distanceTo(targetPosition) > 0.055;

  if (movement.lengthSq() > 0.000001) {
    const targetYaw = Math.atan2(movement.x, movement.z);
    heroPivot.rotation.y = dampAngle(heroPivot.rotation.y, targetYaw, 11, delta);
  }

  setMotionAction(isWalking);
}

function updateGlass(elapsed, delta) {
  if (!glassPivot) return;

  glassPivot.rotation.x = Math.sin(elapsed * 0.45) * 0.015;
  glassPivot.rotation.y = Math.sin(elapsed * 0.28) * 0.025;
  glassPivot.position.x = 0;
  glassPivot.position.y = 1.65;

  glassTileGroups.forEach((group) => {
    const targetScale = group === hoveredTile ? 2.35 : 1;
    const targetZ = group === hoveredTile ? 0.9 : 0;
    const nextScale = THREE.MathUtils.lerp(
      group.scale.x,
      targetScale,
      1 - Math.exp(-delta * 12),
    );
    group.scale.setScalar(nextScale);
    group.position.z = THREE.MathUtils.lerp(
      group.position.z,
      targetZ,
      1 - Math.exp(-delta * 12),
    );
  });
}

function updateCamera(delta) {
  camera.position.x += (0 - camera.position.x) * (1 - Math.exp(-delta * 2.8));
  camera.position.y += (1.45 - camera.position.y) * (1 - Math.exp(-delta * 2.8));
  camera.lookAt(0, 1.05, 0.9);
}

function setMotionAction(isWalking) {
  if (!idleAction || !walkAction) return;

  const nextAction = isWalking ? walkAction : idleAction;
  if (nextAction === activeAction) return;

  nextAction.reset().fadeIn(0.18).play();
  activeAction.fadeOut(0.18);
  activeAction = nextAction;
}

function tuneGlassMaterial(material) {
  const clone = material ? material.clone() : new THREE.MeshPhysicalMaterial();

  clone.transparent = true;
  clone.opacity = Math.min(clone.opacity ?? 1, 0.58);
  clone.depthWrite = false;
  clone.side = THREE.DoubleSide;
  clone.envMapIntensity = 2.2;

  if ("roughness" in clone) clone.roughness = 0.08;
  if ("metalness" in clone) clone.metalness = 0;
  if ("transmission" in clone) clone.transmission = 0.42;
  if ("thickness" in clone) clone.thickness = 0.22;
  if ("ior" in clone) clone.ior = 1.42;
  if ("clearcoat" in clone) clone.clearcoat = 0.8;
  if ("clearcoatRoughness" in clone) clone.clearcoatRoughness = 0.1;

  return clone;
}

function groupHoverTiles(model) {
  const pairs = new Map();

  model.children.forEach((child) => {
    const match = child.name.match(/(?:Tile|Icon)_(\d+)/);
    if (!match) return;

    const key = match[1];
    const pair = pairs.get(key) ?? {};
    if (child.name.startsWith("Tile_")) pair.tile = child;
    if (child.name.startsWith("Icon_")) pair.icon = child;
    pairs.set(key, pair);
  });

  pairs.forEach(({ tile, icon }, key) => {
    if (!tile) return;

    const group = new THREE.Group();
    group.name = `HoverTile_${key}`;
    group.position.copy(tile.position);

    [tile, icon].filter(Boolean).forEach((part) => {
      part.position.sub(group.position);
      part.userData.tileGroup = group;
      group.add(part);
      if (part.isMesh) hoverTargets.push(part);
    });

    glassTileGroups.push(group);
    model.add(group);
  });
}

function updateHoverTarget() {
  if (!hoverTargets.length) return;

  raycaster.setFromCamera(pointer, camera);
  const hit = raycaster.intersectObjects(hoverTargets, true)[0];
  hoveredTile = hit?.object.userData.tileGroup ?? null;
  canvas.style.cursor = hoveredTile ? "pointer" : "default";
}

function resize() {
  const width = window.innerWidth;
  const height = window.innerHeight;

  camera.aspect = width / height;
  camera.position.z = width < 720 ? 17.2 : 14.2;
  camera.updateProjectionMatrix();

  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  renderer.setSize(width, height, false);
}

function centerModel(model) {
  const box = new THREE.Box3().setFromObject(model);
  const center = box.getCenter(new THREE.Vector3());
  model.position.sub(center);
}

function fitModel(model, { maxWidth = Infinity, maxHeight = Infinity }) {
  const box = new THREE.Box3().setFromObject(model);
  const size = box.getSize(new THREE.Vector3());
  const scale = Math.min(maxWidth / size.x, maxHeight / size.y);

  if (Number.isFinite(scale) && scale > 0) {
    model.scale.multiplyScalar(scale);
  }
}

function placeModelOnGround(model) {
  model.updateMatrixWorld(true);
  const box = new THREE.Box3().setFromObject(model);
  model.position.y -= box.min.y;
}

function dampAngle(current, target, lambda, delta) {
  const difference = Math.atan2(Math.sin(target - current), Math.cos(target - current));
  return current + difference * (1 - Math.exp(-lambda * delta));
}
