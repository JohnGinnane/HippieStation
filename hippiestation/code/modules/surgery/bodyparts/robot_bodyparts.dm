/obj/item/bodypart/r_arm/robot/rocket
	name = "rocket powered right arm"
	desc = "A cyborg right arm that detaches at the wrist."
	actions_types = list(/datum/action/item_action/fire_fist)
	var/fired = FALSE
	var/projectile_type = /obj/item/projectile/remotecontrolled/fist

/obj/item/bodypart/r_arm/robot/rocket/item_action_slot_check(slot, mob/user)
	if (owner)
		return TRUE

/obj/item/bodypart/r_arm/robot/rocket/ui_action_click()
	fire_fist()

/datum/action/item_action/fire_fist
	name = "Fire Fist"
	button_icon_state = "borg_r_arm"

/obj/item/bodypart/r_arm/robot/rocket/verb/fire_fist()
	set name = "Fire Fist"
	set category = "Object"

	if (owner)
		fired = TRUE

		var/mob/living/carbon/human/H = owner
		drop_limb()
		var/obj/item/projectile/remotecontrolled/fist/P = new projectile_type(get_turf(src))
		loc = P
		P.rocket_arm = src
		P.firer = H ? H : src
		P.fire(dir2angle(H.dir))

/obj/item/bodypart/r_arm/robot/rocket/attach_limb(mob/living/carbon/C, special)
	. = ..()
	for(var/X in actions)
		var/datum/action/A = X
		A.Grant(owner)

/obj/item/bodypart/r_arm/robot/rocket/drop_limb(special)
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(owner)
	. = ..()
