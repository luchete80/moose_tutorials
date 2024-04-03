//GMSH project
lc = 1.0e-3;
ld = 0.5e-3;
thck = 3.0e-4;
Point(1)  = {0.0,0.0   ,0.0,lc}; 
Point(2)  = {0.001,0.0   ,0.0,lc}; 
Point(3)  = {0.0,  0.0125-0.001,0.0,lc};
Point(4)  = {0.001,0.0125-0.001,0.0,lc};
Point(5)  = {0.0,0.0125-0.0005,0.0,lc};
Point(6)  = {0.0005,0.0125,0.0,lc};
Point(7)  = {0.0 ,0.0125,0.0,lc};
Point(8)  = {0.001 ,0.0125,0.0,lc};
Point(9)  = {0.005, 0.0, 0.0, lc};
Point(10) = {0.005, 0.0125, 0.0, lc};

Point(11) = {0.005, 0.0125-0.001, 0.0, lc};

//Point(11) = {0.05, 0.0, 0.0, lc};
//Point(12) = {0.05, 0.0125, 0.0, lc};

// From https://chi-tech.github.io/d4/db9/_gmsh_example_01.html
//The "Transfinite Line" command is used. This command specifies opposing faces of the four sided
// shapes we will apply a structured mesh to and also how many grid points will be used when drawing mesh lines between the two defined faces. 
//"Using Progression 1" indicates that the structured mesh should have uniform grading. 
//Note that in the outer region of the geometry, "Using Progression 0.85" is used. 
//This causes the meshing to be graded. Also note the input "Transfinite Line {-77, 79}" where the negative sign ensures that both lines have the same orientation which is required when using a grading. Test the input without this and see that the grading is flipped on one side.

//After the transfinite lines are specified, each surface is specified to be mesh with a structured mesh by the syntax "Transfinite Surface {i}". Lastly, "Recombine Surface "*";" is included to specify that the mesh be made up of quadrilaterials. If this input is not included, then gmsh will create a mesh of structured triangles.

Line(1)  = {1,2};
Line(2)  = {2,4};
Line(3)  = {4,3};
Line(4)  = {3,1};

Transfinite Line {1,3} = 10;
Transfinite Line {2,4} = 30;

Line(5)   = {3,5};
Circle(6) = {5, 7, 6};
Line(7)   = {6,8};
Line(8)   = {8,4};

Transfinite Line {5,6,7,8} = 10;


Line(9)   = {2,9};
Line(10)  = {9,11};
Line(11)  = {11,10};
Line(12)  = {10,8};
Line(13)  = {11,4};

Transfinite Line {9,11} = 10; //Top next to znotch

Transfinite Line {10} = 30; //As  2and 4, Top next to znotch

Transfinite Line {12,13,9} = 10; //bottom

//Transfinite Line {12,13} = 10; //bottom

Curve Loop(1) = {1,2,3,4};
Surface(1) = {1};

Transfinite Surface{1};

Curve Loop(2) = {5,6,7,8,3};
Plane Surface(2) = {2};

//Transfinite Surface{2};

//Curve Loop(3) = {9,10,11,12,8,-2};
//Plane Surface(3) = {3};
Curve Loop(3) = {-2,9,10,13};
Surface(3) = {3};
Transfinite Surface{3};

Curve Loop(4) = {-13,11,12,8};
Surface(4) = {4};

//Transfinite Surface{3};

//Transfinite Surface{3};

Recombine Surface "*";


Extrude {0,0,thck} {Surface{1}; Layers{2};Recombine ;}
Extrude {0,0,thck} {Surface{2}; Layers{2};Recombine ;}
Extrude {0,0,thck} {Surface{3}; Layers{2};Recombine ;}
Extrude {0,0,thck} {Surface{4}; Layers{2};Recombine ;}

/*//+*/
Show "*";

/*//+*/
Physical Surface("left",    1) = {74,45};
Physical Surface("bottom",  2) = {22,75};
Physical Surface("back",    3) = {1,2,3,4};

Physical Volume("vol1", 1) = {1};
Physical Volume("vol2", 2) = {2};
Physical Volume("vol3", 3) = {3};
Physical Volume("vol4", 4) = {4};
//+

