//GMSH project
lc = 1e-3;
thck = 3.0e-4;
Point(1) = {0.0,0.0   ,0.0,lc}; 
Point(2) = {0.001,0.0   ,0.0,lc}; 
Point(3) = {0.0,  0.0125-0.001,0.0,lc};
Point(4) = {0.001,0.0125-0.001,0.0,lc};
Point(5) = {0.0,0.0125-0.0005,0.0,lc};
Point(6) = {0.0005,0.0125,0.0,lc};
Point(7) = {0.0 ,0.0125,0.0,lc};
Point(8) = {0.001 ,0.0125,0.0,lc};

Line(1)  = {1,2};
Line(2)  = {2,4};
Line(3)  = {4,3};
Line(4)  = {3,1};

Line(5)   = {3,5};
Circle(6) = {5, 7, 6};
Line(7)   = {6,8};
Line(8)   = {8,4};


Curve Loop(1) = {1,2,3,4};
Plane Surface(1) = {1};

Curve Loop(2) = {5,6,7,8,3};
Plane Surface(2) = {2};

Extrude {0,0,thck} {Surface{1}; Layers{2};}
Extrude {0,0,thck} {Surface{2}; Layers{2};}


//+
Show "*";

//+
Physical Surface("left", 1)   = {29,40};
Physical Surface("bottom", 2) = {13};
Physical Surface("back", 3)   = {1};
//+
Surface Loop(1) = {26, 13, 1, 17, 21, 25};
//+
//Volume(2) = {1};
// HAS TO BE STABLISHED A VOLUME IN ORDER TO KEEP THE ELEMENTS
Physical Volume("vol1", 1) = {1};
Physical Volume("vol2", 2) = {2};
//+

