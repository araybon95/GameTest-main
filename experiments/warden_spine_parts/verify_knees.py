"""Check the forward-facing knee geometry of this right-facing setup pose."""
from pathlib import Path
import json, math

root = Path(__file__).resolve().parent
parts = {p['name']:p for p in json.loads((root/'parts.json').read_text())['parts']}
# Measured outer/front points on the two source knee plates, before mirroring.
front_points = {'near':(580,755), 'far':(440,1000)}
for side, landmark in front_points.items():
    shin = parts[side+'_lower_leg']
    thigh = parts[side+'_thigh']
    foot = parts[side+'_foot']
    knee = shin['joint_world']
    ankle = foot['joint_world']
    assert knee[0] > ankle[0], side+' knee bends behind the ankle in the setup pose'
    # A correctly oriented knee plate projects toward +X (the hero's forward).
    x,y,_,_ = shin['source_region']
    px,py = shin['source_pivot_pixels']
    dx,dy = landmark[0]-x-px, py-(landmark[1]-y)
    if shin['flip_x']: dx = -dx
    angle = math.radians(shin['rotation_world'])
    front_x = (dx*math.cos(angle)-dy*math.sin(angle))*shin['scale']
    assert front_x > 15, side+' knee plate faces away from the forward direction'
    # Thigh and shin describe the same knee, rather than leaving a detached leg.
    tx,ty = thigh['joint_world']
    axis = math.radians(thigh['bone_rotation_world'])
    endpoint = (tx+math.cos(axis)*thigh['bone_length'],ty+math.sin(axis)*thigh['bone_length'])
    assert math.hypot(endpoint[0]-knee[0],endpoint[1]-knee[1]) < .05, side+' knee detached from thigh'
print('WARDEN_KNEES_OK: forward knee plates, forward knee bends, connected thigh/shin pivots')
