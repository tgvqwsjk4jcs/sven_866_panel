module platform(w,h,h2) {
// lowest part of detail
 
 // bottom
 linear_extrude(height=h2) {
  difference() {
   offset(r=5) square([w,h], center=yes);
   offset(r=2.8) square([w,h], center=yes);
  };
 };
 
 // top
 translate([0,0,h2-3])
 linear_extrude(height=3) {
  offset(r=5) square([w,h], center=yes);
 };
};

//platform(65,120,10);
$fn=50;

module hole(in_d1=3, in_d2=7, ex_d=11, h=10, low_h=2.2) { 
 difference() {
  cylinder(h=h, d=ex_d, center=yes); // outside one
  translate([0,0,low_h]) cylinder(h=h, d=in_d2, center=yes);
  translate([0,0,-3]) cylinder(h=h+5, d=in_d1, center=yes);
 };
};

my_pos=[15,15,0];

module pl_with_hole(my_h=6.3, my_w=67.6, my_l=105) {
 union() {
 translate(my_pos) hole(h=my_h);
  difference() {
   platform(my_w,my_l,my_h);
   translate(my_pos) cylinder(d=11,h=20);
  };
 };
};

//pl_with_hole();
my_w=67.6;
my_l=105;
my_r=5.5;

module pl_1(h=6.3, w=67.5, l=105, r=5.5, off=2.2) {
 int_r = r - off;
 linear_extrude(height=h) {
  difference() {
   hull() {
    translate([r,r,0]) circle(r);
    translate([r,l-2*r,0]) circle(r);
    translate([w-2*r,l-2*r,0]) circle(r);
    translate([w-2*r,r,0]) circle(r); }
   hull() {
    translate([r,r,0]) circle(int_r);
    translate([r,l-2*r,0]) circle(int_r);
    translate([w-2*r,l-2*r,0]) circle(int_r);
    translate([w-2*r,r,0]) circle(int_r); }
  }
 }
 }

//translate([10,0,0]) cube(2.2);
pl_1();
