/obj/item/gun/rcp_launcher
	name = "debugging remote controlled projectile launcher"
	desc = "pew pew"
	icon_state = "syringegun"
	item_state = "syringegun"
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 3
	throw_range = 7
	force = 4
	materials = list(MAT_METAL=2000)
	clumsy_check = FALSE
	var/projectile_type = /obj/item/projectile/remotecontrolled
	var/give_control = TRUE

/obj/item/gun/rcp_launcher/afterattack(atom/target, mob/living/carbon/user, proximity, params)
	fire_projectile(user)
	return

/obj/item/gun/rcp_launcher/proc/fire_projectile(mob/user)
	var/obj/item/projectile/remotecontrolled/P = new projectile_type(get_turf(src))
	P.firer = user ? user : src
	P.fire(dir2angle(user.dir))

	return P