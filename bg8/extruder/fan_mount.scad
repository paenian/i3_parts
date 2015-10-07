

hot_rad = 30/2/cos(30);
hotend_x=25;
fan_x = 15;

hotend_y=-5;

thickness = 10;
wall=2.5;

fan_hole = 38/2;
fan_z = fan_hole+wall;

fan_mount();

%cylinder(r=hot_rad, h=20, center=true);

module fan_mount(){
    difference(){
        union(){
            //core
            cylinder(r1=hot_rad+thickness+wall, r2=hot_rad+thickness*2+wall, h=thickness+wall, $fn=6);
            
            hull(){
                intersection(){
                    cylinder(r1=hot_rad+thickness+wall, r2=hot_rad+thickness*2+wall, h=thickness+wall, $fn=6);
                    translate([50+hot_rad,0,50]) cube([100,100,100], center=true);
                }
                translate([hotend_x+fan_x,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole+wall, h=.1);
            }
        }
        
        //center cutout
        translate([0,0,-.5]) cylinder(r=hot_rad+wall, h=thickness+wall+1, $fn=6);
        
        //front cutout
        translate([-(hot_rad+thickness*2+wall),0,0]) cylinder(r=hot_rad+thickness*2+wall, h=thickness+wall*10, center=true, $fn=6);
        
        //air path
        translate([0,0,-.1]) difference(){
            union(){
                cylinder(r1=hot_rad+thickness, r2=hot_rad+thickness*2, h=thickness, $fn=6);
                hull(){
                    intersection(){
                        cylinder(r1=hot_rad+thickness, r2=hot_rad+thickness*2, h=thickness, $fn=6);
                        translate([50+hot_rad+wall,0,50+wall]) cube([100,100,100], center=true);
                    }
                    translate([hotend_x+fan_x,hotend_y,fan_z]) rotate([0,90,0]) cylinder(r=fan_hole, h=.3, center=true);
                }
            }
            cylinder(r=hot_rad+wall+wall, h=thickness+wall, $fn=6);
            translate([-(hot_rad+thickness*2),0,0]) cylinder(r=hot_rad+thickness*2+wall, h=thickness+wall*10, center=true, $fn=6);
        }
    }
}



