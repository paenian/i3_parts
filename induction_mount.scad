slop = .2;

ind_r = 18/2+slop;
ind_washer_r = 30/2+slop;
ind_y_offset = 10;
ind_x_offset = 5;


screw_y_sep = 66;
screw_rad = 4/2+slop;
screw_cap_rad = 7/2+slop;
nut_rad = 8.9/2+slop;

wall = 4;
rotate([0,-90,0]) 
induction_mount();

module induction_mount(){
	difference(){
		union(){
			//Mount to extruder
			hull(){
				for(i=[0,screw_y_sep])
					translate([0,0,i]) rotate([0,90,0]) cylinder(r=screw_cap_rad+wall, h=wall);

				//sensor mount
				translate([ind_washer_r+wall,0,ind_y_offset]) cylinder(r=ind_r+wall, h=wall*2);

				//beef up around the mount
				translate([ind_r+wall,0,ind_y_offset+wall]) cube([(ind_r+wall)*2,(ind_r+wall)*2, wall*2],center=true);
			}
		}
	
		//screwholes
		for(i=[0,screw_y_sep]){
			translate([-.1,0,i]) rotate([0,90,0]) cylinder(r=screw_rad, h=wall*2);
			translate([wall/2,0,i]) rotate([0,90,0]) cylinder(r=nut_rad, h=wall*2, $fn=6);
		}

		//sensor cutout
		translate([ind_washer_r+wall,0,0]) cylinder(r=ind_r, h=200,center=true);
		
		//washer cutouts
		translate([ind_washer_r+wall,0,ind_y_offset+wall])
		for(i=[0,1]) mirror([0,0,i])
			translate([0,0,wall]) cylinder(r=ind_washer_r, h=100);

	
	}
}