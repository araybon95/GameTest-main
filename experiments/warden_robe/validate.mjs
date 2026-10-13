import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import {createHash} from 'node:crypto';
import {pathToFileURL} from 'node:url';
const directory=path.resolve(process.argv[2]);
const core=await import(pathToFileURL(path.join(path.resolve(process.argv[3]),'dist/index.js')));
const manifest=JSON.parse(fs.readFileSync(path.join(directory,'parts.json')));
const json=JSON.parse(fs.readFileSync(path.join(directory,'warden-import.json')));
const hash=b=>createHash('sha256').update(b).digest('hex');
assert.equal(manifest.parts.length,22);assert.equal(json.bones.length,23);
assert(!json.ik?.length&&!json.physics?.length&&!json.transform?.length);
assert.equal(hash(fs.readFileSync(path.join(directory,'source/robe_panels.png'))),manifest.robe_source_sha256);
const regions=new Map();
for(const p of manifest.parts){
 const png=fs.readFileSync(path.join(directory,'images',p.name+'.png'));
 assert.equal(hash(png),p.sha256,p.name+' changed pixels');assert.equal(png[25],6);
 const page=new core.TextureAtlasPage(p.name);page.width=p.width;page.height=p.height;
 const region=new core.TextureAtlasRegion(page,p.name);
 Object.assign(region,{width:p.width,height:p.height,originalWidth:p.width,originalHeight:p.height,offsetX:0,offsetY:0,u:0,v:0,u2:1,v2:1});regions.set(p.name,region);
}
const data=new core.SkeletonJson(new core.AtlasAttachmentLoader({findRegion:name=>regions.get(name)})).readSkeletonData(json);
const skeleton=new core.Skeleton(data);skeleton.updateWorldTransform(core.Physics.none);
function decoded(sk){
 return sk.slots.flatMap(slot=>{
  const attachment=slot.appliedPose.attachment;if(!attachment)return [];
  const vertices=new Array(8).fill(0);attachment.computeWorldVertices(slot,attachment.getOffsets(slot.appliedPose),vertices,0,2);
  assert(vertices.every(Number.isFinite));return [{name:slot.data.name,vertices}];
 });
}
for(const p of manifest.parts){
 const bone=skeleton.findBone(p.name);assert(Math.hypot(bone.appliedPose.worldX-p.joint_world[0],bone.appliedPose.worldY-p.joint_world[1])<.05,p.name+' joint mismatch');
 const slot=skeleton.findSlot(p.name),previous=slot.appliedPose.attachment;
 skeleton.setAttachment(p.name,p.name);const vertices=decoded(skeleton).find(x=>x.name===p.name).vertices;
 const center=[(vertices[0]+vertices[2]+vertices[4]+vertices[6])/4,(vertices[1]+vertices[3]+vertices[5]+vertices[7])/4];
 assert(Math.hypot(center[0]-p.center_world[0],center[1]-p.center_world[1])<.05,p.name+' detached panel');
 skeleton.setAttachment(p.name,previous?previous.name:null);
}
for(const name of manifest.hidden_leg_slots)assert.equal(skeleton.findSlot(name).appliedPose.attachment,null,name+' leg must remain hidden');
const setup=decoded(skeleton);
const duration=data.findAnimation('breathing_walk').duration;assert(Math.abs(duration-2.4)<.001);
const frames=[],joints=[];
for(let i=0;i<=72;i++){
 const sk=new core.Skeleton(data),state=new core.AnimationState(new core.AnimationStateData(data));
 state.setAnimation(0,'breathing_walk',true);state.update(i/30);state.apply(sk);sk.updateWorldTransform(core.Physics.none);
 frames.push(decoded(sk));
 joints.push(Object.fromEntries(['torso','near_foot','far_foot'].map(name=>{const b=sk.findBone(name);return [name,[b.appliedPose.worldX,b.appliedPose.worldY]];})));
 for(const name of manifest.hidden_leg_slots)assert.equal(sk.findSlot(name).appliedPose.attachment,null);
}
assert(joints[36].torso[1]-joints[0].torso[1]>5.9,'Breathing does not move the torso');
assert(Math.abs(joints[18].near_foot[0]-joints[0].near_foot[0])>35.9,'Boot stride missing');
for(const name of ['torso','near_foot','far_foot'])assert(Math.hypot(joints[72][name][0]-joints[0][name][0],joints[72][name][1]-joints[0][name][1])<.05,'Loop does not close: '+name);
for(let i=0;i<72;i++)for(const [name,phase] of [['near_foot',0],['far_foot',.5]]){
 const u=(i/30/1.2+phase)%1;if(u<=.5){const baseline=manifest.parts.find(p=>p.name===name).joint_world[1];assert(Math.abs(joints[i][name][1]-baseline)<.05,name+' contact floats');}
}
fs.writeFileSync(path.join(directory,'motion-frames.json'),JSON.stringify({fps:30,duration,setup,frames:frames.slice(0,72)},null,2)+'\n');
console.log('WARDEN_ROBE_RUNTIME_OK: 22 RGBA layers, 23 basic bones, breathing, boot stride, grounded contacts, hidden legs and closed loop');
