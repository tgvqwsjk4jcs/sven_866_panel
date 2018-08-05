$fn=50;

def_h=6.3;
def_w=67.5;
def_l=105;
def_r=5.5;
def_wall_size=2.2;

s_hole_1_x_off=14;
s_hole_1_y_off=5.2;
s_hole_2_x_off=5.2; //same
s_hole_2_y_off=49.5; //same

s_hole_internal_d=7; // for making holes in platform

b_c_d=16; // bottom cylinder diameter
t_c_d=81; // top cylinder diameter

front_length=120; //
front_h=10;
front_h_max=20;

// for front panel hull from big circle
big_rad=(front_h*front_h+(t_c_d*t_c_d/4))/front_h_max;
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
  cylinder(h=h, d=ex_d, center=yes); // outside one
  translate([0,0,low_h]) cylinder(h=h, d=in_d2, center=yes);
  translate([0,0,-3]) cylinder(h=h+5, d=in_d1, center=yes);
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

//pl_1_with_holes();

module small_c() {
cylinder(h=front_h,d=b_c_d);
}

module big_c() {
cylinder(h=front_h,d=t_c_d);
}

module circle_part_for_hull() {
 difference() {
  cylinder(h=10,d=big_d);
  translate([-(big_rad-10),-big_rad,-front_h]) cube(big_d);
 }
}

//translate([def_w/2,9,0])


hull() {
small_c();
translate([(t_c_d-b_c_d)/2, front_length, 0]) small_c();
translate([-(t_c_d-b_c_d)/2, front_length, 0]) small_c();
}

translate([0,front_length+8,-(big_rad-18)]) rotate([0,90,90]) circle_part_for_hull();

//translate([0,front_length+10,-(big_rad-18)]) rotate([90,0,0]) circle_part_for_hull();
