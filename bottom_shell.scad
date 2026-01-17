module bottom_shell() {
    hole_w = base_plate_w - (2 * walls_size);
    hole_l = base_plate_l - (2 * walls_size);

    fillet_r = 2;  // Bottom edge fillet radius

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

            // Round bottom left edge
            translate([-fix_render, -fix_render, -fix_render])
            difference() {
                cube([fillet_r + fix_render, base_plate_l + 2*fix_render, fillet_r + fix_render]);
                translate([fillet_r, 0, fillet_r])
                rotate([-90, 0, 0])
                    cylinder(h = base_plate_l + 2*fix_render, r = fillet_r, $fn = 32);
            }

            // Round bottom right edge
            translate([base_plate_w - fillet_r, -fix_render, -fix_render])
            difference() {
                cube([fillet_r + fix_render, base_plate_l + 2*fix_render, fillet_r + fix_render]);
                translate([0, 0, fillet_r])
                rotate([-90, 0, 0])
                    cylinder(h = base_plate_l + 2*fix_render, r = fillet_r, $fn = 32);
            }

            // Round bottom back edge
            translate([-fix_render, base_plate_l - fillet_r, -fix_render])
            difference() {
                cube([base_plate_w + 2*fix_render, fillet_r + fix_render, fillet_r + fix_render]);
                translate([0, 0, fillet_r])
                rotate([0, 90, 0])
                    cylinder(h = base_plate_w + 2*fix_render, r = fillet_r, $fn = 32);
            }

            // Round back-left vertical edge
            translate([-fix_render, base_plate_l - fillet_r, -fix_render])
            difference() {
                cube([fillet_r + fix_render, fillet_r + fix_render, inner_h + walls_size + 2*fix_render]);
                translate([fillet_r, 0, 0])
                    cylinder(h = inner_h + walls_size + 2*fix_render, r = fillet_r, $fn = 32);
            }

            // Round back-right vertical edge
            translate([base_plate_w - fillet_r, base_plate_l - fillet_r, -fix_render])
            difference() {
                cube([fillet_r + fix_render, fillet_r + fix_render, inner_h + walls_size + 2*fix_render]);
                translate([0, 0, 0])
                    cylinder(h = inner_h + walls_size + 2*fix_render, r = fillet_r, $fn = 32);
            }
        }

        // Protective ridge around button
        color("green")
        button_ridge(base_plate_w, walls_size, inner_h, walls_size);

        // Seal ridge at top for water sealing with top shell
        color("green")
        top_seal_ridge(base_plate_w, base_plate_l, walls_size, inner_h, walls_size);

        translate([walls_size+support_radius,base_plate_l-walls_size-support_radius,walls_size])
            hot_insert_support(inner_h);

        translate([base_plate_w-walls_size-support_radius,base_plate_l-walls_size-support_radius,walls_size])
            hot_insert_support(inner_h);

        components_offset = 10;
        components_space = battery_holder_w + components_offset + board_w;
        components_start = (base_plate_w - components_space) / 2;

        translate([components_start, (base_plate_l-battery_holder_l)/2, walls_size])
            battery_holder();
        
        translate([components_start + battery_holder_w + components_offset + 5,  (base_plate_l-board_l)/2, walls_size])
            board_holder();
    }
}

// Reusable circular hole module
module circular_hole(pos, radius, depth, rotation = [0, 0, 0]) {
    translate(pos)
    rotate(rotation)
    cylinder(h = depth, r = radius, center = true, $fn = 32);
}

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
    fillet_radius = 2;                 // Radius for bottom edge rounding

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

        // Round the bottom left edge
        translate([-fix_render, -fix_render, -fix_render])
        difference() {
            cube([fillet_radius + fix_render, ridge_depth + 2*fix_render, fillet_radius + fix_render]);
            translate([fillet_radius, 0, fillet_radius])
            rotate([-90, 0, 0])
                cylinder(h = ridge_depth + 2*fix_render, r = fillet_radius, $fn = 32);
        }

        // Round the bottom right edge
        translate([ridge_width - fillet_radius, -fix_render, -fix_render])
        difference() {
            cube([fillet_radius + fix_render, ridge_depth + 2*fix_render, fillet_radius + fix_render]);
            translate([0, 0, fillet_radius])
            rotate([-90, 0, 0])
                cylinder(h = ridge_depth + 2*fix_render, r = fillet_radius, $fn = 32);
        }

        // Round the top front edge
        translate([-fix_render, -fix_render, ridge_height - fillet_radius])
        difference() {
            cube([ridge_width + 2*fix_render, fillet_radius + fix_render, fillet_radius + fix_render]);
            translate([0, fillet_radius, 0])
            rotate([0, 90, 0])
                cylinder(h = ridge_width + 2*fix_render, r = fillet_radius, $fn = 32);
        }

        // Round the top left edge
        translate([-fix_render, -fix_render, ridge_height - fillet_radius])
        difference() {
            cube([fillet_radius + fix_render, ridge_depth + 2*fix_render, fillet_radius + fix_render]);
            translate([fillet_radius, 0, 0])
            rotate([-90, 0, 0])
                cylinder(h = ridge_depth + 2*fix_render, r = fillet_radius, $fn = 32);
        }

        // Round the top right edge
        translate([ridge_width - fillet_radius, -fix_render, ridge_height - fillet_radius])
        difference() {
            cube([fillet_radius + fix_render, ridge_depth + 2*fix_render, fillet_radius + fix_render]);
            translate([0, 0, 0])
            rotate([-90, 0, 0])
                cylinder(h = ridge_depth + 2*fix_render, r = fillet_radius, $fn = 32);
        }
    }
}

module top_seal_ridge(base_w, base_l, base_h, inner_h, walls) {
    rail_height = 5;           // How tall the rail is
    rail_width = walls / 2;    // Width of the rail lip
    rail_clearance = 0.3;      // Clearance for sliding fit
    button_ridge_depth = 10;   // Must match button_ridge ridge_depth
    fillet_r = 2;              // Fillet radius for rounding

    top_z = base_h + inner_h;  // Z position of top of walls
    rail_start_y = -button_ridge_depth + walls;  // Extend into button ridge area
    rail_length = base_l - rail_start_y;

    // Left rail - L-shaped profile running along Y axis
    translate([0, rail_start_y, top_z])
    difference() {
        // Outer block for left rail
        cube([walls, rail_length, rail_height]);
        // Channel cutout for cover to slide in
        translate([rail_width, -1, -1])
            cube([walls - rail_width + rail_clearance, rail_length + 2, rail_height - rail_width + 1]);

        // Round top outer edge (left side)
        translate([-fix_render, -fix_render, rail_height - fillet_r])
        difference() {
            cube([fillet_r + fix_render, rail_length + 2*fix_render, fillet_r + fix_render]);
            translate([fillet_r, 0, 0])
            rotate([-90, 0, 0])
                cylinder(h = rail_length + 2*fix_render, r = fillet_r, $fn = 32);
        }

        // Round top back edge
        translate([-fix_render, rail_length - fillet_r, rail_height - fillet_r])
        difference() {
            cube([walls + 2*fix_render, fillet_r + fix_render, fillet_r + fix_render]);
            translate([0, 0, 0])
            rotate([0, 90, 0])
                cylinder(h = walls + 2*fix_render, r = fillet_r, $fn = 32);
        }

        // Round back-left vertical edge
        translate([-fix_render, rail_length - fillet_r, -fix_render])
        difference() {
            cube([fillet_r + fix_render, fillet_r + fix_render, rail_height + 2*fix_render]);
            translate([fillet_r, 0, 0])
                cylinder(h = rail_height + 2*fix_render, r = fillet_r, $fn = 32);
        }
    }

    // Right rail - L-shaped profile running along Y axis
    translate([base_w - walls, rail_start_y, top_z])
    difference() {
        // Outer block for right rail
        cube([walls, rail_length, rail_height]);
        // Channel cutout for cover to slide in
        translate([-rail_clearance, -1, -1])
            cube([walls - rail_width + rail_clearance, rail_length + 2, rail_height - rail_width + 1]);

        // Round top outer edge (right side)
        translate([walls - fillet_r, -fix_render, rail_height - fillet_r])
        difference() {
            cube([fillet_r + fix_render, rail_length + 2*fix_render, fillet_r + fix_render]);
            translate([0, 0, 0])
            rotate([-90, 0, 0])
                cylinder(h = rail_length + 2*fix_render, r = fillet_r, $fn = 32);
        }

        // Round top back edge
        translate([-fix_render, rail_length - fillet_r, rail_height - fillet_r])
        difference() {
            cube([walls + 2*fix_render, fillet_r + fix_render, fillet_r + fix_render]);
            translate([0, 0, 0])
            rotate([0, 90, 0])
                cylinder(h = walls + 2*fix_render, r = fillet_r, $fn = 32);
        }

        // Round back-right vertical edge
        translate([walls - fillet_r, rail_length - fillet_r, -fix_render])
        difference() {
            cube([fillet_r + fix_render, fillet_r + fix_render, rail_height + 2*fix_render]);
            translate([0, 0, 0])
                cylinder(h = rail_height + 2*fix_render, r = fillet_r, $fn = 32);
        }
    }

    // Front stop - prevents cover from sliding out the front (on the button ridge)
    translate([walls, rail_start_y, top_z])
        cube([base_w - (2 * walls), rail_width, rail_height]);
}
