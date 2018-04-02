#define ROCKET_DEACTIVATED 0
#define ROCKET_ACTIVATED   1
#define ROCKET_LIGHTER     2

/obj/item/bodypart/r_arm/robot/rocket
	name = "rocket powered right arm"
	desc = "A cyborg right arm that detaches at the wrist."
	actions_types = list(/datum/action/item_action/enable_rocket_fist, 
		                 /datum/action/item_action/toggle_finger_lighter,
		                 /datum/action/item_action/drop_rocket_fist)
	var/obj/item/weldingtool/rocket_fist/fist
	var/projectile_type = /obj/item/projectile/remotecontrolled/fist
	var/rocket_status = ROCKET_DEACTIVATED

/obj/item/bodypart/r_arm/robot/rocket/Initialize()
	. = ..()
	fist = new(loc)
	fist.attached = src
	fist.forceMove(src)

/obj/item/bodypart/r_arm/robot/rocket/item_action_slot_check(slot, mob/user)
	if (owner && fist)
		return TRUE

/datum/action/item_action/enable_rocket_fist
	name = "Enable Rocket Fist"
	desc = "Enables the rocket fist for firing, just aim and click!"
	icon_icon = 'icons/obj/tools.dmi'
	button_icon_state = "welder"

/datum/action/item_action/enable_rocket_fist/Trigger()
	var/obj/item/bodypart/r_arm/robot/rocket/R = target
	if (!R)
		return
	var/mob/living/carbon/C = R.owner
	if (!C)
		return
	if (!IsAvailable())
		to_chat(C, "<span class='warning'>You can't do this right now!</span>")
		return

	switch (R.rocket_status)
		if (ROCKET_DEACTIVATED)
			if (!R.fist.get_fuel())
				to_chat(C, "<span class='warning'>You don't have enough fuel to do that!</span>")
				return
			if (C.dropItemToGround(C.get_item_for_held_index(R.held_index), TRUE))
				to_chat(C, "<span class='warning'>You arm the rocket fist!</span>")
				C.put_in_r_hand(R.fist)
				R.rocket_status = ROCKET_ACTIVATED
			else
				to_chat(C, "<span class='warning'>You fail to arm the rocket fist!</span>")
		if (ROCKET_ACTIVATED)
			to_chat(C, "<span class='warning'>You disarm the rocket fist, perhaps another time...</span>")
			C.dropItemToGround(C.get_item_for_held_index(R.held_index), TRUE)
			R.fist.forceMove(R)
			R.rocket_status = ROCKET_DEACTIVATED
		if (ROCKET_LIGHTER)
			to_chat(C, "<span class='warning'>You should probably put away the lighter before doing that!</span>")

/datum/action/item_action/toggle_finger_lighter
	name = "Toggle Finger Lighter"
	desc = "Opens up the nozzle hidden on the index finger, for use with cigars."
	icon_icon = 'icons/obj/tools.dmi'
	button_icon_state = "welder"

/datum/action/item_action/toggle_finger_lighter/Trigger()
	var/obj/item/bodypart/r_arm/robot/rocket/R = target
	if (!R)
		return
	var/mob/living/carbon/C = R.owner
	if (!C)
		return
	if (!IsAvailable())
		to_chat(C, "<span class='warning'>You can't do this right now!</span>")
		return
	
	switch(R.rocket_status)
		if (ROCKET_DEACTIVATED)
			if (C.dropItemToGround(C.get_item_for_held_index(R.held_index), TRUE))
				to_chat(C, "<span class='notice'>You open the tip of your index finger on your [R]</span>")
				C.put_in_r_hand(R.fist)
				R.rocket_status = ROCKET_LIGHTER
			else
				to_chat(C, "<span class='warning'>You fail to open the tip of your index finger on your [R]!</span>")
		if (ROCKET_ACTIVATED)
			to_chat(C, "<span class='warning'>You should probably disarm the rocket before trying to do this!</span>")
		if (ROCKET_LIGHTER)
			to_chat(C, "<span class='notice'>You swiftly put away the hidden lighter</span>")
			R.fist.switched_off(C)
			C.dropItemToGround(C.get_item_for_held_index(R.held_index), TRUE)
			R.fist.forceMove(R)
			R.rocket_status = ROCKET_DEACTIVATED
	
/datum/action/item_action/drop_rocket_fist
	name = "Drop Rocket Fist"
	desc = "Disconnects and drops the rocket fist."
	icon_icon = 'icons/obj/tools.dmi'
	button_icon_state = "welder"

/datum/action/item_action/drop_rocket_fist/Trigger()
	var/obj/item/bodypart/r_arm/robot/rocket/R = target
	if (!R)
		return
	var/mob/living/carbon/C = R.owner
	if (!C)
		return
	if (!IsAvailable())
		to_chat(C, "<span class='warning'>You can't do this right now!</span>")
		return
	
	C.dropItemToGround(C.get_item_for_held_index(R.held_index), TRUE)
	C.hand_bodyparts[R.held_index] = null
	R.fist.forceMove(get_turf(C))	
	R.fist.attached = null
	R.fist = null
	R.remove_verbs()
	var/obj/screen/inventory/hand/H = C.hud_used.hand_slots["[R.held_index]"]
	if(H)
		H.update_icon()

/obj/item/bodypart/r_arm/robot/rocket/proc/fire_fist()
	if (!owner || !fist)
		return

	var/mob/living/carbon/C = owner
	var/obj/item/projectile/remotecontrolled/fist/P = new projectile_type(get_turf(C))
	P.firer = C ? C : src
	P.range = fist.get_fuel()
	P.fist = fist
	C.dropItemToGround(C.get_item_for_held_index(held_index), TRUE)
	C.hand_bodyparts[held_index] = null
	fist.forceMove(P)
	fist.attached = null
	fist = null
	P.fire(dir2angle(C.dir))
	remove_verbs()
	rocket_status = ROCKET_DEACTIVATED
	var/obj/screen/inventory/hand/R = C.hud_used.hand_slots["[held_index]"]
	if(R)
		R.update_icon()

/obj/item/bodypart/r_arm/robot/rocket/proc/add_verbs()
	for(var/X in actions)
		var/datum/action/A = X
		A.Grant(owner)

/obj/item/bodypart/r_arm/robot/rocket/proc/remove_verbs()
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(owner)

/obj/item/bodypart/r_arm/robot/rocket/attach_limb(mob/living/carbon/C, special)
	. = ..()
	add_verbs()

/obj/item/bodypart/r_arm/robot/rocket/drop_limb(special)
	remove_verbs()
	. = ..()

/mob/living/carbon/attackby(obj/item/I, mob/user, params)
	if (istype(I, /obj/item/weldingtool/rocket_fist))
		var/obj/item/bodypart/r_arm/robot/rocket/r_arm = get_bodypart("r_arm")

		if (!r_arm)
			return

		if (r_arm.fist)
			return

		if (do_after(user, 10, target = src))
			if (user.transferItemToLoc(I, r_arm))
				visible_message("<span class='notice'>[src] attaches the rocket fist into the socket on \his arm.</span>",
					            "<span class='notice'>You attach the rocket fist into the socket on your arm.</span>")
				playsound(loc, 'sound/machines/click.ogg', 50, TRUE, -1)
				r_arm.fist = I
				r_arm.fist.attached = r_arm
				r_arm.add_verbs()
				hand_bodyparts[r_arm.held_index] = r_arm
				var/obj/screen/inventory/hand/R = hud_used.hand_slots["[r_arm.held_index]"]
				if(R)
					R.update_icon()
				return TRUE
		else
			return

	..()

/obj/item/weldingtool/rocket_fist
	name = "rocket powered fist"
	desc = "Looks like it uses welding fuel for rocket-powered flight."
	max_fuel = 50 // Used to set projectile "range"
	var/attached // If this is attached to something, dropping will return it to it's origin

/obj/item/weldingtool/rocket_fist/afterattack(atom/A, mob/user)
	if (!attached)
		. = ..()
	else
		var/obj/item/bodypart/r_arm/robot/rocket/R = attached

		if (!istype(R))
			return FALSE

		if (R.rocket_status == ROCKET_ACTIVATED)
			forceMove(R)
			R.fire_fist()
			return FALSE
		else
			. = ..()

/obj/item/weldingtool/rocket_fist/attack_self(mob/user)
	if (attached)
		var/obj/item/bodypart/r_arm/robot/rocket/R = attached

		if (R.rocket_status == ROCKET_ACTIVATED)
			return FALSE // do nothing

	return ..()

/obj/item/weldingtool/rocket_fist/dropped()
	if (attached)
		var/obj/item/bodypart/r_arm/robot/rocket/R = attached
		forceMove(R)
		R.rocket_status = ROCKET_DEACTIVATED