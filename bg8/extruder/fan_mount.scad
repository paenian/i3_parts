

hot_rad = 30/2/cos(30);
hotend_x=25;
fan_x = 15+5;

hotend_y=-5;

thickness = 10;
wall=2;

fan_hole = (40-wall-wall)/2;
fan_z = fan_hole+wall+10;

fan_mount();

%cylinder(r=hot_rad, h=20, center=true);

m3_cap_rad = 4;
m3_rad = 2;

facets = 6;

module fan_mount(){
    difference(){
        union(){
            //core
            cylinder(r1=hot_rad+thickness+wall, r2=hot_rad+thickness*2+wall, h=thickness+wall, $fn=facets);
            
            hull(){
                intersection(){
                    difference(){
                        cylinder(r1=hot_rad+thickness+wall, r2=hot_rad+thickness*2+wall, h=thickness+wall, $fn=facets);
                        translate([0,0,-.5]) cylinder(r1=hot_rad+wall, r2=hot_rad+wall+wall, h=thickness+wall+1, $fn=facets);
                    }
                    translate([50+hot_rad-6.7,50,50]) cube([100,100,100], center=true);
                }
                translate([hotend_x+fan_x-5,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole+wall, h=5);
            }
            
            hull(){
                intersection(){
                    difference(){
                        cylinder(r1=hot_rad+thickness+wall, r2=hot_rad+thickness*2+wall, h=thickness+wall, $fn=facets);
                        translate([0,0,-.5]) cylinder(r1=hot_rad+wall, r2=hot_rad+wall+wall, h=thickness+wall+1, $fn=facets);
                    }
                    translate([50+hot_rad-6.7,-50,50]) cube([100,100,100], center=true);
                }
                translate([hotend_x+fan_x-5,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole+wall, h=5);
            }
            
            //fan mount
            translate([hotend_x+fan_x,hotend_y,fan_z]) rotate([0,90,0]){
                hull() for(i=[0:90:359]) rotate([0,0,i]) {
                    translate([20-wall,20-wall,0]) cylinder(r=wall,h=wall);
                }
            
                //lugs
                for(i=[-16, 16]) hull(){
                    translate([-16,i,-fan_x+5]) cylinder(r=m3_cap_rad, h=fan_x-4);
                    //translate([0,i,0]) cylinder(r=m3_cap_rad/2, h=1);
                }
            }
        }
        
        //center cutout
        translate([0,0,-.5]) cylinder(r1=hot_rad+wall, r2=hot_rad+wall+wall, h=thickness+wall+1, $fn=facets);
        
        //front cutout
        translate([-(hot_rad+thickness*2+wall),0,0]) cylinder(r=hot_rad+thickness*2+wall, h=thickness+wall*10, center=true, $fn=facets);
        
        //fan holes
        translate([hotend_x+fan_x,hotend_y,fan_z]) rotate([0,90,0]){
            for(i=[-16, 16]) {
                translate([-16,i,-10-.1]) cylinder(r=m3_rad, h=100, center=true);
            }
            for(j=[-16, 16]){
                translate([16,j,-1-.1]) cylinder(r=m3_rad, h=2+wall);
            }
        }
        
        //air path
        translate([0,0,-.1]) difference(){
            union(){
                #cylinder(r1=hot_rad+thickness, r2=hot_rad+thickness*2-wall, h=thickness, $fn=facets);
                
                
                
                *hull(){
                    intersection(){
                        cylinder(r1=hot_rad+thickness, r2=hot_rad+thickness*2-wall, h=thickness, $fn=facets);
                        translate([50+hot_rad+wall,0,50+wall]) cube([100,100,100], center=true);
                    }
                    translate([hotend_x+fan_x-5,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole, h=.3, center=true);
                }
                
                
                hull(){
                    intersection(){
                        difference(){
                            cylinder(r1=hot_rad+thickness, r2=hot_rad+thickness*2-wall, h=thickness, $fn=facets);
                            translate([0,0,-.5]) cylinder(r1=hot_rad+wall+wall, r2=hot_rad+wall+wall+wall, h=thickness+wall+1, $fn=facets);
                        }
                        translate([50+hot_rad-6.7,50,50]) cube([100,100,100], center=true);
                    }
                    translate([hotend_x+fan_x-5,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole, h=.3);
                }
                
                hull(){
                    intersection(){
                        difference(){
                            cylinder(r1=hot_rad+thickness, r2=hot_rad+thickness*2-wall, h=thickness, $fn=facets);
                            translate([0,0,-.5]) cylinder(r1=hot_rad+wall+wall, r2=hot_rad+wall+wall+wall, h=thickness+wall+1, $fn=facets);
                        }
                        translate([50+hot_rad-6.7,-50,50]) cube([100,100,100], center=true);
                    }
                    translate([hotend_x+fan_x-5,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole, h=.3);
                }
                
                
                
                
                translate([hotend_x+fan_x-5,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole, h=wall+1+5);
            }
            cylinder(r1=hot_rad+wall+wall, r2=hot_rad+wall+wall+wall, h=thickness+wall, $fn=facets);
            translate([-(hot_rad+thickness*2),0,0]) cylinder(r=hot_rad+thickness*2+wall, h=thickness+wall*10, center=true, $fn=facets);
            translate([0,-5+hotend_y/2,0])cube([100,10,wall]);
        }
    }
}



