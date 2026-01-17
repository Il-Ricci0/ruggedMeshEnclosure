screw_length = 14;
hot_insert_length = 5.5;
hot_insert_diameter = 4.5;
support_diameter = hot_insert_diameter + 4;

module hot_insert_support(support_height) {
    cylinder(h=support_height, r=hot_insert_diameter/2, $fn=32);
}

hot_insert_support(10);