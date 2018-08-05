$fn=50;

def_h=6.3;
def_w=67.5;
def_l=109; // not precise, not really needed
def_r=5.5;
def_wall_size=2.2;

s_hole_1_x_off=14;
s_hole_1_y_off=5.2;
s_hole_2_x_off=5.2; //same
s_hole_2_y_off=49.5; //same

s_hole_internal_d=7; // for making holes in platform


front_l=120; //
front_h=10;
front_h_max=20;

// front panel
small_rad=8;
small_d=small_rad*2;
top_d=81;
big_rad=(front_h*front_h+(top_d*top_d/4))/front_h_max;
big_d=2*big_rad;



module round_cube(h=def_h, w=def_w, l=def_l, r=def_r) {
 translate([r,r,0]) { // move to center by one side
  linear_extrude(height=h) {
   hull() {
    circle(r);
    translate([0,l-2*r,0]) circle(r);
    translate([w-2*r,l-2*r,0]) circle(r);
    translate([w-2*r,0,0]) circle(r);
   } // hull
  } // extrude
 } // translate
} // module

module pl_1(h=def_h, w=def_w, l=def_l, r=def_r, off=def_wall_size) {
 int_r = r - off;
 int_w = w - 2*off;
 int_l = l - 2*off;
 difference() {
  round_cube(h,w,l,r);
  translate([off,off,-off])
  round_cube(w=int_w,l=int_l, r=int_r);
 }
}

module hole(in_d1=3, in_d2=7, ex_d=11, h=def_h, low_h=def_wall_size) { 
 difference() {
  cylinder(h=h, d=ex_d); // outside one
  translate([0,0,low_h]) cylinder(h=h, d=in_d2);
  translate([0,0,-3]) cylinder(h=h+5, d=in_d1);
 };
};

// presice size small hole
module small_hole() {
 hole(in_d1=3, in_d2=7, ex_d=11);
}

//translate([0,0,-15]) cube([def_w,def_l,10], center=yes);

// cutting external hole radius
module cuted_hole(w=3*def_r,d=def_r,h=2*def_h) {
 difference() {
  small_hole(); 
  translate([-w/2,4,-2]) cube([w,d,h]);
 } // diff 
}

module pl_1_with_holes() {
 union() {
  // making holes in platform
  difference() {
   pl_1();
   translate([s_hole_1_x_off,s_hole_1_y_off,0]) // first clock wise
    cylinder(d=s_hole_internal_d,h=2*def_h);
   translate([def_w-s_hole_1_x_off,s_hole_1_y_off,0])
    cylinder(d=s_hole_internal_d,h=2*def_h);
   translate([s_hole_2_x_off,s_hole_2_y_off,0])
    cylinder(d=s_hole_internal_d,h=2*def_h);
   translate([def_w-s_hole_2_x_off,s_hole_2_y_off,0])
    cylinder(d=s_hole_internal_d,h=2*def_h);
  } // holes making in pl1

  // placing holes
  // bottom holes
  translate([s_hole_1_x_off,s_hole_1_y_off,0])
   rotate([0,0,180]) cuted_hole();
  translate([def_w-s_hole_1_x_off,s_hole_1_y_off,0])
   rotate([0,0,180]) cuted_hole();

// top small holes
  translate([s_hole_2_x_off,s_hole_2_y_off,0])
   rotate([0,0,90]) cuted_hole();
  translate([def_w-s_hole_2_x_off,s_hole_2_y_off,0])
   rotate([0,0,-90]) cuted_hole();
 } // union
} // module


module small_c(h=front_h,d=small_d) {
 cylinder(h,d=d);
}

module big_c() {
cylinder(h=front_h,d=top_d);
}

// first try
module circle_part_for_hull() {
 difference() {
  cylinder(h=10,d=big_d);
  translate([-(big_rad-10),-big_rad,-front_h]) cube(big_d);
 }
}

//translate([def_w/2,9,0])

module solid_panel(l=front_l,w=top_d,d=small_d) {
 hull() {
  small_c(d=d);
  translate([0,l-d,front_h_max-front_h]) small_c(d=1);
  translate([(w-1)/2, l, 0]) small_c(d=1);
  translate([-(w-1)/2, l, 0]) small_c(d=1);
 }
}

//pl_1_with_holes();
//translate([def_w/2,9,def_h]) solid_panel();
solid_panel();
color("red") solid_panel(l=front_l-def_wall_size,
 w=top_d-2*def_wall_size,
 d=(small_rad-def_wall_size)*2);