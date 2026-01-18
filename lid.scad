module lid() {
    tolerance = .25;
    difference() {
        // Main lid body - reduced by tolerance and offset to center
        translate([walls_size/2 + tolerance, walls_size/2 + tolerance, inner_h+walls_size])
            cube([base_plate_w-walls_size-(2*tolerance), base_plate_l-(walls_size/2)+fix_render-tolerance, walls_size-tolerance]);

        // Rail cutouts (top half only) - with tolerance for smooth sliding
        //left - cutout extends further inward to thin the edge
        translate([(walls_size/2)-fix_render, walls_size/2, inner_h+walls_size+(walls_size/2)-tolerance])
            cube([(walls_size/2)+tolerance+fix_render, base_plate_l, (walls_size/2)+tolerance+fix_render]);
        //right - cutout extends further inward to thin the edge
        translate([base_plate_w-walls_size-tolerance, walls_size/2, inner_h+walls_size+(walls_size/2)-tolerance])
            cube([(walls_size/2)+tolerance+fix_render, base_plate_l, (walls_size/2)+tolerance+fix_render]);
        //front - cutout extends further inward to thin the edge
        translate([walls_size/2, (walls_size/2)-fix_render, inner_h+walls_size+(walls_size/2)-tolerance])
            cube([base_plate_w-walls_size, (walls_size/2)+tolerance+fix_render, (walls_size/2)+tolerance+fix_render]);

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
        cylinder(h = screw_head_length + fix_render, r1 = screw_diameter/2, r2 = screw_head_diameter/2, $fn = 100);

        // Shaft hole through the lid
        translate([0, 0, -screw_length])
            cylinder(h = screw_length + fix_render, r = screw_diameter/2, $fn = 100);
    }
}
