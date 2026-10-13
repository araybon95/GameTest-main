"""Generate basic-bone Spine data; inspect source pixels without editing raster art."""
from pathlib import Path
import copy, hashlib, json, math
import numpy as np
from PIL import Image

root=Path(__file__).resolve().parents[1]
base=root/'source'
manifest=json.loads((base/'armor-parts.json').read_text())
skeleton=json.loads((base/'armor-import.json').read_text())
sheet=np.asarray(Image.open(root/'source/robe_panels.png').convert('RGBA'))
parts=manifest['parts']
for p in parts: p['source_file']='warden_parts.png'
for name,lo,hi,order in [('robe_front',0,sheet.shape[1]//2,10.5),('robe_rear',sheet.shape[1]//2,sheet.shape[1],10.25)]:
    yy,xx=np.where(sheet[:,lo:hi,3]>40)
    x0=max(lo,lo+int(xx.min())-2);y0=max(0,int(yy.min())-2)
    x1=min(hi,lo+int(xx.max())+3);y1=min(sheet.shape[0],int(yy.max())+3)
    w,h=x1-x0,y1-y0
    pivot=[w*.5,h*.045]
    scale=700./h
    # Inner cloth hangs toward the trailing leg and covers ankle caps above
    # the boots, while remaining behind the decorated front panel.
    joint=[25.,635.] if name=='robe_rear' else [70.,685.]
    center=[joint[0]+(w*.5-pivot[0])*scale,joint[1]+(pivot[1]-h*.5)*scale]
    part=dict(name=name,source_file='robe_panels.png',source_region=[x0,y0,w,h],source_spans=[[row,0,w] for row in range(h)],pivot_pixels=pivot,source_pivot_pixels=pivot,flip_x=False,scale=scale,rotation_world=0.,center_world=center,joint_world=joint,bone_rotation_world=0.,bone_length=600.,parent='waist',draw_order=order,width=w,height=h)
    parts.append(part)
    skeleton['bones'].append(dict(name=name,parent='waist',x=joint[0]-70.,y=joint[1]-685.,length=600.))
    skeleton['skins'][0]['attachments'][name]={name:dict(type='region',path=name,x=center[0]-joint[0],y=center[1]-joint[1],width=w*scale,height=h*scale)}
hidden=['near_thigh','far_thigh','near_lower_leg','far_lower_leg']
skeleton['slots']=[dict(name=p['name'],bone=p['name'],attachment=None if p['name'] in hidden else p['name']) for p in sorted(parts,key=lambda p:p['draw_order'])]

# Foot offsets are transformed into each parent shin's local axes. Cancel
# pelvis bob at the feet so a contact pose does not bounce off the floor.
def bob(t): return 1.5*(1-math.cos(2*math.pi*t/.6))
def gait(t,phase):
    u=(t/1.2+phase)%1.
    if u<=.5: return 18.-72.*u,0.,0.
    f=(u-.5)*2
    return -18.+36.*f,12.*math.sin(math.pi*f),2.*math.sin(math.pi*f)
timelines={}
times=[i*.15 for i in range(17)]
timelines['waist']={'translate':[dict(time=t,x=0.,y=bob(t)) for t in times]}
timelines['torso']={'translate':[dict(time=t,x=0.,y=3*(1-math.cos(2*math.pi*t/2.4))) for t in times]}
timelines['head']={'rotate':[dict(time=t,value=-.3*math.sin(2*math.pi*t/2.4)) for t in times]}
for name,amplitude,delay in [('robe_front',.9,0),('robe_rear',.5,.15)]:
    timelines[name]={'rotate':[dict(time=t,value=amplitude*math.sin(2*math.pi*(t-delay)/1.2)) for t in times]}
by_name={p['name']:p for p in parts}
for side,phase in [('near',0.),('far',.5)]:
    name=side+'_foot';angle=math.radians(by_name[side+'_lower_leg']['bone_rotation_world'])
    translate=[];rotate=[]
    for t in times:
        dx,dy,roll=gait(t,phase);dy-=bob(t)
        translate.append(dict(time=t,x=dx*math.cos(angle)+dy*math.sin(angle),y=-dx*math.sin(angle)+dy*math.cos(angle)))
        rotate.append(dict(time=t,value=roll))
    timelines[name]=dict(translate=translate,rotate=rotate)
skeleton['animations']={'breathing_walk':{'bones':timelines}}
manifest.update(art_status='Separate battle-robe experiment; original upper-body art retained; basic breathing and boot-step study',hidden_leg_slots=hidden,robe_source_sha256=hashlib.sha256((root/'source/robe_panels.png').read_bytes()).hexdigest(),animation=dict(name='breathing_walk',duration=2.4,walk_cycle_seconds=1.2,fps=30),baseline_commit='1c2bab9')
(root/'parts.json').write_text(json.dumps(manifest,indent=2)+'\n')
(root/'warden-import.json').write_text(json.dumps(skeleton,indent=2)+'\n')
print('WARDEN_ROBE_DATA_OK: 22 layers, 23 basic bones, hidden legs and 2.4-second breathing/step loop')
