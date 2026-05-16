// Parameterized insert organizer
// Negative-space inserts arranged in a row, with a floor and border around them.

// ---- Parameters ----
insert_x        = 18;   // insert width  (X)
insert_y        = 41;   // insert depth  (Y)
insert_z        = 31;   // insert height (Z, cut depth)

num_inserts     = 6;    // how many inserts in a row
internal_gap    = 3;    // wall thickness between adjacent inserts
border          = 5;    // wall thickness around the outside
floor_thickness = 2;    // solid floor below the inserts

$fn = 64;

// ---- Derived outer dimensions ----
outer_x = 2 * border
        + num_inserts * insert_x
        + (num_inserts - 1) * internal_gap;
outer_y = 2 * border + insert_y;
outer_z = floor_thickness + insert_z;

module insert_organizer() {
    difference() {
        cube([outer_x, outer_y, outer_z]);

        for (i = [0 : num_inserts - 1]) {
            translate([
                border + i * (insert_x + internal_gap),
                border,
                floor_thickness
            ])
            // Extend Z by 1 so the cut breaks through the top cleanly.
            cube([insert_x, insert_y, insert_z + 1]);
        }
    }
}

insert_organizer();
