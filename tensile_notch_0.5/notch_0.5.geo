//GMSH project
lc = 1e-3;
thck = 3.0e-4;
Point(1) = {0.0,0.0   ,0.0,lc}; 
Point(2) = {0.001,0.0   ,0.0,lc}; 
Point(3) = {0.0,  0.0125-0.001,0.0,lc};
Point(4) = {0.001,0.0125-0.001,0.0,lc};

Line(1)  = {1,2};
Line(2)  = {2,4};
Line(3)  = {4,3};
Line(4)  = {3,1};


Curve Loop(1) = {1,2,3,4};
Plane Surface(1) = {1};

Extrude {0,0,thck} {Surface{1}; Layers{2};}

//+
Show "*";

//+
Physical Surface("left", 27) = {25};
Physical Surface("bottom", 28) = {13};
Physical Surface("back", 29) = {1};
//+
Surface Loop(1) = {26, 13, 1, 17, 21, 25};
//+
//Volume(2) = {1};
//+
Physical Volume("vol", 31) = {1};
