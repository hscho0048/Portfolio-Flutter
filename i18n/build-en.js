// Regenerates main.dart.en.js from main.dart.js by swapping every Korean
// string literal for its entry in i18n/en.json. Run after any edit to
// main.dart.js:  node i18n/build-en.js [build dir, default: repo root]
const fs = require('fs');
const path = require('path');

const root = process.argv[2] || path.join(__dirname, '..');
const map = require('./en.json');
const src = fs.readFileSync(path.join(root, 'main.dart.js'), 'utf8');

const decode = (q, raw) => eval(q + raw + q); // dart2js literals are plain JS strings
const encode = (s) => '"' + JSON.stringify(s).slice(1, -1)
  .replace(/[\u007f-￿]/g, (c) => '\\u' + c.charCodeAt(0).toString(16).padStart(4, '0')) + '"';

const missing = new Set();
// Literals containing a double quote come out single-quoted.
const literal = /"((?:[^"\\\n]|\\.)*)"|'((?:[^'\\\n]|\\.)*)'/g;
const out = src.replace(literal, (lit, dq, sq) => {
  const raw = dq ?? sq;
  if (!/\\u(a[c-f]|b[0-9a-f]|c[0-9a-f]|d[0-7])/i.test(raw)) return lit;
  const ko = decode(dq != null ? '"' : "'", raw);
  if (!/[가-힣]/.test(ko)) return lit;
  if (ko in map) return encode(map[ko]);
  missing.add(ko);
  return lit;
});

fs.writeFileSync(path.join(root, 'main.dart.en.js'), out);
if (missing.size) {
  console.error(`${missing.size} untranslated string(s), left in Korean:`);
  for (const s of missing) console.error('  ' + s);
  process.exitCode = 1;
} else {
  console.log('main.dart.en.js written, all strings translated');
}
