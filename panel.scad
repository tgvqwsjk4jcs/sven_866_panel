$fn=50;

module hole(in_d1=3, in_d2=7, ex_d=11, h=10, low_h=2.2) { 
 difference() {
  cylinder(h=h, d=ex_d, center=yes); // outside one
  translate([0,0,low_h]) cylinder(h=h, d=in_d2, center=yes);
  translate([0,0,-3]) cylinder(h=h+5, d=in_d1, center=yes);
 };
};

module round_cube(h=6.3, w=67.5, l=105, r=5.5) {
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

module pl_1(h=6.3, w=67.5, l=105, r=5.5, off=2.2) {
 int_r = r - off;
 int_w = w - 2*off;
 int_l = l - 2*off;
 difference() {
  round_cube(h,w,l,r);
  translate([off,off,-off]) round_cube(w=int_w,l=int_l, r=int_r);
 }
}

//translate([0,0,-15]) cube([67.5,105,10], center=yes);
pl_1();
//round_cube();
