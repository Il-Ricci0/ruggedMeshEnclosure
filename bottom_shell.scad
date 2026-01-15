walls_size = 5;
base_plate_w = 85;
base_plate_l = 120;
inner_h = 30;
fix_render = .001;

module battery() {
    battery_holder_w = 78;
    battery_holder_l = 21;
    battery_holder_h = 21;
    cube([battery_holder_w,battery_holder_l,2], center=true);
}

// battery();
module bottom_shell() {
    hole_w = base_plate_w - (2 * walls_size);
    hole_l = base_plate_l - (2 * walls_size);

    union() {
        difference() {
            color("green")
                cube([base_plate_w, base_plate_l, inner_h+walls_size]);

            // Square hole in the center
            translate([base_plate_w/2 - hole_w/2, base_plate_l/2 - hole_l/2, walls_size+fix_render])
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

        // Seal ridge at top for water sealing with top shell
        color("green")
        top_seal_ridge(base_plate_w, base_plate_l, walls_size, inner_h, walls_size);
    }
}

module lid() {
    union() {
        translate([walls_size/2, walls_size/2, inner_h+walls_size])
           cube([base_plate_w-walls_size,base_plate_l-(walls_size/2)+fix_render,walls_size/2]);

        difference() {
            translate([walls_size/2, walls_size/2, inner_h+walls_size+(walls_size/2)])
                cube([base_plate_w-walls_size,base_plate_l-(walls_size/2)+fix_render,(walls_size/2)]);
            //left
            translate([(walls_size/2)-fix_render,walls_size/2,inner_h+walls_size+(walls_size/2)])
                cube([(walls_size/2)+fix_render,base_plate_l,(walls_size/2)+fix_render]);
            //right
             translate([base_plate_w-walls_size,walls_size/2,inner_h+walls_size+(walls_size/2)])
                cube([(walls_size/2)+fix_render,base_plate_l,(walls_size/2)+fix_render]);
            //bottom
            translate([walls_size/2, (walls_size/2)-fix_render, inner_h+walls_size+(walls_size/2)])
                cube([base_plate_w-walls_size,(walls_size/2)+fix_render, (walls_size/2)+fix_render]);
        }
    }
}
translate([0,150,0])
lid();
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
        pos = [3*base_w/4, base_l - walls/2, base_h + inner_h/2],
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
        pos = [base_w/2, base_l - walls/2, base_h + inner_h/2],
        radius = usbc_radius,
        depth = walls + 2,
        rotation = [90, 0, 0]
    );
}

module button_ridge(base_w, base_h, inner_h, walls) {
    ridge_width = base_w;              // Full width of the shell
    ridge_depth = 10;                  // How far it extends from the wall
    ridge_height = inner_h + (2*walls);    // Full height of the shell

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

        translate([walls/2,walls+(walls/2),inner_h+walls])
            cube([base_w-walls,(walls/2)+fix_render,walls/2]);
    }
}

module top_seal_ridge(base_w, base_l, base_h, inner_h, walls) {
    rail_height = 5;           // How tall the rail is
    rail_width = walls / 2;    // Width of the rail lip
    rail_clearance = 0.3;      // Clearance for sliding fit
    button_ridge_depth = 10;   // Must match button_ridge ridge_depth

    top_z = base_h + inner_h;  // Z position of top of walls
    rail_start_y = -button_ridge_depth + walls;  // Extend into button ridge area

    // Left rail - L-shaped profile running along Y axis
    translate([0, rail_start_y, top_z])
    difference() {
        // Outer block for left rail
        cube([walls, base_l - rail_start_y, rail_height]);
        // Channel cutout for cover to slide in
        translate([rail_width, -1, -1])
            cube([walls - rail_width + rail_clearance, base_l - rail_start_y + 2, rail_height - rail_width + 1]);
    }

    // Right rail - L-shaped profile running along Y axis
    translate([base_w - walls, rail_start_y, top_z])
    difference() {
        // Outer block for right rail
        cube([walls, base_l - rail_start_y, rail_height]);
        // Channel cutout for cover to slide in
        translate([-rail_clearance, -1, -1])
            cube([walls - rail_width + rail_clearance, base_l - rail_start_y + 2, rail_height - rail_width + 1]);
    }

    // Front stop - prevents cover from sliding out the front (on the button ridge)
    translate([walls, rail_start_y, top_z])
        cube([base_w - (2 * walls), rail_width, rail_height]);
}
