include<config.scad>

module hot_insert_support(support_height) {
    difference() {
        cylinder(h=support_height, r=support_diameter/2, $fn=32);

        translate([0,0,(support_height-screw_length+walls_size)])
            cylinder(h=screw_length+fix_render, r=(screw_diameter/2), $fn=32);
        
        translate([0,0,(support_height-hot_insert_length)])
            cylinder(h=hot_insert_length+fix_render, r=(hot_insert_diameter/2), $fn=32);
    }
}

hot_insert_support(inner_h);