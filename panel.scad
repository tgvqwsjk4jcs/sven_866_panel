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


front_l=120;
front_w=81;
front_h=10;
front_h_max=20;

// front panel
small_rad=8;
small_d=small_rad*2;
top_d=81;
big_rad=(front_h*front_h+(top_d*top_d/4))/front_h_max;
big_d=2*big_rad;

// front panel holes
f_ex_d=18;
f_in_d1=7;
f_in_d2=15;
f_h=12; // height of holes
f_off=24; // between holes centers offset
f_off_from_bottom=43;

power_in_d=3;
power_ex_d=9;
power_h=6;
power_off=23;

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


//translate([def_w/2,9,0])

module solid_panel(l=front_l,
 w=front_w,
 d=small_d,
 h=front_h,
 h_max=front_h_max) {

 smallest_d=1;
 hull() {
  cylinder(h=h,d=d);
  translate([0,l-d,h_max-h]) cylinder(h=h,d=smallest_d);
  translate([(w-1)/2, l, 0]) cylinder(h=h,d=smallest_d);
  translate([-(w-1)/2, l, 0]) cylinder(h=h,d=smallest_d);
 }
}


module big_hole(d1=f_in_d1,
 d2=f_in_d2,
 ex_d=f_ex_d,
 h=f_h) {
 hole(in_d1=d1, in_d2=d2, ex_d=ex_d, h=h);
}

module holes() {
big_hole();
translate([0,f_off,0]) big_hole();
translate([0,2*f_off,0]) big_hole();
}

module power_hole() {
 difference() {
  cylinder(h=power_h,d=power_ex_d);
  translate([0,0,-3]) cylinder(h=power_h+3,d=power_in_d);
 }
}


module holes_to_cut(h=f_h*4,d=f_in_d2) {
cylinder(h=h,d=d);
translate([0,f_off,0]) cylinder(h=h,d=d);
translate([0,2*f_off,0]) cylinder(h=h,d=d);
}

module in_solid_panel() {
solid_panel(l=front_l-def_wall_size,
 w=top_d-2*def_wall_size,
 d=(small_rad-def_wall_size)*2,
 h=front_h+3);
}

module holes_cutting_panel() {
difference() {
solid_panel();
translate([0,0,-f_h/2]) in_solid_panel(); }
}

module holes_minus_panel() {
 difference() {
  union() { // big holes and power hole
   translate([0,f_off_from_bottom,def_h]) holes();
   translate([0,power_off,def_h+1.5]) power_hole();
  }
  translate([0,0,f_h/2]) holes_cutting_panel();
 }
}

module front_panel() {
 difference() {
  union() {
   pl_1_with_holes();
   translate([def_w/2,small_rad+1,def_h]) solid_panel();
  }
  translate([def_w/2,small_rad+1,def_h-3]) in_solid_panel();
  translate([def_w/2,f_off_from_bottom,0]) holes_to_cut();
 }
}

module main() {
difference() {
 union() {
  translate([def_w/2,0,4]) holes_minus_panel();
  front_panel();
 }
 translate([-20,99,-3]) cube([2*def_w,50,def_h+3]);
 translate([def_w/2,power_off,0]) cylinder(d=power_in_d,h=4*f_h);
}
}

main();