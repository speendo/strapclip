/* Buckle */
$fn = 100;


thickness = 5; //mm
roundness = 3; //mm

width = 30; //mm

strapWidth = 40; //mm

strap1Thickness = 4; //mm
strap2Thickness = 0; //mm

treshhold = 1; //mm

opening1 = 5; //mm
opening2 = 0; //mm

opening1Position = 0.5; //share
opening2Position = 0.01; //share

module makeouter() {
	strap2Thickness =   strap2Thickness == 0 ? strap1Thickness : strap2Thickness;
	opening2 = opening2 == 0 ? opening1 : opening2;

	innerHeight = strapWidth + 2 * treshhold;

	outerWidth = 3 * thickness + strap1Thickness + strap2Thickness + 4 * treshhold;
	outerHeight = 2 * thickness + innerHeight;
	
	strapHoleHeight = strapWidth + 2 * treshhold + thickness;

	strapHole1Width = strap1Thickness + 2 * treshhold + thickness;
	strapHole2Width = strap2Thickness + 2 * treshhold + thickness;
	
	opening1Height = opening1 + 2 * treshhold;
	opening2Height = opening2 + 2 * treshhold;
	
	placeOpening1 = thickness + (innerHeight - opening1Height) * (1 - opening1Position);
	placeOpening2 = thickness + (innerHeight - opening2Height) * (1 - opening2Position);

	difference() {
		difference() {
			cube([outerWidth, outerHeight, width]);
			union() {
				translate([-thickness/2,0,0]) {
					vRoundPlus(outerHeight, width, thickness);
				}
				translate([outerWidth + thickness/2,0,0]) {
					mirror([1,0,0]) {
						vRoundPlus(outerHeight, width, thickness);
					}
				}
				hRoundPlus(outerWidth, width, thickness);
				translate([0,outerHeight,0]) {
					mirror([0,1,0]) {
						hRoundPlus(outerWidth, width, thickness);
					}
				}
				translate([thickness/2,thickness/2,0]) {
					cutEdge(width, thickness,180);
				}
				translate([outerWidth - thickness/2,thickness/2,0]) {
					cutEdge(width, thickness,270);
				}
				translate([outerWidth - thickness/2,outerHeight - thickness/2,0]) {
					cutEdge(width, thickness,0);
				}
				translate([thickness/2,outerHeight - thickness/2,0]) {
					cutEdge(width, thickness,90);
				}
			}				
		}
		union() {
			translate([thickness/2,thickness/2,0]) {
				strapHole(strapHole1Width, strapHoleHeight, width, thickness);
			}
			translate([outerWidth - strapHole2Width - thickness/2,thickness/2,0]) {
				strapHole(strapHole2Width, strapHoleHeight, width, thickness);
			}
			makeOpenings(outerHeight, outerWidth, placeOpening1, placeOpening2, opening1, opening2, opening1Height, opening2Height, width, thickness);
		}
	}
}

module strapHole(strapHoleWidth, strapHoleHeight, width, thickness) {
	
	translate([0, 0, -1]) {
		difference() {
			cube([strapHoleWidth, strapHoleHeight, width + 2]);
			union() {
				vRoundMinus(strapHoleHeight, width, thickness);
				translate([strapHoleWidth,0,0]) {
					vRoundMinus(strapHoleHeight, width, thickness);
				}
				hRoundMinus(strapHoleWidth, width, thickness);
				translate([0,strapHoleHeight,0]) {
					hRoundMinus(strapHoleWidth, width, thickness);
				}
			}
		}
	}
}

module opening(opening, openingHeight, width, thickness) {
	
	translate([-1, -thickness/2, -1]) {
		difference() {
			cube([thickness + 2, openingHeight + thickness, width + 2]);
			translate([thickness/2 + 1,0,1]) {
				pillar(width, thickness);
				translate([0,openingHeight + thickness,0]) {
					pillar(width, thickness);
				}
			}
		}
	}
}

module makeOpenings(outerHeight, outerWidth, placeOpening1, placeOpening2, opening1, opening2, opening1Height, opening2Height, width, thickness) {
	difference() {
		union() {
			translate([0,placeOpening1,0]) {
				opening(opening1, opening1Height, width, thickness);
			}
			translate([outerWidth - thickness,placeOpening2,0]) {
				opening(opening2, opening2Height, width, thickness);
			}
		}
		translate([thickness/2,-1,-2]) {
			cube([outerWidth - thickness,thickness + 1,width + 4]);
		}
		translate([thickness/2,outerHeight - thickness,-2]) {
			cube([outerWidth - thickness,thickness + 1,width + 4]);
		}
	}
}

module vRoundPlus(y, z, thickness) {
	translate([-1,-1,-1]) {
		difference() {
			cube([thickness + 1, y + 2, z + 2]);
			translate([thickness + 1,0,thickness/2 + 1]) {
				rotate([-90,0,0]) {
					cylinder(d=thickness, h=y + 2);
				}
			}
			translate([thickness + 1,0,width + 1 - thickness/2]) {
				rotate([-90,0,0]) {
					cylinder(d=thickness, h=y + 2);
				}
			}
			translate([thickness/2 + 1,0,thickness/2 + 1]) {
				cube([thickness/2,y + 2,z - thickness]);
			}
		}
	}
}

module hRoundPlus(x, z, thickness) {
	translate([-1,-thickness/2 -1,-1]) {
		difference() {
			cube([x + 2, thickness + 1, z + 2]);
			translate([0,thickness + 1,thickness/2 + 1]) {
				rotate([0,90,0]) {
					cylinder(d=thickness, h=x + 2);
				}
			}
			translate([0,thickness + 1,width + 1 - thickness/2]) {
				rotate([0,90,0]) {
					cylinder(d=thickness, h=x + 2);
				}
			}
			translate([0,thickness/2 + 1,thickness/2 + 1]) {
				cube([x + 2, thickness/2,z - thickness]);
			}
		}
	}
}

module vRoundMinus(y, z, thickness) {
	translate([0,-1,thickness/2 + 1]) {
		rotate([-90,0,0]) {
			cylinder(d=thickness, h=y + 2);
		}
	}
	translate([0,-1,width + 1 - thickness/2]) {
		rotate([-90,0,0]) {
			cylinder(d=thickness, h=y + 2);
		}
	}
	translate([-thickness/2,-1,thickness/2 + 1]) {
		cube([thickness,y + 2,z - thickness]);
	}
}

module hRoundMinus(x, z, thickness) {
	translate([-1,0,thickness/2 + 1]) {
		rotate([0,90,0]) {
			cylinder(d=thickness, h=x + 2);
		}
	}
	translate([-1,0,width + 1 - thickness/2]) {
		rotate([0,90,0]) {
			cylinder(d=thickness, h=x + 2);
		}
	}
	translate([-1,-thickness/2,thickness/2 + 1]) {
		cube([x + 2,thickness,z - thickness]);
	}
}

module cutEdge(width, thickness, rotation) {
	rotate([0,0,rotation]) {
		difference() {
			translate([0,0,-1]) {
				cube([thickness,thickness,width+2]);
			}
			pillar(width, thickness);
		}
	}
}

module pillar(width, thickness) {
	union() {
		translate([0,0,thickness/2]) {
			cylinder(d=thickness, h=width-thickness);
			sphere(d=thickness);
		}
		translate([0,0,width-thickness/2]) {
			sphere(d=thickness);
		}
	}
}

makeouter();
