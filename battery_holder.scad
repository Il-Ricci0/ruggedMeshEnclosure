module battery_holder() {

    difference() {

        // holder
        cube([battery_holder_w, battery_holder_l, battery_holder_h]);

        // battery
        translate([battery_walls, battery_walls, 0])
            cube([battery_w,battery_l,battery_h]);
    }
}