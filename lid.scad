module lid() {
    difference() {
        // Main lid body
        translate([walls_size/2, walls_size/2, inner_h+walls_size])
            cube([base_plate_w-walls_size, base_plate_l-(walls_size/2)+fix_render, walls_size]);

        // Rail cutouts (top half only)
        //left
        translate([(walls_size/2)-fix_render, walls_size/2, inner_h+walls_size+(walls_size/2)])
            cube([(walls_size/2)+fix_render, base_plate_l, (walls_size/2)+fix_render]);
        //right
        translate([base_plate_w-walls_size, walls_size/2, inner_h+walls_size+(walls_size/2)])
            cube([(walls_size/2)+fix_render, base_plate_l, (walls_size/2)+fix_render]);
        //front
        translate([walls_size/2, (walls_size/2)-fix_render, inner_h+walls_size+(walls_size/2)])
            cube([base_plate_w-walls_size, (walls_size/2)+fix_render, (walls_size/2)+fix_render]);

        // Back-left screw hole (aligned with hot insert support)
        translate([walls_size + support_radius, base_plate_l - walls_size - support_radius, inner_h + (2*walls_size) - screw_head_length])
            lid_screw_hole();

        // Back-right screw hole (aligned with hot insert support)
        translate([base_plate_w - walls_size - support_radius, base_plate_l - walls_size - support_radius, inner_h + (2*walls_size) - screw_head_length])
            lid_screw_hole();
    }
}

module lid_screw_hole() {
    // Countersunk hole: cone for head + cylinder for shaft
    union() {
        // Countersink cone for screw head
        cylinder(h = screw_head_length + fix_render, r1 = screw_diameter/2, r2 = screw_head_diameter/2, $fn = 32);

        // Shaft hole through the lid
        translate([0, 0, -screw_length])
            cylinder(h = screw_length + fix_render, r = screw_diameter/2, $fn = 32);
    }
}
