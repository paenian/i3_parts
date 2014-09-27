// Box size
boxwidth = 50;
boxlength = 111;
boxheight = 45;
boxwall = 2;
facewall = 3;

// Plug outlet hole

plugholesep = 40;
plugholerad = 2.6;
plugwidth= 28.5;
pluglength = 47;
plugheight = 6;
plugbevel = 6;

offsetx = 10.75;
offsety = 55;
offsetz = 1.6;
clearance = 1.5;

// Clip ridges

clipdiameter = 3;
clipspacing = 4;
clipfirst = 3;
cliptop = 12.5;
clipbottom = 36.5;

// Cable exit 
cutoutoffsetx = 18;
cutoutoffsety = 8;
cableoutwidth = 16;
cableoutheight = 8;
cableoffsety = 5;
cableoffsetx = 46;

slop = .2;
m5bolt_dia = 5;
m5bolt_rad = m5bolt_dia/2+slop;
m5bolt_cap_dia = 10+slop;
m5bolt_cap_rad = m5bolt_cap_dia/2;
m5nut_dia = 9.2;
m5nut_rad = m5nut_dia/2+slop;
m5nut_height = 3.25;
lock_nut_height = 5.25;

$fn=32;

module clip(height,diameter,spacing)
{
	translate ([0,-.25,0]) scale([1,.75,1]) rotate ([0,90,0]) cylinder (r=diameter/2, h=height);
	translate ([0,-.25,spacing]) scale([1,.75,1]) rotate ([0,90,0]) cylinder (r=diameter/2, h=height);
}

module bevelbox(width,length,height,bevel)
{
	translate([0,0,-.1]) linear_extrude (height = height+.1) polygon([[0,bevel],[bevel,0],[length,0],[length,width],[bevel,width],[0,width-bevel]], convexity=1);

	translate ([0,0,offsetz]) linear_extrude (height = height) polygon([[0-clearance,bevel-clearance],[bevel-clearance,0-clearance],[length+clearance,0-clearance],[length+clearance,width+clearance],[bevel-clearance,width+clearance],[0-clearance,width-bevel+clearance]], convexity=1);

	for(i=[-1,1]) translate([length/2+1,width/2+i*plugholesep/2,-.1]) {
		cylinder(r=plugholerad, h=height+1);
		translate([0,0,offsetz]) cylinder(r=m5nut_rad, h=height, $fn=6);
		translate([0,0,height+offsetz-.05]) cylinder(r1=m5nut_rad, r2=m5nut_rad-2, h=height, $fn=6);
	}
}

module casing(w,l,h,t)
{
	walls = t*2;
	difference () {
		cube ([w,l,h]);
		translate ([t,t,facewall]) cube ([w-walls,l-walls,h]);
	}
}

module vent(w, l, h, r, n=5){
	ws = w/n;
	ls = l/n;
	for(i=[0:n-1]) hull(){
		translate([ws/2+i*ws, ls/2, -.1]) cylinder(r=r, h=h+1);
		translate([ws/2, ls/2+i*ls, -.1]) cylinder(r=r, h=h+1);
	}
	for(i=[1:n-1]) hull(){
		translate([ws/2+i*ws, l-ls/2, -.1]) cylinder(r=r, h=h+1);
		translate([w-ws/2, ls/2+i*ls, -.1]) cylinder(r=r, h=h+1);
	}
}

module clearance(w,l,h,o)
{
	translate ([-1,-1,o]) cube([w+2,l+2,h]);
}

difference () {
	casing (boxwidth,boxlength,boxheight,boxwall);

	translate ([boxwidth-offsetx,offsety,0]) rotate ([0,0,90]) bevelbox(plugwidth,pluglength,plugheight,plugbevel);
	translate ([cableoffsety,boxlength/2-(cableoutheight/2)-cableoffsetx,-.1]) cube([cableoutheight,cableoutwidth,boxwall+2]);
	clearance (cutoutoffsety,boxlength,boxheight,boxheight-cutoutoffsetx);

	translate([cableoffsety+boxwall+cableoutheight,boxwall,0]) vent(34.75-boxwall,52.5,5,1.75,5);
}

translate ([boxwidth-clipbottom,0,clipdiameter/2+boxheight-clipfirst-(clipdiameter*2)-clipspacing]) clip (clipbottom-cliptop,clipdiameter,clipspacing+clipdiameter);

translate ([boxwidth-clipbottom,boxlength,clipdiameter/2+boxheight-clipfirst-(clipdiameter*2)-clipspacing]) clip (clipbottom-cliptop,clipdiameter,clipspacing+clipdiameter);

