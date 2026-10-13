"""Read-only silhouette checks on official-runtime-decoded animation geometry."""
from pathlib import Path
import json
import numpy as np
from PIL import Image
root=Path(__file__).resolve().parent
manifest=json.loads((root/'parts.json').read_text())
parts={p['name']:p for p in manifest['parts']}
motion=json.loads((root/'motion-frames.json').read_text())
alpha={name:np.asarray(Image.open(root/'images'/(name+'.png')).convert('RGBA'))[:,:,3]/255. for name in ['near_foot','far_foot','robe_front','robe_rear']}

def transform(layer,width,height):
    vertices=np.array(layer['vertices']).reshape(4,2)
    return vertices[1],np.column_stack(((vertices[2]-vertices[1])/width,(vertices[0]-vertices[1])/height))

for index,frame in enumerate(motion['frames']):
    layers={p['name']:p for p in frame}
    for name in ['near_foot','far_foot']:
        part=parts[name];a=alpha[name];h,w=a.shape
        yy,xx=np.mgrid[:h,:w]
        px,py=part['source_pivot_pixels']
        cap=((xx-px)**2+(yy-py)**2<14**2)&(a>.4)
        sole=(yy>h*.86)&(a>.7)
        assert cap.sum()>20 and sole.sum()>20
        origin,matrix=transform(layers[name],w,h)
        for mask,role in [(cap,'cap'),(sole,'sole')]:
            ys,xs=np.where(mask)
            world=origin[:,None]+matrix@np.stack((xs+.5,ys+.5))
            transmission=np.ones(len(xs))
            for cloth in ['robe_rear','robe_front']:
                if parts[cloth]['draw_order']<part['draw_order']: continue
                image=alpha[cloth];ch,cw=image.shape
                co,cm=transform(layers[cloth],cw,ch)
                uv=np.linalg.solve(cm,world-co[:,None])
                cx=np.floor(uv[0]).astype(int);cy=np.floor(uv[1]).astype(int)
                valid=(cx>=0)&(cx<cw)&(cy>=0)&(cy<ch)
                opacity=np.zeros(len(xs));opacity[valid]=image[cy[valid],cx[valid]]
                transmission*=1-opacity
            if role=='cap': assert transmission.max()<.1,f'{name} ankle cap exposed in frame {index}'
            else: assert transmission.mean()>.5,f'{name} sole hidden in frame {index}'
print('WARDEN_ROBE_COVERAGE_OK: both ankle caps covered and boot soles visible across all 72 decoded poses')
