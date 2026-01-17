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
