module board_holder() {
    union() {
        board_support();

        translate([0, 52, 0])
            board_support();

        translate([22, 52, 0])
            board_support();

        translate([24, 0, 0])
            board_support();
    }
}

module board_support() {
    difference() {
        cylinder(h=board_support_height, r=(board_support_diameter/2), $fn=32);

        translate([0,0,(board_support_height-board_hot_insert_length)])
            cylinder(h=board_hot_insert_length+fix_render, r=(board_hot_insert_diameter/2), $fn=32);
    }
};

// 22