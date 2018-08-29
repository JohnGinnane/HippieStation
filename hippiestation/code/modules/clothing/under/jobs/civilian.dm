/obj/item/clothing/under/rank/clown/Initialize()
	. = ..()
	var/list/hit_sounds = list('hippiestation/sound/misc/hitsounds/cartoon_badoing.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_bird_whistle_down.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_boing.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_boing1.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_boing2.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_boing_wobble.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_clown_nose.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_doying.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_drum_roll_smash.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_heavy_badoing.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_heavy_bong.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_hit_on_head.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_short_whistle.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_slide_whistle_down_crash.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_slip_donk.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_spin_whistle.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_waboing.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_wet_boing.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_whack.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_whiggle_whistle_down.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_whistle_down.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_whistle_up.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_wiggle_metal1.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_wiggle_metal2.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_wiggle_whistle_up.ogg'=1,
							   'hippiestation/sound/misc/hitsounds/cartoon_woink.ogg'=1)
	AddComponent(/datum/component/squeak, hit_sounds, 50)

/obj/item/clothing/shoes/clown_shoes/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/effects/clownstep1.ogg'=1,'sound/effects/clownstep2.ogg'=1), 50, ,0)