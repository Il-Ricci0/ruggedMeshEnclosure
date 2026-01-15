
module battery() {
    battery_holder_w = 78;
    battery_holder_l = 21;
    battery_holder_h = 21;
    cube([battery_holder_w,battery_holder_l,2], center=true);
}

// battery();
module bottom_shell() {
    base_plate_w = 85;
    base_plate_l = 120;

    inner_h = 30;
    walls_size = 5;
    hole_w = base_plate_w - (2 * walls_size);
    hole_l = base_plate_l - (2 * walls_size);

    union() {
        difference() {
            color("green")
                cube([base_plate_w, base_plate_l, inner_h+walls_size]);

            // Square hole in the center
            translate([base_plate_w/2 - hole_w/2, base_plate_l/2 - hole_l/2, walls_size+1])
                cube([hole_w, hole_l, inner_h]);

            // Antenna holes on back wall
            lora_antenna_hole(base_plate_w, base_plate_l, walls_size, inner_h, walls_size);
            gps_antenna_hole(base_plate_w, base_plate_l, walls_size, inner_h, walls_size);

            // USB-C hole on back wall
            usbc_hole(base_plate_w, base_plate_l, walls_size, inner_h, walls_size);

            // Button hole on front wall
            button_hole(base_plate_w, base_plate_l, walls_size, inner_h, walls_size);
        }

        // Protective ridge around button
        color("green")
        button_ridge(base_plate_w, walls_size, inner_h, walls_size);
    }
}

bottom_shell();

// Reusable circular hole module
module circular_hole(pos, radius, depth, rotation = [0, 0, 0]) {
    translate(pos)
    rotate(rotation)
    cylinder(h = depth, r = radius, center = true, $fn = 32);
}

// SMA connector hole (6.5mm diameter)
sma_radius = 6.5 / 2;

// Button hole (12mm diameter)
button_radius = 12 / 2;

// USB-C hole (14.6mm diameter)
usbc_radius = 14.6 / 2;

module lora_antenna_hole(base_w, base_l, base_h, inner_h, walls) {
    circular_hole(
        pos = [base_w/2, base_l - walls/2, base_h + inner_h/2],
        radius = sma_radius,
        depth = walls + 2,
        rotation = [90, 0, 0]
    );
}

module gps_antenna_hole(base_w, base_l, base_h, inner_h, walls) {
    circular_hole(
        pos = [base_w/4, base_l - walls/2, base_h + inner_h/2],
        radius = sma_radius,
        depth = walls + 2,
        rotation = [90, 0, 0]
    );
}

module button_hole(base_w, base_l, base_h, inner_h, walls) {
    circular_hole(
        pos = [base_w/2, walls/2, base_h + inner_h/2],
        radius = button_radius,
        depth = walls + 2,
        rotation = [90, 0, 0]
    );
}

module usbc_hole(base_w, base_l, base_h, inner_h, walls) {
    circular_hole(
        pos = [3*base_w/4, base_l - walls/2, base_h + inner_h/2],
        radius = usbc_radius,
        depth = walls + 2,
        rotation = [90, 0, 0]
    );
}

module button_ridge(base_w, base_h, inner_h, walls) {
    ridge_width = base_w;              // Full width of the shell
    ridge_depth = 10;                  // How far it extends from the wall
    ridge_height = inner_h + walls;    // Full height of the shell

    // Position attached to front wall
    translate([0, -ridge_depth + walls, 0])
    difference() {
        // Outer block
        cube([ridge_width, ridge_depth, ridge_height]);

        // Inner cutout to create U-shape (open toward the front)
        translate([walls, -1, walls])
            cube([ridge_width - (2 * walls), ridge_depth - walls + 1, ridge_height - (2 * walls)]);

        // Button hole through the ridge
        translate([base_w/2, ridge_depth/2, base_h + inner_h/2])
        rotate([90, 0, 0])
            cylinder(h = ridge_depth + 2, r = button_radius, center = true, $fn = 32);
    }
}
