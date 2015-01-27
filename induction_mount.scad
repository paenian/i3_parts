slop = .2;
$fn=60;

//hotend stuff
hotend_rad = 18/2+slop;

//standard stuff
bolt_slop = .5;
nut_slop = .85;
bolt_dia = 5+bolt_slop;
bolt_rad = bolt_dia/2;
bolt_cap_dia = 10+bolt_slop;
bolt_cap_rad = bolt_cap_dia/2;
nut_dia = 9+nut_slop;
nut_rad = nut_dia/2;
nut_height = 3.25;
lock_nut_height = 5.25;

m3_nut_rad = 6/cos(30)/2;
m3_nut_height = 3;
m3_rad = 1.8;
m3_cap_rad = 3.25;

632_dia = 3.5;
632_rad = 632_dia/2+slop;
632_nut_rad = 8.25/cos(45)/2;
632_cap_dia = 6.5;
632_cap_rad = 632_cap_dia/2+slop;
632_cap_height = 2+slop;
632_nut_height = 5;

ind_r = 18/2+slop;
ind_washer_r = 30/2+slop;
ind_y_offset = 10;
ind_x_offset = 5;


screw_y_sep = 66;
screw_rad = 4/2+slop*2;
screw_cap_rad = 7/2+slop*2;
nut_rad = 8.9/2+slop;

wall = 4;
//rotate([0,-90,0]) 
induction_mount2();

module induction_mount2(){
	height = 13;
	notch_h = 6-1.5;
	notch = 2;
	offset = 6;
	difference(){
		union(){
			translate([0,-hotend_rad-offset/2,height/2]) hull(){
				cube([hotend_rad*2+wall,offset,height], center=true);
				translate([0,hotend_rad+offset/2,0]) cube([hotend_rad*2+wall,offset,height], center=true);
			}
			extruder_mount(1, m_height=height);
		}
		extruder_mount(0, m_height=height);

		//screw holes
		translate([0,-hotend_rad-offset-.1,height-screw_cap_rad+.1]){
			rotate([-90,0,0]) cap_cylinder(r=screw_rad, h=30);
			rotate([-90,0,0]) translate([0,0,notch+2]) cap_cylinder(r=screw_cap_rad, h=wall*2);
			
			//this makes the protrusion into the bearing slot
			translate([0,0,height/2-notch_h]) cube([hotend_rad*2+wall*2,notch*2,height], center=true);
		}		
	}
}

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

module extruder_mount(solid = 1, m_height = 10, m_thickness=50, fillet = 8, tap_height=0, width=20){
	gap = 2;
	tap_dia = 9.1;
	tap_rad = tap_dia/2;
	
	clamp_offset = 1.5;

	if(solid){		
		//clamp material
		if(m_height > nut_rad*2){
			cylinder(r=(hotend_rad+wall)/cos(30), h=m_height, $fn=6);
			translate([hotend_rad+bolt_rad+clamp_offset,gap,m_height/2]) rotate([-90,0,0]) cylinder(r=m_height/2/cos(30), h=wall+1, $fn=6);
			translate([hotend_rad+bolt_rad+clamp_offset,-wall-1,m_height/2]) rotate([-90,0,0]) cylinder(r=m_height/2/cos(30), h=wall+1, $fn=6);
		}
	}else{
		union(){
			//hotend hole
			translate([0,0,-.05]) cylinder(r=hotend_rad/cos(180/18)+.1, h=m_height+20, $fn=36);

			//bolt slots
			if(m_height > nut_rad*2){
				render() translate([hotend_rad+bolt_rad+clamp_offset,-m_thickness-.05,m_height/2]) rotate([-90,0,0]) cap_cylinder(r=632_rad, h=m_thickness+10);
				translate([hotend_rad+bolt_rad+clamp_offset,-wall*2-1,m_height/2]) rotate([-90,0,0]) cylinder(r=632_nut_rad, h=wall, $fn=4);

				//mount tightener
				translate([hotend_rad+bolt_rad+clamp_offset,wall+gap+1,m_height/2]) rotate([-90,0,0]) cylinder(r=632_cap_rad, h=10);
				translate([0,0,-.05]) cube([wall*5, gap, m_height+.1]);
			}
		}
	}
}

module cap_cylinder(r=1, h=1, center=false){
	render() union(){
		cylinder(r=r, h=h, center=center);
		intersection(){
			rotate([0,0,22.5]) cylinder(r=r/cos(180/8), h=h, $fn=8, center=center);
			translate([0,-r/cos(180/4),0]) rotate([0,0,0]) cylinder(r=r/cos(180/4), h=h, $fn=4, center=center);
		}
	}
}
