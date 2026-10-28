'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "92c74d794b8b3ec90b90dc4be8a71d14",
"assets/AssetManifest.bin.json": "257409b67653cc476ed615586616af5b",
"assets/AssetManifest.json": "78746e7e18bb5b309eb52e9c1b6d7056",
"assets/assets/devicons/amazonwebservices-original-wordmark.svg": "4c6edca3d26fd0dcd787fab65402b234",
"assets/assets/devicons/arduino-original.svg": "6d59ba92c7457b20b65d594bbde1e630",
"assets/assets/devicons/chartjs-original.svg": "4d8c9b1f1707db8a5476ac16e12a0ba4",
"assets/assets/devicons/cplusplus-original.svg": "6f2a76ffb3b72fcb544ed350170ffeae",
"assets/assets/devicons/d3js-original.svg": "ae36d2e0268a7ea331ceafe8d962abef",
"assets/assets/devicons/docker-original.svg": "1380befa46d4027b411bc47b093424a9",
"assets/assets/devicons/electron-original.svg": "96f652cebdd5b09b43b814b826de79f2",
"assets/assets/devicons/express-original.svg": "8260c0cc847a9414de1325084f425404",
"assets/assets/devicons/fastapi-original.svg": "a86396c8e01664c1c0033edb539f4ce4",
"assets/assets/devicons/figma-original.svg": "c7ef676648d0a63907b26420105ed20d",
"assets/assets/devicons/flask-original.svg": "318c795b48bf389a0ff4bd7951bcbe45",
"assets/assets/devicons/githubactions-original.svg": "9fba1b3f5112ab6a5ba81f44a9ef87b3",
"assets/assets/devicons/googlecloud-original.svg": "39c69ecb9f7f2581ee35b6b895e026c4",
"assets/assets/devicons/hardhat-original.svg": "737e57285b7eef05ec653a6d8cca55c3",
"assets/assets/devicons/html5-original.svg": "16d07e8682a531f3bc1e9fb01bd59740",
"assets/assets/devicons/java-original.svg": "459bbae2e96a2410c5b429eb941a4c11",
"assets/assets/devicons/javascript-original.svg": "0c1f700da144243c526f252e59362138",
"assets/assets/devicons/jquery-original.svg": "29614680c75d411ee61bb2d4ecedcd94",
"assets/assets/devicons/k3s-original.svg": "a6eee89aad0e55a1437f0448f4c4f0b4",
"assets/assets/devicons/keras-original.svg": "a6bf39c3090677c6d9e3be0088cac5f7",
"assets/assets/devicons/kubernetes-original.svg": "a059eff5b8a8c40dd1e067bf33d132ef",
"assets/assets/devicons/mongodb-original.svg": "8aad4da2ed641d2378923f85fe35189d",
"assets/assets/devicons/mysql-original.svg": "e390b8eabf8854596742b62129201741",
"assets/assets/devicons/nextjs-original.svg": "0030748cf6df92120617519a85106342",
"assets/assets/devicons/nginx-original.svg": "5a22dba00debfc428e4449886686afb6",
"assets/assets/devicons/nodejs-original.svg": "bfd96b0662522e3d16db3f6a6e7f5585",
"assets/assets/devicons/notion-original.svg": "401a3ba9e360d4ed28bd77a0c0372f44",
"assets/assets/devicons/npm-original.svg": "eac19835e19323161193e345a2a4fcd3",
"assets/assets/devicons/openapi-original.svg": "ed169a405732c4929380f5be1aec2772",
"assets/assets/devicons/opencv-original.svg": "d8f8ce3991482e25f580280b28cad087",
"assets/assets/devicons/pandas-original.svg": "2ba8409965769ecc334c41622e58d63c",
"assets/assets/devicons/postcss-original.svg": "4ad5cc757cddfb95bfdbd680e4194f38",
"assets/assets/devicons/python-original.svg": "19816abc24d61b6c0cf28814ba9394ab",
"assets/assets/devicons/pytorch-original.svg": "f4d14651535fd5a2b92f973caa40d21d",
"assets/assets/devicons/raspberrypi-original.svg": "d6e1d1d619c2b7b17410117953b1b8f5",
"assets/assets/devicons/react-original.svg": "4f81f37c8c72270f6c343b8814c10ea8",
"assets/assets/devicons/redis-original.svg": "7feaace40cd0e23c42092c9735032471",
"assets/assets/devicons/rust-original.svg": "993b3555224d8cb1aa8cdea46733c62c",
"assets/assets/devicons/scikitlearn-original.svg": "12455dff8d0e70d2d55cd8145dee1db6",
"assets/assets/devicons/solidity-original.svg": "876fcea0785fb0bfeaffe5f994b76b3b",
"assets/assets/devicons/spring-original.svg": "ebc243468a6fcc9c2c86a6b55a2b6455",
"assets/assets/devicons/tailwindcss-original.svg": "d7d7dab40ebc4625b7b885da451168e3",
"assets/assets/devicons/tauri-original.svg": "39bbd367e80f879c8ab0d6d8d158f72b",
"assets/assets/devicons/tensorflow-original.svg": "40000672d48095ab68563d08ca60b127",
"assets/assets/devicons/typescript-original.svg": "c06d3c068de68e5654d05552e26e3452",
"assets/assets/devicons/web3js-original.svg": "c78d01f7210fe9138b036bd2ce8b61ab",
"assets/assets/devicons/zustand-original.svg": "5ae3dfe8aa885eca5cb7a7ecd3d7ce75",
"assets/assets/fontawesome/brands/ethereum.svg": "3c3f45664cb240ba8a76c1ccf9524b5f",
"assets/assets/fontawesome/solid/atom.svg": "ff0923e645e4f2f7e319523a066d6674",
"assets/assets/fontawesome/solid/battery-full.svg": "264cf29887ba7727e9d56f9198b59216",
"assets/assets/fontawesome/solid/bolt.svg": "343f729fbdc919853ad5a44aa1eb16a2",
"assets/assets/fontawesome/solid/brain.svg": "0cfb06f6822b9bb8f03a4fdadc6f03e7",
"assets/assets/fontawesome/solid/chart-line.svg": "1cba17e699d4cda3096b0e2c6b58f38f",
"assets/assets/fontawesome/solid/chart-pie.svg": "6a8dda8d500324ef9beec3602a0fb239",
"assets/assets/fontawesome/solid/clock.svg": "59d90e12d0caaa0998b48c4bff741ac0",
"assets/assets/fontawesome/solid/cloud.svg": "017ab2838deb4b5037c1ca658fb796c0",
"assets/assets/fontawesome/solid/code.svg": "38efd4183b8da74b913fdae6cf001c02",
"assets/assets/fontawesome/solid/coins.svg": "b0f8a091d1bdcdb71742fb6ea3472a77",
"assets/assets/fontawesome/solid/cubes.svg": "b187cc13346c85c43d42112ed08f2fa6",
"assets/assets/fontawesome/solid/database.svg": "961c79a8d170689b5b7b5a9e1407fe6a",
"assets/assets/fontawesome/solid/diagram-project.svg": "b0617398e81f2344f0d8326eb22719f4",
"assets/assets/fontawesome/solid/display.svg": "a4157414e2dba75f1d1a0dda7442155d",
"assets/assets/fontawesome/solid/eye.svg": "1a025e1813cde2b307b2d696bfa9c1bd",
"assets/assets/fontawesome/solid/film.svg": "6a90bf574783a840145066af1753f7bd",
"assets/assets/fontawesome/solid/flask.svg": "e9be9c52e412584470e63e5beb7dbf79",
"assets/assets/fontawesome/solid/gem.svg": "b88536498c7b5f3b151cf5cef754e507",
"assets/assets/fontawesome/solid/globe.svg": "1e85e45a3fa0d3ae59c36b956ac9afcb",
"assets/assets/fontawesome/solid/industry.svg": "a0fb7ca54f527c293b064e3d7a6a3b9a",
"assets/assets/fontawesome/solid/key.svg": "4db418de5d2ec9b80047ffefe20d797b",
"assets/assets/fontawesome/solid/layer-group.svg": "262e0d0d9f58dd6e76ab2a20088591d2",
"assets/assets/fontawesome/solid/magnifying-glass.svg": "0d3b8bd8e3609254627d3395155ccaa5",
"assets/assets/fontawesome/solid/microchip.svg": "058c65a13e21dc5d8c30ae4020945656",
"assets/assets/fontawesome/solid/mobile-screen-button.svg": "d3ba902a5913f8e63b16a64cf0b931e0",
"assets/assets/fontawesome/solid/network-wired.svg": "1e186554cf6a4e938b40c38bd01e669e",
"assets/assets/fontawesome/solid/newspaper.svg": "a09fe6c58e9fa269dc2321c7d88fc2bb",
"assets/assets/fontawesome/solid/plug.svg": "cb1fc054cc4689d38a4af90b728bd95f",
"assets/assets/fontawesome/solid/robot.svg": "efe58bb08a325b5818a99f5b3fc02587",
"assets/assets/fontawesome/solid/ruler-combined.svg": "5cbe4ebb89baeab1cd9555c8ab5c421c",
"assets/assets/fontawesome/solid/server.svg": "da52d72e69e26044641c26bc3f341ab1",
"assets/assets/fontawesome/solid/share-nodes.svg": "a2ccbdf9a8d5e96d12bacc156a5cd554",
"assets/assets/fontawesome/solid/tower-broadcast.svg": "11b09aa09aad0a61a0bd9971020af3cb",
"assets/assets/fontawesome/solid/wallet.svg": "5a1a292122d2ac7df7cf45da2bd622d3",
"assets/assets/fonts/A2Z/A2Z-1Thin.ttf": "fd7d5ca09fd91c1e77ca0922496e2f68",
"assets/assets/fonts/A2Z/A2Z-2ExtraLight.ttf": "99c4f162280303e770699634d91d037b",
"assets/assets/fonts/A2Z/A2Z-3Light.ttf": "28b8dc743fb3d9dba51ba717a487c50d",
"assets/assets/fonts/A2Z/A2Z-4Regular.ttf": "55395802315a533fbd1413dd72690d61",
"assets/assets/fonts/A2Z/A2Z-5Medium.ttf": "a59b5394f1a31429a9f01b8fa70107a6",
"assets/assets/fonts/A2Z/A2Z-6SemiBold.ttf": "4cef1c4409e36affcdbaf5a981940e07",
"assets/assets/fonts/A2Z/A2Z-7Bold.ttf": "a102bcb8aaebe071277e09ec8ffe3814",
"assets/assets/fonts/A2Z/A2Z-8ExtraBold.ttf": "6f83a307af97404d927ceaf27017346a",
"assets/assets/fonts/A2Z/A2Z-9Black.ttf": "0ae99a977ec6fa148e5accd37593ded3",
"assets/assets/hosung.jpg": "343deb3bf929cc88b9872c1434340946",
"assets/assets/remote/projects/architecture/crabpaste-rust-sync-architecture.png": "f97e8c95a73ae5e2969c5dfd70eced99",
"assets/assets/remote/projects/architecture/eoreusim-ai-senior-welfare-platform-architecture.png": "f70d999c8fd72a222e0c1d50f12e4a00",
"assets/assets/remote/projects/architecture/lan-bomber-online-architecture.png": "b88d71b22a8091a69fd798fa62a50f5c",
"assets/assets/remote/projects/architecture/lan-bomber-typescript-realtime-multiplayer-game-architecture.png": "046e9ff3c31a2d9d7843ebb48aaf24cd",
"assets/assets/remote/projects/architecture/meme-insight-ai-crypto-dashboard-architecture.png": "96b88d98d0b2bcb021d89a88b9c05879",
"assets/assets/remote/projects/architecture/portfolio-os-architecture.png": "25f32d2d7a829e895d6913a2650a0c96",
"assets/assets/remote/projects/architecture/seoul-bike-demand-forecast-system-architecture.png": "792729d6b580e4d8265d58ee1ff4170b",
"assets/assets/remote/projects/architecture/snapdragon-energy-150-shots.png": "60167c9990b4ac2475a08c1abf6ad5b2",
"assets/assets/remote/projects/architecture/snapdragon-energy-core-placement.png": "d17b1d0a28d60ca39816b3b9e55ee208",
"assets/assets/remote/projects/architecture/snapdragon-energy-per-shot.png": "3fe6500723c2a6fa251f217f956071b6",
"assets/assets/remote/projects/architecture/snapdragon-energy-sorigul-rails.png": "fb8f8053e52be18c660ab4258c1aa0bb",
"assets/assets/remote/projects/architecture/voda-ai-smart-factory-quality-inspection-architecture.png": "f0b5d9f54b877f9c473dc49ac463fd3c",
"assets/assets/remote/projects/thumbnails/crabpaste-rust-p2p-clipboard-sync.png": "96e5c898748bc0b530e067c7a36ddda2",
"assets/assets/remote/projects/thumbnails/crabpaste-rust-sync.png": "96e5c898748bc0b530e067c7a36ddda2",
"assets/assets/remote/projects/thumbnails/eoreusim-ai-senior-welfare-platform.png": "1c160e622536f8c262e12968b177c66b",
"assets/assets/remote/projects/thumbnails/hearo.png": "5480f4385fad13d416bd55f441cd6c20",
"assets/assets/remote/projects/thumbnails/kyonggi-in-pick-blockchain-voting-dapp.png": "bfa3591b670206c1ef5f5b61cb4467a0",
"assets/assets/remote/projects/thumbnails/lan-bomber-online.png": "f6268914d5b3ed0313e9b6c38d637a3d",
"assets/assets/remote/projects/thumbnails/lan-bomber-typescript-realtime-multiplayer-game.png": "f93e17170a47d2944fd875ec2f4f7c68",
"assets/assets/remote/projects/thumbnails/lg-wa-minimalist-cx-strategy.jpg": "3a0f17275b12f31ab3542d64791b0bcf",
"assets/assets/remote/projects/thumbnails/meme-insight-ai-crypto-dashboard.png": "84c8e9c11fccab811de448c40bdaadd7",
"assets/assets/remote/projects/thumbnails/portfolio-os.png": "a1dd62c4e12e5f7895a10abd65b028ae",
"assets/assets/remote/projects/thumbnails/raw-burst-hdr.png": "628132b32f9dbe236f5ce4a1b6a847ab",
"assets/assets/remote/projects/thumbnails/semiconductor-quality-8d-process-analysis.png": "493dbf7756113f409dc68c984f8b872f",
"assets/assets/remote/projects/thumbnails/seoul-bike-demand-forecast-system.png": "a242753266ad24a4806a2fa240d86eae",
"assets/assets/remote/projects/thumbnails/snapdragon-energy-thumbnail.png": "a6af3b591460f433fa6d57afe3546729",
"assets/assets/remote/projects/thumbnails/sori-gul.png": "a0508a897b7db772e6f91a1e5f15bbe0",
"assets/assets/remote/projects/thumbnails/tandem-qled-multilayer-optimization.png": "0f7470acf45561581fd1f5d18922b23a",
"assets/assets/remote/projects/thumbnails/voda-ai-smart-factory-quality-inspection.png": "09f4b71e2e4bf060ad0f06aab9383b08",
"assets/FontManifest.json": "349df3842ab3651319d57db376544549",
"assets/fonts/MaterialIcons-Regular.otf": "024b0eea5ca7ceb9c7a32f7d28c3cd5e",
"assets/NOTICES": "ebce4f19bce6226a073eb0e9d97e3dd6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "fde3652131b5f27a18bc6f6d78726f6f",
"index.html": "fcb7b861879685bf423fe6a102b62d1f",
"/": "fcb7b861879685bf423fe6a102b62d1f",
"main.dart.en.js": "5f4b9e1408c7fc7327e721eb10e6f4d7",
"main.dart.js": "afce2835a273d9126bf3235ec393dde3",
"manifest.json": "9b899a3a6a238f4ee3aefbddd8a04074",
"three_intro/glass_tiles_v6.glb": "69fee52f5a8db056a54156703cfe78c9",
"three_intro/hero_rig_idle_walk.glb": "df011483f36c4ffa296443d672db78ec",
"three_intro/index.html": "232c827abe6e4b89eda65a579d677a22",
"three_intro/main.mjs": "b34eb426533da6d955ec0c985e06cb69",
"three_intro/styles.css": "b902856b2917c2dd6483cdc35540f455",
"version.json": "51de3d78b764f252d2b2f771efdc2353"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
