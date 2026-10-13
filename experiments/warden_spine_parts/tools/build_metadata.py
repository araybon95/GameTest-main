"""Read source pixels to identify parts; write geometry/ownership JSON, never raster art."""
from pathlib import Path
import hashlib, json, math
import numpy as np
from PIL import Image
from scipy.ndimage import label, binary_dilation

ROOT = Path(__file__).resolve().parents[1]
sheet = np.asarray(Image.open(ROOT/'source/warden_parts.png').convert('RGBA'))
labels, _ = label(sheet[:,:,3] > 40)
yy, xx = np.mgrid[:sheet.shape[0], :sheet.shape[1]]

def polygon_mask(points):
    hit = np.zeros(xx.shape, dtype=bool)
    for a,b in zip(points,points[1:]+points[:1]):
        if a[1] != b[1]:
            hit ^= ((a[1]>yy)!=(b[1]>yy)) & (xx < (b[0]-a[0])*(yy-a[1])/(b[1]-a[1])+a[0])
    return hit

shield = polygon_mask([[1189,925],[1220,996],[1230,1199],[1065,1199],[1060,950]])
# The mace's last tip ends at row 937. The shield's sloped top edge below
# that row belongs entirely to the shield, including the thin left extension.
shield |= yy >= 938
# Source joint positions are measured on the generated sheet. Target joints
# follow the current game's reference stance, with concealed far limbs inferred.
# name, component, source pivot, target joint, parent, order, scale, optional end
specs = [
 ('head',3,(154,236),(770,225),'torso',17,.85,None),
 ('torso',2,(505,245),(770,535),'waist',11,1.35,None),
 ('waist',4,(800,72),(770,535),'root',12,1.15,None),
 ('cape',1,(1210,44),(770,245),'torso',0,2.65,None),
 ('near_shoulder',7,(258,325),(690,245),'torso',16,1.0,None),
 ('near_upper_arm',5,(511,290),(620,320),'near_shoulder',13,None,((465,466),(550,450))),
 ('near_lower_arm',6,(785,297),(550,450),'near_upper_arm',14,None,((875,463),(530,615))),
 ('near_hand',8,(1108,330),(530,615),'near_lower_arm',15,None,((1181,438),(560,680))),
 ('far_shoulder',11,(107,548),(865,270),'torso',1,.8,None),
 ('far_upper_arm',9,(478,507),(880,325),'far_shoulder',2,None,((551,671),(925,470))),
 ('far_lower_arm',10,(866,506),(925,470),'far_upper_arm',3,None,((779,679),(930,615))),
 ('far_hand',12,(1196,546),(930,615),'far_lower_arm',4,None,((1098,645),(935,680))),
 ('near_thigh',13,(165,711),(640,730),'waist',8,None,((222,898),(560,900))),
 ('near_lower_leg',14,(501,714),(560,900),'near_thigh',9,None,((480,908),(500,1120))),
 ('near_foot',16,(782,741),(500,1120),'near_lower_leg',10,1.0,None),
 ('mace',15,(1018,728),(560,680),'near_hand',18,None,((1204,860),(700,835))),
 ('far_thigh',17,(185,947),(870,730),'waist',5,None,((121,1128),(930,900))),
 ('far_lower_leg',18,(505,950),(930,900),'far_thigh',6,None,((550,1150),(950,1125))),
 ('far_foot',19,(848,991),(950,1125),'far_lower_leg',7,1.0,None),
 ('shield',15,(1140,1030),(955,600),'far_hand',19,2.1,None),
]

def point(p): return np.array([p[0]-700.,1220.-p[1]])
def rotation(degrees):
    a=math.radians(degrees)
    return np.array([[math.cos(a),-math.sin(a)],[math.sin(a),math.cos(a)]])
def angle(v): return math.degrees(math.atan2(v[1],v[0]))
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()

parts=[]
for name,component,pivot,target,parent,order,scale,end in specs:
    selected=labels==component
    if name=='mace': selected &= ~shield
    if name=='shield': selected &= shield
    # Ownership clips neighboring pieces from the same rectangle. Color values
    # remain untouched; native export copies selected source pixels verbatim.
    selected=binary_dilation(selected,iterations=2)&(sheet[:,:,3]>0)
    selected &= (labels==component)|(labels==0)
    if name=='mace': selected &= (yy < 938)&~shield
    if name=='shield': selected &= shield
    y,x=np.where(selected); x0=max(0,int(x.min())-2);y0=max(0,int(y.min())-2)
    x1=min(sheet.shape[1],int(x.max())+3);y1=min(sheet.shape[0],int(y.max())+3)
    w,h=x1-x0,y1-y0
    spans=[]
    for row in range(y0,y1):
        positions=np.where(selected[row,x0:x1])[0]
        if not len(positions): continue
        for segment in np.split(positions,np.where(np.diff(positions)>1)[0]+1):
            spans.append([row-y0,int(segment[0]),int(segment[-1]+1)])
    pivot_local=np.array([pivot[0]-x0,pivot[1]-y0],dtype=float)
    flip=name=='far_foot'
    if flip: pivot_local[0]=w-pivot_local[0]
    world=point(target)
    image_rotation=0.
    bone_rotation=0.
    length=0.
    if end:
        source_end,target_end=end
        source_delta=np.array([source_end[0]-pivot[0],pivot[1]-source_end[1]],dtype=float)
        target_delta=point(target_end)-world
        scale=float(np.linalg.norm(target_delta)/np.linalg.norm(source_delta))
        bone_rotation=angle(target_delta)
        image_rotation=bone_rotation-angle(source_delta)
        length=float(np.linalg.norm(target_delta))
    if name=='torso': bone_rotation=90.;length=310.
    if name=='head': bone_rotation=90.;length=120.
    offset=np.array([(w*.5-pivot_local[0])*scale,(pivot_local[1]-h*.5)*scale])
    center=world+rotation(image_rotation)@offset
    parts.append(dict(name=name,source_region=[x0,y0,w,h],source_spans=spans,pivot_pixels=pivot_local.tolist(),source_pivot_pixels=[pivot[0]-x0,pivot[1]-y0],flip_x=flip,scale=scale,rotation_world=image_rotation,center_world=center.tolist(),joint_world=world.tolist(),bone_rotation_world=bone_rotation,bone_length=length,parent=parent,draw_order=order,width=w,height=h))

by_name={p['name']:p for p in parts}
bones=[dict(name='root')]; ordered=[]
pending=parts.copy();available={'root'}
while pending:
    ready=[p for p in pending if p['parent'] in available]
    assert ready,'Bone parent cycle'
    for p in ready:
        parent=by_name.get(p['parent']); parent_pos=np.array(parent['joint_world']) if parent else np.zeros(2)
        parent_rotation=parent['bone_rotation_world'] if parent else 0.
        local=rotation(-parent_rotation)@(np.array(p['joint_world'])-parent_pos)
        bone=dict(name=p['name'],parent=p['parent'],x=float(local[0]),y=float(local[1]),rotation=p['bone_rotation_world']-parent_rotation,length=p['bone_length'])
        bones.append(bone);ordered.append(p);available.add(p['name']);pending.remove(p)

slots=[];attachments={}
for p in sorted(parts,key=lambda p:p['draw_order']):
    name=p['name'];slots.append(dict(name=name,bone=name,attachment=name))
    local=rotation(-p['bone_rotation_world'])@(np.array(p['center_world'])-np.array(p['joint_world']))
    attachments[name]={name:dict(type='region',path=name,x=float(local[0]),y=float(local[1]),rotation=p['rotation_world']-p['bone_rotation_world'],width=p['width']*p['scale'],height=p['height']*p['scale'],scaleX=-1 if p['flip_x'] else 1,scaleY=1)}

manifest=dict(schema=1,prototype_only=True,art_status='AI-reconstructed cutouts from current in-game Warden; hidden far limbs inferred; setup alignment draft',source_sha256=sha(ROOT/'source/warden_parts.png'),reference_sha256=sha(ROOT/'source/hero_warden_reference.png'),parts=parts)
(ROOT/'parts.json').write_text(json.dumps(manifest,indent=2)+'\n')
skeleton=dict(skeleton=dict(spine='4.3.00',images='./images/',fps=30),bones=bones,slots=slots,skins=[dict(name='default',attachments=attachments)],animations={})
(ROOT/'warden-import.json').write_text(json.dumps(skeleton,indent=2)+'\n')
print('WARDEN_PARTS_METADATA_OK: 20 parts, 21 parent-first bones, measured source ownership')
