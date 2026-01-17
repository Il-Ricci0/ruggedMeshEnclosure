// Global configuration variables for rugged mesh enclosure

// Enclosure dimensions
walls_size = 5;
base_plate_w = 85;
base_plate_l = 120;
inner_h = 30;

// Rendering fix for boolean operations
fix_render = .001;

// SMA connector hole (6.5mm diameter)
sma_radius = 6.5 / 2;

// Button hole (12mm diameter)
button_radius = 12 / 2;

// USB-C hole (14.6mm diameter)
usbc_radius = 14.6 / 2;

// Hot insert / screw dimensions
screw_length = 16;
screw_diameter = 3;
screw_head_length = 2;
screw_head_diameter = 5;

hot_insert_length = 5.5;
hot_insert_diameter = 4.5;
hot_insert_radius = hot_insert_diameter/2;
support_diameter = hot_insert_diameter + 4;
support_radius = support_diameter/2;

battery_w = 78;
battery_l = 21;
battery_h = 21;
battery_walls = 2;

battery_holder_h = 10;
battery_holder_w = battery_w + (2*battery_walls);
battery_holder_l = battery_l + (2*battery_walls); 
