// Official runtime stays outside the game. Pass its installation directory as argv[3].
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { createHash } from 'node:crypto';
import { fileURLToPath, pathToFileURL } from 'node:url';
const directory = path.resolve(process.argv[2] ?? path.dirname(fileURLToPath(import.meta.url)));
const corePath = process.argv[3];
assert(fs.existsSync(path.join(directory, 'warden-import.json')), 'Spine skeleton handoff is missing');
assert(corePath, 'Pass the installed official spine-core package directory');
const core = await import(pathToFileURL(path.join(path.resolve(corePath), 'dist/index.js')));
const json = JSON.parse(fs.readFileSync(path.join(directory, 'warden-import.json')));
const manifest = JSON.parse(fs.readFileSync(path.join(directory, 'attachments.json')));
const expected = JSON.parse(fs.readFileSync(path.join(directory, 'setup-geometry.json')));
assert.equal(manifest.images.length, 24, 'All body and equipment layers must be present');
assert(!json.constraints?.length && !json.ik?.length && !json.transform?.length && !json.physics?.length, 'Basic-bone handoff must not require constraints');
assert.equal(json.skins.length, 1);
assert.equal(json.skins[0].name, 'default');
const regions = new Map();
for (const entry of manifest.images) {
  const png = fs.readFileSync(path.join(directory, 'images', entry.path + '.png'));
  assert.equal(createHash('sha256').update(png).digest('hex'), entry.sha256, 'Attachment hash mismatch: ' + entry.path);
  assert.equal(png.subarray(1, 4).toString(), 'PNG', entry.path);
  assert.equal(png.readUInt32BE(16), entry.width, entry.path);
  assert.equal(png.readUInt32BE(20), entry.height, entry.path);
  assert.equal(png[25], 6, 'Source layers must preserve RGBA: ' + entry.path);
  const page = new core.TextureAtlasPage(entry.path);
  page.width = entry.width; page.height = entry.height;
  const region = new core.TextureAtlasRegion(page, entry.path);
  Object.assign(region, { width: entry.width, height: entry.height, originalWidth: entry.width, originalHeight: entry.height, offsetX: 0, offsetY: 0, u: 0, v: 0, u2: 1, v2: 1 });
  regions.set(entry.path, region);
}
const atlas = { findRegion: name => regions.get(name) ?? null };
const data = new core.SkeletonJson(new core.AtlasAttachmentLoader(atlas)).readSkeletonData(json);
const skeleton = new core.Skeleton(data);
skeleton.updateWorldTransform(core.Physics.none);
for (const [name, point] of Object.entries(expected.bones)) {
  const bone = skeleton.findBone(name);
  assert(bone, 'Missing bone: ' + name);
  assert(Math.hypot(bone.appliedPose.worldX - point[0], bone.appliedPose.worldY - point[1]) < 0.05, 'Coordinate conversion detached bone: ' + name);
}
const decoded = [];
for (const slotData of data.slots) {
  const entries = json.skins[0].attachments[slotData.name];
  for (const [name, attachment] of Object.entries(entries)) {
    assert.equal(attachment.type, 'region', 'Only basic region attachments are supported');
    assert(regions.has(attachment.path), 'Unresolved attachment path: ' + attachment.path);
    skeleton.setAttachment(slotData.name, name);
    skeleton.updateWorldTransform(core.Physics.none);
    const slot = skeleton.findSlot(slotData.name);
    const region = slot.appliedPose.attachment;
    const vertices = new Array(8).fill(0);
    region.computeWorldVertices(slot, region.getOffsets(slot.appliedPose), vertices, 0, 2);
    const points = Array.from({length: 4}, (_, i) => vertices.slice(i*2, i*2+2));
    const wanted = expected.attachments[slotData.name + '/' + name];
    assert(wanted, 'Missing native geometry for ' + name);
    for (let i = 0; i < 4; i++) {
      const point = wanted[[3, 0, 1, 2][i]]; // BL, TL, TR, BR: also proves UV orientation.
      assert(Math.hypot(points[i][0]-point[0], points[i][1]-point[1]) < 0.05, 'Image corner/orientation mismatch: ' + name);
    }
    if (slotData.attachmentName === name) decoded.push({slot: slotData.name, path: attachment.path, vertices, width: attachment.width, height: attachment.height});
  }
}
const wardrobe = JSON.parse(fs.readFileSync(path.join(directory, 'equipment.json')));
for (const choices of Object.values(wardrobe.slots)) {
  for (const changes of Object.values(choices)) {
    for (const [slot, name] of Object.entries(changes)) {
      assert(data.findSlot(slot), 'Invalid equipment slot: ' + slot);
      assert(name === null || data.defaultSkin.getAttachment(data.findSlot(slot).index, name), 'Missing equipment attachment: ' + name);
    }
  }
}
const state = new core.AnimationState(new core.AnimationStateData(data));
const setupTorsoY = expected.bones.torso[1];
state.setAnimation(0, 'idle_blockout', true);
state.update(1.2); state.apply(skeleton); skeleton.updateWorldTransform(core.Physics.none);
assert(Math.abs(skeleton.findBone('torso').appliedPose.worldY - setupTorsoY - 0.8) < 0.05, 'Idle breathing timeline did not apply');
for (const bone of skeleton.bones) assert(Number.isFinite(bone.appliedPose.worldX) && Number.isFinite(bone.appliedPose.worldY), 'Invalid idle pose');
state.update(1.2); state.apply(skeleton); skeleton.updateWorldTransform(core.Physics.none);
assert(Math.abs(skeleton.findBone('torso').appliedPose.worldY - setupTorsoY) < 0.05, 'Idle loop did not return to setup');
fs.writeFileSync(path.join(directory, 'decoded-setup.json'), JSON.stringify(decoded, null, 2) + '\n');
console.log(`SPINE_HANDOFF_OK: ${data.bones.length} bones, ${data.slots.length} slots, ${regions.size} RGBA layers, all equipment and world geometry verified`);
