// @ts-nocheck
/* eslint-disable */
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import { natureColors, productTypes, typeColors } from './cosmosData'

export function initCosmosScene(companiesData: any[], relationsData: any[], onNavigate?: (path: string) => void) {
  const COMPANIES = companiesData
  const GROUP_RELATIONS = relationsData

/* ============================================================
   保险公司数据
   ============================================================ */


/* ============================================================
   数据映射
   ============================================================ */



const maxCapital = Math.max(...COMPANIES.map(c => c.capital));

/* ============================================================
   场景初始化
   ============================================================ */
const root = document.getElementById('root');
const scene = new THREE.Scene();
scene.background = new THREE.Color(0x0a0c14);
scene.fog = new THREE.FogExp2(0x0a0c14, 0.0022);

const camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 0.1, 5000);
camera.position.set(0, 30, 350);

const renderer = new THREE.WebGLRenderer({ antialias: true });
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
renderer.domElement.style.display = 'block';
root.appendChild(renderer.domElement);

const controls = new OrbitControls(camera, renderer.domElement);
controls.enableDamping = true;
controls.dampingFactor = 0.05;
controls.minDistance = 20;
controls.maxDistance = 800;
controls.autoRotate = true;
controls.autoRotateSpeed = 0.15;

/* ============================================================
   Shader 星空 — 视差分层 + 径向流动 + 闪烁
   ============================================================ */
const starVert = `
attribute float aSize; attribute vec3 aColor; attribute float aSpeed;
attribute float aPhase; attribute float aLayer;
varying vec3 vColor; varying float vAlpha; uniform float uTime;
void main() {
  vColor = aColor;
  float parallax = 1.0 + aLayer * 0.6;
  vec3 pos = position;
  float angle = uTime * aSpeed * parallax * 0.008;
  float c = cos(angle), s = sin(angle);
  float x = pos.x * c - pos.z * s;
  float z = pos.x * s + pos.z * c;
  pos.x = x; pos.z = z;
  float drift = uTime * aSpeed * parallax * 0.35;
  float r = length(pos.xz);
  float sc = 1.0 + drift / (r + 120.0);
  pos.xz *= sc;
  pos.y += sin(uTime * aSpeed * 0.3 + aPhase) * 3.0;
  float twinkle = sin(uTime * 2.5 + aPhase) * 0.5 + 0.5;
  twinkle = pow(twinkle, 2.0);
  vAlpha = 0.2 + twinkle * 0.8;
  vec4 mv = modelViewMatrix * vec4(pos, 1.0);
  gl_PointSize = aSize * (400.0 / -mv.z);
  gl_Position = projectionMatrix * mv;
}`;

const starFrag = `
varying vec3 vColor; varying float vAlpha;
void main() {
  vec2 c = gl_PointCoord - vec2(0.5);
  float d = length(c);
  if (d > 0.5) discard;
  float a = smoothstep(0.5, 0.1, d) * vAlpha;
  gl_FragColor = vec4(vColor, a);
}`;

function createStarfield() {
  const count = 80000;
  const pos = [], col = [], sz = [], spd = [], ph = [], ly = [];
  const warm = new THREE.Color('#ffe8cc'), cold = new THREE.Color('#cce0ff'), gold = new THREE.Color('#ffd27a');
  const green = new THREE.Color('#4ade80'), teal = new THREE.Color('#2dd4bf'), cyan = new THREE.Color('#67e8f9');
  for (let i = 0; i < count; i++) {
    const layer = i < 30000 ? 0.0 : (i < 55000 ? 1.0 : 2.0);
    const radius = layer === 0.0 ? 500 + Math.random() * 1500 : layer === 1.0 ? 200 + Math.random() * 800 : 50 + Math.random() * 400;
    const theta = Math.random() * Math.PI * 2;
    const phi = Math.acos(2 * Math.random() - 1);
    const x = radius * Math.sin(phi) * Math.cos(theta);
    const y = radius * Math.sin(phi) * Math.sin(theta);
    const z = radius * Math.cos(phi);
    pos.push(x, y, z);
    const bright = 0.35 + Math.random() * 0.65;
    const t = Math.random();
    // 根据位置决定颜色：右侧(x>0)偏向绿/青色，中心区域金黄，其余暖白/冷白
    let c;
    if (x > 80 && t < 0.55) {
      c = t < 0.25 ? green : t < 0.4 ? teal : cyan;
    } else if (radius < 200 && t < 0.5) {
      c = gold;
    } else {
      c = t < 0.55 ? gold : t < 0.82 ? warm : cold;
    }
    col.push(c.r * bright, c.g * bright, c.b * bright);
    sz.push(layer === 0.0 ? 0.4 + Math.random() * 0.9 : layer === 1.0 ? 0.8 + Math.random() * 1.3 : 1.2 + Math.random() * 1.8);
    spd.push(0.2 + Math.random() * 0.8);
    ph.push(Math.random() * Math.PI * 2);
    ly.push(layer);
  }
  const geo = new THREE.BufferGeometry();
  geo.setAttribute('position', new THREE.Float32BufferAttribute(pos, 3));
  geo.setAttribute('aColor', new THREE.Float32BufferAttribute(col, 3));
  geo.setAttribute('aSize', new THREE.Float32BufferAttribute(sz, 1));
  geo.setAttribute('aSpeed', new THREE.Float32BufferAttribute(spd, 1));
  geo.setAttribute('aPhase', new THREE.Float32BufferAttribute(ph, 1));
  geo.setAttribute('aLayer', new THREE.Float32BufferAttribute(ly, 1));
  const mat = new THREE.ShaderMaterial({
    vertexShader: starVert, fragmentShader: starFrag,
    uniforms: { uTime: { value: 0 } },
    transparent: true, blending: THREE.AdditiveBlending, depthWrite: false,
  });
  const stars = new THREE.Points(geo, mat);
  scene.add(stars);
  return stars;
}
const starfield = createStarfield();

/* ============================================================
   星系核心光晕
   ============================================================ */
function createGalaxyCore() {
  const canvas = document.createElement('canvas');
  canvas.width = 512; canvas.height = 512;
  const ctx = canvas.getContext('2d');
  const gradient = ctx.createRadialGradient(256, 256, 0, 256, 256, 256);
  gradient.addColorStop(0, 'rgba(255, 240, 200, 0.9)');
  gradient.addColorStop(0.1, 'rgba(255, 220, 150, 0.5)');
  gradient.addColorStop(0.25, 'rgba(255, 200, 100, 0.2)');
  gradient.addColorStop(0.5, 'rgba(255, 180, 80, 0.08)');
  gradient.addColorStop(1, 'rgba(0, 0, 0, 0)');
  ctx.fillStyle = gradient; ctx.fillRect(0, 0, 512, 512);
  const tex = new THREE.CanvasTexture(canvas);
  const mat = new THREE.SpriteMaterial({ map: tex, blending: THREE.AdditiveBlending, transparent: true, opacity: 0.6, depthWrite: false });
  const sprite = new THREE.Sprite(mat);
  sprite.position.set(0, 0, 0);
  sprite.scale.set(300, 300, 1);
  scene.add(sprite);
  return sprite;
}
const galaxyCore = createGalaxyCore();

/* ============================================================
   流星系统
   ============================================================ */
const meteors = [];
function spawnMeteor(time) {
  if (meteors.length >= 10) return;
  const geo = new THREE.BufferGeometry();
  const count = 6;
  const positions = new Float32Array(count * 3);
  geo.setAttribute('position', new THREE.BufferAttribute(positions, 3));
  const mat = new THREE.PointsMaterial({
    color: 0xffe8cc, size: 2.5, transparent: true, opacity: 0.9,
    blending: THREE.AdditiveBlending, depthWrite: false, sizeAttenuation: true,
  });
  const pts = new THREE.Points(geo, mat);
  scene.add(pts);
  const angle = Math.random() * Math.PI * 2;
  const radius = 300 + Math.random() * 400;
  const origin = new THREE.Vector3(Math.cos(angle) * radius, (Math.random() - 0.5) * 200 + 50, Math.sin(angle) * radius);
  const dir = new THREE.Vector3(Math.cos(angle + 1.2) * 0.8 + (Math.random() - 0.5) * 0.4, -0.2 - Math.random() * 0.3, Math.sin(angle + 1.2) * 0.8 + (Math.random() - 0.5) * 0.4).normalize();
  meteors.push({ pts, geo, mat, positions: [], origin, dir, speed: 100 + Math.random() * 150, life: 0, maxLife: 1.0 + Math.random() * 1.5 });
}

function updateMeteors(dt, time) {
  if (Math.random() < 0.006) spawnMeteor(time);
  for (let i = meteors.length - 1; i >= 0; i--) {
    const m = meteors[i];
    m.life += dt;
    if (m.life > m.maxLife) {
      scene.remove(m.pts); m.geo.dispose(); m.mat.dispose(); meteors.splice(i, 1); continue;
    }
    const t = m.life / m.maxLife;
    let fade = t < 0.15 ? t / 0.15 : (t > 0.7 ? (1 - t) / 0.3 : 1);
    m.mat.opacity = fade * 0.85;
    const head = m.origin.clone().add(m.dir.clone().multiplyScalar(m.speed * m.life));
    m.positions.unshift(head.clone());
    if (m.positions.length > 6) m.positions.pop();
    const arr = m.geo.attributes.position.array;
    for (let j = 0; j < 6; j++) {
      if (j < m.positions.length) { arr[j*3] = m.positions[j].x; arr[j*3+1] = m.positions[j].y; arr[j*3+2] = m.positions[j].z; }
      else { arr[j*3] = head.x; arr[j*3+1] = head.y; arr[j*3+2] = head.z; }
    }
    m.geo.attributes.position.needsUpdate = true;
  }
}

/* ============================================================
   光丝连线（保司星点之间）
   ============================================================ */
let filamentLines = null;
function createFilaments() {
  const poetPositions = [];
  for (let i = 0; i < COMPANIES.length; i++) {
    const r = 80 + ((i * 137.5) % 220);
    const theta = (i * 137.5) * (Math.PI / 180);
    const phi = Math.acos(2 * ((i * 73) % 1000) / 1000 - 1);
    poetPositions.push(new THREE.Vector3(r * Math.sin(phi) * Math.cos(theta), r * Math.sin(phi) * Math.sin(theta), r * Math.cos(phi)));
  }
  const positions = [], colors = [];
  let conn = 0;
  for (let i = 0; i < poetPositions.length && conn < 90; i++) {
    for (let j = i + 1; j < poetPositions.length && conn < 90; j++) {
      const dist = poetPositions[i].distanceTo(poetPositions[j]);
      if (dist < 85) {
        positions.push(poetPositions[i].x, poetPositions[i].y, poetPositions[i].z, poetPositions[j].x, poetPositions[j].y, poetPositions[j].z);
        const a = 1.0 - dist / 85; const c = 0.5 + a * 0.5;
        colors.push(c * 0.95, c * 0.82, c * 0.48, c * 0.95, c * 0.82, c * 0.48);
        conn++;
      }
    }
  }
  if (positions.length === 0) return;
  const geo = new THREE.BufferGeometry();
  geo.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
  geo.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3));
  const mat = new THREE.LineBasicMaterial({ vertexColors: true, transparent: true, opacity: 0.25, blending: THREE.AdditiveBlending, depthWrite: false });
  filamentLines = new THREE.LineSegments(geo, mat);
  scene.add(filamentLines);
}
createFilaments();

/* ============================================================
   集团关系连线（保司之间的股东/关联关系）
   ============================================================ */
let groupRelLines = null;        // 背景关系线（全部）
let groupRelHighlightLines = null; // 高亮关系线（悬停/选中时）
let groupRelVisible = false;       // 是否显示关系线

function createGroupRelationLines() {
  if (groupRelLines) { scene.remove(groupRelLines); groupRelLines.geometry.dispose(); groupRelLines.material.dispose(); groupRelLines = null; }
  const positions = [], colors = [];
  GROUP_RELATIONS.forEach(rel => {
    const fromPos = poetPositions[rel.from];
    const toPos = poetPositions[rel.to];
    if (!fromPos || !toPos) return;
    positions.push(fromPos.x, fromPos.y, fromPos.z, toPos.x, toPos.y, toPos.z);
    // 用淡青色表示关联关系
    colors.push(0.3, 0.85, 0.85, 0.3, 0.85, 0.85);
  });
  if (positions.length === 0) return;
  const geo = new THREE.BufferGeometry();
  geo.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
  geo.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3));
  const mat = new THREE.LineBasicMaterial({
    vertexColors: true, transparent: true, opacity: 0.18,
    blending: THREE.AdditiveBlending, depthWrite: false
  });
  groupRelLines = new THREE.LineSegments(geo, mat);
  groupRelLines.visible = groupRelVisible;
  scene.add(groupRelLines);
}

// 高亮与指定保司相关的连线
function highlightGroupRelations(idx) {
  if (groupRelHighlightLines) { scene.remove(groupRelHighlightLines); groupRelHighlightLines.geometry.dispose(); groupRelHighlightLines.material.dispose(); groupRelHighlightLines = null; }
  const positions = [], colors = [];
  GROUP_RELATIONS.forEach(rel => {
    if (rel.from !== idx && rel.to !== idx) return;
    const fromPos = poetPositions[rel.from];
    const toPos = poetPositions[rel.to];
    if (!fromPos || !toPos) return;
    positions.push(fromPos.x, fromPos.y, fromPos.z, toPos.x, toPos.y, toPos.z);
    // 高亮用亮白青色
    const bright = 0.95;
    colors.push(bright, bright, 1.0, bright, bright, 1.0);
  });
  if (positions.length === 0) return;
  const geo = new THREE.BufferGeometry();
  geo.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
  geo.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3));
  const mat = new THREE.LineBasicMaterial({
    vertexColors: true, transparent: true, opacity: 0.7,
    blending: THREE.AdditiveBlending, depthWrite: false
  });
  groupRelHighlightLines = new THREE.LineSegments(geo, mat);
  scene.add(groupRelHighlightLines);
}

// 清除高亮
function clearGroupHighlight() {
  if (groupRelHighlightLines) { scene.remove(groupRelHighlightLines); groupRelHighlightLines.geometry.dispose(); groupRelHighlightLines.material.dispose(); groupRelHighlightLines = null; }
}

// 获取与指定保司有关系的所有保司索引
function getRelatedCompanyIndices(idx) {
  const related = new Set();
  GROUP_RELATIONS.forEach(rel => {
    if (rel.from === idx) related.add(rel.to);
    if (rel.to === idx) related.add(rel.from);
  });
  return related;
}

// 获取指定保司所属的集团名称
function getCompanyGroups(idx) {
  const groups = new Set();
  GROUP_RELATIONS.forEach(rel => {
    if (rel.from === idx || rel.to === idx) groups.add(rel.group);
  });
  return [...groups];
}

/* ============================================================
   星云效果
   ============================================================ */
function createNebulaTexture() {
  const canvas = document.createElement('canvas');
  canvas.width = 256; canvas.height = 256;
  const ctx = canvas.getContext('2d');
  const gradient = ctx.createRadialGradient(128, 128, 0, 128, 128, 128);
  gradient.addColorStop(0, 'rgba(255,210,122,0.4)');
  gradient.addColorStop(0.3, 'rgba(255,200,100,0.15)');
  gradient.addColorStop(0.6, 'rgba(200,180,255,0.05)');
  gradient.addColorStop(1, 'rgba(0,0,0,0)');
  ctx.fillStyle = gradient; ctx.fillRect(0, 0, 256, 256);
  return new THREE.CanvasTexture(canvas);
}
const nebulaSprites = [];
for (let i = 0; i < 7; i++) {
  const tex = createNebulaTexture();
  const mat = new THREE.SpriteMaterial({ map: tex, blending: THREE.AdditiveBlending, transparent: true, opacity: 0.03 + Math.random() * 0.05, depthWrite: false });
  const sprite = new THREE.Sprite(mat);
  const radius = 150 + Math.random() * 500;
  const theta = Math.random() * Math.PI * 2;
  const phi = Math.acos(2 * Math.random() - 1);
  sprite.position.set(radius * Math.sin(phi) * Math.cos(theta), radius * Math.sin(phi) * Math.sin(theta), radius * Math.cos(phi));
  const scale = 50 + Math.random() * 100;
  sprite.scale.set(scale, scale, 1);
  sprite.userData = { origY: sprite.position.y, phase: Math.random() * Math.PI * 2, rotSpeed: 0.0002 + Math.random() * 0.0003 };
  scene.add(sprite); nebulaSprites.push(sprite);
}

/* ============================================================
   保司星点 + 标签
   ============================================================ */
function createGlowTexture(color, size) {
  const canvas = document.createElement('canvas');
  canvas.width = size; canvas.height = size;
  const ctx = canvas.getContext('2d');
  const gradient = ctx.createRadialGradient(size/2, size/2, 0, size/2, size/2, size/2);
  gradient.addColorStop(0, color); gradient.addColorStop(0.4, color.replace('1)', '0.5)'));
  gradient.addColorStop(0.8, color.replace('1)', '0.1)')); gradient.addColorStop(1, 'rgba(0,0,0,0)');
  ctx.fillStyle = gradient; ctx.fillRect(0, 0, size, size);
  return new THREE.CanvasTexture(canvas);
}

const natureGlowTexs = {};
Object.entries(natureColors).forEach(([nature, color]) => {
  const r = parseInt(color.slice(1, 3), 16), g = parseInt(color.slice(3, 5), 16), b = parseInt(color.slice(5, 7), 16);
  natureGlowTexs[nature] = createGlowTexture(`rgba(${r},${g},${b},1)`, 64);
});
const poetPositions = [];
const poetSprites = [];
const labelContainer = document.createElement('div');
labelContainer.style.cssText = 'position:fixed;inset:0;pointer-events:none;z-index:10;overflow:hidden;';
root.appendChild(labelContainer);

const poetLabels = [];
const poetLabelCoords = [];
const minCapital = Math.min(...COMPANIES.map(c => c.capital));

for (let i = 0; i < COMPANIES.length; i++) {
  const company = COMPANIES[i];
  const r = 80 + ((i * 137.5) % 220);
  const theta = (i * 137.5) * (Math.PI / 180);
  const phi = Math.acos(2 * ((i * 73) % 1000) / 1000 - 1);
  const pos = new THREE.Vector3(r * Math.sin(phi) * Math.cos(theta), r * Math.sin(phi) * Math.sin(theta), r * Math.cos(phi));
  poetPositions.push(pos);

  // 注资规模决定星点大小：4 ~ 12
  const capitalRatio = (company.capital - minCapital) / (maxCapital - minCapital || 1);
  const starScale = 4 + capitalRatio * 8;

  const spriteMat = new THREE.SpriteMaterial({ map: natureGlowTexs[company.nature], blending: THREE.AdditiveBlending, transparent: true, opacity: 0.7, depthWrite: false });
  const sprite = new THREE.Sprite(spriteMat);
  sprite.position.copy(pos);
  sprite.scale.set(starScale, starScale, 1);
  sprite.userData = { poetIndex: i, type: 'poet', originalScale: starScale };
  scene.add(sprite); poetSprites.push(sprite);

  const label = document.createElement('div');
  label.className = 'poet-label';
  label.textContent = company.name;
  label.dataset.index = i;
  label.style.display = 'none'; // 默认隐藏，仅悬停/选中时显示
  labelContainer.appendChild(label);
  poetLabels.push(label);
  poetLabelCoords.push({ x: 0, y: 0, visible: false });
}

// 初始化集团关系连线（必须在poetPositions填充之后）
createGroupRelationLines();

/* ============================================================
   UI 组件
   ============================================================ */
// 顶部栏 — 分层布局
const hudTop = document.createElement('div');
hudTop.className = 'hud-top';
hudTop.style.cssText = 'pointer-events:none;z-index:20;padding:16px 20px;position:fixed;top:0;left:0;right:0;display:flex;flex-direction:column;gap:8px;';
const totalWorks = COMPANIES.reduce((sum, p) => sum + p.products.length, 0);
hudTop.innerHTML = `
  <div style="display:flex;align-items:center;gap:18px;flex-wrap:wrap;">
    <span class="title">保险宇宙<span class="title-en">一切可能的保障</span></span>
    <span class="stat" style="margin-left:auto"><span class="pull-count">${COMPANIES.length.toLocaleString()}</span> 家保司 · <span class="pull-count">${totalWorks.toLocaleString()}</span> 款</span>
  </div>
  <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
    <div class="seg"><button class="seg-btn on" data-mode="poet">保司</button><button class="seg-btn" data-mode="search">寻险</button><button class="seg-btn" data-mode="explore">探险</button><button class="seg-btn" data-mode="dynasty">性质</button></div>
    <button class="filter on" data-f="wujue">重疾险</button><button class="filter" data-f="qijue">医疗险</button><button class="filter" data-f="wulv">意外险</button><button class="filter" data-f="qilv">定期寿险</button><button class="filter" data-f="ziyou">年金险</button><button class="filter" data-f="changyong">增额寿</button><button class="filter" data-f="gelv">终身寿险</button><button class="filter" data-f="more">更多</button>
    <button class="ui-hide-btn" id="relation-btn" style="color:#55dfe5;border:1px solid #55dfe566">关系网 · 隐藏</button>
    <button class="ui-hide-btn" id="quality-btn">画质·低</button>
    <button class="ui-hide-btn" id="hide-btn">隐藏界面 · H</button>
  </div>`;
// 使子元素可交互
hudTop.querySelectorAll('*').forEach(el => { if(el.style) el.style.pointerEvents = 'auto'; });
root.appendChild(hudTop);

// 底部栏
const hudBottom = document.createElement('div');
hudBottom.className = 'hud-bottom';
hudBottom.innerHTML = `<div class="hint"><b>WASD</b> 飞行 · 拖拽转向 · 滚轮调速 · 点保司星看其产品 · 点虚空从噪声里捞险</div><div>速度 <span class="speed" id="speed-display">×1.00</span> · <span id="units-display">140</span> 单位/秒</div>`;
root.appendChild(hudBottom);

// 图例
const legend = document.createElement('div');
legend.className = 'legend';
legend.innerHTML = `<div class="legend-head"><span>险种</span><div class="legend-presets"><button>全部</button><button>无</button></div></div><div class="legend-list">
  <button class="legend-row" data-type="all"><span class="dot" style="background:#ffd27a;box-shadow:0 0 6px #ffd27a"></span><span class="legend-label">全部</span></button>
  <button class="legend-row" data-type="央企"><span class="dot" style="background:#ff4d4f;box-shadow:0 0 6px #ff4d4f"></span><span class="legend-label">央企</span></button>
  <button class="legend-row" data-type="国资"><span class="dot" style="background:#1890ff;box-shadow:0 0 6px #1890ff"></span><span class="legend-label">国资</span></button>
  <button class="legend-row" data-type="合资"><span class="dot" style="background:#52c41a;box-shadow:0 0 6px #52c41a"></span><span class="legend-label">合资</span></button>
  <button class="legend-row" data-type="外资"><span class="dot" style="background:#faad14;box-shadow:0 0 6px #faad14"></span><span class="legend-label">外资</span></button>
  <button class="legend-row" data-type="民营"><span class="dot" style="background:#722ed1;box-shadow:0 0 6px #722ed1"></span><span class="legend-label">民营</span></button>
</div>`;
root.appendChild(legend);

// 搜索
const searchBox = document.createElement('div');
searchBox.className = 'search';
searchBox.innerHTML = `<input type="text" placeholder="搜索保司…（回车飞到第一个）" id="search-input" autocomplete="off"><div class="search-results" id="search-results"></div>`;
root.appendChild(searchBox);

// 保司面板
const poetPanel = document.createElement('div');
poetPanel.className = 'poet-panel';
root.appendChild(poetPanel);

// Tooltip
const tooltip = document.createElement('div');
tooltip.className = 'hud-tooltip';
root.appendChild(tooltip);

/* ============================================================
   交互逻辑
   ============================================================ */
let uiVisible = true;
let currentPoet = null;
let currentMode = 'poet';
let currentFilter = 'wujue';
const raycaster = new THREE.Raycaster();
const mouse = new THREE.Vector2(-999, -999);
let hoveredPoet = null;

// 滚轮调速
renderer.domElement.addEventListener('wheel', (e) => {
  e.preventDefault();
  const delta = e.deltaY > 0 ? -0.02 : 0.02;
  controls.autoRotateSpeed = Math.max(0, Math.min(3, controls.autoRotateSpeed + delta));
}, { passive: false });

// 虚空捞险面板
const voidPanel = document.createElement('div');
voidPanel.className = 'poet-panel';
voidPanel.style.display = 'none';
voidPanel.style.zIndex = '26';
root.appendChild(voidPanel);

// 隐藏UI
document.getElementById('hide-btn').addEventListener('click', () => {
  uiVisible = !uiVisible;
  const opacity = uiVisible ? '1' : '0';
  hudTop.style.opacity = opacity; hudBottom.style.opacity = opacity;
  legend.style.opacity = opacity; searchBox.style.opacity = opacity;
  hudTop.style.pointerEvents = uiVisible ? 'auto' : 'none';
  hudBottom.style.pointerEvents = uiVisible ? 'auto' : 'none';
  legend.style.pointerEvents = uiVisible ? 'auto' : 'none';
  searchBox.style.pointerEvents = uiVisible ? 'auto' : 'none';
});
document.addEventListener('keydown', (e) => { if (e.key === 'h' || e.key === 'H') document.getElementById('hide-btn').click(); });

// WASD 飞行
const keys = { w: false, a: false, s: false, d: false };
document.addEventListener('keydown', (e) => {
  const k = e.key.toLowerCase();
  if (k === 'w' || k === 'a' || k === 's' || k === 'd') keys[k] = true;
});
document.addEventListener('keyup', (e) => {
  const k = e.key.toLowerCase();
  if (k === 'w' || k === 'a' || k === 's' || k === 'd') keys[k] = false;
});

// 关系线开关
document.getElementById('relation-btn').addEventListener('click', function() {
  groupRelVisible = !groupRelVisible;
  if (groupRelLines) groupRelLines.visible = groupRelVisible;
  this.textContent = groupRelVisible ? '关系网 · 显示' : '关系网 · 隐藏';
  this.style.color = groupRelVisible ? '#55dfe5' : '#888';
  this.style.borderColor = groupRelVisible ? '#55dfe566' : '#444666';
});

// 画质切换
document.getElementById('quality-btn').addEventListener('click', function() {
  const high = this.textContent === '画质·低';
  this.textContent = high ? '画质·高' : '画质·低';
  renderer.setPixelRatio(high ? Math.min(window.devicePixelRatio, 2) : 1);
});

// 筛选按钮（险种过滤）
const formToFilter = { 'wujue':'重疾险', 'qijue':'医疗险', 'wulv':'意外险', 'qilv':'定期寿险', 'ziyou':'年金险', 'changyong':'增额终身寿', 'gelv':'终身寿险', 'more':'' };
hudTop.querySelectorAll('.filter[data-f]').forEach(btn => {
  btn.addEventListener('click', () => {
    hudTop.querySelectorAll('.filter[data-f]').forEach(b => b.classList.remove('on'));
    btn.classList.add('on');
    currentFilter = btn.dataset.f;
    const formName = formToFilter[currentFilter];
    if (!formName) {
      poetSprites.forEach((spr, i) => { spr.visible = true; });
      return;
    }
    poetSprites.forEach((spr, i) => {
      const poet = COMPANIES[i];
      const hasForm = poet.products.some((_, wi) => productTypes[(i + wi) % productTypes.length] === formName);
      spr.visible = hasForm;
    });
  });
});

// 模式按钮
hudTop.querySelectorAll('.seg-btn[data-mode]').forEach(btn => {
  btn.addEventListener('click', () => {
    hudTop.querySelectorAll('.seg-btn[data-mode]').forEach(b => b.classList.remove('on'));
    btn.classList.add('on');
    currentMode = btn.dataset.mode;
    if (currentMode === 'search') {
      document.getElementById('search-input').focus();
    } else if (currentMode === 'explore') {
      startExplore();
    } else if (currentMode === 'dynasty') {
      showDynastyView();
    }
  });
});

let exploreTimer = null;
function startExplore() {
  if (exploreTimer) clearInterval(exploreTimer);
  let count = 0;
  exploreTimer = setInterval(() => {
    if (currentMode !== 'explore' || count >= 20) { clearInterval(exploreTimer); exploreTimer = null; return; }
    const idx = Math.floor(Math.random() * COMPANIES.length);
    flyToPoet(idx);
    count++;
  }, 4000);
}

function showDynastyView() {
  const dynastyCounts = {};
  COMPANIES.forEach(p => { dynastyCounts[p.nature] = (dynastyCounts[p.nature] || 0) + 1; });
  const sorted = Object.entries(dynastyCounts).sort((a, b) => b[1] - a[1]);
  voidPanel.innerHTML = `
    <button class="panel-close" id="dynasty-close">&#10005;</button>
    <div class="poet-head"><div class="poet-name">性质分布</div><div class="poet-sub">共 ${Object.keys(dynastyCounts).length} 个性质</div></div>
    <div class="poem-list">${sorted.map(([d, c]) => `<div class="poem-item"><div class="pi-title">${d}<span class="pi-form" style="border-color:${natureColors[d]||'#ffd27a'};color:${natureColors[d]||'#ffd27a'}">${c} 家</span></div></div>`).join('')}</div>`;
  voidPanel.style.display = 'block';
  document.getElementById('dynasty-close').addEventListener('click', () => { voidPanel.style.display = 'none'; });
}

// 图例切换
function setAllPoetsVisible(visible) {
  poetSprites.forEach((spr, i) => { spr.visible = visible; });
}
function updateLegendRows() {
  legend.querySelectorAll('.legend-row[data-type]').forEach(row => {
    const type = row.dataset.type;
    let anyOn = false, anyOff = false;
    poetSprites.forEach((spr, i) => {
      const nature = COMPANIES[i].nature;
      const match = type === 'all' || type === nature;
      if (match) { if (spr.visible) anyOn = true; else anyOff = true; }
    });
    if (anyOn && anyOff) { /* mixed, keep current */ }
    else if (anyOn && !anyOff) row.classList.remove('off');
    else if (!anyOn && anyOff) row.classList.add('off');
  });
}

legend.querySelectorAll('.legend-row[data-type]').forEach(row => {
  row.addEventListener('click', () => {
    row.classList.toggle('off');
    const type = row.dataset.type;
    const visible = !row.classList.contains('off');
    poetSprites.forEach((spr, i) => {
      const nature = COMPANIES[i].nature;
      if (type === 'all') { spr.visible = visible; }
      else if (type === nature) { spr.visible = visible; }
    });
  });
});

// 图例预设按钮
legend.querySelectorAll('.legend-presets button').forEach((btn, bi) => {
  btn.addEventListener('click', () => {
    if (bi === 0) { // 全部
      setAllPoetsVisible(true);
      legend.querySelectorAll('.legend-row[data-type]').forEach(r => r.classList.remove('off'));
    } else { // 无
      setAllPoetsVisible(false);
      legend.querySelectorAll('.legend-row[data-type]').forEach(r => r.classList.add('off'));
    }
  });
});

// 搜索
const searchInput = document.getElementById('search-input');
const searchResults = document.getElementById('search-results');
searchInput.addEventListener('input', () => {
  const q = searchInput.value.trim().toLowerCase();
  if (!q) { searchResults.style.display = 'none'; return; }
  const results = [];
  COMPANIES.forEach((p, i) => {
    if (p.name.includes(q) || p.nature.includes(q)) results.push({ name: p.name, dynasty: p.nature, idx: i });
    p.products.forEach(w => { if (w.includes(q)) results.push({ name: w, dynasty: p.name + ' · ' + p.nature, idx: i }); });
  });
  if (results.length === 0) { searchResults.innerHTML = '<div style="color:var(--muted);padding:8px 14px;font-size:13px">未找到匹配结果</div>'; searchResults.style.display = 'block'; return; }
  searchResults.innerHTML = results.slice(0, 15).map(r => `<button class="search-row" data-idx="${r.idx}"><span><span class="sr-name">${r.name}</span><span class="sr-title">${r.nature}</span></span></button>`).join('');
  searchResults.style.display = 'block';
  searchResults.querySelectorAll('.search-row').forEach(row => {
    row.addEventListener('click', () => { const idx = +row.dataset.idx; flyToPoet(idx); searchResults.style.display = 'none'; searchInput.value = ''; });
  });
});
document.addEventListener('click', (e) => { if (!searchBox.contains(e.target)) searchResults.style.display = 'none'; });

function flyToPoet(idx) {
  // 清除之前选中保司的高亮
  if (currentPoet !== null) {
    poetLabels[currentPoet].classList.remove('focus');
    poetLabels[currentPoet].style.color = '';
    poetSprites[currentPoet].scale.set(poetSprites[currentPoet].userData.originalScale, poetSprites[currentPoet].userData.originalScale, 1);
  }
  controls.enabled = false;
  const dir = poetPositions[idx].clone().normalize();
  const target = poetPositions[idx].clone().add(dir.multiplyScalar(80));
  const start = camera.position.clone();
  const startQ = camera.quaternion.clone();
  camera.lookAt(poetPositions[idx]);
  const endQ = camera.quaternion.clone();
  camera.quaternion.copy(startQ);
  let t = 0;
  function step() {
    t += 0.02;
    if (t >= 1) {
      camera.position.copy(target);
      controls.target.copy(poetPositions[idx]);
      controls.enabled = true;
      controls.autoRotateSpeed = 0.8;
      camera.lookAt(poetPositions[idx]);
      // 高亮当前保司标签，颜色与性质一致
      const natureColor = natureColors[COMPANIES[idx].nature] || '#ffd27a';
      poetLabels[idx].classList.add('focus');
      poetLabels[idx].style.color = natureColor;
      poetSprites[idx].scale.set(poetSprites[idx].userData.originalScale * 1.6, poetSprites[idx].userData.originalScale * 1.6, 1);
      // 立即跳转选中保司的标签坐标
      const sPos = poetPositions[idx].clone().project(camera);
      poetLabelCoords[idx].x = (sPos.x * 0.5 + 0.5) * window.innerWidth;
      poetLabelCoords[idx].y = (-sPos.y * 0.5 + 0.5) * window.innerHeight;
      // 高亮该保司的关系线
      if (groupRelVisible) highlightGroupRelations(idx);
      // 高亮关联保司的星点
      const relatedSet = getRelatedCompanyIndices(idx);
      relatedSet.forEach(ri => {
        poetSprites[ri].scale.set(poetSprites[ri].userData.originalScale * 1.4, poetSprites[ri].userData.originalScale * 1.4, 1);
      });
      showPoetPanel(idx);
      return;
    }
    const ease = 1 - Math.pow(1 - t, 3);
    camera.position.lerpVectors(start, target, ease);
    camera.quaternion.slerpQuaternions(startQ, endQ, ease);
    requestAnimationFrame(step);
  }
  step();
}

let radialLines = null;

let satelliteStars = null;

function createRadialLines(centerPos, natureColor, capitalRatio) {
  if (radialLines) { scene.remove(radialLines); radialLines.geometry.dispose(); radialLines.material.dispose(); }
  if (satelliteStars) { scene.remove(satelliteStars); satelliteStars.geometry.dispose(); satelliteStars.material.dispose(); }
  const lineCount = 48;
  const positions = [];
  const colors = [];
  const r = parseInt((natureColor || '#ffd27a').slice(1, 3), 16) / 255;
  const g = parseInt((natureColor || '#ffd27a').slice(3, 5), 16) / 255;
  const b = parseInt((natureColor || '#ffd27a').slice(5, 7), 16) / 255;
  for (let i = 0; i < lineCount; i++) {
    const angle = (i / lineCount) * Math.PI * 2 + Math.random() * 0.3;
    const len = 60 + Math.random() * 120;
    const x1 = centerPos.x, y1 = centerPos.y, z1 = centerPos.z;
    const x2 = centerPos.x + Math.cos(angle) * len;
    const y2 = centerPos.y + (Math.random() - 0.5) * 40;
    const z2 = centerPos.z + Math.sin(angle) * len;
    positions.push(x1, y1, z1, x2, y2, z2);
    const brightness = 0.6 + Math.random() * 0.4;
    colors.push(brightness * r, brightness * g, brightness * b, brightness * r, brightness * g, brightness * b);
  }
  const geo = new THREE.BufferGeometry();
  geo.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
  geo.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3));
  const mat = new THREE.LineBasicMaterial({ vertexColors: true, transparent: true, opacity: 0.45, blending: THREE.AdditiveBlending, depthWrite: false });
  radialLines = new THREE.LineSegments(geo, mat);
  scene.add(radialLines);

  // 卫星星星：注资规模越大，周围星星越多
  const satCount = Math.floor(30 + capitalRatio * 120);
  const satPos = [], satCol = [], satSize = [];
  for (let i = 0; i < satCount; i++) {
    const angle = Math.random() * Math.PI * 2;
    const radius = 20 + Math.random() * 100;
    const sx = centerPos.x + Math.cos(angle) * radius;
    const sy = centerPos.y + (Math.random() - 0.5) * 30;
    const sz = centerPos.z + Math.sin(angle) * radius;
    satPos.push(sx, sy, sz);
    const bright = 0.5 + Math.random() * 0.5;
    satCol.push(r * bright, g * bright, b * bright);
    satSize.push(0.8 + Math.random() * 2.5);
  }
  const satGeo = new THREE.BufferGeometry();
  satGeo.setAttribute('position', new THREE.Float32BufferAttribute(satPos, 3));
  satGeo.setAttribute('aColor', new THREE.Float32BufferAttribute(satCol, 3));
  satGeo.setAttribute('aSize', new THREE.Float32BufferAttribute(satSize, 1));
  // 复用 starfield 的 shader
  const satMat = new THREE.ShaderMaterial({
    vertexShader: starVert, fragmentShader: starFrag,
    uniforms: { uTime: { value: 0 } },
    transparent: true, blending: THREE.AdditiveBlending, depthWrite: false,
  });
  satelliteStars = new THREE.Points(satGeo, satMat);
  scene.add(satelliteStars);
}

function removeRadialLines() {
  if (radialLines) { scene.remove(radialLines); radialLines.geometry.dispose(); radialLines.material.dispose(); radialLines = null; }
  if (satelliteStars) { scene.remove(satelliteStars); satelliteStars.geometry.dispose(); satelliteStars.material.dispose(); satelliteStars = null; }
}

function showPoetPanel(idx) {
  currentPoet = idx;
  const poet = COMPANIES[idx];
  const dynastyColor = natureColors[poet.nature] || '#ffd27a';
  const capitalRatio = (COMPANIES[idx].capital - minCapital) / (maxCapital - minCapital || 1);
  createRadialLines(poetPositions[idx], natureColors[COMPANIES[idx].nature], capitalRatio);
  // 获取关联保司信息
  const relatedIndices = getRelatedCompanyIndices(idx);
  const groups = getCompanyGroups(idx);
  const relatedHtml = relatedIndices.size > 0
    ? `<div style="margin-bottom:12px;padding:10px;background:rgba(85,223,229,0.06);border:1px solid rgba(85,223,229,0.2);border-radius:8px;">
        <div style="font-size:12px;color:#55dfe5;margin-bottom:6px;font-weight:bold">关联保司${groups.length > 0 ? ' · ' + groups.join('/') + '集团' : ''}</div>
        <div style="font-size:12px;color:var(--muted);line-height:1.7">${[...relatedIndices].map(ri => `<span style="color:${natureColors[COMPANIES[ri].nature] || '#aaa'};cursor:pointer" class="related-company" data-idx="${ri}">${COMPANIES[ri].name}</span>`).join(' · ')}</div>
       </div>`
    : '';
  poetPanel.innerHTML = `
    <button class="panel-close">&#10005;</button>
    <div class="poet-head"><div class="poet-name">${poet.name}</div><div class="poet-sub">${poet.nature} · 注册资本 ${poet.capital} 亿 · ${poet.products.length} 款真实产品</div></div>
    ${relatedHtml}
    <div style="display:flex;gap:8px;margin-bottom:12px;">
      <button class="ui-hide-btn" id="btn-share" style="flex:1;font-size:12px;padding:5px 0;">分享</button>
      <button class="ui-hide-btn" id="btn-photo" style="flex:1;font-size:12px;padding:5px 0;">留影</button>
    </div>
    <div class="poem-list">${poet.products.map((w, wi) => {
      const form = productTypes[(idx + wi) % productTypes.length];
      const fColor = typeColors[form];
      const pseudoLines = ['${w}，开篇起兴。','声律铿锵，对仗工整。','意境深远，余韵悠长。','结句收束，回味无穷。'];
      return `<div class="poem-item" data-wi="${wi}"><div class="pi-title" style="cursor:pointer">${w}<span class="pi-form" style="border-color:${fColor};color:${fColor}">${form}</span><span style="color:var(--muted);font-size:10px;margin-left:6px">#${(idx*1000+wi+1).toString().padStart(6,'0')}</span></div><div class="pi-detail" style="display:none;margin-top:6px;padding:8px 10px;background:rgba(255,255,255,0.03);border-radius:6px;border-left:2px solid ${fColor}"><div style="font-family:var(--serif);color:#f1ede2;letter-spacing:.08em;font-size:13px;line-height:1.9">${pseudoLines[wi%4]}</div></div><div class="poem-actions"><button class="poem-btn btn-locate" data-wi="${wi}">定位</button><button class="poem-btn btn-snap" data-wi="${wi}">留影</button><button class="poem-btn btn-copy" data-name="${w}">复制编号</button></div></div>`;
    }).join('')}</div>
    <div class="poem-foot">共 ${poet.products.length} 款产品</div>`;
  poetPanel.style.display = 'block';
  poetPanel.querySelector('.panel-close').addEventListener('click', () => {
    if (currentPoet !== null) { poetLabels[currentPoet].classList.remove('focus'); poetSprites[currentPoet].scale.set(6, 6, 1); }
    // 清除关系高亮和关联保司高亮
    clearGroupHighlight();
    const oldRelated = getRelatedCompanyIndices(currentPoet);
    oldRelated.forEach(ri => { poetSprites[ri].scale.set(poetSprites[ri].userData.originalScale, poetSprites[ri].userData.originalScale, 1); });
    poetPanel.style.display = 'none'; currentPoet = null; removeRadialLines(); controls.target.set(0,0,0); controls.autoRotateSpeed = 0.15;
  });

  // 关联保司点击跳转
  poetPanel.querySelectorAll('.related-company').forEach(el => {
    el.addEventListener('click', () => {
      const targetIdx = +el.dataset.idx;
      flyToPoet(targetIdx);
    });
  });

  // 产品标题点击展开
  poetPanel.querySelectorAll('.pi-title').forEach(title => {
    title.addEventListener('click', () => {
      const detail = title.parentElement.querySelector('.pi-detail');
      if (detail) {
        const showing = detail.style.display === 'block';
        poetPanel.querySelectorAll('.pi-detail').forEach(d => d.style.display = 'none');
        detail.style.display = showing ? 'none' : 'block';
      }
    });
  });

  // 分享
  document.getElementById('btn-share').addEventListener('click', () => {
    const text = `我在保险宇宙中发现了 ${poet.name}（${poet.nature}）的 ${poet.products.length} 款产品，快来一起探索吧！`;
    navigator.clipboard.writeText(text).then(() => alert('已复制到剪贴板'));
  });

  // 留影（截图）
  document.getElementById('btn-photo').addEventListener('click', () => {
    renderer.render(scene, camera);
    const link = document.createElement('a');
    link.download = `保险宇宙_${poet.name}.png`;
    link.href = renderer.domElement.toDataURL('image/png');
    link.click();
  });

  // 定位产品
  poetPanel.querySelectorAll('.btn-locate').forEach(btn => {
    btn.addEventListener('click', () => {
      const wi = +btn.dataset.wi;
      const angle = (wi / Math.max(1, poet.products.length)) * Math.PI * 2;
      const orbitR = 25;
      const offset = new THREE.Vector3(Math.cos(angle) * orbitR, (Math.random() - 0.5) * 10, Math.sin(angle) * orbitR);
      const workPos = poetPositions[idx].clone().add(offset);
      const dir = workPos.clone().normalize();
      const camPos = workPos.clone().add(dir.multiplyScalar(40));
      controls.enabled = false;
      const start = camera.position.clone();
      const startQ = camera.quaternion.clone();
      camera.lookAt(workPos);
      const endQ = camera.quaternion.clone();
      camera.quaternion.copy(startQ);
      let t = 0;
      function step() {
        t += 0.03;
        if (t >= 1) {
          camera.position.copy(camPos);
          controls.target.copy(workPos);
          controls.enabled = true;
          camera.lookAt(workPos);
          return;
        }
        const ease = 1 - Math.pow(1 - t, 3);
        camera.position.lerpVectors(start, camPos, ease);
        camera.quaternion.slerpQuaternions(startQ, endQ, ease);
        requestAnimationFrame(step);
      }
      step();
    });
  });

  // 复制编号
  poetPanel.querySelectorAll('.btn-copy').forEach(btn => {
    btn.addEventListener('click', () => {
      navigator.clipboard.writeText(btn.dataset.name).then(() => { btn.textContent = '已复制'; setTimeout(() => btn.textContent = '复制编号', 1200); });
    });
  });

  // 产品留影
  poetPanel.querySelectorAll('.btn-snap').forEach(btn => {
    btn.addEventListener('click', () => {
      renderer.render(scene, camera);
      const link = document.createElement('a');
      link.download = `保险宇宙_${poet.name}_${btn.dataset.wi}.png`;
      link.href = renderer.domElement.toDataURL('image/png');
      link.click();
    });
  });
}

// 鼠标交互
renderer.domElement.addEventListener('pointermove', (e) => {
  mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
  mouse.y = -(e.clientY / window.innerHeight) * 2 + 1;
  raycaster.setFromCamera(mouse, camera);
  const hits = raycaster.intersectObjects(poetSprites);
  if (hits.length > 0) {
    const idx = hits[0].object.userData.poetIndex;
    if (hoveredPoet !== idx) {
      if (hoveredPoet !== null) { poetSprites[hoveredPoet].scale.set(poetSprites[hoveredPoet].userData.originalScale, poetSprites[hoveredPoet].userData.originalScale, 1); poetLabels[hoveredPoet].classList.remove('focus'); poetLabels[hoveredPoet].style.color = ''; }
      hoveredPoet = idx;
      // 立即将标签坐标跳到星点位置，避免从远处飞过来
      const hPos = poetPositions[idx].clone().project(camera);
      poetLabelCoords[idx].x = (hPos.x * 0.5 + 0.5) * window.innerWidth;
      poetLabelCoords[idx].y = (-hPos.y * 0.5 + 0.5) * window.innerHeight;
      const hScale = poetSprites[idx].userData.originalScale * 1.6;
      poetSprites[idx].scale.set(hScale, hScale, 1);
      const hColor = natureColors[COMPANIES[idx].nature] || '#ffd27a';
      poetLabels[idx].classList.add('focus');
      poetLabels[idx].style.color = hColor;
      renderer.domElement.style.cursor = 'pointer';
      // 悬停时高亮关系线
      if (groupRelVisible) highlightGroupRelations(idx);
    }
    // tooltip显示关系信息
    const groups = getCompanyGroups(idx);
    const relCount = getRelatedCompanyIndices(idx).size;
    const relInfo = groups.length > 0 ? `<div style="margin-top:3px;color:#55dfe5;font-size:11px">${groups.join('/')}集团 · ${relCount} 家关联保司</div>` : '';
    tooltip.style.display = 'block';
    tooltip.style.left = Math.min(e.clientX + 12, window.innerWidth - 200) + 'px';
    tooltip.style.top = Math.min(e.clientY + 12, window.innerHeight - 80) + 'px';
    tooltip.innerHTML = `<div class="tooltip-name">${COMPANIES[idx].name}</div><div class="tooltip-info">${COMPANIES[idx].nature} · 注册资本 ${COMPANIES[idx].capital} 亿 · ${COMPANIES[idx].products.length} 款产品</div>${relInfo}<div style="margin-top:4px;color:var(--muted);font-size:11px">点击进入星系</div>`;
  } else {
    if (hoveredPoet !== null) { poetSprites[hoveredPoet].scale.set(poetSprites[hoveredPoet].userData.originalScale, poetSprites[hoveredPoet].userData.originalScale, 1); poetLabels[hoveredPoet].classList.remove('focus'); poetLabels[hoveredPoet].style.color = ''; hoveredPoet = null; }
    clearGroupHighlight();
    tooltip.style.display = 'none';
    renderer.domElement.style.cursor = 'crosshair';
  }
});

renderer.domElement.addEventListener('click', (e) => {
  mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
  mouse.y = -(e.clientY / window.innerHeight) * 2 + 1;
  raycaster.setFromCamera(mouse, camera);
  const hits = raycaster.intersectObjects(poetSprites);
  if (hits.length > 0) {
    const idx = hits[0].object.userData.poetIndex;
    flyToPoet(idx);
  } else {
    // 点虚空从噪声里捞险：若已选中保司，只捞该保司的产品
    const sourcePoet = currentPoet !== null ? COMPANIES[currentPoet] : COMPANIES[Math.floor(Math.random() * COMPANIES.length)];
    const sourceIdx = currentPoet !== null ? currentPoet : COMPANIES.indexOf(sourcePoet);
    const randomWork = sourcePoet.products[Math.floor(Math.random() * sourcePoet.products.length)];
    const wi = sourcePoet.products.indexOf(randomWork);
    const wf = productTypes[(sourceIdx + wi) % productTypes.length];
    const wc = typeColors[wf];
    voidPanel.innerHTML = `
      <button class="panel-close" id="void-close">&#10005;</button>
      <div class="poet-head"><div class="poet-name">${randomWork}</div><div class="poet-sub">${sourcePoet.name} · ${sourcePoet.nature} · <span style="color:${wc};border:1px solid ${wc}66;border-radius:4px;padding:0 4px;font-size:10px">${wf}</span></div></div>
      <div class="pi-body" style="margin-top:12px;font-family:var(--serif);color:#f1ede2;letter-spacing:.1em;font-size:16px;line-height:1.85">从噪声的星云中偶然捞得此险。</div>
      <div class="poem-foot" style="margin-top:16px">点击虚空继续探索…</div>`;
    voidPanel.style.display = 'block';
    document.getElementById('void-close').addEventListener('click', () => { voidPanel.style.display = 'none'; });
  }
});

document.addEventListener('keydown', (e) => { if (e.key === 'Escape') {
  if (currentPoet !== null) { poetLabels[currentPoet].classList.remove('focus'); poetSprites[currentPoet].scale.set(6, 6, 1); }
  clearGroupHighlight();
  const oldRelated = getRelatedCompanyIndices(currentPoet);
  oldRelated.forEach(ri => { poetSprites[ri].scale.set(poetSprites[ri].userData.originalScale, poetSprites[ri].userData.originalScale, 1); });
  poetPanel.style.display = 'none'; currentPoet = null; removeRadialLines(); controls.target.set(0,0,0); controls.autoRotateSpeed = 0.15; voidPanel.style.display = 'none';
} });

/* ============================================================
   加载进度
   ============================================================ */
const loadBar = document.getElementById('load-bar');
const loadCount = document.getElementById('load-count');
const loadingOverlay = document.getElementById('loading');

function setLoadProgress(pct, count) {
  if (loadBar) loadBar.style.width = pct + '%';
  if (loadCount) loadCount.textContent = count;
}

let loadStep = 0;
const loadInterval = setInterval(() => {
  loadStep += 3;
  if (loadStep > 100) { clearInterval(loadInterval); loadingOverlay.classList.add('done'); setTimeout(() => loadingOverlay.remove(), 800); }
  else setLoadProgress(loadStep, Math.floor(COMPANIES.length * loadStep / 100));
}, 30);

/* ============================================================
   动画循环
   ============================================================ */
const clock = new THREE.Clock();

function animate() {
  requestAnimationFrame(animate);
  const dt = clock.getDelta();
  const time = clock.getElapsedTime();

  controls.update();

  // WASD 飞行
  if (keys.w || keys.a || keys.s || keys.d) {
    const flySpeed = 80 * dt;
    const forward = new THREE.Vector3();
    camera.getWorldDirection(forward);
    const right = new THREE.Vector3();
    right.crossVectors(forward, camera.up).normalize();
    const move = new THREE.Vector3();
    if (keys.w) move.add(forward);
    if (keys.s) move.sub(forward);
    if (keys.d) move.add(right);
    if (keys.a) move.sub(right);
    if (move.lengthSq() > 0) {
      move.normalize().multiplyScalar(flySpeed);
      camera.position.add(move);
      controls.target.add(move);
    }
  }

  // 更新星空 shader time
  starfield.material.uniforms.uTime.value = time;
  if (satelliteStars) satelliteStars.material.uniforms.uTime.value = time;

  // 更新流星
  updateMeteors(dt, time);

  // 星云浮动
  nebulaSprites.forEach(s => {
    s.position.y = s.userData.origY + Math.sin(time * 0.3 + s.userData.phase) * 8;
    s.material.rotation += s.userData.rotSpeed;
  });

  // 光丝透明度呼吸
  if (filamentLines) {
    filamentLines.material.opacity = 0.15 + Math.sin(time * 0.5) * 0.05;
  }

  // 关系线呼吸动画
  if (groupRelLines && groupRelLines.visible) {
    groupRelLines.material.opacity = 0.12 + Math.sin(time * 0.8) * 0.06;
  }
  // 高亮关系线呼吸
  if (groupRelHighlightLines) {
    groupRelHighlightLines.material.opacity = 0.55 + Math.sin(time * 1.5) * 0.15;
  }

  // 径向线条呼吸动画
  if (radialLines) {
    radialLines.material.opacity = 0.35 + Math.sin(time * 2.0) * 0.1;
  }

  // 星系核心呼吸
  if (galaxyCore) {
    galaxyCore.material.opacity = 0.5 + Math.sin(time * 0.4) * 0.1;
  }

  // 动态速度显示（默认速度系数为1）
  const speedEl = document.getElementById('speed-display');
  const unitsEl = document.getElementById('units-display');
  if (speedEl && unitsEl) {
    const rotSpeed = controls.autoRotateSpeed;
    const speedVal = (rotSpeed / 0.15).toFixed(2);
    const unitsVal = Math.round(140 * rotSpeed / 0.15);
    speedEl.textContent = '×' + speedVal;
    unitsEl.textContent = unitsVal;
  }

  // 选中保司时锁定旋转中心
  if (currentPoet !== null) {
    controls.target.copy(poetPositions[currentPoet]);
  }

  // 更新保司标签位置（仅悬停/选中时显示，紧贴星点）
  for (let i = 0; i < poetLabels.length; i++) {
    const pos = poetPositions[i].clone();
    pos.project(camera);
    const tx = (pos.x * 0.5 + 0.5) * window.innerWidth;
    const ty = (-pos.y * 0.5 + 0.5) * window.innerHeight;
    const coord = poetLabelCoords[i];
    const smooth = 0.2; // 悬停/选中时用更快的插值
    coord.x += (tx - coord.x) * smooth;
    coord.y += (ty - coord.y) * smooth;
    // 仅悬停或选中时才显示标签
    const isHovered = (hoveredPoet === i);
    const isSelected = (currentPoet === i);
    // 选中保司的关联保司也显示标签
    const isRelated = isSelected ? false : (currentPoet !== null && getRelatedCompanyIndices(currentPoet).has(i));
    const shouldShow = (pos.z < 1) && (isHovered || isSelected || isRelated);
    if (shouldShow !== coord.visible) {
      coord.visible = shouldShow;
      poetLabels[i].style.display = shouldShow ? 'block' : 'none';
    }
    if (shouldShow) {
      // 标签偏移：紧贴星点下方
      const offsetY = isSelected ? 18 : 14;
      poetLabels[i].style.transform = `translate3d(${coord.x.toFixed(1)}px, ${(coord.y + offsetY).toFixed(1)}px, 0) translate(-50%, 0)`;
    }
  }

  renderer.render(scene, camera);
}

animate();

// 窗口大小调整
window.addEventListener('resize', () => {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
});

console.log('保险宇宙已启动:', COMPANIES.length, '家保司');

  // Start animation loop
  animate()

  // Return cleanup function
  return () => {
    if (typeof animId !== 'undefined' && animId) {
      cancelAnimationFrame(animId)
    }
  }
}
