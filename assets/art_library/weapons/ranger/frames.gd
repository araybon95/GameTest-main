extends RefCounted
## Generated registered weapon records.
static var RECORDS: Dictionary = str_to_var("""{
"ranger|alternate|ranger_bow|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 467)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-attack-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 467),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "attack",
"style": "alternate",
"weapon_axis": PackedVector2Array(450, 547, 449.99997, 117),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_bow|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(348, 602)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-camp-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(373, 602),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "camp",
"style": "alternate",
"weapon_axis": PackedVector2Array(428, 602, -2, 601.99994),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_bow|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(451, 467)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-cast-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(476, 467),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "cast",
"style": "alternate",
"weapon_axis": PackedVector2Array(451, 547, 450.99997, 117),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_bow|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(458, 515)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-death-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(483, 515),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "death",
"style": "alternate",
"weapon_axis": PackedVector2Array(444.10815, 593.7846, 518.77686, 170.31729),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_bow|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(440, 510)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-guard-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(465, 510),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "guard",
"style": "alternate",
"weapon_axis": PackedVector2Array(426.10815, 588.7846, 500.7769, 165.31729),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_bow|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(459, 514)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-hurt-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(484, 514),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "hurt",
"style": "alternate",
"weapon_axis": PackedVector2Array(445.10815, 592.7846, 519.77686, 169.31729),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_bow|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(448, 524)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(473, 524),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "idle",
"style": "alternate",
"weapon_axis": PackedVector2Array(434.10815, 602.7846, 508.7769, 179.31729),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_bow|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(448, 524)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(473, 524),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "portrait",
"style": "alternate",
"weapon_axis": PackedVector2Array(434.10815, 602.7846, 508.7769, 179.31729),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_bow|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(422, 524)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_0-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(447, 524),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_0",
"style": "alternate",
"weapon_axis": PackedVector2Array(365.43146, 580.56854, 669.48737, 276.51263),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_bow|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(432, 529)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_1-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 266.0,
"emitter_point": Vector2(457, 529),
"hit_point": Vector2(350, 485.08002),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_1",
"style": "alternate",
"weapon_axis": PackedVector2Array(375.43146, 585.56854, 679.48737, 281.51263),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_bow|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(415, 530)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_2-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 268.0,
"emitter_point": Vector2(440, 530),
"hit_point": Vector2(350, 483.84),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_2",
"style": "alternate",
"weapon_axis": PackedVector2Array(358.43146, 586.56854, 662.48737, 282.51263),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_bow|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(422, 508)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_3-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 265.0,
"emitter_point": Vector2(447, 508),
"hit_point": Vector2(350, 485.7),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_3",
"style": "alternate",
"weapon_axis": PackedVector2Array(365.43146, 564.56854, 669.48737, 260.51263),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_bow|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(451, 467)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-windup-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(476, 467),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "windup",
"style": "alternate",
"weapon_axis": PackedVector2Array(451, 547, 450.99997, 117),
"weapon_profile": "ranger_bow"
},
"ranger|alternate|ranger_epic|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 467)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-attack-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 467),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "attack",
"style": "alternate",
"weapon_axis": PackedVector2Array(450, 547, 449.99997, 117),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_epic|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(348, 602)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-camp-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(373, 602),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "camp",
"style": "alternate",
"weapon_axis": PackedVector2Array(428, 602, -2, 601.99994),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_epic|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(451, 467)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-cast-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(476, 467),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "cast",
"style": "alternate",
"weapon_axis": PackedVector2Array(451, 547, 450.99997, 117),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_epic|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(458, 515)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-death-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(483, 515),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "death",
"style": "alternate",
"weapon_axis": PackedVector2Array(444.10815, 593.7846, 518.77686, 170.31729),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_epic|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(440, 510)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-guard-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(465, 510),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "guard",
"style": "alternate",
"weapon_axis": PackedVector2Array(426.10815, 588.7846, 500.7769, 165.31729),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_epic|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(459, 514)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-hurt-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(484, 514),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "hurt",
"style": "alternate",
"weapon_axis": PackedVector2Array(445.10815, 592.7846, 519.77686, 169.31729),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_epic|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(448, 524)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(473, 524),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "idle",
"style": "alternate",
"weapon_axis": PackedVector2Array(434.10815, 602.7846, 508.7769, 179.31729),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_epic|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(448, 524)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(473, 524),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "portrait",
"style": "alternate",
"weapon_axis": PackedVector2Array(434.10815, 602.7846, 508.7769, 179.31729),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_epic|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(422, 524)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_0-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(447, 524),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_0",
"style": "alternate",
"weapon_axis": PackedVector2Array(365.43146, 580.56854, 669.48737, 276.51263),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_epic|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(432, 529)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_1-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 266.0,
"emitter_point": Vector2(457, 529),
"hit_point": Vector2(350, 485.08002),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_1",
"style": "alternate",
"weapon_axis": PackedVector2Array(375.43146, 585.56854, 679.48737, 281.51263),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_epic|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(415, 530)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_2-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 268.0,
"emitter_point": Vector2(440, 530),
"hit_point": Vector2(350, 483.84),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_2",
"style": "alternate",
"weapon_axis": PackedVector2Array(358.43146, 586.56854, 662.48737, 282.51263),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_epic|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(422, 508)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_3-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 265.0,
"emitter_point": Vector2(447, 508),
"hit_point": Vector2(350, 485.7),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_3",
"style": "alternate",
"weapon_axis": PackedVector2Array(365.43146, 564.56854, 669.48737, 260.51263),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_epic|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(451, 467)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-windup-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(476, 467),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "windup",
"style": "alternate",
"weapon_axis": PackedVector2Array(451, 547, 450.99997, 117),
"weapon_profile": "ranger_epic"
},
"ranger|alternate|ranger_legend|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 467)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-attack-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 467),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "attack",
"style": "alternate",
"weapon_axis": PackedVector2Array(450, 547, 449.99997, 117),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_legend|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(348, 602)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-camp-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(373, 602),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "camp",
"style": "alternate",
"weapon_axis": PackedVector2Array(428, 602, -2, 601.99994),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_legend|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(451, 467)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-cast-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(476, 467),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "cast",
"style": "alternate",
"weapon_axis": PackedVector2Array(451, 547, 450.99997, 117),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_legend|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(458, 515)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-death-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(483, 515),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "death",
"style": "alternate",
"weapon_axis": PackedVector2Array(444.10815, 593.7846, 518.77686, 170.31729),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_legend|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(440, 510)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-guard-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(465, 510),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "guard",
"style": "alternate",
"weapon_axis": PackedVector2Array(426.10815, 588.7846, 500.7769, 165.31729),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_legend|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(459, 514)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-hurt-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(484, 514),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "hurt",
"style": "alternate",
"weapon_axis": PackedVector2Array(445.10815, 592.7846, 519.77686, 169.31729),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_legend|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(448, 524)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(473, 524),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "idle",
"style": "alternate",
"weapon_axis": PackedVector2Array(434.10815, 602.7846, 508.7769, 179.31729),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_legend|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(448, 524)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(473, 524),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "portrait",
"style": "alternate",
"weapon_axis": PackedVector2Array(434.10815, 602.7846, 508.7769, 179.31729),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_legend|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(422, 524)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_0-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(447, 524),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_0",
"style": "alternate",
"weapon_axis": PackedVector2Array(365.43146, 580.56854, 669.48737, 276.51263),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_legend|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(432, 529)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_1-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 266.0,
"emitter_point": Vector2(457, 529),
"hit_point": Vector2(350, 485.08002),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_1",
"style": "alternate",
"weapon_axis": PackedVector2Array(375.43146, 585.56854, 679.48737, 281.51263),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_legend|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(415, 530)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_2-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 268.0,
"emitter_point": Vector2(440, 530),
"hit_point": Vector2(350, 483.84),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_2",
"style": "alternate",
"weapon_axis": PackedVector2Array(358.43146, 586.56854, 662.48737, 282.51263),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_legend|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(422, 508)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_3-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 265.0,
"emitter_point": Vector2(447, 508),
"hit_point": Vector2(350, 485.7),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_3",
"style": "alternate",
"weapon_axis": PackedVector2Array(365.43146, 564.56854, 669.48737, 260.51263),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_legend|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(451, 467)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-windup-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(476, 467),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "windup",
"style": "alternate",
"weapon_axis": PackedVector2Array(451, 547, 450.99997, 117),
"weapon_profile": "ranger_legend"
},
"ranger|alternate|ranger_venombow|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 467)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-attack-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 467),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "attack",
"style": "alternate",
"weapon_axis": PackedVector2Array(450, 547, 449.99997, 117),
"weapon_profile": "ranger_venombow"
},
"ranger|alternate|ranger_venombow|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(348, 602)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-camp-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(373, 602),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "camp",
"style": "alternate",
"weapon_axis": PackedVector2Array(428, 602, -2, 601.99994),
"weapon_profile": "ranger_venombow"
},
"ranger|alternate|ranger_venombow|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(451, 467)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-cast-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(476, 467),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "cast",
"style": "alternate",
"weapon_axis": PackedVector2Array(451, 547, 450.99997, 117),
"weapon_profile": "ranger_venombow"
},
"ranger|alternate|ranger_venombow|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(458, 515)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-death-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(483, 515),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "death",
"style": "alternate",
"weapon_axis": PackedVector2Array(444.10815, 593.7846, 518.77686, 170.31729),
"weapon_profile": "ranger_venombow"
},
"ranger|alternate|ranger_venombow|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(440, 510)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-guard-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(465, 510),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "guard",
"style": "alternate",
"weapon_axis": PackedVector2Array(426.10815, 588.7846, 500.7769, 165.31729),
"weapon_profile": "ranger_venombow"
},
"ranger|alternate|ranger_venombow|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(459, 514)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-hurt-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(484, 514),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "hurt",
"style": "alternate",
"weapon_axis": PackedVector2Array(445.10815, 592.7846, 519.77686, 169.31729),
"weapon_profile": "ranger_venombow"
},
"ranger|alternate|ranger_venombow|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(448, 524)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(473, 524),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "idle",
"style": "alternate",
"weapon_axis": PackedVector2Array(434.10815, 602.7846, 508.7769, 179.31729),
"weapon_profile": "ranger_venombow"
},
"ranger|alternate|ranger_venombow|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(448, 524)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(473, 524),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "portrait",
"style": "alternate",
"weapon_axis": PackedVector2Array(434.10815, 602.7846, 508.7769, 179.31729),
"weapon_profile": "ranger_venombow"
},
"ranger|alternate|ranger_venombow|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(422, 524)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_0-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(447, 524),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_0",
"style": "alternate",
"weapon_axis": PackedVector2Array(365.43146, 580.56854, 669.48737, 276.51263),
"weapon_profile": "ranger_venombow"
},
"ranger|alternate|ranger_venombow|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(432, 529)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_1-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 266.0,
"emitter_point": Vector2(457, 529),
"hit_point": Vector2(350, 485.08002),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_1",
"style": "alternate",
"weapon_axis": PackedVector2Array(375.43146, 585.56854, 679.48737, 281.51263),
"weapon_profile": "ranger_venombow"
},
"ranger|alternate|ranger_venombow|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(415, 530)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_2-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 268.0,
"emitter_point": Vector2(440, 530),
"hit_point": Vector2(350, 483.84),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_2",
"style": "alternate",
"weapon_axis": PackedVector2Array(358.43146, 586.56854, 662.48737, 282.51263),
"weapon_profile": "ranger_venombow"
},
"ranger|alternate|ranger_venombow|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(422, 508)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_3-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 265.0,
"emitter_point": Vector2(447, 508),
"hit_point": Vector2(350, 485.7),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_3",
"style": "alternate",
"weapon_axis": PackedVector2Array(365.43146, 564.56854, 669.48737, 260.51263),
"weapon_profile": "ranger_venombow"
},
"ranger|alternate|ranger_venombow|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(451, 467)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/alternate-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-windup-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/alternate-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "alternate",
"body_height_pixels": 270.0,
"emitter_point": Vector2(476, 467),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "windup",
"style": "alternate",
"weapon_axis": PackedVector2Array(451, 547, 450.99997, 117),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_bow|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(460, 456)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-attack-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(485, 456),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "attack",
"style": "original",
"weapon_axis": PackedVector2Array(460, 536, 459.99997, 106),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(252, 496)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-camp-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(277, 496),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "camp",
"style": "original",
"weapon_axis": PackedVector2Array(231.29448, 573.27405, 342.58667, 157.92596),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(464, 455)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-cast-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(489, 455),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "cast",
"style": "original",
"weapon_axis": PackedVector2Array(464, 535, 463.99997, 105),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(313, 627)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-death-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(338, 627),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "death",
"style": "original",
"weapon_axis": PackedVector2Array(393, 627, -37, 626.99994),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(387, 507)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-guard-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(412, 507),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "guard",
"style": "original",
"weapon_axis": PackedVector2Array(335.577, 568.28357, 611.9757, 238.88446),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(430, 511)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-hurt-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(455, 511),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "hurt",
"style": "original",
"weapon_axis": PackedVector2Array(409.29446, 588.27405, 520.5867, 172.92596),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(418, 513)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(443, 513),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "idle",
"style": "original",
"weapon_axis": PackedVector2Array(397.29446, 590.27405, 508.58667, 174.92596),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(418, 513)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(443, 513),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "portrait",
"style": "original",
"weapon_axis": PackedVector2Array(397.29446, 590.27405, 508.58667, 174.92596),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|study_execution_0": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(670, 408)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_0-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(670, 408),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_0",
"style": "original",
"weapon_axis": PackedVector2Array(670, 488, 670, -242),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|study_execution_1": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(680, 404)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_1-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(680, 404),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_1",
"style": "original",
"weapon_axis": PackedVector2Array(680, 484, 680, -246),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|study_execution_2": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(632, 430)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_2-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(632, 430),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_2",
"style": "original",
"weapon_axis": PackedVector2Array(618.10815, 508.7846, 744.87134, -210.125),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|study_execution_3": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(670, 375)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_3-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(670, 375),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_3",
"style": "original",
"weapon_axis": PackedVector2Array(670, 455, 670, -275),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|study_execution_4": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(699, 383)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_4-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(699, 383),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_4",
"style": "original",
"weapon_axis": PackedVector2Array(699, 463, 699, -267),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|study_execution_5": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(586, 501)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_5-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_5-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_5-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(586, 501),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_5",
"style": "original",
"weapon_axis": PackedVector2Array(534.57697, 562.28357, 1003.81195, 3.071106),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(441, 501)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_0-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 302.0,
"emitter_point": Vector2(466, 501),
"hit_point": Vector2(350, 462.76),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_0",
"style": "original",
"weapon_axis": PackedVector2Array(413.6384, 576.1754, 560.70703, 172.10757),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(449, 505)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_1-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 301.0,
"emitter_point": Vector2(474, 505),
"hit_point": Vector2(350, 463.38),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_1",
"style": "original",
"weapon_axis": PackedVector2Array(421.6384, 580.1754, 568.70703, 176.10757),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(452, 512)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_2-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 298.0,
"emitter_point": Vector2(477, 512),
"hit_point": Vector2(350, 465.24),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_2",
"style": "original",
"weapon_axis": PackedVector2Array(424.6384, 587.1754, 571.70703, 183.10757),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(460, 507)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_3-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 302.0,
"emitter_point": Vector2(485, 507),
"hit_point": Vector2(350, 462.76),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_3",
"style": "original",
"weapon_axis": PackedVector2Array(432.6384, 582.1754, 579.70703, 178.10757),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_bow|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(472, 455)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-windup-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(497, 455),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "windup",
"style": "original",
"weapon_axis": PackedVector2Array(472, 535, 471.99997, 105),
"weapon_profile": "ranger_bow"
},
"ranger|original|ranger_epic|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(460, 456)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-attack-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(485, 456),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "attack",
"style": "original",
"weapon_axis": PackedVector2Array(460, 536, 459.99997, 106),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(252, 496)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-camp-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(277, 496),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "camp",
"style": "original",
"weapon_axis": PackedVector2Array(231.29448, 573.27405, 342.58667, 157.92596),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(464, 455)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-cast-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(489, 455),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "cast",
"style": "original",
"weapon_axis": PackedVector2Array(464, 535, 463.99997, 105),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(313, 627)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-death-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(338, 627),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "death",
"style": "original",
"weapon_axis": PackedVector2Array(393, 627, -37, 626.99994),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(387, 507)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-guard-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(412, 507),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "guard",
"style": "original",
"weapon_axis": PackedVector2Array(335.577, 568.28357, 611.9757, 238.88446),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(430, 511)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-hurt-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(455, 511),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "hurt",
"style": "original",
"weapon_axis": PackedVector2Array(409.29446, 588.27405, 520.5867, 172.92596),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(418, 513)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(443, 513),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "idle",
"style": "original",
"weapon_axis": PackedVector2Array(397.29446, 590.27405, 508.58667, 174.92596),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(418, 513)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(443, 513),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "portrait",
"style": "original",
"weapon_axis": PackedVector2Array(397.29446, 590.27405, 508.58667, 174.92596),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|study_execution_0": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(670, 408)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_0-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(670, 408),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_0",
"style": "original",
"weapon_axis": PackedVector2Array(670, 488, 670, -242),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|study_execution_1": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(680, 404)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_1-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(680, 404),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_1",
"style": "original",
"weapon_axis": PackedVector2Array(680, 484, 680, -246),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|study_execution_2": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(632, 430)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_2-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(632, 430),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_2",
"style": "original",
"weapon_axis": PackedVector2Array(618.10815, 508.7846, 744.87134, -210.125),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|study_execution_3": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(670, 375)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_3-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(670, 375),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_3",
"style": "original",
"weapon_axis": PackedVector2Array(670, 455, 670, -275),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|study_execution_4": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(699, 383)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_4-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(699, 383),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_4",
"style": "original",
"weapon_axis": PackedVector2Array(699, 463, 699, -267),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|study_execution_5": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(586, 501)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_5-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_5-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_5-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(586, 501),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_5",
"style": "original",
"weapon_axis": PackedVector2Array(534.57697, 562.28357, 1003.81195, 3.071106),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(441, 501)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_0-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 302.0,
"emitter_point": Vector2(466, 501),
"hit_point": Vector2(350, 462.76),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_0",
"style": "original",
"weapon_axis": PackedVector2Array(413.6384, 576.1754, 560.70703, 172.10757),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(449, 505)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_1-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 301.0,
"emitter_point": Vector2(474, 505),
"hit_point": Vector2(350, 463.38),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_1",
"style": "original",
"weapon_axis": PackedVector2Array(421.6384, 580.1754, 568.70703, 176.10757),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(452, 512)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_2-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 298.0,
"emitter_point": Vector2(477, 512),
"hit_point": Vector2(350, 465.24),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_2",
"style": "original",
"weapon_axis": PackedVector2Array(424.6384, 587.1754, 571.70703, 183.10757),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(460, 507)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_3-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 302.0,
"emitter_point": Vector2(485, 507),
"hit_point": Vector2(350, 462.76),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_3",
"style": "original",
"weapon_axis": PackedVector2Array(432.6384, 582.1754, 579.70703, 178.10757),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_epic|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(472, 455)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-windup-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(497, 455),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "windup",
"style": "original",
"weapon_axis": PackedVector2Array(472, 535, 471.99997, 105),
"weapon_profile": "ranger_epic"
},
"ranger|original|ranger_legend|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(460, 456)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-attack-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(485, 456),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "attack",
"style": "original",
"weapon_axis": PackedVector2Array(460, 536, 459.99997, 106),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(252, 496)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-camp-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(277, 496),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "camp",
"style": "original",
"weapon_axis": PackedVector2Array(231.29448, 573.27405, 342.58667, 157.92596),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(464, 455)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-cast-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(489, 455),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "cast",
"style": "original",
"weapon_axis": PackedVector2Array(464, 535, 463.99997, 105),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(313, 627)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-death-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(338, 627),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "death",
"style": "original",
"weapon_axis": PackedVector2Array(393, 627, -37, 626.99994),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(387, 507)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-guard-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(412, 507),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "guard",
"style": "original",
"weapon_axis": PackedVector2Array(335.577, 568.28357, 611.9757, 238.88446),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(430, 511)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-hurt-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(455, 511),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "hurt",
"style": "original",
"weapon_axis": PackedVector2Array(409.29446, 588.27405, 520.5867, 172.92596),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(418, 513)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(443, 513),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "idle",
"style": "original",
"weapon_axis": PackedVector2Array(397.29446, 590.27405, 508.58667, 174.92596),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(418, 513)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(443, 513),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "portrait",
"style": "original",
"weapon_axis": PackedVector2Array(397.29446, 590.27405, 508.58667, 174.92596),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|study_execution_0": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(670, 408)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_0-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(670, 408),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_0",
"style": "original",
"weapon_axis": PackedVector2Array(670, 488, 670, -242),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|study_execution_1": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(680, 404)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_1-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(680, 404),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_1",
"style": "original",
"weapon_axis": PackedVector2Array(680, 484, 680, -246),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|study_execution_2": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(632, 430)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_2-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(632, 430),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_2",
"style": "original",
"weapon_axis": PackedVector2Array(618.10815, 508.7846, 744.87134, -210.125),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|study_execution_3": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(670, 375)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_3-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(670, 375),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_3",
"style": "original",
"weapon_axis": PackedVector2Array(670, 455, 670, -275),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|study_execution_4": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(699, 383)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_4-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(699, 383),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_4",
"style": "original",
"weapon_axis": PackedVector2Array(699, 463, 699, -267),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|study_execution_5": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(586, 501)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_5-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_5-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_5-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(586, 501),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_5",
"style": "original",
"weapon_axis": PackedVector2Array(534.57697, 562.28357, 1003.81195, 3.071106),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(441, 501)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_0-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 302.0,
"emitter_point": Vector2(466, 501),
"hit_point": Vector2(350, 462.76),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_0",
"style": "original",
"weapon_axis": PackedVector2Array(413.6384, 576.1754, 560.70703, 172.10757),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(449, 505)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_1-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 301.0,
"emitter_point": Vector2(474, 505),
"hit_point": Vector2(350, 463.38),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_1",
"style": "original",
"weapon_axis": PackedVector2Array(421.6384, 580.1754, 568.70703, 176.10757),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(452, 512)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_2-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 298.0,
"emitter_point": Vector2(477, 512),
"hit_point": Vector2(350, 465.24),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_2",
"style": "original",
"weapon_axis": PackedVector2Array(424.6384, 587.1754, 571.70703, 183.10757),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(460, 507)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_3-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 302.0,
"emitter_point": Vector2(485, 507),
"hit_point": Vector2(350, 462.76),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_3",
"style": "original",
"weapon_axis": PackedVector2Array(432.6384, 582.1754, 579.70703, 178.10757),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_legend|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(472, 455)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-windup-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(497, 455),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "windup",
"style": "original",
"weapon_axis": PackedVector2Array(472, 535, 471.99997, 105),
"weapon_profile": "ranger_legend"
},
"ranger|original|ranger_venombow|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(460, 456)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-attack-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(485, 456),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "attack",
"style": "original",
"weapon_axis": PackedVector2Array(460, 536, 459.99997, 106),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(252, 496)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-camp-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(277, 496),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "camp",
"style": "original",
"weapon_axis": PackedVector2Array(231.29448, 573.27405, 342.58667, 157.92596),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(464, 455)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-cast-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(489, 455),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "cast",
"style": "original",
"weapon_axis": PackedVector2Array(464, 535, 463.99997, 105),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(313, 627)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-death-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(338, 627),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "death",
"style": "original",
"weapon_axis": PackedVector2Array(393, 627, -37, 626.99994),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(387, 507)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-guard-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(412, 507),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "guard",
"style": "original",
"weapon_axis": PackedVector2Array(335.577, 568.28357, 611.9757, 238.88446),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(430, 511)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-hurt-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(455, 511),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "hurt",
"style": "original",
"weapon_axis": PackedVector2Array(409.29446, 588.27405, 520.5867, 172.92596),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(418, 513)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(443, 513),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "idle",
"style": "original",
"weapon_axis": PackedVector2Array(397.29446, 590.27405, 508.58667, 174.92596),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(418, 513)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(443, 513),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "portrait",
"style": "original",
"weapon_axis": PackedVector2Array(397.29446, 590.27405, 508.58667, 174.92596),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|study_execution_0": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(670, 408)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_0-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(670, 408),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_0",
"style": "original",
"weapon_axis": PackedVector2Array(670, 488, 670, -242),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|study_execution_1": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(680, 404)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_1-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(680, 404),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_1",
"style": "original",
"weapon_axis": PackedVector2Array(680, 484, 680, -246),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|study_execution_2": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(632, 430)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_2-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(632, 430),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_2",
"style": "original",
"weapon_axis": PackedVector2Array(618.10815, 508.7846, 744.87134, -210.125),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|study_execution_3": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(670, 375)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_3-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(670, 375),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_3",
"style": "original",
"weapon_axis": PackedVector2Array(670, 455, 670, -275),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|study_execution_4": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(699, 383)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_4-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(699, 383),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_4",
"style": "original",
"weapon_axis": PackedVector2Array(699, 463, 699, -267),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|study_execution_5": {
"canvas_size": Vector2i(1024, 700),
"foot": Vector2(512, 650),
"grips": [Vector2(586, 501)],
"hero": "ranger",
"layers": [{
"offset": Vector2i(256, 150),
"path": "res://assets/art_library/weapons/ranger/study_execution_5-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_5-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/study_execution_5-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 350.4,
"emitter_point": Vector2(586, 501),
"hit_point": Vector2(512, 430),
"idle_pixel_height": 700.0,
"pose_id": "ranger",
"study_source_scale": 0.8
},
"pose": "study_execution_5",
"style": "original",
"weapon_axis": PackedVector2Array(534.57697, 562.28357, 1003.81195, 3.071106),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(441, 501)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_0-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 302.0,
"emitter_point": Vector2(466, 501),
"hit_point": Vector2(350, 462.76),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_0",
"style": "original",
"weapon_axis": PackedVector2Array(413.6384, 576.1754, 560.70703, 172.10757),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(449, 505)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_1-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 301.0,
"emitter_point": Vector2(474, 505),
"hit_point": Vector2(350, 463.38),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_1",
"style": "original",
"weapon_axis": PackedVector2Array(421.6384, 580.1754, 568.70703, 176.10757),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(452, 512)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_2-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 298.0,
"emitter_point": Vector2(477, 512),
"hit_point": Vector2(350, 465.24),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_2",
"style": "original",
"weapon_axis": PackedVector2Array(424.6384, 587.1754, 571.70703, 183.10757),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(460, 507)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_3-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 302.0,
"emitter_point": Vector2(485, 507),
"hit_point": Vector2(350, 462.76),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_3",
"style": "original",
"weapon_axis": PackedVector2Array(432.6384, 582.1754, 579.70703, 178.10757),
"weapon_profile": "ranger_venombow"
},
"ranger|original|ranger_venombow|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(472, 455)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/original-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-windup-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/original-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 270.0,
"emitter_point": Vector2(497, 455),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "windup",
"style": "original",
"weapon_axis": PackedVector2Array(472, 535, 471.99997, 105),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_bow|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 468)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-attack-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 468),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "attack",
"style": "relic",
"weapon_axis": PackedVector2Array(450, 548, 449.99997, 118),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_bow|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(348, 603)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-camp-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(373, 603),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "camp",
"style": "relic",
"weapon_axis": PackedVector2Array(428, 603, -2, 602.99994),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_bow|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 468)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-cast-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 468),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "cast",
"style": "relic",
"weapon_axis": PackedVector2Array(450, 548, 449.99997, 118),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_bow|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(444, 514)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-death-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(469, 514),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "death",
"style": "relic",
"weapon_axis": PackedVector2Array(430.10815, 592.7846, 504.7769, 169.31729),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_bow|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(434, 515)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-guard-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(459, 515),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "guard",
"style": "relic",
"weapon_axis": PackedVector2Array(420.10815, 593.7846, 494.7769, 170.31729),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_bow|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(447, 515)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-hurt-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(472, 515),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "hurt",
"style": "relic",
"weapon_axis": PackedVector2Array(433.10815, 593.7846, 507.7769, 170.31729),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_bow|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(442, 526)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(467, 526),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "idle",
"style": "relic",
"weapon_axis": PackedVector2Array(428.10815, 604.7846, 502.7769, 181.31729),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_bow|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(442, 526)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(467, 526),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "portrait",
"style": "relic",
"weapon_axis": PackedVector2Array(428.10815, 604.7846, 502.7769, 181.31729),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_bow|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(418, 522)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_0-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 274.0,
"emitter_point": Vector2(443, 522),
"hit_point": Vector2(350, 480.12),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_0",
"style": "relic",
"weapon_axis": PackedVector2Array(361.43146, 578.56854, 665.48737, 274.51263),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_bow|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(427, 521)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_1-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(452, 521),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_1",
"style": "relic",
"weapon_axis": PackedVector2Array(370.43146, 577.56854, 674.48737, 273.51263),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_bow|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(433, 522)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_2-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 267.0,
"emitter_point": Vector2(458, 522),
"hit_point": Vector2(350, 484.46002),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_2",
"style": "relic",
"weapon_axis": PackedVector2Array(376.43146, 578.56854, 680.48737, 274.51263),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_bow|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(423, 512)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_3-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 265.0,
"emitter_point": Vector2(448, 512),
"hit_point": Vector2(350, 485.7),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_3",
"style": "relic",
"weapon_axis": PackedVector2Array(366.43146, 568.56854, 670.48737, 264.51263),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_bow|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 468)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-windup-ranger_bow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 468),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "windup",
"style": "relic",
"weapon_axis": PackedVector2Array(450, 548, 449.99997, 118),
"weapon_profile": "ranger_bow"
},
"ranger|relic|ranger_epic|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 468)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-attack-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 468),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "attack",
"style": "relic",
"weapon_axis": PackedVector2Array(450, 548, 449.99997, 118),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_epic|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(348, 603)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-camp-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(373, 603),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "camp",
"style": "relic",
"weapon_axis": PackedVector2Array(428, 603, -2, 602.99994),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_epic|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 468)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-cast-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 468),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "cast",
"style": "relic",
"weapon_axis": PackedVector2Array(450, 548, 449.99997, 118),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_epic|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(444, 514)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-death-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(469, 514),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "death",
"style": "relic",
"weapon_axis": PackedVector2Array(430.10815, 592.7846, 504.7769, 169.31729),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_epic|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(434, 515)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-guard-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(459, 515),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "guard",
"style": "relic",
"weapon_axis": PackedVector2Array(420.10815, 593.7846, 494.7769, 170.31729),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_epic|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(447, 515)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-hurt-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(472, 515),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "hurt",
"style": "relic",
"weapon_axis": PackedVector2Array(433.10815, 593.7846, 507.7769, 170.31729),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_epic|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(442, 526)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(467, 526),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "idle",
"style": "relic",
"weapon_axis": PackedVector2Array(428.10815, 604.7846, 502.7769, 181.31729),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_epic|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(442, 526)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(467, 526),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "portrait",
"style": "relic",
"weapon_axis": PackedVector2Array(428.10815, 604.7846, 502.7769, 181.31729),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_epic|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(418, 522)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_0-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 274.0,
"emitter_point": Vector2(443, 522),
"hit_point": Vector2(350, 480.12),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_0",
"style": "relic",
"weapon_axis": PackedVector2Array(361.43146, 578.56854, 665.48737, 274.51263),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_epic|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(427, 521)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_1-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(452, 521),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_1",
"style": "relic",
"weapon_axis": PackedVector2Array(370.43146, 577.56854, 674.48737, 273.51263),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_epic|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(433, 522)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_2-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 267.0,
"emitter_point": Vector2(458, 522),
"hit_point": Vector2(350, 484.46002),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_2",
"style": "relic",
"weapon_axis": PackedVector2Array(376.43146, 578.56854, 680.48737, 274.51263),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_epic|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(423, 512)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_3-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 265.0,
"emitter_point": Vector2(448, 512),
"hit_point": Vector2(350, 485.7),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_3",
"style": "relic",
"weapon_axis": PackedVector2Array(366.43146, 568.56854, 670.48737, 264.51263),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_epic|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 468)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-windup-ranger_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 468),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "windup",
"style": "relic",
"weapon_axis": PackedVector2Array(450, 548, 449.99997, 118),
"weapon_profile": "ranger_epic"
},
"ranger|relic|ranger_legend|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 468)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-attack-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 468),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "attack",
"style": "relic",
"weapon_axis": PackedVector2Array(450, 548, 449.99997, 118),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_legend|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(348, 603)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-camp-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(373, 603),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "camp",
"style": "relic",
"weapon_axis": PackedVector2Array(428, 603, -2, 602.99994),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_legend|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 468)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-cast-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 468),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "cast",
"style": "relic",
"weapon_axis": PackedVector2Array(450, 548, 449.99997, 118),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_legend|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(444, 514)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-death-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(469, 514),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "death",
"style": "relic",
"weapon_axis": PackedVector2Array(430.10815, 592.7846, 504.7769, 169.31729),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_legend|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(434, 515)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-guard-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(459, 515),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "guard",
"style": "relic",
"weapon_axis": PackedVector2Array(420.10815, 593.7846, 494.7769, 170.31729),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_legend|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(447, 515)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-hurt-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(472, 515),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "hurt",
"style": "relic",
"weapon_axis": PackedVector2Array(433.10815, 593.7846, 507.7769, 170.31729),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_legend|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(442, 526)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(467, 526),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "idle",
"style": "relic",
"weapon_axis": PackedVector2Array(428.10815, 604.7846, 502.7769, 181.31729),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_legend|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(442, 526)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(467, 526),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "portrait",
"style": "relic",
"weapon_axis": PackedVector2Array(428.10815, 604.7846, 502.7769, 181.31729),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_legend|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(418, 522)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_0-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 274.0,
"emitter_point": Vector2(443, 522),
"hit_point": Vector2(350, 480.12),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_0",
"style": "relic",
"weapon_axis": PackedVector2Array(361.43146, 578.56854, 665.48737, 274.51263),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_legend|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(427, 521)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_1-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(452, 521),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_1",
"style": "relic",
"weapon_axis": PackedVector2Array(370.43146, 577.56854, 674.48737, 273.51263),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_legend|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(433, 522)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_2-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 267.0,
"emitter_point": Vector2(458, 522),
"hit_point": Vector2(350, 484.46002),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_2",
"style": "relic",
"weapon_axis": PackedVector2Array(376.43146, 578.56854, 680.48737, 274.51263),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_legend|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(423, 512)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_3-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 265.0,
"emitter_point": Vector2(448, 512),
"hit_point": Vector2(350, 485.7),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_3",
"style": "relic",
"weapon_axis": PackedVector2Array(366.43146, 568.56854, 670.48737, 264.51263),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_legend|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 468)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-windup-ranger_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 468),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "windup",
"style": "relic",
"weapon_axis": PackedVector2Array(450, 548, 449.99997, 118),
"weapon_profile": "ranger_legend"
},
"ranger|relic|ranger_venombow|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 468)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-attack-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 468),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "attack",
"style": "relic",
"weapon_axis": PackedVector2Array(450, 548, 449.99997, 118),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_venombow|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(348, 603)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-camp-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(373, 603),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "camp",
"style": "relic",
"weapon_axis": PackedVector2Array(428, 603, -2, 602.99994),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_venombow|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 468)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-cast-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 468),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "cast",
"style": "relic",
"weapon_axis": PackedVector2Array(450, 548, 449.99997, 118),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_venombow|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(444, 514)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-death-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(469, 514),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": true
},
"pose": "death",
"style": "relic",
"weapon_axis": PackedVector2Array(430.10815, 592.7846, 504.7769, 169.31729),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_venombow|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(434, 515)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-guard-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(459, 515),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "guard",
"style": "relic",
"weapon_axis": PackedVector2Array(420.10815, 593.7846, 494.7769, 170.31729),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_venombow|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(447, 515)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-hurt-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(472, 515),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "hurt",
"style": "relic",
"weapon_axis": PackedVector2Array(433.10815, 593.7846, 507.7769, 170.31729),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_venombow|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(442, 526)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(467, 526),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "idle",
"style": "relic",
"weapon_axis": PackedVector2Array(428.10815, 604.7846, 502.7769, 181.31729),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_venombow|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(442, 526)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(467, 526),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "portrait",
"style": "relic",
"weapon_axis": PackedVector2Array(428.10815, 604.7846, 502.7769, 181.31729),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_venombow|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(418, 522)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_0-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 274.0,
"emitter_point": Vector2(443, 522),
"hit_point": Vector2(350, 480.12),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_0",
"style": "relic",
"weapon_axis": PackedVector2Array(361.43146, 578.56854, 665.48737, 274.51263),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_venombow|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(427, 521)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_1-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(452, 521),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_1",
"style": "relic",
"weapon_axis": PackedVector2Array(370.43146, 577.56854, 674.48737, 273.51263),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_venombow|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(433, 522)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_2-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 267.0,
"emitter_point": Vector2(458, 522),
"hit_point": Vector2(350, 484.46002),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_2",
"style": "relic",
"weapon_axis": PackedVector2Array(376.43146, 578.56854, 680.48737, 274.51263),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_venombow|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(423, 512)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_3-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 265.0,
"emitter_point": Vector2(448, 512),
"hit_point": Vector2(350, 485.7),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "walk_3",
"style": "relic",
"weapon_axis": PackedVector2Array(366.43146, 568.56854, 670.48737, 264.51263),
"weapon_profile": "ranger_venombow"
},
"ranger|relic|ranger_venombow|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": Array[Vector2]([Vector2(450, 468)]),
"hero": "ranger",
"layers": [{
"offset": Vector2i(158, 317),
"path": "res://assets/art_library/weapons/ranger/relic-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-windup-ranger_venombow.png",
"role": "front_weapon"
}, {
"offset": Vector2i(0, 0),
"path": "res://assets/art_library/weapons/ranger/relic-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "equipment",
"body_height_pixels": 270.0,
"emitter_point": Vector2(475, 468),
"hit_point": Vector2(350, 482.6),
"idle_pixel_height": 700.0,
"party_build": "ranger",
"pose_id": "ranger",
"weapon_resting": false
},
"pose": "windup",
"style": "relic",
"weapon_axis": PackedVector2Array(450, 548, 449.99997, 118),
"weapon_profile": "ranger_venombow"
}
}""")
