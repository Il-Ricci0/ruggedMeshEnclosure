// Main assembly file for rugged mesh enclosure
// Open this file in OpenSCAD to render the complete model

include <config.scad>
include <bottom_shell.scad>
include <lid.scad>
include <hot_insert_support.scad>
include <battery_holder.scad>
include <board_holder.scad>

// Render the bottom shell
bottom_shell();

// Render the lid (offset for visibility)
translate([0, 150, 0])
    lid();
