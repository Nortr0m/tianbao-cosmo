// @ts-nocheck
/* eslint-disable */
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import { natureColors, productTypes, typeColors } from './cosmosData'

// 关联类型配置
const RELATION_CONFIG = {
  1: { color: '#06b6d4', name: '同一集团', lineStyle: 'solid', width: 1.0 },       // 青色实线
  2: { color: '#8b5cf6', name: '同一大股东', lineStyle: 'dashed', width: 0.8 },    // 紫色虚线
  3: { color: '#f59e0b', name: '母子公司', lineStyle: 'solid', width: 1.2 },       // 金色实线+箭头
  4: { color: '#10b981', name: '参股投资', lineStyle: 'dotted', width: 0.6 }        // 绿色细虚线
}

export function initCosmosScene(companiesData: any[], relationsData: any[], onNavigate?: (path: string) => void, onProductClick?: (companyId: number, productName: string) => void, onCompanyClick?: (companyId: number, companyData: any) => void, onVoidFishing?: () => Promise<{ productName: string; companyName: string; companyNature: string; productType: string; productTypeColor: string; productBrief?: string; productHighlights?: string[]; suitableFor?: string; productId?: number; productTags?: string[]; coverageSummary?: string; recommendationScore?: number; briefStatus?: number } | null>) {
  const COMPANIES = companiesData
  const GROUP_RELATIONS = relationsData

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
   集团关系连线（多类型股权关系线）
   ============================================================ */
let equityRelationLines: Record<number, any> = {};        // 各类型关系线
let equityHighlightLines: Record<number, any> = {};      // 各类型高亮关系线
let equityRelVisible = true;       // 股权关系线总开关（默认开启）
let equityTypeVisible: Record<number, boolean> = { 1: true, 2: true, 3: true, 4: true }; // 各类型可见性

// 将十六进制颜色转换为RGB分量
function hexToRgb(hex: string) {
  const r = parseInt(hex.slice(1, 3), 16) / 255;
  const g = parseInt(hex.slice(3, 5), 16) / 255;
  const b = parseInt(hex.slice(5, 7), 16) / 255;
  return { r, g, b };
}

// 创建虚线几何体（通过点的疏密模拟虚线）
function createDashedLineGeometry(fromPos: THREE.Vector3, toPos: THREE.Vector3, colorRgb: any, dashSize = 4, gapSize = 3) {
  const positions = [];
  const colors = [];
  const dist = fromPos.distanceTo(toPos);
  const dashCount = Math.floor(dist / (dashSize + gapSize));
  const dir = toPos.clone().sub(fromPos).normalize();
  
  for (let i = 0; i < dashCount; i++) {
    const start = fromPos.clone().add(dir.clone().multiplyScalar(i * (dashSize + gapSize)));
    const end = fromPos.clone().add(dir.clone().multiplyScalar(i * (dashSize + gapSize) + dashSize));
    positions.push(start.x, start.y, start.z, end.x, end.y, end.z);
    colors.push(colorRgb.r, colorRgb.g, colorRgb.b, colorRgb.r, colorRgb.g, colorRgb.b);
  }
  
  const geo = new THREE.BufferGeometry();
  geo.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
  geo.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3));
  return geo;
}

// 创建点线（细虚线/点状线）几何体
function createDottedLineGeometry(fromPos: THREE.Vector3, toPos: THREE.Vector3, colorRgb: any, dotSpacing = 2.5) {
  const positions = [];
  const colors = [];
  const dist = fromPos.distanceTo(toPos);
  const dotCount = Math.floor(dist / dotSpacing);
  const dir = toPos.clone().sub(fromPos).normalize();
  
  for (let i = 0; i < dotCount; i++) {
    const pos = fromPos.clone().add(dir.clone().multiplyScalar(i * dotSpacing));
    const nextPos = fromPos.clone().add(dir.clone().multiplyScalar(i * dotSpacing + 0.5));
    positions.push(pos.x, pos.y, pos.z, nextPos.x, nextPos.y, nextPos.z);
    colors.push(colorRgb.r, colorRgb.g, colorRgb.b, colorRgb.r, colorRgb.g, colorRgb.b);
  }
  
  const geo = new THREE.BufferGeometry();
  geo.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
  geo.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3));
  return geo;
}

// 创建带箭头的线（用于母子公司关系）
function createArrowLine(fromPos: THREE.Vector3, toPos: THREE.Vector3, colorHex: string, colorRgb: any) {
  const group = new THREE.Group();
  
  // 主线
  const lineGeo = new THREE.BufferGeometry();
  const positions = [fromPos.x, fromPos.y, fromPos.z, toPos.x, toPos.y, toPos.z];
  const colors = [colorRgb.r, colorRgb.g, colorRgb.b, colorRgb.r, colorRgb.g, colorRgb.b];
  lineGeo.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
  lineGeo.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3));
  const lineMat = new THREE.LineBasicMaterial({
    vertexColors: true, transparent: true, opacity: 0.22,
    blending: THREE.AdditiveBlending, depthWrite: false
  });
  const line = new THREE.LineSegments(lineGeo, lineMat);
  group.add(line);
  
  // 箭头（用锥形表示，朝向子公司方向）
  const arrowDir = toPos.clone().sub(fromPos).normalize();
  const arrowLength = 8;
  const arrowPos = toPos.clone().sub(arrowDir.clone().multiplyScalar(arrowLength + 2));
  
  const arrowGeo = new THREE.ConeGeometry(2.5, arrowLength, 8);
  const arrowMat = new THREE.MeshBasicMaterial({
    color: new THREE.Color(colorHex),
    transparent: true,
    opacity: 0.35,
    blending: THREE.AdditiveBlending,
    depthWrite: false
  });
  const arrow = new THREE.Mesh(arrowGeo, arrowMat);
  arrow.position.copy(arrowPos);
  arrow.lookAt(toPos);
  arrow.rotateX(Math.PI / 2);
  group.add(arrow);
  
  return group;
}

// 创建所有类型的股权关系线
function createEquityRelationLines() {
  // 清理旧的
  Object.values(equityRelationLines).forEach(item => {
    if (item) {
      scene.remove(item);
      if (item.geometry) item.geometry.dispose();
      if (item.material) item.material.dispose();
      if (item.children) {
        item.children.forEach((child: any) => {
          if (child.geometry) child.geometry.dispose();
          if (child.material) child.material.dispose();
        });
      }
    }
  });
  equityRelationLines = {};

  // 按类型分组创建
  const typeGroups: Record<number, any[]> = {};
  
  GROUP_RELATIONS.forEach(rel => {
    const fromPos = poetPositions[rel.from];
    const toPos = poetPositions[rel.to];
    if (!fromPos || !toPos) return;
    
    const relType = rel.relationType || 1;
    const config = RELATION_CONFIG[relType] || RELATION_CONFIG[1];
    const colorRgb = hexToRgb(config.color);
    
    if (!typeGroups[relType]) typeGroups[relType] = [];
    
    if (config.lineStyle === 'solid' && relType !== 3) {
      // 实线 - 普通LineSegments
      typeGroups[relType].push({
        type: 'solid',
        from: fromPos,
        to: toPos,
        colorRgb
      });
    } else if (config.lineStyle === 'dashed') {
      // 虚线
      typeGroups[relType].push({
        type: 'dashed',
        from: fromPos,
        to: toPos,
        colorRgb
      });
    } else if (config.lineStyle === 'dotted') {
      // 点线
      typeGroups[relType].push({
        type: 'dotted',
        from: fromPos,
        to: toPos,
        colorRgb
      });
    } else if (relType === 3) {
      // 母子公司 - 带箭头
      typeGroups[relType].push({
        type: 'arrow',
        from: fromPos,
        to: toPos,
        colorHex: config.color,
        colorRgb
      });
    }
  });

  // 为每种类型创建合并的几何体
  Object.entries(typeGroups).forEach(([type, items]) => {
    const relType = parseInt(type);
    const config = RELATION_CONFIG[relType] || RELATION_CONFIG[1];
    
    if (relType === 3) {
      // 母子公司用Group（包含箭头）
      const group = new THREE.Group();
      items.forEach(item => {
        const arrow = createArrowLine(item.from, item.to, item.colorHex, item.colorRgb);
        group.add(arrow);
      });
      group.visible = equityRelVisible && equityTypeVisible[relType];
      scene.add(group);
      equityRelationLines[relType] = group;
    } else {
      // 其他类型合并为LineSegments
      const allPositions: number[] = [];
      const allColors: number[] = [];
      
      items.forEach(item => {
        if (item.type === 'solid') {
          allPositions.push(item.from.x, item.from.y, item.from.z, item.to.x, item.to.y, item.to.z);
          allColors.push(item.colorRgb.r, item.colorRgb.g, item.colorRgb.b, item.colorRgb.r, item.colorRgb.g, item.colorRgb.b);
        } else if (item.type === 'dashed') {
          const dist = item.from.distanceTo(item.to);
          const dashSize = 5, gapSize = 4;
          const dashCount = Math.floor(dist / (dashSize + gapSize));
          const dir = item.to.clone().sub(item.from).normalize();
          for (let i = 0; i < dashCount; i++) {
            const start = item.from.clone().add(dir.clone().multiplyScalar(i * (dashSize + gapSize)));
            const end = item.from.clone().add(dir.clone().multiplyScalar(i * (dashSize + gapSize) + dashSize));
            allPositions.push(start.x, start.y, start.z, end.x, end.y, end.z);
            allColors.push(item.colorRgb.r, item.colorRgb.g, item.colorRgb.b, item.colorRgb.r, item.colorRgb.g, item.colorRgb.b);
          }
        } else if (item.type === 'dotted') {
          const dist = item.from.distanceTo(item.to);
          const dotSpacing = 3;
          const dotCount = Math.floor(dist / dotSpacing);
          const dir = item.to.clone().sub(item.from).normalize();
          for (let i = 0; i < dotCount; i++) {
            const pos = item.from.clone().add(dir.clone().multiplyScalar(i * dotSpacing));
            const nextPos = item.from.clone().add(dir.clone().multiplyScalar(i * dotSpacing + 0.6));
            allPositions.push(pos.x, pos.y, pos.z, nextPos.x, nextPos.y, nextPos.z);
            allColors.push(item.colorRgb.r, item.colorRgb.g, item.colorRgb.b, item.colorRgb.r, item.colorRgb.g, item.colorRgb.b);
          }
        }
      });
      
      if (allPositions.length > 0) {
        const geo = new THREE.BufferGeometry();
        geo.setAttribute('position', new THREE.Float32BufferAttribute(allPositions, 3));
        geo.setAttribute('color', new THREE.Float32BufferAttribute(allColors, 3));
        const mat = new THREE.LineBasicMaterial({
          vertexColors: true, transparent: true, opacity: 0.22,
          blending: THREE.AdditiveBlending, depthWrite: false
        });
        const lines = new THREE.LineSegments(geo, mat);
        lines.visible = equityRelVisible && equityTypeVisible[relType];
        scene.add(lines);
        equityRelationLines[relType] = lines;
      }
    }
  });
}

// 高亮与指定保司相关的连线
function highlightEquityRelations(idx: number) {
  // 清理旧的高亮
  clearEquityHighlight();
  
  const typeHighlights: Record<number, any[]> = {};
  
  GROUP_RELATIONS.forEach(rel => {
    if (rel.from !== idx && rel.to !== idx) return;
    const fromPos = poetPositions[rel.from];
    const toPos = poetPositions[rel.to];
    if (!fromPos || !toPos) return;
    
    const relType = rel.relationType || 1;
    const config = RELATION_CONFIG[relType] || RELATION_CONFIG[1];
    const colorRgb = hexToRgb(config.color);
    
    if (!typeHighlights[relType]) typeHighlights[relType] = [];
    
    // 高亮用更亮的颜色
    const brightRgb = { r: Math.min(1, colorRgb.r * 1.5), g: Math.min(1, colorRgb.g * 1.5), b: Math.min(1, colorRgb.b * 1.5) };
    
    if (relType === 3) {
      typeHighlights[relType].push({ type: 'arrow', from: fromPos, to: toPos, colorHex: config.color, colorRgb: brightRgb });
    } else if (config.lineStyle === 'dashed') {
      typeHighlights[relType].push({ type: 'dashed', from: fromPos, to: toPos, colorRgb: brightRgb });
    } else if (config.lineStyle === 'dotted') {
      typeHighlights[relType].push({ type: 'dotted', from: fromPos, to: toPos, colorRgb: brightRgb });
    } else {
      typeHighlights[relType].push({ type: 'solid', from: fromPos, to: toPos, colorRgb: brightRgb });
    }
  });

  Object.entries(typeHighlights).forEach(([type, items]) => {
    const relType = parseInt(type);
    
    if (relType === 3) {
      const group = new THREE.Group();
      items.forEach(item => {
        const arrow = createArrowLine(item.from, item.to, item.colorHex, item.colorRgb);
        // 提高不透明度
        arrow.traverse((child: any) => {
          if (child.material) child.material.opacity = child.material.opacity * 2.5;
        });
        group.add(arrow);
      });
      scene.add(group);
      equityHighlightLines[relType] = group;
    } else {
      const allPositions: number[] = [];
      const allColors: number[] = [];
      
      items.forEach(item => {
        if (item.type === 'solid') {
          allPositions.push(item.from.x, item.from.y, item.from.z, item.to.x, item.to.y, item.to.z);
          allColors.push(item.colorRgb.r, item.colorRgb.g, item.colorRgb.b, item.colorRgb.r, item.colorRgb.g, item.colorRgb.b);
        } else if (item.type === 'dashed') {
          const dist = item.from.distanceTo(item.to);
          const dashSize = 5, gapSize = 4;
          const dashCount = Math.floor(dist / (dashSize + gapSize));
          const dir = item.to.clone().sub(item.from).normalize();
          for (let i = 0; i < dashCount; i++) {
            const start = item.from.clone().add(dir.clone().multiplyScalar(i * (dashSize + gapSize)));
            const end = item.from.clone().add(dir.clone().multiplyScalar(i * (dashSize + gapSize) + dashSize));
            allPositions.push(start.x, start.y, start.z, end.x, end.y, end.z);
            allColors.push(item.colorRgb.r, item.colorRgb.g, item.colorRgb.b, item.colorRgb.r, item.colorRgb.g, item.colorRgb.b);
          }
        } else if (item.type === 'dotted') {
          const dist = item.from.distanceTo(item.to);
          const dotSpacing = 3;
          const dotCount = Math.floor(dist / dotSpacing);
          const dir = item.to.clone().sub(item.from).normalize();
          for (let i = 0; i < dotCount; i++) {
            const pos = item.from.clone().add(dir.clone().multiplyScalar(i * dotSpacing));
            const nextPos = item.from.clone().add(dir.clone().multiplyScalar(i * dotSpacing + 0.6));
            allPositions.push(pos.x, pos.y, pos.z, nextPos.x, nextPos.y, nextPos.z);
            allColors.push(item.colorRgb.r, item.colorRgb.g, item.colorRgb.b, item.colorRgb.r, item.colorRgb.g, item.colorRgb.b);
          }
        }
      });
      
      if (allPositions.length > 0) {
        const geo = new THREE.BufferGeometry();
        geo.setAttribute('position', new THREE.Float32BufferAttribute(allPositions, 3));
        geo.setAttribute('color', new THREE.Float32BufferAttribute(allColors, 3));
        const mat = new THREE.LineBasicMaterial({
          vertexColors: true, transparent: true, opacity: 0.75,
          blending: THREE.AdditiveBlending, depthWrite: false
        });
        const lines = new THREE.LineSegments(geo, mat);
        scene.add(lines);
        equityHighlightLines[relType] = lines;
      }
    }
  });
}

// 清除高亮
function clearEquityHighlight() {
  Object.values(equityHighlightLines).forEach(item => {
    if (item) {
      scene.remove(item);
      if (item.geometry) item.geometry.dispose();
      if (item.material) item.material.dispose();
      if (item.children) {
        item.children.forEach((child: any) => {
          if (child.geometry) child.geometry.dispose();
          if (child.material) child.material.dispose();
        });
      }
    }
  });
  equityHighlightLines = {};
}

// 切换股权关系线总开关
function toggleEquityRelations(visible: boolean) {
  equityRelVisible = visible;
  Object.entries(equityRelationLines).forEach(([type, line]) => {
    if (line) {
      line.visible = visible && equityTypeVisible[parseInt(type)];
    }
  });
}

// 切换某类型关系线
function toggleEquityType(type: number, visible: boolean) {
  equityTypeVisible[type] = visible;
  if (equityRelationLines[type]) {
    equityRelationLines[type].visible = equityRelVisible && visible;
  }
}

// 获取与指定保司有关系的所有保司索引
function getRelatedCompanyIndices(idx: number) {
  const related = new Set();
  GROUP_RELATIONS.forEach(rel => {
    if (rel.from === idx) related.add(rel.to);
    if (rel.to === idx) related.add(rel.from);
  });
  return related;
}

// 获取指定保司的关联关系详情
function getCompanyRelations(idx: number) {
  const relations: any[] = [];
  GROUP_RELATIONS.forEach(rel => {
    if (rel.from === idx || rel.to === idx) {
      const otherIdx = rel.from === idx ? rel.to : rel.from;
      relations.push({
        index: otherIdx,
        companyName: COMPANIES[otherIdx]?.name || '',
        relationType: rel.relationType || 1,
        relationName: rel.relationName || rel.group || ''
      });
    }
  });
  return relations;
}

// 获取指定保司的主要股东（从星系数据）
function getCompanyShareholders(idx: number) {
  return COMPANIES[idx]?.shareholders || [];
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
  label.style.display = 'none';
  label.style.color = natureColors[company.nature] || '#ffd27a';
  // 鼠标悬停标签时也触发星点高亮
  label.addEventListener('mouseenter', () => {
    if (hoveredPoet !== null && hoveredPoet !== i && hoveredPoet !== currentPoet) {
      poetSprites[hoveredPoet].scale.set(poetSprites[hoveredPoet].userData.originalScale, poetSprites[hoveredPoet].userData.originalScale, 1);
      poetLabels[hoveredPoet].classList.remove('focus');
      poetLabels[hoveredPoet].style.color = natureColors[COMPANIES[hoveredPoet].nature] || '#ffd27a';
    }
    hoveredPoet = i;
    renderer.domElement.style.cursor = 'pointer';
    if (currentPoet === i) return;
    const hScale = poetSprites[i].userData.originalScale * 1.6;
    poetSprites[i].scale.set(hScale, hScale, 1);
    const hColor = natureColors[COMPANIES[i].nature] || '#ffd27a';
    poetLabels[i].classList.add('focus');
    poetLabels[i].style.color = hColor;
    controls.autoRotateSpeed = 0.2;
    if (equityRelVisible) highlightEquityRelations(i);
  });
  label.addEventListener('mouseleave', () => {
    if (hoveredPoet === i) {
      if (currentPoet !== i) {
        poetSprites[i].scale.set(poetSprites[i].userData.originalScale, poetSprites[i].userData.originalScale, 1);
        poetLabels[i].classList.remove('focus');
        poetLabels[i].style.color = natureColors[COMPANIES[i].nature] || '#ffd27a';
      }
      hoveredPoet = null;
      renderer.domElement.style.cursor = 'crosshair';
      clearEquityHighlight();
      if (currentPoet === null) controls.autoRotateSpeed = 0.15;
    }
  });
  labelContainer.appendChild(label);
  poetLabels.push(label);
  poetLabelCoords.push({ x: 0, y: 0, visible: false });
}

// 初始化股权关系连线（必须在poetPositions填充之后）
createEquityRelationLines();

/* ============================================================
   UI 组件
   ============================================================ */
// 左侧面板
const hudTop = document.createElement('div');
hudTop.className = 'hud-top';
hudTop.style.cssText = 'pointer-events:none;z-index:20;position:fixed;top:96px;left:20px;right:auto;width:220px;display:flex;flex-direction:column;gap:0;align-items:stretch;';
const totalWorks = COMPANIES.reduce((sum, p) => sum + p.products.length, 0);

// 股权关系图例HTML
const relationLegendHtml = `
  <div class="hud-section hud-equity-section">
    <div class="equity-toggle-row">
      <span class="equity-toggle-label">股权关系</span>
      <label class="switch">
        <input type="checkbox" id="equity-toggle" checked>
        <span class="slider"></span>
      </label>
    </div>
    <div class="equity-legend-list" id="equity-legend-list">
      <div class="equity-legend-item" data-type="1">
        <span class="equity-line equity-line-solid" style="background:#06b6d4"></span>
        <span class="equity-legend-name">同一集团</span>
      </div>
      <div class="equity-legend-item" data-type="2">
        <span class="equity-line equity-line-dashed" style="background:linear-gradient(to right,#8b5cf6 50%,transparent 50%);background-size:8px 2px"></span>
        <span class="equity-legend-name">同一大股东</span>
      </div>
      <div class="equity-legend-item" data-type="3">
        <span class="equity-line equity-line-arrow" style="background:#f59e0b">➤</span>
        <span class="equity-legend-name">母子公司</span>
      </div>
      <div class="equity-legend-item" data-type="4">
        <span class="equity-line equity-line-dotted" style="background:radial-gradient(circle,#10b981 1.5px,transparent 1.5px);background-size:4px 2px"></span>
        <span class="equity-legend-name">参股投资</span>
      </div>
    </div>
  </div>`;

hudTop.innerHTML = `
  <div class="hud-panel">
    <!-- 模式切换 -->
    <div class="hud-section">
      <div class="hud-seg">
        <button class="seg-btn on" data-mode="poet">保司</button>
        <button class="seg-btn" data-mode="search">寻险</button>
        <button class="seg-btn" data-mode="explore">探险</button>
      </div>
    </div>
    <!-- 搜索框 -->
    <div class="hud-section hud-search-section">
      <div class="search hud-search">
        <input type="text" placeholder="搜索保司…（回车飞到第一个）" id="search-input" autocomplete="off">
        <div class="search-results" id="search-results"></div>
      </div>
    </div>
    <!-- 险种图例 -->
    <div class="hud-section">
      <div class="legend hud-legend">
        <div class="legend-head">
          <span>险种筛选</span>
          <div class="legend-presets">
            <button>全部</button>
            <button>无</button>
          </div>
        </div>
        <div class="legend-list">
          <button class="legend-row" data-type="all"><span class="dot" style="background:#ffd27a;box-shadow:0 0 6px #ffd27a"></span><span class="legend-label">全部</span></button>
          <button class="legend-row" data-type="重疾险"><span class="dot" style="background:#1890ff;box-shadow:0 0 6px #1890ff"></span><span class="legend-label">重疾险</span></button>
          <button class="legend-row" data-type="增额终身寿"><span class="dot" style="background:#52c41a;box-shadow:0 0 6px #52c41a"></span><span class="legend-label">增额寿</span></button>
          <button class="legend-row" data-type="年金险"><span class="dot" style="background:#faad14;box-shadow:0 0 6px #faad14"></span><span class="legend-label">年金险</span></button>
        </div>
      </div>
    </div>
    ${relationLegendHtml}
    <!-- 操作按钮 -->
    <div class="hud-section hud-actions-section">
      <button class="ui-hide-btn" id="quality-btn">画质 · 低</button>
      <button class="ui-hide-btn" id="hide-btn">隐藏界面 · H</button>
    </div>
    <!-- 统计信息 -->
    <div class="hud-section hud-stat-section">
      <div class="hud-stat">
        <span class="pull-count">${COMPANIES.length.toLocaleString()}</span> 家保司
      </div>
      <div class="hud-stat">
        <span class="pull-count">${totalWorks.toLocaleString()}</span> 款产品
      </div>
    </div>
  </div>`;
// 使子元素可交互
hudTop.querySelectorAll('*').forEach(el => { if(el.style) el.style.pointerEvents = 'auto'; });
root.appendChild(hudTop);

// 底部栏
const hudBottom = document.createElement('div');
hudBottom.className = 'hud-bottom';
hudBottom.innerHTML = `<div class="hint"><b>WASD</b> 飞行 · 拖拽转向 · 滚轮调速 · 点保司星看其详情 · 点虚空从噪声里捞险</div><div>速度 <span class="speed" id="speed-display">×1.00</span> · <span id="units-display">140</span> 单位/秒</div>`;
root.appendChild(hudBottom);

// 引用搜索和图例元素
const legend = hudTop.querySelector('.legend');
const searchBox = hudTop.querySelector('.search');

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
let hoverPauseTimer: ReturnType<typeof setTimeout> | null = null;
const HOVER_PAUSE_DURATION = 2500;
let savedRotateSpeed = 0.15;

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
  const transform = uiVisible ? '' : 'translateX(-120%)';
  hudTop.style.opacity = opacity; hudTop.style.transform = transform;
  hudBottom.style.opacity = opacity;
  hudTop.style.pointerEvents = uiVisible ? 'auto' : 'none';
  hudBottom.style.pointerEvents = uiVisible ? 'auto' : 'none';
  if (!uiVisible) {
    poetPanel.style.display = 'none';
    voidPanel.style.display = 'none';
    tooltip.style.display = 'none';
  }
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

// 股权关系总开关
const equityToggle = document.getElementById('equity-toggle') as HTMLInputElement;
if (equityToggle) {
  equityToggle.addEventListener('change', function() {
    toggleEquityRelations(this.checked);
    const legendList = document.getElementById('equity-legend-list');
    if (legendList) {
      legendList.style.opacity = this.checked ? '1' : '0.4';
      legendList.style.pointerEvents = this.checked ? 'auto' : 'none';
    }
  });
}

// 股权关系类型开关（点击图例项切换）
document.querySelectorAll('.equity-legend-item').forEach(item => {
  const type = parseInt((item as HTMLElement).dataset.type || '1');
  item.addEventListener('click', () => {
    const isActive = !item.classList.contains('off');
    item.classList.toggle('off');
    toggleEquityType(type, isActive);
  });
});

// 画质切换
document.getElementById('quality-btn').addEventListener('click', function() {
  const high = this.textContent === '画质·低';
  this.textContent = high ? '画质·高' : '画质·低';
  renderer.setPixelRatio(high ? Math.min(window.devicePixelRatio, 2) : 1);
});

const formToFilter = { 'wujue':'重疾险', 'changyong':'增额终身寿', 'ziyou':'年金险' };

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
    }
  });
});

let exploreTimer = null;
function startExplore() {
  if (exploreTimer) clearInterval(exploreTimer);
  flyToPoet(Math.floor(Math.random() * COMPANIES.length));
  let count = 0;
  exploreTimer = setInterval(() => {
    if (currentMode !== 'explore' || count >= 20) { clearInterval(exploreTimer); exploreTimer = null; return; }
    const idx = Math.floor(Math.random() * COMPANIES.length);
    flyToPoet(idx);
    count++;
  }, 6000);
}

function resetExploreTimer() {
  if (currentMode === 'explore' && exploreTimer) {
    clearInterval(exploreTimer);
    let count = 0;
    exploreTimer = setInterval(() => {
      if (currentMode !== 'explore' || count >= 20) { clearInterval(exploreTimer); exploreTimer = null; return; }
      const idx = Math.floor(Math.random() * COMPANIES.length);
      flyToPoet(idx);
      count++;
    }, 6000);
  }
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
      const poet = COMPANIES[i];
      let match = false;
      if (type === 'all') { match = true; }
      else { match = poet.products.some((_, wi) => productTypes[(i + wi) % productTypes.length] === type); }
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
      const poet = COMPANIES[i];
      if (type === 'all') { spr.visible = visible; }
      else {
        const hasForm = poet.products.some((_, wi) => productTypes[(i + wi) % productTypes.length] === type);
        if (hasForm) { spr.visible = visible; }
      }
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
  // 关闭虚空捞取面板，避免叠加显示
  voidPanel.style.display = 'none';
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
      controls.autoRotateSpeed = 0.3825;
      camera.lookAt(poetPositions[idx]);
      // 高亮当前保司标签
      const natureColor = natureColors[COMPANIES[idx].nature] || '#ffd27a';
      poetLabels[idx].classList.add('focus');
      poetLabels[idx].style.color = natureColor;
      poetSprites[idx].scale.set(poetSprites[idx].userData.originalScale * 1.6, poetSprites[idx].userData.originalScale * 1.6, 1);
      // 立即跳转选中保司的标签坐标
      const sPos = poetPositions[idx].clone().project(camera);
      poetLabelCoords[idx].x = (sPos.x * 0.5 + 0.5) * window.innerWidth;
      poetLabelCoords[idx].y = (-sPos.y * 0.5 + 0.5) * window.innerHeight;
      // 高亮该保司的关系线
      if (equityRelVisible) highlightEquityRelations(idx);
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

  // 卫星星星
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
  
  // 获取关联保司信息（按类型分组）
  const relatedIndices = getRelatedCompanyIndices(idx);
  const companyRelations = getCompanyRelations(idx);
  const shareholders = getCompanyShareholders(idx);
  
  // 按关联类型分组显示
  const relationByType: Record<number, any[]> = {};
  companyRelations.forEach(rel => {
    if (!relationByType[rel.relationType]) relationByType[rel.relationType] = [];
    relationByType[rel.relationType].push(rel);
  });
  
  // 生成关联保司HTML
  let relatedHtml = '';
  if (relatedIndices.size > 0) {
    const typeLabels: Record<number, string> = {
      1: '同一集团', 2: '同一大股东', 3: '母子公司', 4: '参股投资'
    };
    const typeColors: Record<number, string> = {
      1: '#06b6d4', 2: '#8b5cf6', 3: '#f59e0b', 4: '#10b981'
    };
    
    let relationsListHtml = '';
    Object.entries(relationByType).forEach(([type, rels]) => {
      const relType = parseInt(type);
      const color = typeColors[relType] || '#55dfe5';
      const label = typeLabels[relType] || '关联';
      relationsListHtml += `
        <div style="margin-bottom:8px;">
          <div style="font-size:11px;color:${color};margin-bottom:4px;font-weight:600">◆ ${label}</div>
          <div style="font-size:12px;color:var(--muted);line-height:1.8">
            ${rels.map(r => `<span style="color:${natureColors[COMPANIES[r.index]?.nature] || '#aaa'};cursor:pointer" class="related-company" data-idx="${r.index}">${r.companyName}</span>`).join(' · ')}
          </div>
        </div>`;
    });
    
    // 主要股东信息（前3名）
    let shareholdersHtml = '';
    if (shareholders && shareholders.length > 0) {
      const topShareholders = shareholders.slice(0, 3);
      shareholdersHtml = `
        <div style="margin-bottom:10px;padding:10px;background:rgba(255,210,122,0.06);border:1px solid rgba(255,210,122,0.15);border-radius:8px;">
          <div style="font-size:12px;color:var(--gold);margin-bottom:8px;font-weight:bold">主要股东</div>
          <div style="display:flex;flex-direction:column;gap:6px;">
            ${topShareholders.map((s: any, si: number) => `
              <div style="display:flex;align-items:center;justify-content:space-between;gap:8px;">
                <span style="font-size:12px;color:var(--fg);flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${si + 1}. ${s.name}</span>
                <span style="font-size:11px;color:var(--muted);font-weight:600">${s.ratio}</span>
              </div>
            `).join('')}
          </div>
        </div>`;
    }
    
    relatedHtml = `
      <div style="margin-bottom:12px;padding:10px;background:rgba(85,223,229,0.04);border:1px solid rgba(85,223,229,0.15);border-radius:8px;">
        <div style="font-size:12px;color:#55dfe5;margin-bottom:8px;font-weight:bold">关联保司 · ${relatedIndices.size} 家</div>
        ${relationsListHtml}
      </div>
      ${shareholdersHtml}
      <div style="margin-bottom:12px;text-align:center;">
        <button class="ui-hide-btn" id="btn-detail" style="width:100%;padding:8px 16px;border-color:#ffd27a66;color:#ffd27a;">
          查看完整公司详情 →
        </button>
      </div>`;
  }

  poetPanel.innerHTML = `
    <button class="panel-close">&#10005;</button>
    <div class="poet-head"><div class="poet-name">${poet.name}</div><div class="poet-sub">${poet.nature} · 注册资本 ${poet.capital} 亿 · ${poet.products.length} 款真实产品</div></div>
    <div style="display:flex;gap:8px;margin-bottom:10px;">
      <button class="ui-hide-btn" id="btn-prev" style="flex:1;font-size:12px;padding:5px 0;">&#9664; 上一个</button>
      <button class="ui-hide-btn" id="btn-next" style="flex:1;font-size:12px;padding:5px 0;">下一个 &#9654;</button>
    </div>
    ${relatedHtml}
    <div style="display:flex;gap:8px;margin-bottom:12px;">
      <button class="ui-hide-btn" id="btn-share" style="flex:1;font-size:12px;padding:5px 0;">分享</button>
    </div>
    <div class="poem-list">${poet.products.map((w, wi) => {
      const form = productTypes[(idx + wi) % productTypes.length];
      const fColor = typeColors[form];
      const pseudoLines = ['${w}，开篇起兴。','声律铿锵，对仗工整。','意境深远，余韵悠长。','结句收束，回味无穷。'];
      return `<div class="poem-item" data-wi="${wi}"><div class="pi-title"><span class="product-name-link" data-product-name="${w}" style="cursor:pointer;color:#67e8f9;text-decoration:underline;text-underline-offset:3px">${w}</span><span class="pi-form" style="border-color:${fColor};color:${fColor};margin-left:6px">${form}</span><span style="color:var(--muted);font-size:10px;margin-left:6px">#${(idx*1000+wi+1).toString().padStart(6,'0')}</span></div><div class="pi-detail" style="display:none;margin-top:6px;padding:8px 10px;background:rgba(255,255,255,0.03);border-radius:6px;border-left:2px solid ${fColor}"><div style="font-family:var(--serif);color:#f1ede2;letter-spacing:.08em;font-size:13px;line-height:1.9">${pseudoLines[wi%4]}</div></div></div>`;
    }).join('')}</div>
    <div class="poem-foot">共 ${poet.products.length} 款产品</div>`;
  poetPanel.style.display = 'block';
  poetPanel.querySelector('.panel-close').addEventListener('click', () => {
    if (currentPoet !== null) { poetLabels[currentPoet].classList.remove('focus'); poetSprites[currentPoet].scale.set(6, 6, 1); }
    clearEquityHighlight();
    const oldRelated = getRelatedCompanyIndices(currentPoet);
    oldRelated.forEach(ri => { poetSprites[ri].scale.set(poetSprites[ri].userData.originalScale, poetSprites[ri].userData.originalScale, 1); });
    poetPanel.style.display = 'none'; currentPoet = null; removeRadialLines(); controls.target.set(0,0,0); controls.autoRotateSpeed = 0.15;
  });

  // 上一个/下一个按钮
  const btnPrev = poetPanel.querySelector('#btn-prev');
  const btnNext = poetPanel.querySelector('#btn-next');
  if (btnPrev) {
    btnPrev.addEventListener('click', () => {
      const newIdx = (idx - 1 + COMPANIES.length) % COMPANIES.length;
      flyToPoet(newIdx);
      resetExploreTimer();
    });
  }
  if (btnNext) {
    btnNext.addEventListener('click', () => {
      const newIdx = (idx + 1) % COMPANIES.length;
      flyToPoet(newIdx);
      resetExploreTimer();
    });
  }

  // 查看完整详情按钮
  const btnDetail = poetPanel.querySelector('#btn-detail');
  if (btnDetail) {
    btnDetail.addEventListener('click', () => {
      if (onCompanyClick) {
        onCompanyClick(poet.companyId || idx + 1, poet);
      }
    });
  }

  // 关联保司点击跳转
  poetPanel.querySelectorAll('.related-company').forEach(el => {
    el.addEventListener('click', () => {
      const targetIdx = +el.dataset.idx;
      flyToPoet(targetIdx);
    });
  });

  // 产品标题点击 — 弹出产品详情弹窗
  poetPanel.querySelectorAll('.product-name-link').forEach(link => {
    link.addEventListener('click', (e) => {
      e.stopPropagation();
      const productName = link.dataset.productName;
      if (onProductClick) {
        onProductClick(poet.companyId || 0, productName);
      }
    });
  });

  // 产品标题点击展开详情
  poetPanel.querySelectorAll('.pi-title').forEach(title => {
    title.addEventListener('click', (e) => {
      if (e.target.classList.contains('product-name-link')) return;
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
    const text = `我在天保星君中发现了 ${poet.name}（${poet.nature}）的 ${poet.products.length} 款产品，快来一起探索吧！`;
    navigator.clipboard.writeText(text).then(() => alert('已复制到剪贴板'));
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
      if (hoverPauseTimer) clearTimeout(hoverPauseTimer);
      controls.autoRotateSpeed = 0;
      hoverPauseTimer = setTimeout(() => {
        hoverPauseTimer = null;
        if (currentPoet === null && hoveredPoet === idx) {
          controls.autoRotateSpeed = 0.15;
        }
      }, HOVER_PAUSE_DURATION);
      const hPos = poetPositions[idx].clone().project(camera);
      poetLabelCoords[idx].x = (hPos.x * 0.5 + 0.5) * window.innerWidth;
      poetLabelCoords[idx].y = (-hPos.y * 0.5 + 0.5) * window.innerHeight;
      const hScale = poetSprites[idx].userData.originalScale * 1.6;
      poetSprites[idx].scale.set(hScale, hScale, 1);
      const hColor = natureColors[COMPANIES[idx].nature] || '#ffd27a';
      poetLabels[idx].classList.add('focus');
      poetLabels[idx].style.color = hColor;
      renderer.domElement.style.cursor = 'pointer';
      if (equityRelVisible) highlightEquityRelations(idx);
    }
    // tooltip显示关系信息
    const relCount = getRelatedCompanyIndices(idx).size;
    const shareholders = getCompanyShareholders(idx);
    const topShareholder = shareholders?.[0]?.name || '';
    const relInfo = relCount > 0 ? `<div style="margin-top:3px;color:#55dfe5;font-size:11px">${relCount} 家关联保司${topShareholder ? ' · 控股股东: ' + topShareholder : ''}</div>` : '';
    tooltip.style.display = 'block';
    tooltip.style.left = Math.min(e.clientX + 12, window.innerWidth - 200) + 'px';
    tooltip.style.top = Math.min(e.clientY + 12, window.innerHeight - 80) + 'px';
    tooltip.innerHTML = `<div class="tooltip-name">${COMPANIES[idx].name}</div><div class="tooltip-info">${COMPANIES[idx].nature} · 注册资本 ${COMPANIES[idx].capital} 亿 · ${COMPANIES[idx].products.length} 款产品</div>${relInfo}<div style="margin-top:4px;color:var(--muted);font-size:11px">点击查看详情</div>`;
  } else {
    if (hoveredPoet !== null) { poetSprites[hoveredPoet].scale.set(poetSprites[hoveredPoet].userData.originalScale, poetSprites[hoveredPoet].userData.originalScale, 1); poetLabels[hoveredPoet].classList.remove('focus'); poetLabels[hoveredPoet].style.color = ''; hoveredPoet = null; if (currentPoet === null) controls.autoRotateSpeed = 0.15; }
    clearEquityHighlight();
    tooltip.style.display = 'none';
    renderer.domElement.style.cursor = 'crosshair';
    if (hoverPauseTimer) { clearTimeout(hoverPauseTimer); hoverPauseTimer = null; }
  }
});

renderer.domElement.addEventListener('click', (e) => {
  mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
  mouse.y = -(e.clientY / window.innerHeight) * 2 + 1;
  raycaster.setFromCamera(mouse, camera);
  const hits = raycaster.intersectObjects(poetSprites);
  if (hits.length > 0) {
    const idx = hits[0].object.userData.poetIndex;
    if (hoverPauseTimer) { clearTimeout(hoverPauseTimer); hoverPauseTimer = null; }
    flyToPoet(idx);
  } else {
    // 点虚空从噪声里捞险
    // 如果有回调函数，从后端获取真实产品简介
    if (onVoidFishing) {
      // 先显示加载状态
      voidPanel.innerHTML = `
        <button class="panel-close" id="void-close">&#10005;</button>
        <div class="poet-head"><div class="poet-name">正在捞取…</div><div class="poet-sub">从星云雾霭中探寻</div></div>
        <div class="pi-body" style="margin-top:20px;text-align:center;color:#9a8f7a"><span style="display:inline-block;width:12px;height:12px;border:2px solid #ffd27a;border-top-color:transparent;border-radius:50%;animation:spin 0.8s linear infinite"></span></div>
        <div class="poem-foot" style="margin-top:16px">稍候片刻…</div>`;
      voidPanel.style.display = 'block';
      document.getElementById('void-close').addEventListener('click', () => { voidPanel.style.display = 'none'; });

      // 异步获取真实产品数据
      onVoidFishing().then(productData => {
        if (!productData) {
          voidPanel.style.display = 'none';
          return;
        }
        const highlightsHtml = productData.productHighlights && productData.productHighlights.length > 0
          ? productData.productHighlights.slice(0, 4).map(h => `<div class="void-highlight-item"><span class="highlight-dot">✦</span>${h}</div>`).join('')
          : '';

        // 推荐星级
        const score = productData.recommendationScore || 0
        const starsHtml = score > 0
          ? `<div class="void-score">${'★'.repeat(score)}${'☆'.repeat(5 - score)}<span class="score-text">推荐指数</span></div>`
          : ''

        // 产品标签
        const tagsHtml = productData.productTags && productData.productTags.length > 0
          ? `<div class="void-tags">${productData.productTags.slice(0, 4).map(t => `<span class="void-tag">${t}</span>`).join('')}</div>`
          : ''

        // 保障摘要
        const coverageHtml = productData.coverageSummary
          ? `<div class="void-coverage"><span class="coverage-icon">🛡</span><span>${productData.coverageSummary}</span></div>`
          : ''

        // AI生成标识
        const aiBadgeHtml = productData.briefStatus === 1
          ? `<div class="void-ai-badge">⚡ AI智能生成</div>`
          : ''

        // 兜底：无任何简介内容时
        const hasBriefContent = productData.productBrief || (productData.productHighlights && productData.productHighlights.length > 0) || productData.suitableFor || productData.coverageSummary
        const fallbackHtml = !hasBriefContent
          ? `<div class="void-fallback">本产品正在整理资料中<br/>点击查看详情了解更多</div>`
          : ''

        voidPanel.innerHTML = `
          <button class="panel-close" id="void-close">&#10005;</button>
          <div class="poet-head">
            <div class="poet-name-row">
              <div class="poet-name">${productData.productName}</div>
              ${aiBadgeHtml}
            </div>
            <div class="poet-sub">
              ${productData.companyName} · ${productData.companyNature} · 
              <span style="color:${productData.productTypeColor};border:1px solid ${productData.productTypeColor}66;border-radius:4px;padding:0 4px;font-size:10px">${productData.productType}</span>
            </div>
            ${starsHtml}
            ${tagsHtml}
          </div>
          ${fallbackHtml}
          ${productData.productBrief ? `<div class="void-brief">${productData.productBrief}</div>` : ''}
          ${highlightsHtml ? `<div class="void-highlights">${highlightsHtml}</div>` : ''}
          ${coverageHtml}
          ${productData.suitableFor ? `<div class="void-suitable"><span class="suitable-label">适合人群：</span>${productData.suitableFor}</div>` : ''}
          <div class="void-actions">
            <button class="void-detail-btn" id="void-detail-btn">查看详情</button>
          </div>
          <div class="poem-foot" style="margin-top:12px">点击虚空继续探索…</div>`;
        voidPanel.style.display = 'block';
        document.getElementById('void-close').addEventListener('click', () => { voidPanel.style.display = 'none'; });
        const detailBtn = document.getElementById('void-detail-btn');
        if (detailBtn && productData.productId && onNavigate) {
          detailBtn.addEventListener('click', () => {
            voidPanel.style.display = 'none';
            onNavigate(`/product/${productData.productId}`);
          });
        } else if (detailBtn && productData.productId && onProductClick) {
          detailBtn.addEventListener('click', () => {
            voidPanel.style.display = 'none';
            onProductClick(productData.productId!, productData.productName);
          });
        }
      }).catch(() => {
        voidPanel.style.display = 'none';
      });
    } else {
      // Fallback: 使用演示数据
      const validCompanies = COMPANIES.filter(p => p.products.length > 0);
      const sourcePool = validCompanies.length > 0 ? validCompanies : COMPANIES;
      let sourcePoet, sourceIdx;
      if (currentPoet !== null && COMPANIES[currentPoet].products.length > 0) {
        sourcePoet = COMPANIES[currentPoet];
        sourceIdx = currentPoet;
      } else {
        sourcePoet = sourcePool[Math.floor(Math.random() * sourcePool.length)];
        sourceIdx = COMPANIES.indexOf(sourcePoet);
      }
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
  }
});

document.addEventListener('keydown', (e) => { if (e.key === 'Escape') {
  if (currentPoet !== null) { poetLabels[currentPoet].classList.remove('focus'); poetSprites[currentPoet].scale.set(6, 6, 1); }
  clearEquityHighlight();
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
  if (loadStep > 100) { clearInterval(loadInterval); loadingOverlay.classList.add('done'); setTimeout(() => loadingOverlay.remove(), 800); window.dispatchEvent(new CustomEvent('cosmos-loaded')); }
  else setLoadProgress(loadStep, Math.floor(COMPANIES.length * loadStep / 100));
}, 30);

/* ============================================================
   动画循环
   ============================================================ */
const clock = new THREE.Timer();

function animate() {
  requestAnimationFrame(animate);
  const dt = clock.getDelta();
  const time = clock.elapsedTime;

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

  // 股权关系线呼吸动画
  Object.values(equityRelationLines).forEach(line => {
    if (line && line.visible) {
      if (line.material) {
        line.material.opacity = 0.15 + Math.sin(time * 0.8) * 0.07;
      } else if (line.children) {
        line.children.forEach((child: any) => {
          if (child.material) {
            child.material.opacity = (child.material.opacity || 0.2) * (0.8 + Math.sin(time * 0.8) * 0.2);
          }
        });
      }
    }
  });
  
  // 高亮关系线呼吸
  Object.values(equityHighlightLines).forEach(line => {
    if (line) {
      if (line.material) {
        line.material.opacity = 0.6 + Math.sin(time * 1.5) * 0.15;
      } else if (line.children) {
        line.children.forEach((child: any) => {
          if (child.material) {
            child.material.opacity = (child.material.opacity || 0.7) * (0.85 + Math.sin(time * 1.5) * 0.15);
          }
        });
      }
    }
  });

  // 径向线条呼吸动画
  if (radialLines) {
    radialLines.material.opacity = 0.35 + Math.sin(time * 2.0) * 0.1;
  }

  // 星系核心呼吸
  if (galaxyCore) {
    galaxyCore.material.opacity = 0.5 + Math.sin(time * 0.4) * 0.1;
  }

  // 动态速度显示
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

  // 更新保司标签位置
  for (let i = 0; i < poetLabels.length; i++) {
    const pos = poetPositions[i].clone();
    pos.project(camera);
    const tx = (pos.x * 0.5 + 0.5) * window.innerWidth;
    const ty = (-pos.y * 0.5 + 0.5) * window.innerHeight;
    const coord = poetLabelCoords[i];
    const smooth = 0.2;
    coord.x += (tx - coord.x) * smooth;
    coord.y += (ty - coord.y) * smooth;
    const isHovered = (hoveredPoet === i);
    const isSelected = (currentPoet === i);
    const shouldShow = (pos.z < 1) && (isHovered || isSelected);
    if (shouldShow !== coord.visible) {
      coord.visible = shouldShow;
      poetLabels[i].style.display = shouldShow ? 'block' : 'none';
      if (shouldShow) {
        coord.x = tx;
        coord.y = ty;
      }
    }
    if (shouldShow) {
      const opacity = isSelected ? 1 : 0.85;
      const fontSize = isSelected ? 16 : 13;
      const fontWeight = isSelected ? 600 : 400;
      poetLabels[i].style.opacity = String(opacity);
      poetLabels[i].style.fontSize = fontSize + 'px';
      poetLabels[i].style.fontWeight = String(fontWeight);
      poetLabels[i].style.transform = `translate3d(${coord.x.toFixed(1)}px, ${coord.y.toFixed(1)}px, 0) translate(-50%, -50%)`;
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

console.log('天保星君已启动:', COMPANIES.length, '家保司');

  animate()

  // Return cleanup function
  return () => {
    if (typeof animId !== 'undefined' && animId) {
      cancelAnimationFrame(animId)
    }
  }
}
