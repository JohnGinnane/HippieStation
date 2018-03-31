/obj/item/projectile/remotecontrolled
	name = "remote controlled projectile"
	icon_state = "atrocket"
	icon_state = "rocketfist"
	damage = 0
	var/mob/camera/aiEye/remote/controller/eyeobj

/obj/item/projectile/remotecontrolled/Initialize()
	create_eye()

/obj/item/projectile/remotecontrolled/Destroy()
	if (eyeobj)
		remove_eye_control()
		qdel(eyeobj)
	..()

/obj/item/projectile/remotecontrolled/process()
	. = ..()
	if (eyeobj)
		if (eyeobj.eye_user)
			eyeobj.setLoc(loc)

/obj/item/projectile/remotecontrolled/proc/create_eye()
	eyeobj = new()
	eyeobj.origin = src
	eyeobj.eye_initialized = TRUE

/obj/item/projectile/remotecontrolled/proc/give_eye_control(mob/user)
	if (!eyeobj)
		create_eye()

	eyeobj.eye_user = user
	eyeobj.name = "Camera Eye ([user.name])"
	user.remote_control = eyeobj
	user.reset_perspective(eyeobj)
	eyeobj.setLoc(loc)

/obj/item/projectile/remotecontrolled/proc/remove_eye_control()
	if (!eyeobj)
		return

	if (!eyeobj.eye_user)
		return

	if (eyeobj.eye_user.client)
		eyeobj.eye_user.reset_perspective(null)
		eyeobj.RemoveImages()

	eyeobj.eye_user.remote_control = null
	eyeobj.eye_user = null

/mob/camera/aiEye/remote/controller
	name = "Inactive Controller Camera Eye"

/mob/camera/aiEye/remote/controller/relaymove(mob/user, direct)
	if (istype(origin, /obj/item/projectile/remotecontrolled/))
		var/obj/item/projectile/remotecontrolled/P = origin
		P.setAngle(dir2angle(direct))
