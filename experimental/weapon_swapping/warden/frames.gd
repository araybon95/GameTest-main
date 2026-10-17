extends RefCounted
## Registered Warden catalog records; publication remains gated.
static var RECORDS: Dictionary = str_to_var("""{
"warden|alternate|warden_epic|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(390, 442)],
"hero": "warden",
"layers": [{
"offset": Vector2i(173, 356),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-attack-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(371, 422),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(390, 442),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "attack",
"style": "alternate",
"weapon_axis": PackedVector2Array(390, 442, 556.89307, 509.4292),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(383, 471)],
"hero": "warden",
"layers": [{
"offset": Vector2i(96, 387),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-camp-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(364, 451),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(383, 471),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "camp",
"style": "alternate",
"weapon_axis": PackedVector2Array(383, 471, 404.93646, 649.6583),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(248, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(179, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-cast-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(229, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(248, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "cast",
"style": "alternate",
"weapon_axis": PackedVector2Array(248, 365, 422.65323, 408.54596),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 526)],
"hero": "warden",
"layers": [{
"offset": Vector2i(159, 349),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-death-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 506),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(279, 526),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "death",
"style": "alternate",
"weapon_axis": PackedVector2Array(279, 526, 445.8931, 593.4292),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(291, 502)],
"hero": "warden",
"layers": [{
"offset": Vector2i(69, 154),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_0-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(271, 484),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(291, 502),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_0",
"style": "alternate",
"weapon_axis": PackedVector2Array(291, 502, 451.38116, 583.71826),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(244, 459)],
"hero": "warden",
"layers": [{
"offset": Vector2i(100, 154),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_1-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(224, 441),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(244, 459),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_1",
"style": "alternate",
"weapon_axis": PackedVector2Array(244, 459, 396.64865, 554.3855),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(374, 221)],
"hero": "warden",
"layers": [{
"offset": Vector2i(77, 154),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_2-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(354, 203),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(374, 221),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_2",
"style": "alternate",
"weapon_axis": PackedVector2Array(374, 221, 507.76605, 100.55649),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(469, 522)],
"hero": "warden",
"layers": [{
"offset": Vector2i(134, 184),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_3-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(449, 504),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(469, 522),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_3",
"style": "alternate",
"weapon_axis": PackedVector2Array(469, 522, 616.4474, 625.2438),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(287, 484)],
"hero": "warden",
"layers": [{
"offset": Vector2i(68, 184),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_4-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(267, 466),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(287, 484),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_4",
"style": "alternate",
"weapon_axis": PackedVector2Array(287, 484, 442.88458, 574),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution-contact-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(720, 340),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_contact",
"style": "alternate",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(283, 503)],
"hero": "warden",
"layers": [{
"offset": Vector2i(171, 325),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-guard-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(264, 483),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(283, 503),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "guard",
"style": "alternate",
"weapon_axis": PackedVector2Array(283, 503, 449.8931, 570.4292),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 526)],
"hero": "warden",
"layers": [{
"offset": Vector2i(159, 349),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-hurt-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 506),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(279, 526),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "hurt",
"style": "alternate",
"weapon_axis": PackedVector2Array(279, 526, 445.8931, 593.4292),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(283, 503)],
"hero": "warden",
"layers": [{
"offset": Vector2i(171, 325),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-idle-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(264, 483),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(283, 503),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "idle",
"style": "alternate",
"weapon_axis": PackedVector2Array(283, 503, 449.8931, 570.4292),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(-223, -344)],
"hero": "warden",
"layers": [{
"offset": Vector2i(186, 351),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-portrait-body.png",
"role": "full_frame"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(-223, -344),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"portrait_view": true,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": false
},
"pose": "portrait",
"style": "alternate",
"weapon_axis": PackedVector2Array(-223, -344, -56.106903, -276.5708),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(294, 497)],
"hero": "warden",
"layers": [{
"offset": Vector2i(169, 338),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_0-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(275, 477),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(294, 497),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_0",
"style": "alternate",
"weapon_axis": PackedVector2Array(294, 497, 460.8931, 564.4292),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(306, 496)],
"hero": "warden",
"layers": [{
"offset": Vector2i(153, 341),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_1-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(287, 476),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(306, 496),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_1",
"style": "alternate",
"weapon_axis": PackedVector2Array(306, 496, 472.8931, 563.4292),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(293, 491)],
"hero": "warden",
"layers": [{
"offset": Vector2i(153, 338),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_2-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(274, 471),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(293, 491),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_2",
"style": "alternate",
"weapon_axis": PackedVector2Array(293, 491, 459.8931, 558.4292),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(305, 502)],
"hero": "warden",
"layers": [{
"offset": Vector2i(172, 342),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_3-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(286, 482),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(305, 502),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_3",
"style": "alternate",
"weapon_axis": PackedVector2Array(305, 502, 471.8931, 569.4292),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_epic|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(248, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(179, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-windup-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(229, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(248, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "windup",
"style": "alternate",
"weapon_axis": PackedVector2Array(248, 365, 422.65323, 408.54596),
"weapon_profile": "warden_epic"
},
"warden|alternate|warden_frostblade|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(390, 442)],
"hero": "warden",
"layers": [{
"offset": Vector2i(173, 356),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-attack-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(371, 422),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(390, 442),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "attack",
"style": "alternate",
"weapon_axis": PackedVector2Array(390, 442, 556.89307, 509.4292),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(383, 471)],
"hero": "warden",
"layers": [{
"offset": Vector2i(96, 387),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-camp-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(364, 451),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(383, 471),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "camp",
"style": "alternate",
"weapon_axis": PackedVector2Array(383, 471, 404.93646, 649.6583),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(248, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(179, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-cast-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(229, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(248, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "cast",
"style": "alternate",
"weapon_axis": PackedVector2Array(248, 365, 422.65323, 408.54596),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 526)],
"hero": "warden",
"layers": [{
"offset": Vector2i(159, 349),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-death-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 506),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(279, 526),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "death",
"style": "alternate",
"weapon_axis": PackedVector2Array(279, 526, 445.8931, 593.4292),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(291, 502)],
"hero": "warden",
"layers": [{
"offset": Vector2i(69, 154),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_0-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(271, 484),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(291, 502),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_0",
"style": "alternate",
"weapon_axis": PackedVector2Array(291, 502, 451.38116, 583.71826),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(244, 459)],
"hero": "warden",
"layers": [{
"offset": Vector2i(100, 154),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_1-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(224, 441),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(244, 459),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_1",
"style": "alternate",
"weapon_axis": PackedVector2Array(244, 459, 396.64865, 554.3855),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(374, 221)],
"hero": "warden",
"layers": [{
"offset": Vector2i(77, 154),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_2-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(354, 203),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(374, 221),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_2",
"style": "alternate",
"weapon_axis": PackedVector2Array(374, 221, 507.76605, 100.55649),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(469, 522)],
"hero": "warden",
"layers": [{
"offset": Vector2i(134, 184),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_3-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(449, 504),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(469, 522),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_3",
"style": "alternate",
"weapon_axis": PackedVector2Array(469, 522, 616.4474, 625.2438),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(287, 484)],
"hero": "warden",
"layers": [{
"offset": Vector2i(68, 184),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_4-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(267, 466),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(287, 484),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_4",
"style": "alternate",
"weapon_axis": PackedVector2Array(287, 484, 442.88458, 574),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution-contact-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(720, 340),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_contact",
"style": "alternate",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(283, 503)],
"hero": "warden",
"layers": [{
"offset": Vector2i(171, 325),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-guard-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(264, 483),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(283, 503),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "guard",
"style": "alternate",
"weapon_axis": PackedVector2Array(283, 503, 449.8931, 570.4292),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 526)],
"hero": "warden",
"layers": [{
"offset": Vector2i(159, 349),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-hurt-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 506),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(279, 526),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "hurt",
"style": "alternate",
"weapon_axis": PackedVector2Array(279, 526, 445.8931, 593.4292),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(283, 503)],
"hero": "warden",
"layers": [{
"offset": Vector2i(171, 325),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-idle-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(264, 483),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(283, 503),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "idle",
"style": "alternate",
"weapon_axis": PackedVector2Array(283, 503, 449.8931, 570.4292),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(-223, -344)],
"hero": "warden",
"layers": [{
"offset": Vector2i(186, 351),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-portrait-body.png",
"role": "full_frame"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(-223, -344),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"portrait_view": true,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": false
},
"pose": "portrait",
"style": "alternate",
"weapon_axis": PackedVector2Array(-223, -344, -56.106903, -276.5708),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(294, 497)],
"hero": "warden",
"layers": [{
"offset": Vector2i(169, 338),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_0-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(275, 477),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(294, 497),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_0",
"style": "alternate",
"weapon_axis": PackedVector2Array(294, 497, 460.8931, 564.4292),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(306, 496)],
"hero": "warden",
"layers": [{
"offset": Vector2i(153, 341),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_1-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(287, 476),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(306, 496),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_1",
"style": "alternate",
"weapon_axis": PackedVector2Array(306, 496, 472.8931, 563.4292),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(293, 491)],
"hero": "warden",
"layers": [{
"offset": Vector2i(153, 338),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_2-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(274, 471),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(293, 491),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_2",
"style": "alternate",
"weapon_axis": PackedVector2Array(293, 491, 459.8931, 558.4292),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(305, 502)],
"hero": "warden",
"layers": [{
"offset": Vector2i(172, 342),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_3-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(286, 482),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(305, 502),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_3",
"style": "alternate",
"weapon_axis": PackedVector2Array(305, 502, 471.8931, 569.4292),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_frostblade|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(248, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(179, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-windup-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(229, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(248, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "windup",
"style": "alternate",
"weapon_axis": PackedVector2Array(248, 365, 422.65323, 408.54596),
"weapon_profile": "warden_frostblade"
},
"warden|alternate|warden_legend|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(390, 442)],
"hero": "warden",
"layers": [{
"offset": Vector2i(173, 356),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-attack-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(371, 422),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(390, 442),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "attack",
"style": "alternate",
"weapon_axis": PackedVector2Array(390, 442, 556.89307, 509.4292),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(383, 471)],
"hero": "warden",
"layers": [{
"offset": Vector2i(96, 387),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-camp-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(364, 451),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(383, 471),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "camp",
"style": "alternate",
"weapon_axis": PackedVector2Array(383, 471, 404.93646, 649.6583),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(248, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(179, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-cast-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(229, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(248, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "cast",
"style": "alternate",
"weapon_axis": PackedVector2Array(248, 365, 422.65323, 408.54596),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 526)],
"hero": "warden",
"layers": [{
"offset": Vector2i(159, 349),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-death-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 506),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(279, 526),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "death",
"style": "alternate",
"weapon_axis": PackedVector2Array(279, 526, 445.8931, 593.4292),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(291, 502)],
"hero": "warden",
"layers": [{
"offset": Vector2i(69, 154),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_0-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(271, 484),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(291, 502),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_0",
"style": "alternate",
"weapon_axis": PackedVector2Array(291, 502, 451.38116, 583.71826),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(244, 459)],
"hero": "warden",
"layers": [{
"offset": Vector2i(100, 154),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_1-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(224, 441),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(244, 459),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_1",
"style": "alternate",
"weapon_axis": PackedVector2Array(244, 459, 396.64865, 554.3855),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(374, 221)],
"hero": "warden",
"layers": [{
"offset": Vector2i(77, 154),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_2-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(354, 203),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(374, 221),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_2",
"style": "alternate",
"weapon_axis": PackedVector2Array(374, 221, 507.76605, 100.55649),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(469, 522)],
"hero": "warden",
"layers": [{
"offset": Vector2i(134, 184),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_3-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(449, 504),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(469, 522),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_3",
"style": "alternate",
"weapon_axis": PackedVector2Array(469, 522, 616.4474, 625.2438),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(287, 484)],
"hero": "warden",
"layers": [{
"offset": Vector2i(68, 184),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_4-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(267, 466),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(287, 484),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_4",
"style": "alternate",
"weapon_axis": PackedVector2Array(287, 484, 442.88458, 574),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution-contact-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(720, 340),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_contact",
"style": "alternate",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(283, 503)],
"hero": "warden",
"layers": [{
"offset": Vector2i(171, 325),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-guard-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(264, 483),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(283, 503),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "guard",
"style": "alternate",
"weapon_axis": PackedVector2Array(283, 503, 449.8931, 570.4292),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 526)],
"hero": "warden",
"layers": [{
"offset": Vector2i(159, 349),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-hurt-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 506),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(279, 526),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "hurt",
"style": "alternate",
"weapon_axis": PackedVector2Array(279, 526, 445.8931, 593.4292),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(283, 503)],
"hero": "warden",
"layers": [{
"offset": Vector2i(171, 325),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-idle-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(264, 483),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(283, 503),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "idle",
"style": "alternate",
"weapon_axis": PackedVector2Array(283, 503, 449.8931, 570.4292),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(-223, -344)],
"hero": "warden",
"layers": [{
"offset": Vector2i(186, 351),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-portrait-body.png",
"role": "full_frame"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(-223, -344),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"portrait_view": true,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": false
},
"pose": "portrait",
"style": "alternate",
"weapon_axis": PackedVector2Array(-223, -344, -56.106903, -276.5708),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(294, 497)],
"hero": "warden",
"layers": [{
"offset": Vector2i(169, 338),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_0-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(275, 477),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(294, 497),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_0",
"style": "alternate",
"weapon_axis": PackedVector2Array(294, 497, 460.8931, 564.4292),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(306, 496)],
"hero": "warden",
"layers": [{
"offset": Vector2i(153, 341),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_1-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(287, 476),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(306, 496),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_1",
"style": "alternate",
"weapon_axis": PackedVector2Array(306, 496, 472.8931, 563.4292),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(293, 491)],
"hero": "warden",
"layers": [{
"offset": Vector2i(153, 338),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_2-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(274, 471),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(293, 491),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_2",
"style": "alternate",
"weapon_axis": PackedVector2Array(293, 491, 459.8931, 558.4292),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(305, 502)],
"hero": "warden",
"layers": [{
"offset": Vector2i(172, 342),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_3-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(286, 482),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(305, 502),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_3",
"style": "alternate",
"weapon_axis": PackedVector2Array(305, 502, 471.8931, 569.4292),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_legend|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(248, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(179, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-windup-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(229, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(248, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "windup",
"style": "alternate",
"weapon_axis": PackedVector2Array(248, 365, 422.65323, 408.54596),
"weapon_profile": "warden_legend"
},
"warden|alternate|warden_sword|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(390, 442)],
"hero": "warden",
"layers": [{
"offset": Vector2i(173, 356),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-attack-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(371, 422),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(390, 442),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "attack",
"style": "alternate",
"weapon_axis": PackedVector2Array(390, 442, 556.89307, 509.4292),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(383, 471)],
"hero": "warden",
"layers": [{
"offset": Vector2i(96, 387),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-camp-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(364, 451),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(383, 471),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "camp",
"style": "alternate",
"weapon_axis": PackedVector2Array(383, 471, 404.93646, 649.6583),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(248, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(179, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-cast-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(229, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(248, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "cast",
"style": "alternate",
"weapon_axis": PackedVector2Array(248, 365, 422.65323, 408.54596),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 526)],
"hero": "warden",
"layers": [{
"offset": Vector2i(159, 349),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-death-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 506),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(279, 526),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "death",
"style": "alternate",
"weapon_axis": PackedVector2Array(279, 526, 445.8931, 593.4292),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(291, 502)],
"hero": "warden",
"layers": [{
"offset": Vector2i(69, 154),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_0-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(271, 484),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(291, 502),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_0",
"style": "alternate",
"weapon_axis": PackedVector2Array(291, 502, 451.38116, 583.71826),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(244, 459)],
"hero": "warden",
"layers": [{
"offset": Vector2i(100, 154),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_1-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(224, 441),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(244, 459),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_1",
"style": "alternate",
"weapon_axis": PackedVector2Array(244, 459, 396.64865, 554.3855),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(374, 221)],
"hero": "warden",
"layers": [{
"offset": Vector2i(77, 154),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_2-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(354, 203),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(374, 221),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_2",
"style": "alternate",
"weapon_axis": PackedVector2Array(374, 221, 507.76605, 100.55649),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(469, 522)],
"hero": "warden",
"layers": [{
"offset": Vector2i(134, 184),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_3-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(449, 504),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(469, 522),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_3",
"style": "alternate",
"weapon_axis": PackedVector2Array(469, 522, 616.4474, 625.2438),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(287, 484)],
"hero": "warden",
"layers": [{
"offset": Vector2i(68, 184),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_4-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(267, 466),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(287, 484),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_4",
"style": "alternate",
"weapon_axis": PackedVector2Array(287, 484, 442.88458, 574),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution-contact-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(720, 340),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden",
"warden_outfit": "alternate"
},
"pose": "execution_contact",
"style": "alternate",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(283, 503)],
"hero": "warden",
"layers": [{
"offset": Vector2i(171, 325),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-guard-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(264, 483),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(283, 503),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "guard",
"style": "alternate",
"weapon_axis": PackedVector2Array(283, 503, 449.8931, 570.4292),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 526)],
"hero": "warden",
"layers": [{
"offset": Vector2i(159, 349),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-hurt-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 506),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(279, 526),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "hurt",
"style": "alternate",
"weapon_axis": PackedVector2Array(279, 526, 445.8931, 593.4292),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(283, 503)],
"hero": "warden",
"layers": [{
"offset": Vector2i(171, 325),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-idle-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(264, 483),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(283, 503),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "idle",
"style": "alternate",
"weapon_axis": PackedVector2Array(283, 503, 449.8931, 570.4292),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(-223, -344)],
"hero": "warden",
"layers": [{
"offset": Vector2i(186, 351),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-portrait-body.png",
"role": "full_frame"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(-223, -344),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"portrait_view": true,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": false
},
"pose": "portrait",
"style": "alternate",
"weapon_axis": PackedVector2Array(-223, -344, -56.106903, -276.5708),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(294, 497)],
"hero": "warden",
"layers": [{
"offset": Vector2i(169, 338),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_0-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(275, 477),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(294, 497),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_0",
"style": "alternate",
"weapon_axis": PackedVector2Array(294, 497, 460.8931, 564.4292),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(306, 496)],
"hero": "warden",
"layers": [{
"offset": Vector2i(153, 341),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_1-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(287, 476),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(306, 496),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_1",
"style": "alternate",
"weapon_axis": PackedVector2Array(306, 496, 472.8931, 563.4292),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(293, 491)],
"hero": "warden",
"layers": [{
"offset": Vector2i(153, 338),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_2-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(274, 471),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(293, 491),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_2",
"style": "alternate",
"weapon_axis": PackedVector2Array(293, 491, 459.8931, 558.4292),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(305, 502)],
"hero": "warden",
"layers": [{
"offset": Vector2i(172, 342),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_3-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(286, 482),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(305, 502),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "walk_3",
"style": "alternate",
"weapon_axis": PackedVector2Array(305, 502, 471.8931, 569.4292),
"weapon_profile": "warden_sword"
},
"warden|alternate|warden_sword|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(248, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(179, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-windup-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(229, 345),
"path": "res://experimental/weapon_swapping/warden/assets/alternate-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(248, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "alternate",
"weapon_visible": true
},
"pose": "windup",
"style": "alternate",
"weapon_axis": PackedVector2Array(248, 365, 422.65323, 408.54596),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_epic|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(253, 334)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(234, 314),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(253, 334),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "attack",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(253, 334, 408.88458, 244),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 485),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(285, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "camp",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(285, 505, 440.88458, 595),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(253, 334)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(234, 314),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(253, 334),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "cast",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(253, 334, 408.88458, 244),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "death",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(286, 478)],
"hero": "warden",
"layers": [{
"offset": Vector2i(75, 144),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_0-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 460),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(286, 478),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_0",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(286, 478, 446.38116, 559.71826),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(230, 432)],
"hero": "warden",
"layers": [{
"offset": Vector2i(104, 145),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_1-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(210, 414),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(230, 432),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_1",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(230, 432, 382.64865, 527.3855),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(291, 222)],
"hero": "warden",
"layers": [{
"offset": Vector2i(61, 145),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_2-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(271, 204),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(291, 222),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_2",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(291, 222, 424.76605, 101.55649),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(484, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(125, 182),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_3-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(464, 487),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(484, 505),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_3",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(484, 505, 631.4474, 608.2438),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 454)],
"hero": "warden",
"layers": [{
"offset": Vector2i(60, 187),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_4-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(262, 436),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(282, 454),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_4",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(282, 454, 437.88458, 544),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution-contact-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(720, 340),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_contact",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "guard",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "hurt",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "idle",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 485),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(285, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "portrait",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(285, 505, 440.88458, 595),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 485),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(285, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_0",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(285, 505, 440.88458, 595),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 522)],
"hero": "warden",
"layers": [{
"offset": Vector2i(111, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_1-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 502),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(279, 522),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_1",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(279, 522, 434.88458, 612),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(293, 498)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 300),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_2-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(274, 478),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(293, 498),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_2",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(293, 498, 448.88458, 588),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(289, 501)],
"hero": "warden",
"layers": [{
"offset": Vector2i(122, 304),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_3-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(270, 481),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(289, 501),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_3",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(289, 501, 444.88458, 591),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|walk_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(302, 511)],
"hero": "warden",
"layers": [{
"offset": Vector2i(132, 301),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_4-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(283, 491),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_4-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(302, 511),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_4",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(302, 511, 457.88458, 601),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|walk_5": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(288, 546)],
"hero": "warden",
"layers": [{
"offset": Vector2i(109, 299),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_5-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_5-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(269, 526),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_5-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(288, 546),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_5",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(288, 546, 443.88458, 636),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|walk_6": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(295, 510)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 313),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_6-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_6-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(276, 490),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_6-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(295, 510),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_6",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(295, 510, 450.88458, 600),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|walk_7": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(287, 512)],
"hero": "warden",
"layers": [{
"offset": Vector2i(137, 312),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_7-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_7-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(268, 492),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_7-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(287, 512),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_7",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(287, 512, 442.88458, 602),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|walk_8": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(293, 525)],
"hero": "warden",
"layers": [{
"offset": Vector2i(136, 311),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_8-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_8-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(274, 505),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_8-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(293, 525),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_8",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(293, 525, 448.88458, 615),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|walk_9": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(297, 534)],
"hero": "warden",
"layers": [{
"offset": Vector2i(114, 311),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_9-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_9-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(278, 514),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_9-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(297, 534),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_9",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(297, 534, 452.88458, 624),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_epic|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(253, 334)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(234, 314),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(253, 334),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "windup",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(253, 334, 408.88458, 244),
"weapon_profile": "warden_epic"
},
"warden|ashen_wolf|warden_frostblade|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(253, 334)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(234, 314),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(253, 334),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "attack",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(253, 334, 408.88458, 244),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 485),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(285, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "camp",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(285, 505, 440.88458, 595),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(253, 334)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(234, 314),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(253, 334),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "cast",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(253, 334, 408.88458, 244),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "death",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(286, 478)],
"hero": "warden",
"layers": [{
"offset": Vector2i(75, 144),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_0-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 460),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(286, 478),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_0",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(286, 478, 446.38116, 559.71826),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(230, 432)],
"hero": "warden",
"layers": [{
"offset": Vector2i(104, 145),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_1-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(210, 414),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(230, 432),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_1",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(230, 432, 382.64865, 527.3855),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(291, 222)],
"hero": "warden",
"layers": [{
"offset": Vector2i(61, 145),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_2-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(271, 204),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(291, 222),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_2",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(291, 222, 424.76605, 101.55649),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(484, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(125, 182),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_3-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(464, 487),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(484, 505),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_3",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(484, 505, 631.4474, 608.2438),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 454)],
"hero": "warden",
"layers": [{
"offset": Vector2i(60, 187),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_4-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(262, 436),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(282, 454),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_4",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(282, 454, 437.88458, 544),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution-contact-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(720, 340),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_contact",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "guard",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "hurt",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "idle",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 485),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(285, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "portrait",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(285, 505, 440.88458, 595),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 485),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(285, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_0",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(285, 505, 440.88458, 595),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 522)],
"hero": "warden",
"layers": [{
"offset": Vector2i(111, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_1-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 502),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(279, 522),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_1",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(279, 522, 434.88458, 612),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(293, 498)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 300),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_2-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(274, 478),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(293, 498),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_2",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(293, 498, 448.88458, 588),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(289, 501)],
"hero": "warden",
"layers": [{
"offset": Vector2i(122, 304),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_3-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(270, 481),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(289, 501),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_3",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(289, 501, 444.88458, 591),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|walk_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(302, 511)],
"hero": "warden",
"layers": [{
"offset": Vector2i(132, 301),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_4-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(283, 491),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_4-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(302, 511),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_4",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(302, 511, 457.88458, 601),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|walk_5": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(288, 546)],
"hero": "warden",
"layers": [{
"offset": Vector2i(109, 299),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_5-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_5-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(269, 526),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_5-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(288, 546),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_5",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(288, 546, 443.88458, 636),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|walk_6": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(295, 510)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 313),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_6-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_6-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(276, 490),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_6-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(295, 510),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_6",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(295, 510, 450.88458, 600),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|walk_7": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(287, 512)],
"hero": "warden",
"layers": [{
"offset": Vector2i(137, 312),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_7-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_7-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(268, 492),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_7-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(287, 512),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_7",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(287, 512, 442.88458, 602),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|walk_8": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(293, 525)],
"hero": "warden",
"layers": [{
"offset": Vector2i(136, 311),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_8-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_8-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(274, 505),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_8-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(293, 525),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_8",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(293, 525, 448.88458, 615),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|walk_9": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(297, 534)],
"hero": "warden",
"layers": [{
"offset": Vector2i(114, 311),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_9-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_9-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(278, 514),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_9-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(297, 534),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_9",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(297, 534, 452.88458, 624),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_frostblade|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(253, 334)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(234, 314),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(253, 334),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "windup",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(253, 334, 408.88458, 244),
"weapon_profile": "warden_frostblade"
},
"warden|ashen_wolf|warden_legend|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(253, 334)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(234, 314),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(253, 334),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "attack",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(253, 334, 408.88458, 244),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 485),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(285, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "camp",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(285, 505, 440.88458, 595),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(253, 334)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(234, 314),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(253, 334),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "cast",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(253, 334, 408.88458, 244),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "death",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(286, 478)],
"hero": "warden",
"layers": [{
"offset": Vector2i(75, 144),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_0-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 460),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(286, 478),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_0",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(286, 478, 446.38116, 559.71826),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(230, 432)],
"hero": "warden",
"layers": [{
"offset": Vector2i(104, 145),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_1-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(210, 414),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(230, 432),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_1",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(230, 432, 382.64865, 527.3855),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(291, 222)],
"hero": "warden",
"layers": [{
"offset": Vector2i(61, 145),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_2-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(271, 204),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(291, 222),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_2",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(291, 222, 424.76605, 101.55649),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(484, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(125, 182),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_3-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(464, 487),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(484, 505),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_3",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(484, 505, 631.4474, 608.2438),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 454)],
"hero": "warden",
"layers": [{
"offset": Vector2i(60, 187),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_4-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(262, 436),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(282, 454),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_4",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(282, 454, 437.88458, 544),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution-contact-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(720, 340),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_contact",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "guard",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "hurt",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "idle",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 485),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(285, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "portrait",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(285, 505, 440.88458, 595),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 485),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(285, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_0",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(285, 505, 440.88458, 595),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 522)],
"hero": "warden",
"layers": [{
"offset": Vector2i(111, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_1-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 502),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(279, 522),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_1",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(279, 522, 434.88458, 612),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(293, 498)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 300),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_2-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(274, 478),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(293, 498),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_2",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(293, 498, 448.88458, 588),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(289, 501)],
"hero": "warden",
"layers": [{
"offset": Vector2i(122, 304),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_3-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(270, 481),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(289, 501),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_3",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(289, 501, 444.88458, 591),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|walk_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(302, 511)],
"hero": "warden",
"layers": [{
"offset": Vector2i(132, 301),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_4-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(283, 491),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_4-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(302, 511),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_4",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(302, 511, 457.88458, 601),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|walk_5": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(288, 546)],
"hero": "warden",
"layers": [{
"offset": Vector2i(109, 299),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_5-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_5-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(269, 526),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_5-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(288, 546),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_5",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(288, 546, 443.88458, 636),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|walk_6": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(295, 510)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 313),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_6-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_6-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(276, 490),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_6-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(295, 510),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_6",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(295, 510, 450.88458, 600),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|walk_7": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(287, 512)],
"hero": "warden",
"layers": [{
"offset": Vector2i(137, 312),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_7-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_7-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(268, 492),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_7-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(287, 512),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_7",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(287, 512, 442.88458, 602),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|walk_8": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(293, 525)],
"hero": "warden",
"layers": [{
"offset": Vector2i(136, 311),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_8-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_8-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(274, 505),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_8-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(293, 525),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_8",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(293, 525, 448.88458, 615),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|walk_9": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(297, 534)],
"hero": "warden",
"layers": [{
"offset": Vector2i(114, 311),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_9-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_9-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(278, 514),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_9-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(297, 534),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_9",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(297, 534, 452.88458, 624),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_legend|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(253, 334)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(234, 314),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(253, 334),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "windup",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(253, 334, 408.88458, 244),
"weapon_profile": "warden_legend"
},
"warden|ashen_wolf|warden_sword|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(253, 334)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(234, 314),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(253, 334),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "attack",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(253, 334, 408.88458, 244),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 485),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(285, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "camp",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(285, 505, 440.88458, 595),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(253, 334)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(234, 314),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(253, 334),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "cast",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(253, 334, 408.88458, 244),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "death",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(286, 478)],
"hero": "warden",
"layers": [{
"offset": Vector2i(75, 144),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_0-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 460),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(286, 478),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_0",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(286, 478, 446.38116, 559.71826),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(230, 432)],
"hero": "warden",
"layers": [{
"offset": Vector2i(104, 145),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_1-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(210, 414),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(230, 432),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_1",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(230, 432, 382.64865, 527.3855),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(291, 222)],
"hero": "warden",
"layers": [{
"offset": Vector2i(61, 145),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_2-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(271, 204),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(291, 222),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_2",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(291, 222, 424.76605, 101.55649),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(484, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(125, 182),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_3-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(464, 487),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(484, 505),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_3",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(484, 505, 631.4474, 608.2438),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 454)],
"hero": "warden",
"layers": [{
"offset": Vector2i(60, 187),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_4-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(262, 436),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(282, 454),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_4",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(282, 454, 437.88458, 544),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution-contact-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(720, 340),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf"
},
"pose": "execution_contact",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "guard",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "hurt",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 473),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 493),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "idle",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(276, 493, 449.86664, 539.5874),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 485),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(285, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "portrait",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(285, 505, 440.88458, 595),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 485),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(285, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_0",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(285, 505, 440.88458, 595),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 522)],
"hero": "warden",
"layers": [{
"offset": Vector2i(111, 265),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_1-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 502),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(279, 522),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_1",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(279, 522, 434.88458, 612),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(293, 498)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 300),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_2-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(274, 478),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(293, 498),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_2",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(293, 498, 448.88458, 588),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(289, 501)],
"hero": "warden",
"layers": [{
"offset": Vector2i(122, 304),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_3-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(270, 481),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(289, 501),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_3",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(289, 501, 444.88458, 591),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|walk_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(302, 511)],
"hero": "warden",
"layers": [{
"offset": Vector2i(132, 301),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_4-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(283, 491),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_4-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(302, 511),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_4",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(302, 511, 457.88458, 601),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|walk_5": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(288, 546)],
"hero": "warden",
"layers": [{
"offset": Vector2i(109, 299),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_5-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_5-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(269, 526),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_5-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(288, 546),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_5",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(288, 546, 443.88458, 636),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|walk_6": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(295, 510)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 313),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_6-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_6-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(276, 490),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_6-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(295, 510),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_6",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(295, 510, 450.88458, 600),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|walk_7": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(287, 512)],
"hero": "warden",
"layers": [{
"offset": Vector2i(137, 312),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_7-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_7-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(268, 492),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_7-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(287, 512),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_7",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(287, 512, 442.88458, 602),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|walk_8": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(293, 525)],
"hero": "warden",
"layers": [{
"offset": Vector2i(136, 311),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_8-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_8-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(274, 505),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_8-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(293, 525),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_8",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(293, 525, 448.88458, 615),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|walk_9": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(297, 534)],
"hero": "warden",
"layers": [{
"offset": Vector2i(114, 311),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_9-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_9-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(278, 514),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-walk_9-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(297, 534),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "walk_9",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(297, 534, 452.88458, 624),
"weapon_profile": "warden_sword"
},
"warden|ashen_wolf|warden_sword|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(253, 334)],
"hero": "warden",
"layers": [{
"offset": Vector2i(135, 269),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(234, 314),
"path": "res://experimental/weapon_swapping/warden/assets/ashen_wolf-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(253, 334),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "ashen_wolf",
"weapon_visible": true
},
"pose": "windup",
"style": "ashen_wolf",
"weapon_axis": PackedVector2Array(253, 334, 408.88458, 244),
"weapon_profile": "warden_sword"
},
"warden|original|warden_epic|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(484, 444)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 237),
"path": "res://experimental/weapon_swapping/warden/assets/attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/attack-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(459, 422),
"path": "res://experimental/weapon_swapping/warden/assets/attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(484, 444),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "attack",
"style": "original",
"weapon_axis": PackedVector2Array(484, 444, 683.18585, 559),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 268),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(263, 485),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(282, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "camp",
"style": "original",
"weapon_axis": PackedVector2Array(282, 505, 437.88458, 595),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 456)],
"hero": "warden",
"layers": [{
"offset": Vector2i(109, 251),
"path": "res://experimental/weapon_swapping/warden/assets/guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/guard-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(215, 434),
"path": "res://experimental/weapon_swapping/warden/assets/guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(240, 456),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "cast",
"style": "original",
"weapon_axis": PackedVector2Array(240, 456, 430.67865, 584.6144),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(433, 580)],
"hero": "warden",
"layers": [{
"offset": Vector2i(60, 445),
"path": "res://experimental/weapon_swapping/warden/assets/death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/death-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(408, 558),
"path": "res://experimental/weapon_swapping/warden/assets/death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(433, 580),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "death",
"style": "original",
"weapon_axis": PackedVector2Array(433, 580, 655.16296, 639.5284),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(319, 498)],
"hero": "warden",
"layers": [{
"offset": Vector2i(94, 150),
"path": "res://experimental/weapon_swapping/warden/assets/execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_0-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(294, 476),
"path": "res://experimental/weapon_swapping/warden/assets/execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(319, 498),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_0",
"style": "original",
"weapon_axis": PackedVector2Array(319, 498, 479.38116, 579.71826),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(239, 456)],
"hero": "warden",
"layers": [{
"offset": Vector2i(94, 150),
"path": "res://experimental/weapon_swapping/warden/assets/execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_1-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(214, 434),
"path": "res://experimental/weapon_swapping/warden/assets/execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(239, 456),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_1",
"style": "original",
"weapon_axis": PackedVector2Array(239, 456, 391.64865, 551.3855),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(305, 273)],
"hero": "warden",
"layers": [{
"offset": Vector2i(85, 156),
"path": "res://experimental/weapon_swapping/warden/assets/execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_2-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(280, 251),
"path": "res://experimental/weapon_swapping/warden/assets/execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(305, 273),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_2",
"style": "original",
"weapon_axis": PackedVector2Array(305, 273, 438.76605, 152.55649),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(494, 517)],
"hero": "warden",
"layers": [{
"offset": Vector2i(158, 160),
"path": "res://experimental/weapon_swapping/warden/assets/execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_3-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(469, 495),
"path": "res://experimental/weapon_swapping/warden/assets/execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(494, 517),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_3",
"style": "original",
"weapon_axis": PackedVector2Array(494, 517, 641.4474, 620.2438),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(302, 476)],
"hero": "warden",
"layers": [{
"offset": Vector2i(85, 155),
"path": "res://experimental/weapon_swapping/warden/assets/execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_4-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(277, 454),
"path": "res://experimental/weapon_swapping/warden/assets/execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(302, 476),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_4",
"style": "original",
"weapon_axis": PackedVector2Array(302, 476, 457.88458, 566),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution-contact-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(705, 330),
"path": "res://experimental/weapon_swapping/warden/assets/execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden"
},
"pose": "execution_contact",
"style": "original",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 456)],
"hero": "warden",
"layers": [{
"offset": Vector2i(109, 251),
"path": "res://experimental/weapon_swapping/warden/assets/guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/guard-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(215, 434),
"path": "res://experimental/weapon_swapping/warden/assets/guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(240, 456),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "guard",
"style": "original",
"weapon_axis": PackedVector2Array(240, 456, 430.67865, 584.6144),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(120, 502)],
"hero": "warden",
"layers": [{
"offset": Vector2i(44, 252),
"path": "res://experimental/weapon_swapping/warden/assets/hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/hurt-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(95, 480),
"path": "res://experimental/weapon_swapping/warden/assets/hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(120, 502),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "hurt",
"style": "original",
"weapon_axis": PackedVector2Array(120, 502, 319.18585, 617),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(263, 435)],
"hero": "warden",
"layers": [{
"offset": Vector2i(129, 171),
"path": "res://experimental/weapon_swapping/warden/assets/idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/idle-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(238, 413),
"path": "res://experimental/weapon_swapping/warden/assets/idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(263, 435),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "idle",
"style": "original",
"weapon_axis": PackedVector2Array(263, 435, 453.67865, 563.6144),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 268),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(263, 485),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(282, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "portrait",
"style": "original",
"weapon_axis": PackedVector2Array(282, 505, 437.88458, 595),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 268),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(263, 485),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(282, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_0",
"style": "original",
"weapon_axis": PackedVector2Array(282, 505, 437.88458, 595),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(274, 512)],
"hero": "warden",
"layers": [{
"offset": Vector2i(122, 266),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_1-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(255, 492),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(274, 512),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_1",
"style": "original",
"weapon_axis": PackedVector2Array(274, 512, 429.88458, 602),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(278, 499)],
"hero": "warden",
"layers": [{
"offset": Vector2i(130, 305),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_2-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 479),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(278, 499),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_2",
"style": "original",
"weapon_axis": PackedVector2Array(278, 499, 433.88458, 589),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 498)],
"hero": "warden",
"layers": [{
"offset": Vector2i(125, 305),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_3-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 478),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 498),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_3",
"style": "original",
"weapon_axis": PackedVector2Array(276, 498, 431.88458, 588),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|walk_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(294, 508)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 303),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_4-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(275, 488),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_4-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(294, 508),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_4",
"style": "original",
"weapon_axis": PackedVector2Array(294, 508, 449.88458, 598),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|walk_5": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(280, 529)],
"hero": "warden",
"layers": [{
"offset": Vector2i(117, 301),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_5-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_5-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(261, 509),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_5-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(280, 529),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_5",
"style": "original",
"weapon_axis": PackedVector2Array(280, 529, 435.88458, 619),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|walk_6": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(284, 503)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 310),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_6-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_6-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(265, 483),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_6-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(284, 503),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_6",
"style": "original",
"weapon_axis": PackedVector2Array(284, 503, 439.88458, 593),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|walk_7": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 500)],
"hero": "warden",
"layers": [{
"offset": Vector2i(136, 306),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_7-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_7-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 480),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_7-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(279, 500),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_7",
"style": "original",
"weapon_axis": PackedVector2Array(279, 500, 434.88458, 590),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|walk_8": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(280, 528)],
"hero": "warden",
"layers": [{
"offset": Vector2i(127, 310),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_8-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_8-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(261, 508),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_8-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(280, 528),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_8",
"style": "original",
"weapon_axis": PackedVector2Array(280, 528, 435.88458, 618),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|walk_9": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(289, 519)],
"hero": "warden",
"layers": [{
"offset": Vector2i(121, 307),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_9-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_9-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(270, 499),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_9-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(289, 519),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_9",
"style": "original",
"weapon_axis": PackedVector2Array(289, 519, 444.88458, 609),
"weapon_profile": "warden_epic"
},
"warden|original|warden_epic|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(269, 209)],
"hero": "warden",
"layers": [{
"offset": Vector2i(166, 106),
"path": "res://experimental/weapon_swapping/warden/assets/windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/windup-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(244, 187),
"path": "res://experimental/weapon_swapping/warden/assets/windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(269, 209),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "windup",
"style": "original",
"weapon_axis": PackedVector2Array(269, 209, 413.74368, 30.256424),
"weapon_profile": "warden_epic"
},
"warden|original|warden_frostblade|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(484, 444)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 237),
"path": "res://experimental/weapon_swapping/warden/assets/attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/attack-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(459, 422),
"path": "res://experimental/weapon_swapping/warden/assets/attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(484, 444),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "attack",
"style": "original",
"weapon_axis": PackedVector2Array(484, 444, 683.18585, 559),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 268),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(263, 485),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(282, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "camp",
"style": "original",
"weapon_axis": PackedVector2Array(282, 505, 437.88458, 595),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 456)],
"hero": "warden",
"layers": [{
"offset": Vector2i(109, 251),
"path": "res://experimental/weapon_swapping/warden/assets/guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/guard-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(215, 434),
"path": "res://experimental/weapon_swapping/warden/assets/guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(240, 456),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "cast",
"style": "original",
"weapon_axis": PackedVector2Array(240, 456, 430.67865, 584.6144),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(433, 580)],
"hero": "warden",
"layers": [{
"offset": Vector2i(60, 445),
"path": "res://experimental/weapon_swapping/warden/assets/death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/death-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(408, 558),
"path": "res://experimental/weapon_swapping/warden/assets/death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(433, 580),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "death",
"style": "original",
"weapon_axis": PackedVector2Array(433, 580, 655.16296, 639.5284),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(319, 498)],
"hero": "warden",
"layers": [{
"offset": Vector2i(94, 150),
"path": "res://experimental/weapon_swapping/warden/assets/execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_0-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(294, 476),
"path": "res://experimental/weapon_swapping/warden/assets/execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(319, 498),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_0",
"style": "original",
"weapon_axis": PackedVector2Array(319, 498, 479.38116, 579.71826),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(239, 456)],
"hero": "warden",
"layers": [{
"offset": Vector2i(94, 150),
"path": "res://experimental/weapon_swapping/warden/assets/execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_1-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(214, 434),
"path": "res://experimental/weapon_swapping/warden/assets/execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(239, 456),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_1",
"style": "original",
"weapon_axis": PackedVector2Array(239, 456, 391.64865, 551.3855),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(305, 273)],
"hero": "warden",
"layers": [{
"offset": Vector2i(85, 156),
"path": "res://experimental/weapon_swapping/warden/assets/execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_2-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(280, 251),
"path": "res://experimental/weapon_swapping/warden/assets/execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(305, 273),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_2",
"style": "original",
"weapon_axis": PackedVector2Array(305, 273, 438.76605, 152.55649),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(494, 517)],
"hero": "warden",
"layers": [{
"offset": Vector2i(158, 160),
"path": "res://experimental/weapon_swapping/warden/assets/execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_3-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(469, 495),
"path": "res://experimental/weapon_swapping/warden/assets/execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(494, 517),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_3",
"style": "original",
"weapon_axis": PackedVector2Array(494, 517, 641.4474, 620.2438),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(302, 476)],
"hero": "warden",
"layers": [{
"offset": Vector2i(85, 155),
"path": "res://experimental/weapon_swapping/warden/assets/execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_4-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(277, 454),
"path": "res://experimental/weapon_swapping/warden/assets/execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(302, 476),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_4",
"style": "original",
"weapon_axis": PackedVector2Array(302, 476, 457.88458, 566),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution-contact-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(705, 330),
"path": "res://experimental/weapon_swapping/warden/assets/execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden"
},
"pose": "execution_contact",
"style": "original",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 456)],
"hero": "warden",
"layers": [{
"offset": Vector2i(109, 251),
"path": "res://experimental/weapon_swapping/warden/assets/guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/guard-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(215, 434),
"path": "res://experimental/weapon_swapping/warden/assets/guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(240, 456),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "guard",
"style": "original",
"weapon_axis": PackedVector2Array(240, 456, 430.67865, 584.6144),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(120, 502)],
"hero": "warden",
"layers": [{
"offset": Vector2i(44, 252),
"path": "res://experimental/weapon_swapping/warden/assets/hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/hurt-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(95, 480),
"path": "res://experimental/weapon_swapping/warden/assets/hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(120, 502),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "hurt",
"style": "original",
"weapon_axis": PackedVector2Array(120, 502, 319.18585, 617),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(263, 435)],
"hero": "warden",
"layers": [{
"offset": Vector2i(129, 171),
"path": "res://experimental/weapon_swapping/warden/assets/idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/idle-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(238, 413),
"path": "res://experimental/weapon_swapping/warden/assets/idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(263, 435),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "idle",
"style": "original",
"weapon_axis": PackedVector2Array(263, 435, 453.67865, 563.6144),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 268),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(263, 485),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(282, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "portrait",
"style": "original",
"weapon_axis": PackedVector2Array(282, 505, 437.88458, 595),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 268),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(263, 485),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(282, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_0",
"style": "original",
"weapon_axis": PackedVector2Array(282, 505, 437.88458, 595),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(274, 512)],
"hero": "warden",
"layers": [{
"offset": Vector2i(122, 266),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_1-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(255, 492),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(274, 512),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_1",
"style": "original",
"weapon_axis": PackedVector2Array(274, 512, 429.88458, 602),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(278, 499)],
"hero": "warden",
"layers": [{
"offset": Vector2i(130, 305),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_2-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 479),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(278, 499),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_2",
"style": "original",
"weapon_axis": PackedVector2Array(278, 499, 433.88458, 589),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 498)],
"hero": "warden",
"layers": [{
"offset": Vector2i(125, 305),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_3-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 478),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 498),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_3",
"style": "original",
"weapon_axis": PackedVector2Array(276, 498, 431.88458, 588),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|walk_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(294, 508)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 303),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_4-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(275, 488),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_4-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(294, 508),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_4",
"style": "original",
"weapon_axis": PackedVector2Array(294, 508, 449.88458, 598),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|walk_5": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(280, 529)],
"hero": "warden",
"layers": [{
"offset": Vector2i(117, 301),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_5-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_5-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(261, 509),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_5-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(280, 529),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_5",
"style": "original",
"weapon_axis": PackedVector2Array(280, 529, 435.88458, 619),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|walk_6": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(284, 503)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 310),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_6-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_6-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(265, 483),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_6-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(284, 503),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_6",
"style": "original",
"weapon_axis": PackedVector2Array(284, 503, 439.88458, 593),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|walk_7": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 500)],
"hero": "warden",
"layers": [{
"offset": Vector2i(136, 306),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_7-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_7-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 480),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_7-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(279, 500),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_7",
"style": "original",
"weapon_axis": PackedVector2Array(279, 500, 434.88458, 590),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|walk_8": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(280, 528)],
"hero": "warden",
"layers": [{
"offset": Vector2i(127, 310),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_8-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_8-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(261, 508),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_8-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(280, 528),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_8",
"style": "original",
"weapon_axis": PackedVector2Array(280, 528, 435.88458, 618),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|walk_9": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(289, 519)],
"hero": "warden",
"layers": [{
"offset": Vector2i(121, 307),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_9-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_9-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(270, 499),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_9-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(289, 519),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_9",
"style": "original",
"weapon_axis": PackedVector2Array(289, 519, 444.88458, 609),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_frostblade|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(269, 209)],
"hero": "warden",
"layers": [{
"offset": Vector2i(166, 106),
"path": "res://experimental/weapon_swapping/warden/assets/windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/windup-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(244, 187),
"path": "res://experimental/weapon_swapping/warden/assets/windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(269, 209),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "windup",
"style": "original",
"weapon_axis": PackedVector2Array(269, 209, 413.74368, 30.256424),
"weapon_profile": "warden_frostblade"
},
"warden|original|warden_legend|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(484, 444)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 237),
"path": "res://experimental/weapon_swapping/warden/assets/attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/attack-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(459, 422),
"path": "res://experimental/weapon_swapping/warden/assets/attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(484, 444),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "attack",
"style": "original",
"weapon_axis": PackedVector2Array(484, 444, 683.18585, 559),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 268),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(263, 485),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(282, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "camp",
"style": "original",
"weapon_axis": PackedVector2Array(282, 505, 437.88458, 595),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 456)],
"hero": "warden",
"layers": [{
"offset": Vector2i(109, 251),
"path": "res://experimental/weapon_swapping/warden/assets/guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/guard-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(215, 434),
"path": "res://experimental/weapon_swapping/warden/assets/guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(240, 456),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "cast",
"style": "original",
"weapon_axis": PackedVector2Array(240, 456, 430.67865, 584.6144),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(433, 580)],
"hero": "warden",
"layers": [{
"offset": Vector2i(60, 445),
"path": "res://experimental/weapon_swapping/warden/assets/death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/death-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(408, 558),
"path": "res://experimental/weapon_swapping/warden/assets/death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(433, 580),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "death",
"style": "original",
"weapon_axis": PackedVector2Array(433, 580, 655.16296, 639.5284),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(319, 498)],
"hero": "warden",
"layers": [{
"offset": Vector2i(94, 150),
"path": "res://experimental/weapon_swapping/warden/assets/execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_0-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(294, 476),
"path": "res://experimental/weapon_swapping/warden/assets/execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(319, 498),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_0",
"style": "original",
"weapon_axis": PackedVector2Array(319, 498, 479.38116, 579.71826),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(239, 456)],
"hero": "warden",
"layers": [{
"offset": Vector2i(94, 150),
"path": "res://experimental/weapon_swapping/warden/assets/execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_1-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(214, 434),
"path": "res://experimental/weapon_swapping/warden/assets/execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(239, 456),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_1",
"style": "original",
"weapon_axis": PackedVector2Array(239, 456, 391.64865, 551.3855),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(305, 273)],
"hero": "warden",
"layers": [{
"offset": Vector2i(85, 156),
"path": "res://experimental/weapon_swapping/warden/assets/execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_2-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(280, 251),
"path": "res://experimental/weapon_swapping/warden/assets/execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(305, 273),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_2",
"style": "original",
"weapon_axis": PackedVector2Array(305, 273, 438.76605, 152.55649),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(494, 517)],
"hero": "warden",
"layers": [{
"offset": Vector2i(158, 160),
"path": "res://experimental/weapon_swapping/warden/assets/execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_3-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(469, 495),
"path": "res://experimental/weapon_swapping/warden/assets/execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(494, 517),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_3",
"style": "original",
"weapon_axis": PackedVector2Array(494, 517, 641.4474, 620.2438),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(302, 476)],
"hero": "warden",
"layers": [{
"offset": Vector2i(85, 155),
"path": "res://experimental/weapon_swapping/warden/assets/execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_4-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(277, 454),
"path": "res://experimental/weapon_swapping/warden/assets/execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(302, 476),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_4",
"style": "original",
"weapon_axis": PackedVector2Array(302, 476, 457.88458, 566),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution-contact-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(705, 330),
"path": "res://experimental/weapon_swapping/warden/assets/execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden"
},
"pose": "execution_contact",
"style": "original",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 456)],
"hero": "warden",
"layers": [{
"offset": Vector2i(109, 251),
"path": "res://experimental/weapon_swapping/warden/assets/guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/guard-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(215, 434),
"path": "res://experimental/weapon_swapping/warden/assets/guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(240, 456),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "guard",
"style": "original",
"weapon_axis": PackedVector2Array(240, 456, 430.67865, 584.6144),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(120, 502)],
"hero": "warden",
"layers": [{
"offset": Vector2i(44, 252),
"path": "res://experimental/weapon_swapping/warden/assets/hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/hurt-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(95, 480),
"path": "res://experimental/weapon_swapping/warden/assets/hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(120, 502),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "hurt",
"style": "original",
"weapon_axis": PackedVector2Array(120, 502, 319.18585, 617),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(263, 435)],
"hero": "warden",
"layers": [{
"offset": Vector2i(129, 171),
"path": "res://experimental/weapon_swapping/warden/assets/idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/idle-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(238, 413),
"path": "res://experimental/weapon_swapping/warden/assets/idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(263, 435),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "idle",
"style": "original",
"weapon_axis": PackedVector2Array(263, 435, 453.67865, 563.6144),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 268),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(263, 485),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(282, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "portrait",
"style": "original",
"weapon_axis": PackedVector2Array(282, 505, 437.88458, 595),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 268),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(263, 485),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(282, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_0",
"style": "original",
"weapon_axis": PackedVector2Array(282, 505, 437.88458, 595),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(274, 512)],
"hero": "warden",
"layers": [{
"offset": Vector2i(122, 266),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_1-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(255, 492),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(274, 512),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_1",
"style": "original",
"weapon_axis": PackedVector2Array(274, 512, 429.88458, 602),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(278, 499)],
"hero": "warden",
"layers": [{
"offset": Vector2i(130, 305),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_2-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 479),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(278, 499),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_2",
"style": "original",
"weapon_axis": PackedVector2Array(278, 499, 433.88458, 589),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 498)],
"hero": "warden",
"layers": [{
"offset": Vector2i(125, 305),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_3-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 478),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 498),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_3",
"style": "original",
"weapon_axis": PackedVector2Array(276, 498, 431.88458, 588),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|walk_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(294, 508)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 303),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_4-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(275, 488),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_4-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(294, 508),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_4",
"style": "original",
"weapon_axis": PackedVector2Array(294, 508, 449.88458, 598),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|walk_5": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(280, 529)],
"hero": "warden",
"layers": [{
"offset": Vector2i(117, 301),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_5-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_5-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(261, 509),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_5-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(280, 529),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_5",
"style": "original",
"weapon_axis": PackedVector2Array(280, 529, 435.88458, 619),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|walk_6": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(284, 503)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 310),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_6-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_6-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(265, 483),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_6-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(284, 503),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_6",
"style": "original",
"weapon_axis": PackedVector2Array(284, 503, 439.88458, 593),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|walk_7": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 500)],
"hero": "warden",
"layers": [{
"offset": Vector2i(136, 306),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_7-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_7-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 480),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_7-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(279, 500),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_7",
"style": "original",
"weapon_axis": PackedVector2Array(279, 500, 434.88458, 590),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|walk_8": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(280, 528)],
"hero": "warden",
"layers": [{
"offset": Vector2i(127, 310),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_8-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_8-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(261, 508),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_8-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(280, 528),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_8",
"style": "original",
"weapon_axis": PackedVector2Array(280, 528, 435.88458, 618),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|walk_9": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(289, 519)],
"hero": "warden",
"layers": [{
"offset": Vector2i(121, 307),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_9-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_9-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(270, 499),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_9-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(289, 519),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_9",
"style": "original",
"weapon_axis": PackedVector2Array(289, 519, 444.88458, 609),
"weapon_profile": "warden_legend"
},
"warden|original|warden_legend|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(269, 209)],
"hero": "warden",
"layers": [{
"offset": Vector2i(166, 106),
"path": "res://experimental/weapon_swapping/warden/assets/windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/windup-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(244, 187),
"path": "res://experimental/weapon_swapping/warden/assets/windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(269, 209),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "windup",
"style": "original",
"weapon_axis": PackedVector2Array(269, 209, 413.74368, 30.256424),
"weapon_profile": "warden_legend"
},
"warden|original|warden_sword|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(484, 444)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 237),
"path": "res://experimental/weapon_swapping/warden/assets/attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/attack-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(459, 422),
"path": "res://experimental/weapon_swapping/warden/assets/attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(484, 444),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "attack",
"style": "original",
"weapon_axis": PackedVector2Array(484, 444, 683.18585, 559),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 268),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(263, 485),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(282, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "camp",
"style": "original",
"weapon_axis": PackedVector2Array(282, 505, 437.88458, 595),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 456)],
"hero": "warden",
"layers": [{
"offset": Vector2i(109, 251),
"path": "res://experimental/weapon_swapping/warden/assets/guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/guard-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(215, 434),
"path": "res://experimental/weapon_swapping/warden/assets/guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(240, 456),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "cast",
"style": "original",
"weapon_axis": PackedVector2Array(240, 456, 430.67865, 584.6144),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(433, 580)],
"hero": "warden",
"layers": [{
"offset": Vector2i(60, 445),
"path": "res://experimental/weapon_swapping/warden/assets/death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/death-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(408, 558),
"path": "res://experimental/weapon_swapping/warden/assets/death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(433, 580),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "death",
"style": "original",
"weapon_axis": PackedVector2Array(433, 580, 655.16296, 639.5284),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(319, 498)],
"hero": "warden",
"layers": [{
"offset": Vector2i(94, 150),
"path": "res://experimental/weapon_swapping/warden/assets/execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_0-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(294, 476),
"path": "res://experimental/weapon_swapping/warden/assets/execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(319, 498),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_0",
"style": "original",
"weapon_axis": PackedVector2Array(319, 498, 479.38116, 579.71826),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(239, 456)],
"hero": "warden",
"layers": [{
"offset": Vector2i(94, 150),
"path": "res://experimental/weapon_swapping/warden/assets/execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_1-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(214, 434),
"path": "res://experimental/weapon_swapping/warden/assets/execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(239, 456),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_1",
"style": "original",
"weapon_axis": PackedVector2Array(239, 456, 391.64865, 551.3855),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(305, 273)],
"hero": "warden",
"layers": [{
"offset": Vector2i(85, 156),
"path": "res://experimental/weapon_swapping/warden/assets/execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_2-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(280, 251),
"path": "res://experimental/weapon_swapping/warden/assets/execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(305, 273),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_2",
"style": "original",
"weapon_axis": PackedVector2Array(305, 273, 438.76605, 152.55649),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(494, 517)],
"hero": "warden",
"layers": [{
"offset": Vector2i(158, 160),
"path": "res://experimental/weapon_swapping/warden/assets/execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_3-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(469, 495),
"path": "res://experimental/weapon_swapping/warden/assets/execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(494, 517),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_3",
"style": "original",
"weapon_axis": PackedVector2Array(494, 517, 641.4474, 620.2438),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(302, 476)],
"hero": "warden",
"layers": [{
"offset": Vector2i(85, 155),
"path": "res://experimental/weapon_swapping/warden/assets/execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution_4-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(277, 454),
"path": "res://experimental/weapon_swapping/warden/assets/execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(302, 476),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden"
},
"pose": "execution_4",
"style": "original",
"weapon_axis": PackedVector2Array(302, 476, 457.88458, 566),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/execution-contact-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(705, 330),
"path": "res://experimental/weapon_swapping/warden/assets/execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden"
},
"pose": "execution_contact",
"style": "original",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 456)],
"hero": "warden",
"layers": [{
"offset": Vector2i(109, 251),
"path": "res://experimental/weapon_swapping/warden/assets/guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/guard-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(215, 434),
"path": "res://experimental/weapon_swapping/warden/assets/guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(240, 456),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "guard",
"style": "original",
"weapon_axis": PackedVector2Array(240, 456, 430.67865, 584.6144),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(120, 502)],
"hero": "warden",
"layers": [{
"offset": Vector2i(44, 252),
"path": "res://experimental/weapon_swapping/warden/assets/hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/hurt-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(95, 480),
"path": "res://experimental/weapon_swapping/warden/assets/hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(120, 502),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "hurt",
"style": "original",
"weapon_axis": PackedVector2Array(120, 502, 319.18585, 617),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(263, 435)],
"hero": "warden",
"layers": [{
"offset": Vector2i(129, 171),
"path": "res://experimental/weapon_swapping/warden/assets/idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/idle-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(238, 413),
"path": "res://experimental/weapon_swapping/warden/assets/idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(263, 435),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "idle",
"style": "original",
"weapon_axis": PackedVector2Array(263, 435, 453.67865, 563.6144),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 268),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(263, 485),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(282, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "portrait",
"style": "original",
"weapon_axis": PackedVector2Array(282, 505, 437.88458, 595),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(282, 505)],
"hero": "warden",
"layers": [{
"offset": Vector2i(133, 268),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(263, 485),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(282, 505),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_0",
"style": "original",
"weapon_axis": PackedVector2Array(282, 505, 437.88458, 595),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(274, 512)],
"hero": "warden",
"layers": [{
"offset": Vector2i(122, 266),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_1-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(255, 492),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(274, 512),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_1",
"style": "original",
"weapon_axis": PackedVector2Array(274, 512, 429.88458, 602),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(278, 499)],
"hero": "warden",
"layers": [{
"offset": Vector2i(130, 305),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_2-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 479),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(278, 499),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_2",
"style": "original",
"weapon_axis": PackedVector2Array(278, 499, 433.88458, 589),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 498)],
"hero": "warden",
"layers": [{
"offset": Vector2i(125, 305),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_3-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 478),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(276, 498),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_3",
"style": "original",
"weapon_axis": PackedVector2Array(276, 498, 431.88458, 588),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|walk_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(294, 508)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 303),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_4-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(275, 488),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_4-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(294, 508),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_4",
"style": "original",
"weapon_axis": PackedVector2Array(294, 508, 449.88458, 598),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|walk_5": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(280, 529)],
"hero": "warden",
"layers": [{
"offset": Vector2i(117, 301),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_5-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_5-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(261, 509),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_5-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(280, 529),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_5",
"style": "original",
"weapon_axis": PackedVector2Array(280, 529, 435.88458, 619),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|walk_6": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(284, 503)],
"hero": "warden",
"layers": [{
"offset": Vector2i(131, 310),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_6-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_6-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(265, 483),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_6-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(284, 503),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_6",
"style": "original",
"weapon_axis": PackedVector2Array(284, 503, 439.88458, 593),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|walk_7": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 500)],
"hero": "warden",
"layers": [{
"offset": Vector2i(136, 306),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_7-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_7-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(260, 480),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_7-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(279, 500),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_7",
"style": "original",
"weapon_axis": PackedVector2Array(279, 500, 434.88458, 590),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|walk_8": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(280, 528)],
"hero": "warden",
"layers": [{
"offset": Vector2i(127, 310),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_8-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_8-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(261, 508),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_8-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(280, 528),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_8",
"style": "original",
"weapon_axis": PackedVector2Array(280, 528, 435.88458, 618),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|walk_9": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(289, 519)],
"hero": "warden",
"layers": [{
"offset": Vector2i(121, 307),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_9-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_9-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(270, 499),
"path": "res://experimental/weapon_swapping/warden/assets/original-walk_9-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 340.0,
"emitter_point": Vector2(289, 519),
"hit_point": Vector2(350, 439.2),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "original",
"weapon_visible": true
},
"pose": "walk_9",
"style": "original",
"weapon_axis": PackedVector2Array(289, 519, 444.88458, 609),
"weapon_profile": "warden_sword"
},
"warden|original|warden_sword|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(269, 209)],
"hero": "warden",
"layers": [{
"offset": Vector2i(166, 106),
"path": "res://experimental/weapon_swapping/warden/assets/windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/windup-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(244, 187),
"path": "res://experimental/weapon_swapping/warden/assets/windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "warden_complete",
"body_height_pixels": 479.0,
"emitter_point": Vector2(269, 209),
"experimental_weapon": true,
"hit_point": Vector2(350, 353),
"idle_pixel_height": 700.0,
"party_build": "warden",
"pose_id": "warden",
"warden_outfit": "original"
},
"pose": "windup",
"style": "original",
"weapon_axis": PackedVector2Array(269, 209, 413.74368, 30.256424),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_epic|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(380, 434)],
"hero": "warden",
"layers": [{
"offset": Vector2i(174, 343),
"path": "res://experimental/weapon_swapping/warden/assets/relic-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-attack-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(361, 414),
"path": "res://experimental/weapon_swapping/warden/assets/relic-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(380, 434),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "attack",
"style": "relic",
"weapon_axis": PackedVector2Array(380, 434, 546.89307, 501.4292),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(380, 469)],
"hero": "warden",
"layers": [{
"offset": Vector2i(97, 379),
"path": "res://experimental/weapon_swapping/warden/assets/relic-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-camp-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(361, 449),
"path": "res://experimental/weapon_swapping/warden/assets/relic-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(380, 469),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "camp",
"style": "relic",
"weapon_axis": PackedVector2Array(380, 469, 408.1582, 646.78394),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(187, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-cast-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(221, 345),
"path": "res://experimental/weapon_swapping/warden/assets/relic-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(240, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "cast",
"style": "relic",
"weapon_axis": PackedVector2Array(240, 365, 414.65323, 408.54596),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(278, 517)],
"hero": "warden",
"layers": [{
"offset": Vector2i(172, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-death-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 497),
"path": "res://experimental/weapon_swapping/warden/assets/relic-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(278, 517),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "death",
"style": "relic",
"weapon_axis": PackedVector2Array(278, 517, 444.8931, 584.4292),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 479)],
"hero": "warden",
"layers": [{
"offset": Vector2i(84, 144),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_0-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 461),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(279, 479),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_0",
"style": "relic",
"weapon_axis": PackedVector2Array(279, 479, 439.38116, 560.71826),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(229, 436)],
"hero": "warden",
"layers": [{
"offset": Vector2i(96, 142),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_1-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(209, 418),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(229, 436),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_1",
"style": "relic",
"weapon_axis": PackedVector2Array(229, 436, 381.64865, 531.3855),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(305, 241)],
"hero": "warden",
"layers": [{
"offset": Vector2i(69, 142),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_2-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(285, 223),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(305, 241),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_2",
"style": "relic",
"weapon_axis": PackedVector2Array(305, 241, 438.76605, 120.55649),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(466, 501)],
"hero": "warden",
"layers": [{
"offset": Vector2i(121, 204),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_3-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(446, 483),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(466, 501),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_3",
"style": "relic",
"weapon_axis": PackedVector2Array(466, 501, 613.4474, 604.2438),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(265, 472)],
"hero": "warden",
"layers": [{
"offset": Vector2i(55, 201),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_4-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(245, 454),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(265, 472),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_4",
"style": "relic",
"weapon_axis": PackedVector2Array(265, 472, 420.88458, 562),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution-contact-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(720, 340),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_contact",
"style": "relic",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(177, 312),
"path": "res://experimental/weapon_swapping/warden/assets/relic-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-guard-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(276, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "guard",
"style": "relic",
"weapon_axis": PackedVector2Array(276, 492, 442.8931, 559.4292),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(278, 517)],
"hero": "warden",
"layers": [{
"offset": Vector2i(172, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-hurt-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 497),
"path": "res://experimental/weapon_swapping/warden/assets/relic-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(278, 517),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "hurt",
"style": "relic",
"weapon_axis": PackedVector2Array(278, 517, 444.8931, 584.4292),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(177, 312),
"path": "res://experimental/weapon_swapping/warden/assets/relic-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-idle-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(276, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "idle",
"style": "relic",
"weapon_axis": PackedVector2Array(276, 492, 442.8931, 559.4292),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(-223, -348)],
"hero": "warden",
"layers": [{
"offset": Vector2i(176, 340),
"path": "res://experimental/weapon_swapping/warden/assets/relic-portrait-body.png",
"role": "full_frame"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(-223, -348),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"portrait_view": true,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": false
},
"pose": "portrait",
"style": "relic",
"weapon_axis": PackedVector2Array(-223, -348, -56.106903, -280.5708),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(292, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(177, 331),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_0-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(273, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(292, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_0",
"style": "relic",
"weapon_axis": PackedVector2Array(292, 492, 458.8931, 559.4292),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(304, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(153, 335),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_1-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(285, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(304, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_1",
"style": "relic",
"weapon_axis": PackedVector2Array(304, 492, 470.8931, 559.4292),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(169, 335),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_2-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 473),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(285, 493),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_2",
"style": "relic",
"weapon_axis": PackedVector2Array(285, 493, 451.8931, 560.4292),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(290, 499)],
"hero": "warden",
"layers": [{
"offset": Vector2i(183, 336),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_3-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(271, 479),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(290, 499),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_3",
"style": "relic",
"weapon_axis": PackedVector2Array(290, 499, 456.8931, 566.4292),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_epic|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(187, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-windup-warden_epic.png",
"role": "front_weapon"
}, {
"offset": Vector2i(221, 345),
"path": "res://experimental/weapon_swapping/warden/assets/relic-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(240, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "windup",
"style": "relic",
"weapon_axis": PackedVector2Array(240, 365, 414.65323, 408.54596),
"weapon_profile": "warden_epic"
},
"warden|relic|warden_frostblade|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(380, 434)],
"hero": "warden",
"layers": [{
"offset": Vector2i(174, 343),
"path": "res://experimental/weapon_swapping/warden/assets/relic-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-attack-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(361, 414),
"path": "res://experimental/weapon_swapping/warden/assets/relic-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(380, 434),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "attack",
"style": "relic",
"weapon_axis": PackedVector2Array(380, 434, 546.89307, 501.4292),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(380, 469)],
"hero": "warden",
"layers": [{
"offset": Vector2i(97, 379),
"path": "res://experimental/weapon_swapping/warden/assets/relic-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-camp-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(361, 449),
"path": "res://experimental/weapon_swapping/warden/assets/relic-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(380, 469),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "camp",
"style": "relic",
"weapon_axis": PackedVector2Array(380, 469, 408.1582, 646.78394),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(187, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-cast-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(221, 345),
"path": "res://experimental/weapon_swapping/warden/assets/relic-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(240, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "cast",
"style": "relic",
"weapon_axis": PackedVector2Array(240, 365, 414.65323, 408.54596),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(278, 517)],
"hero": "warden",
"layers": [{
"offset": Vector2i(172, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-death-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 497),
"path": "res://experimental/weapon_swapping/warden/assets/relic-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(278, 517),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "death",
"style": "relic",
"weapon_axis": PackedVector2Array(278, 517, 444.8931, 584.4292),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 479)],
"hero": "warden",
"layers": [{
"offset": Vector2i(84, 144),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_0-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 461),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(279, 479),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_0",
"style": "relic",
"weapon_axis": PackedVector2Array(279, 479, 439.38116, 560.71826),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(229, 436)],
"hero": "warden",
"layers": [{
"offset": Vector2i(96, 142),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_1-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(209, 418),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(229, 436),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_1",
"style": "relic",
"weapon_axis": PackedVector2Array(229, 436, 381.64865, 531.3855),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(305, 241)],
"hero": "warden",
"layers": [{
"offset": Vector2i(69, 142),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_2-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(285, 223),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(305, 241),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_2",
"style": "relic",
"weapon_axis": PackedVector2Array(305, 241, 438.76605, 120.55649),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(466, 501)],
"hero": "warden",
"layers": [{
"offset": Vector2i(121, 204),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_3-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(446, 483),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(466, 501),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_3",
"style": "relic",
"weapon_axis": PackedVector2Array(466, 501, 613.4474, 604.2438),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(265, 472)],
"hero": "warden",
"layers": [{
"offset": Vector2i(55, 201),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_4-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(245, 454),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(265, 472),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_4",
"style": "relic",
"weapon_axis": PackedVector2Array(265, 472, 420.88458, 562),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution-contact-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(720, 340),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_contact",
"style": "relic",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(177, 312),
"path": "res://experimental/weapon_swapping/warden/assets/relic-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-guard-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(276, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "guard",
"style": "relic",
"weapon_axis": PackedVector2Array(276, 492, 442.8931, 559.4292),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(278, 517)],
"hero": "warden",
"layers": [{
"offset": Vector2i(172, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-hurt-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 497),
"path": "res://experimental/weapon_swapping/warden/assets/relic-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(278, 517),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "hurt",
"style": "relic",
"weapon_axis": PackedVector2Array(278, 517, 444.8931, 584.4292),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(177, 312),
"path": "res://experimental/weapon_swapping/warden/assets/relic-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-idle-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(276, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "idle",
"style": "relic",
"weapon_axis": PackedVector2Array(276, 492, 442.8931, 559.4292),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(-223, -348)],
"hero": "warden",
"layers": [{
"offset": Vector2i(176, 340),
"path": "res://experimental/weapon_swapping/warden/assets/relic-portrait-body.png",
"role": "full_frame"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(-223, -348),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"portrait_view": true,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": false
},
"pose": "portrait",
"style": "relic",
"weapon_axis": PackedVector2Array(-223, -348, -56.106903, -280.5708),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(292, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(177, 331),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_0-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(273, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(292, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_0",
"style": "relic",
"weapon_axis": PackedVector2Array(292, 492, 458.8931, 559.4292),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(304, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(153, 335),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_1-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(285, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(304, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_1",
"style": "relic",
"weapon_axis": PackedVector2Array(304, 492, 470.8931, 559.4292),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(169, 335),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_2-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 473),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(285, 493),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_2",
"style": "relic",
"weapon_axis": PackedVector2Array(285, 493, 451.8931, 560.4292),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(290, 499)],
"hero": "warden",
"layers": [{
"offset": Vector2i(183, 336),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_3-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(271, 479),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(290, 499),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_3",
"style": "relic",
"weapon_axis": PackedVector2Array(290, 499, 456.8931, 566.4292),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_frostblade|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(187, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-windup-warden_frostblade.png",
"role": "front_weapon"
}, {
"offset": Vector2i(221, 345),
"path": "res://experimental/weapon_swapping/warden/assets/relic-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(240, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "windup",
"style": "relic",
"weapon_axis": PackedVector2Array(240, 365, 414.65323, 408.54596),
"weapon_profile": "warden_frostblade"
},
"warden|relic|warden_legend|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(380, 434)],
"hero": "warden",
"layers": [{
"offset": Vector2i(174, 343),
"path": "res://experimental/weapon_swapping/warden/assets/relic-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-attack-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(361, 414),
"path": "res://experimental/weapon_swapping/warden/assets/relic-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(380, 434),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "attack",
"style": "relic",
"weapon_axis": PackedVector2Array(380, 434, 546.89307, 501.4292),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(380, 469)],
"hero": "warden",
"layers": [{
"offset": Vector2i(97, 379),
"path": "res://experimental/weapon_swapping/warden/assets/relic-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-camp-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(361, 449),
"path": "res://experimental/weapon_swapping/warden/assets/relic-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(380, 469),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "camp",
"style": "relic",
"weapon_axis": PackedVector2Array(380, 469, 408.1582, 646.78394),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(187, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-cast-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(221, 345),
"path": "res://experimental/weapon_swapping/warden/assets/relic-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(240, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "cast",
"style": "relic",
"weapon_axis": PackedVector2Array(240, 365, 414.65323, 408.54596),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(278, 517)],
"hero": "warden",
"layers": [{
"offset": Vector2i(172, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-death-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 497),
"path": "res://experimental/weapon_swapping/warden/assets/relic-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(278, 517),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "death",
"style": "relic",
"weapon_axis": PackedVector2Array(278, 517, 444.8931, 584.4292),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 479)],
"hero": "warden",
"layers": [{
"offset": Vector2i(84, 144),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_0-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 461),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(279, 479),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_0",
"style": "relic",
"weapon_axis": PackedVector2Array(279, 479, 439.38116, 560.71826),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(229, 436)],
"hero": "warden",
"layers": [{
"offset": Vector2i(96, 142),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_1-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(209, 418),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(229, 436),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_1",
"style": "relic",
"weapon_axis": PackedVector2Array(229, 436, 381.64865, 531.3855),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(305, 241)],
"hero": "warden",
"layers": [{
"offset": Vector2i(69, 142),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_2-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(285, 223),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(305, 241),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_2",
"style": "relic",
"weapon_axis": PackedVector2Array(305, 241, 438.76605, 120.55649),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(466, 501)],
"hero": "warden",
"layers": [{
"offset": Vector2i(121, 204),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_3-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(446, 483),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(466, 501),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_3",
"style": "relic",
"weapon_axis": PackedVector2Array(466, 501, 613.4474, 604.2438),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(265, 472)],
"hero": "warden",
"layers": [{
"offset": Vector2i(55, 201),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_4-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(245, 454),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(265, 472),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_4",
"style": "relic",
"weapon_axis": PackedVector2Array(265, 472, 420.88458, 562),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution-contact-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(720, 340),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_contact",
"style": "relic",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(177, 312),
"path": "res://experimental/weapon_swapping/warden/assets/relic-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-guard-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(276, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "guard",
"style": "relic",
"weapon_axis": PackedVector2Array(276, 492, 442.8931, 559.4292),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(278, 517)],
"hero": "warden",
"layers": [{
"offset": Vector2i(172, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-hurt-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 497),
"path": "res://experimental/weapon_swapping/warden/assets/relic-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(278, 517),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "hurt",
"style": "relic",
"weapon_axis": PackedVector2Array(278, 517, 444.8931, 584.4292),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(177, 312),
"path": "res://experimental/weapon_swapping/warden/assets/relic-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-idle-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(276, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "idle",
"style": "relic",
"weapon_axis": PackedVector2Array(276, 492, 442.8931, 559.4292),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(-223, -348)],
"hero": "warden",
"layers": [{
"offset": Vector2i(176, 340),
"path": "res://experimental/weapon_swapping/warden/assets/relic-portrait-body.png",
"role": "full_frame"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(-223, -348),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"portrait_view": true,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": false
},
"pose": "portrait",
"style": "relic",
"weapon_axis": PackedVector2Array(-223, -348, -56.106903, -280.5708),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(292, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(177, 331),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_0-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(273, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(292, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_0",
"style": "relic",
"weapon_axis": PackedVector2Array(292, 492, 458.8931, 559.4292),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(304, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(153, 335),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_1-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(285, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(304, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_1",
"style": "relic",
"weapon_axis": PackedVector2Array(304, 492, 470.8931, 559.4292),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(169, 335),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_2-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 473),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(285, 493),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_2",
"style": "relic",
"weapon_axis": PackedVector2Array(285, 493, 451.8931, 560.4292),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(290, 499)],
"hero": "warden",
"layers": [{
"offset": Vector2i(183, 336),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_3-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(271, 479),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(290, 499),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_3",
"style": "relic",
"weapon_axis": PackedVector2Array(290, 499, 456.8931, 566.4292),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_legend|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(187, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-windup-warden_legend.png",
"role": "front_weapon"
}, {
"offset": Vector2i(221, 345),
"path": "res://experimental/weapon_swapping/warden/assets/relic-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(240, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "windup",
"style": "relic",
"weapon_axis": PackedVector2Array(240, 365, 414.65323, 408.54596),
"weapon_profile": "warden_legend"
},
"warden|relic|warden_sword|attack": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(380, 434)],
"hero": "warden",
"layers": [{
"offset": Vector2i(174, 343),
"path": "res://experimental/weapon_swapping/warden/assets/relic-attack-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-attack-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(361, 414),
"path": "res://experimental/weapon_swapping/warden/assets/relic-attack-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(380, 434),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "attack",
"style": "relic",
"weapon_axis": PackedVector2Array(380, 434, 546.89307, 501.4292),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|camp": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(380, 469)],
"hero": "warden",
"layers": [{
"offset": Vector2i(97, 379),
"path": "res://experimental/weapon_swapping/warden/assets/relic-camp-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-camp-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(361, 449),
"path": "res://experimental/weapon_swapping/warden/assets/relic-camp-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(380, 469),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "camp",
"style": "relic",
"weapon_axis": PackedVector2Array(380, 469, 408.1582, 646.78394),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|cast": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(187, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-cast-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-cast-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(221, 345),
"path": "res://experimental/weapon_swapping/warden/assets/relic-cast-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(240, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "cast",
"style": "relic",
"weapon_axis": PackedVector2Array(240, 365, 414.65323, 408.54596),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|death": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(278, 517)],
"hero": "warden",
"layers": [{
"offset": Vector2i(172, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-death-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-death-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 497),
"path": "res://experimental/weapon_swapping/warden/assets/relic-death-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(278, 517),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "death",
"style": "relic",
"weapon_axis": PackedVector2Array(278, 517, 444.8931, 584.4292),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|execution_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(279, 479)],
"hero": "warden",
"layers": [{
"offset": Vector2i(84, 144),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_0-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 461),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_0-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(279, 479),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_0",
"style": "relic",
"weapon_axis": PackedVector2Array(279, 479, 439.38116, 560.71826),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|execution_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(229, 436)],
"hero": "warden",
"layers": [{
"offset": Vector2i(96, 142),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_1-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(209, 418),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_1-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(229, 436),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_1",
"style": "relic",
"weapon_axis": PackedVector2Array(229, 436, 381.64865, 531.3855),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|execution_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(305, 241)],
"hero": "warden",
"layers": [{
"offset": Vector2i(69, 142),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_2-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(285, 223),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_2-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(305, 241),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_2",
"style": "relic",
"weapon_axis": PackedVector2Array(305, 241, 438.76605, 120.55649),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|execution_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(466, 501)],
"hero": "warden",
"layers": [{
"offset": Vector2i(121, 204),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_3-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(446, 483),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_3-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(466, 501),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_3",
"style": "relic",
"weapon_axis": PackedVector2Array(466, 501, 613.4474, 604.2438),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|execution_4": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(265, 472)],
"hero": "warden",
"layers": [{
"offset": Vector2i(55, 201),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_4-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_4-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(245, 454),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution_4-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(265, 472),
"experimental_weapon": true,
"hit_point": Vector2(350, 360),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_4",
"style": "relic",
"weapon_axis": PackedVector2Array(265, 472, 420.88458, 562),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|execution_contact": {
"canvas_size": Vector2i(1536, 1024),
"foot": Vector2(492, 928),
"grips": [Vector2(750, 380)],
"hero": "warden",
"layers": [{
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution-contact-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution-contact-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(720, 340),
"path": "res://experimental/weapon_swapping/warden/assets/relic-execution-contact-hands.png",
"role": "hands"
}],
"metadata": {
"body_height_pixels": 479.0,
"emitter_point": Vector2(750, 380),
"experimental_weapon": true,
"hit_point": Vector2(492, 638),
"idle_pixel_height": 1024.0,
"pose_id": "warden",
"warden_outfit": "relic"
},
"pose": "execution_contact",
"style": "relic",
"weapon_axis": PackedVector2Array(750, 380, 1078, 444),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|guard": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(177, 312),
"path": "res://experimental/weapon_swapping/warden/assets/relic-guard-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-guard-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-guard-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(276, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "guard",
"style": "relic",
"weapon_axis": PackedVector2Array(276, 492, 442.8931, 559.4292),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|hurt": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(278, 517)],
"hero": "warden",
"layers": [{
"offset": Vector2i(172, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-hurt-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-hurt-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(259, 497),
"path": "res://experimental/weapon_swapping/warden/assets/relic-hurt-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(278, 517),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "hurt",
"style": "relic",
"weapon_axis": PackedVector2Array(278, 517, 444.8931, 584.4292),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|idle": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(276, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(177, 312),
"path": "res://experimental/weapon_swapping/warden/assets/relic-idle-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-idle-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(257, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-idle-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(276, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "idle",
"style": "relic",
"weapon_axis": PackedVector2Array(276, 492, 442.8931, 559.4292),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|portrait": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(-223, -348)],
"hero": "warden",
"layers": [{
"offset": Vector2i(176, 340),
"path": "res://experimental/weapon_swapping/warden/assets/relic-portrait-body.png",
"role": "full_frame"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(-223, -348),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"portrait_view": true,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": false
},
"pose": "portrait",
"style": "relic",
"weapon_axis": PackedVector2Array(-223, -348, -56.106903, -280.5708),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|walk_0": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(292, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(177, 331),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_0-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_0-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(273, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_0-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(292, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_0",
"style": "relic",
"weapon_axis": PackedVector2Array(292, 492, 458.8931, 559.4292),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|walk_1": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(304, 492)],
"hero": "warden",
"layers": [{
"offset": Vector2i(153, 335),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_1-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_1-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(285, 472),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_1-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(304, 492),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_1",
"style": "relic",
"weapon_axis": PackedVector2Array(304, 492, 470.8931, 559.4292),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|walk_2": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(285, 493)],
"hero": "warden",
"layers": [{
"offset": Vector2i(169, 335),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_2-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_2-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(266, 473),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_2-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(285, 493),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_2",
"style": "relic",
"weapon_axis": PackedVector2Array(285, 493, 451.8931, 560.4292),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|walk_3": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(290, 499)],
"hero": "warden",
"layers": [{
"offset": Vector2i(183, 336),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_3-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_3-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(271, 479),
"path": "res://experimental/weapon_swapping/warden/assets/relic-walk_3-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(290, 499),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"stride_anchor": 0.4557291666666667,
"stride_scale": 1.0,
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "walk_3",
"style": "relic",
"weapon_axis": PackedVector2Array(290, 499, 456.8931, 566.4292),
"weapon_profile": "warden_sword"
},
"warden|relic|warden_sword|windup": {
"canvas_size": Vector2i(768, 700),
"foot": Vector2(350, 650),
"grips": [Vector2(240, 365)],
"hero": "warden",
"layers": [{
"offset": Vector2i(187, 338),
"path": "res://experimental/weapon_swapping/warden/assets/relic-windup-body.png",
"role": "body"
}, {
"offset": Vector2i(0, 0),
"path": "res://experimental/weapon_swapping/warden/assets/relic-windup-warden_sword.png",
"role": "front_weapon"
}, {
"offset": Vector2i(221, 345),
"path": "res://experimental/weapon_swapping/warden/assets/relic-windup-hands.png",
"role": "hands"
}],
"metadata": {
"appearance_style": "weapon_layers",
"body_height_pixels": 325.0,
"emitter_point": Vector2(240, 365),
"hit_point": Vector2(350, 448.5),
"idle_pixel_height": 700.0,
"pose_id": "warden",
"warden_outfit": "relic",
"weapon_visible": true
},
"pose": "windup",
"style": "relic",
"weapon_axis": PackedVector2Array(240, 365, 414.65323, 408.54596),
"weapon_profile": "warden_sword"
}
}""")
