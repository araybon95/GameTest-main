import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { createHash } from 'node:crypto';
import { pathToFileURL } from 'node:url';
const directory=path.resolve(process.argv[2]);
const core=await import(pathToFileURL(path.join(path.resolve(process.argv[3]),'dist/index.js')));
const manifest=JSON.parse(fs.readFileSync(path.join(directory,'parts.json')));
const json=JSON.parse(fs.readFileSync(path.join(directory,'warden-import.json')));
const hash=b=>createHash('sha256').update(b).digest('hex');
assert.equal(manifest.parts.length,20);
assert.equal(json.bones.length,21);
assert(!json.ik?.length && !json.transform?.length && !json.physics?.length);
assert.equal(json.skins.length,1);
assert.equal(hash(fs.readFileSync(path.join(directory,'source/warden_parts.png'))),manifest.source_sha256);
const regions=new Map();
for(const part of manifest.parts){
 const data=fs.readFileSync(path.join(directory,'images',part.name+'.png'));
 assert.equal(hash(data),part.sha256,part.name+' image hash');
 assert.equal(data.readUInt32BE(16),part.width);
 assert.equal(data.readUInt32BE(20),part.height);
 assert.equal(data[25],6,'PNG must remain RGBA');
 const page=new core.TextureAtlasPage(part.name);page.width=part.width;page.height=part.height;
 const region=new core.TextureAtlasRegion(page,part.name);
 Object.assign(region,{width:part.width,height:part.height,originalWidth:part.width,originalHeight:part.height,offsetX:0,offsetY:0,u:0,v:0,u2:1,v2:1});
 regions.set(part.name,region);
}
const data=new core.SkeletonJson(new core.AtlasAttachmentLoader({findRegion:name=>regions.get(name)})).readSkeletonData(json);
const skeleton=new core.Skeleton(data);
skeleton.updateWorldTransform(core.Physics.none);
const decoded=[];
for(const part of manifest.parts){
 const bone=skeleton.findBone(part.name);
 assert(Math.hypot(bone.appliedPose.worldX-part.joint_world[0],bone.appliedPose.worldY-part.joint_world[1])<.05,part.name+' joint mismatch');
 const slot=skeleton.findSlot(part.name),attachment=slot.appliedPose.attachment;
 assert(attachment instanceof core.RegionAttachment,part.name+' requires basic region');
 const vertices=new Array(8).fill(0);
 attachment.computeWorldVertices(slot,attachment.getOffsets(slot.appliedPose),vertices,0,2);
 assert(vertices.every(Number.isFinite));
 const center=[(vertices[0]+vertices[2]+vertices[4]+vertices[6])/4,(vertices[1]+vertices[3]+vertices[5]+vertices[7])/4];
 assert(Math.hypot(center[0]-part.center_world[0],center[1]-part.center_world[1])<.05,part.name+' attachment detached');
 decoded.push({name:part.name,center,vertices});
}
fs.writeFileSync(path.join(directory,'runtime-setup.json'),JSON.stringify(decoded,null,2)+'\n');
console.log('WARDEN_SPINE_PARTS_OK: official 4.3 runtime, 21 joints, 20 RGBA regions, source/image hashes and attachment centers');
