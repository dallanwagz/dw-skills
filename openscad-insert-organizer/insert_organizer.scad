// Parameterized insert organizer
// Big inserts (18 x 41 x 31) arranged in a row, plus a perpendicular column
// of small inserts (23 x 11 x 31) at the right end. All gaps and borders
// match the shared spec; the outer X grows to fit.

// ---- Big insert parameters ----
big_insert_x = 18;   // big insert width  (X, short side)
big_insert_y = 41;   // big insert depth  (Y, long side)
big_insert_z = 31;   // big insert height (Z, cut depth)
num_big      = 5;    // how many big inserts in the row

// ---- Small insert parameters (perpendicular orientation) ----
small_insert_x = 23; // small insert long side, along X (perpendicular to big inserts)
small_insert_y = 11; // small insert short side, along Y
small_insert_z = 31;

// ---- Shared parameters ----
internal_gap    = 3; // nominal wall thickness between adjacent inserts
border          = 5; // nominal wall thickness around the outside
floor_thickness = 2; // solid floor below the inserts

$fn = 64;

// ---- Outer box ----
// X grows just enough to give the small-insert column a full 3 mm gap to the
// last big insert and a full 5 mm right border. Y and Z are unchanged.
last_big_end_x = border + num_big * big_insert_x + (num_big - 1) * internal_gap;
small_x_origin = last_big_end_x + internal_gap;
outer_x        = small_x_origin + small_insert_x + border;
outer_y        = 2 * border + big_insert_y;
outer_z        = floor_thickness + big_insert_z;

// How many small inserts fit stacked along Y inside the big-insert Y window,
// using the standard internal_gap between them.
num_small         = floor((big_insert_y + internal_gap) / (small_insert_y + internal_gap));
small_stack_y     = num_small * small_insert_y + (num_small - 1) * internal_gap;
small_y_offset    = (big_insert_y - small_stack_y) / 2;        // center the stack in Y

module insert_organizer() {
    difference() {
        cube([outer_x, outer_y, outer_z]);

        // Big inserts (long axis along Y)
        for (i = [0 : num_big - 1]) {
            translate([
                border + i * (big_insert_x + internal_gap),
                border,
                floor_thickness
            ])
            cube([big_insert_x, big_insert_y, big_insert_z + 1]);
        }

        // Small inserts (long axis along X, stacked along Y)
        for (j = [0 : num_small - 1]) {
            translate([
                small_x_origin,
                border + small_y_offset + j * (small_insert_y + internal_gap),
                floor_thickness
            ])
            cube([small_insert_x, small_insert_y, small_insert_z + 1]);
        }
    }
}

insert_organizer();

echo(str("Outer: ", outer_x, " x ", outer_y, " x ", outer_z, " mm"));
echo(str("Small inserts fit: ", num_small));
