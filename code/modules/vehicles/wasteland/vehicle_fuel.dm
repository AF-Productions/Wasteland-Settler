//Fallout 13 general fuel directory - Gas! Petrol! Guzzolene!

/obj/vehicle/ridden/fuel
	name = "vehicle"
	desc = "Something went wrong! Badmins spawned shit!"
	icon_state = ""

	var/fuel = 600
	var/max_fuel = 600
	var/obj/item/reagent_containers/fuel_tank/fuel_holder
	//var/idle_wasting = 0.5
	//var/move_wasting = 0.1
	var/engine_on = null

/obj/vehicle/ridden/fuel/New()
	..()
	fuel_holder = new(max_fuel, fuel)

/obj/vehicle/ridden/fuel/attackby(obj/item/weapon/W, mob/user, params) //Refueling
	if(istype(W, /obj/item/reagent_containers))
		fuel_holder.attackby(W, user, params)
		return 1
	return ..()

/obj/vehicle/ridden/fuel/Move(NewLoc,Dir=0,step_x=0,step_y=0)
	. = ..()
	if(engine_on && fuel_holder.move_wasting)
		fuel_holder.reagents.remove_reagent("welding_fuel",fuel_holder.move_wasting)

/obj/vehicle/ridden/fuel/process() //If process begining you can sure that engine is on
	. = ..()
	var/fuel_wasting

	fuel_wasting += fuel_holder.idle_wasting

//Health check
	var/health = (obj_integrity/max_integrity)
	if(health < 1)
		if(health < 0.5 && fuel > 100 && prob(10)) // If vehicle is broken it will burn
			visible_message("<span class='warning'>[src] is badly damaged, the engine has burst into flames!</span>")
			fuel_wasting += 2
			if(prob(50)) //MOAR FIRE
				dyn_explosion(epicenter = src, power = fuel_holder.reagents.get_reagent_amount("welding_fuel")/10, flash_range = 2, adminlog = 0, flame_range = 5 ,silent = 1)

	fuel_holder.reagents.remove_reagent("welding_fuel",fuel_wasting)

	if(fuel_holder.reagents.get_reagent_amount("welding_fuel") < 1)
		stop_engine()

/obj/vehicle/ridden/fuel/proc/start_engine()
	if(fuel_holder.reagents.get_reagent_amount("welding_fuel") < 1)
		to_chat(usr, "<span class='warning'>[src] has run out of fuel!</span>")
		return
	START_PROCESSING(SSobj, src)

/obj/vehicle/ridden/fuel/proc/stop_engine()
	STOP_PROCESSING(SSobj, src)

/obj/vehicle/ridden/fuel/verb/ToggleFuelTank()
	set name = "Toggle Fuel Tank"
	set category = "Object"
	set src in view(1)
	fuel_holder.inside = !fuel_holder.inside
	to_chat(usr, span_notice("You changed transfer type."))

/obj/vehicle/ridden/fuel/examine(mob/user)
	. = ..()
	if(fuel_holder)
		var/fuel_percent = fuel_holder.reagents.total_volume / fuel_holder.reagents.maximum_volume * 100
		switch(fuel_percent)
			if(95 to INFINITY)
				. += span_notice("Fuel meter shows 100% ! The fuel tank is full to the top. Let's ride!")
			if(60 to 95)
				. += span_notice("Fuel meter shows 75% ! Not so full, but it'll still last a while.")
			if(25 to 60)
				. += span_notice("Fuel meter shows 50% ! That should be just enough to find more fuel.")
			if(1 to 25)
				. += span_warning("Fuel meter shows 25% ! It's almost out of fuel!")
			else
				. += span_danger("Fuel meter shows 0% ! There is no fuel left!")



/obj/item/reagent_containers/jerrycan
	name = "Jerrycan"
	amount_per_transfer_from_this = 50
	volume = 500
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/fuel)
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "jerrycan"
	reagent_flags = OPENCONTAINER

/obj/item/reagent_containers/fuel_tank
	name = "fuel tank"
	var/idle_wasting = 0.5
	var/move_wasting = 0.1
	amount_per_transfer_from_this = 25
	var/inside = 1
	volume = 1000
	w_class = WEIGHT_CLASS_BULKY
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "fuel_tank"
	reagent_flags = DRAWABLE

/obj/item/reagent_containers/fuel_tank/upgraded
	name = "Upgraded fuel tank"
	idle_wasting = 0.2
	move_wasting = 0.05
	volume = 1500
	icon_state = "fuel_tank_u"
/obj/item/reagent_containers/fuel_tank/hyper
	name = "Hyper fuel tank"
	idle_wasting = 0.1
	move_wasting = 0.025
	volume = 2000
	icon_state = "fuel_tank_h"

/*/obj/item/reagent_containers/fuel_tank/New(volume, fuel)
	src.volume = volume
	list_reagents = list(/datum/reagent/fuel = fuel)
	..()*/

/obj/item/reagent_containers/fuel_tank/attackby(obj/item/weapon/W, mob/user, params)
	if(W.is_open_container() && W.reagents)
		if(inside)
			if(!W.reagents.total_volume)
				to_chat(user, "<span class='warning'>[W] is empty!</span>")
				return

			if(src.reagents.total_volume >= src.reagents.maximum_volume)
				to_chat(user, "<span class='notice'>[src] is full.</span>")
				return


			var/trans = W.reagents.trans_to(src, amount_per_transfer_from_this)
			to_chat(user, "<span class='notice'>You transfer [trans] units of the solution to [src].</span>")
		else
			if(!src.reagents.total_volume)
				to_chat(user, "<span class='warning'>[src] is empty!</span>")
				return

			if(W.reagents.total_volume >= W.reagents.maximum_volume)
				to_chat(user, "<span class='notice'>[W] is full.</span>")
				return


			var/trans = src.reagents.trans_to(W, amount_per_transfer_from_this)
			to_chat(user, "<span class='notice'>You transfer [trans] units of the solution to [W].</span>")
	. = ..()

/obj/item/reagent_containers/fuel_tank/use(amount = 0)
	if(reagents.total_volume <= 0)
		return 0
	var/used = min(reagents.total_volume,amount)
	reagents.remove_reagent("welding_fue", used)
	if(!istype(loc, /obj/machinery/power/apc))
		SSblackbox.record_feedback("tally", "cell_used", 1, type)
	return used

/obj/item/reagent_containers/fuel_tank/proc/percent()		// return % charge of cell
	return 100*reagents.total_volume/volume

