Several color conversion and graphic tools to play around with 

There are mainly three functionalities
1) conversion between color spaces (RGB, HSV, HSL, XYZ, xyY, Lab), here nothing new
2) Constructing 3D meshes of cubes and cylinders based on either rectangles or triangles
3) Intersecting a 3D mesh with a section plane. 

The latter is used to create a constant L (Lab) section and mapping it back to RGB space.

----------
Contents:
----------

geometric\

A number of patch primitives:
- getRectangleMesh(nx,ny): a nx x ny patch of rectangles in [0..1]x[0..1] or of triangles.
- getCubeMesh(n,meshType): 6 faces of a cube returned into vertex and faces matrixes
                           each face is a n x n rectangular patch from getRectangleMesh
                           this is used to define an RGB color space with a fixed value
- getCubeSolidMesh       : Not just the outer 6 faces, but depending on n, also the internal ones.
                           E.g. for n=5 there will be 3 shells with sides 1,3,5 one inside the other.
                           This is useful to construct a solid RGB color space.
- getCilinderMesh        : useful to construct a primitive space for HSL or HSV.
- intersectMeshPlane     : given a generic triangular patch of a 3D solid, return the perimeter section (1D curve) with a given plane
                           Useful to compute a constant L section in Lab, where the Lab solid is the image of an RGB primitive
- makeUniformPerimeter   : downsample and/or upsample points along a perimeter with linear interpolation. A little too simple, but effective.
- perimeter_2_mesh       : convert a planar perimeter into a planar patch in 3D

conversions\

Color space conversion scripts, RGB,HSV,HSL,XYZ,xyY,Lab.
testbench: testConversions.m 

Format is not compatible with an RGB image which is a 3D matrix. The format is an Nx3 matrix where each row is one color.
This format is compatible with a vetrex matrix from a patch.

It is possible to make a wrapper that converts 3D images in this format, and back but I did not make one since the purpose of this package is to
study color spaces as such, not to apply conversions on images, for which there are plenty of tools out there.


plotting\

Nothing special here, basically auxiliary functions to add textbook type of axis (arrows departing from origin), draw curved arrows, link rotations, etc.
One function is worth mentioning,

placefig(figNr,m,n,k) 

which resizes a figure to fit in a grid of mxn figures on the screen in position k.



MAIN scripts (demos)

HSV_HSL_solids.m
-----------------
Shows three rows : RGB HSV HSL
where 
in row 1 the primitive is RGB, and its mappings to HSV and to HSL
in row 2 the primitive is HSV, and its mappings to RGB and to HSL
in row 3 the primitive is HSL, and its mappings to RGB and to HSV

Motivation here was to visualize how a constant value has higher lightness at low saturation.


RGB_cube_2_Lab_XYZ_xyY_HSV.m
-----------------------------
The name says it all. From a primitive RGB cube the other spaces are plotted, and one can rotate them around (set if you wish hideAxis=0), and see the shapes in the different domains.


RGB_cube_2_Lab_PLaneIntersect.m
-----------------------------
Here the idea was to create constant lightness sections in Lab and see the locus in RGB space. A number of slices are shown in both domains.
A primitive RGB space is mapped to Lab, using triangular meshes; then it is mapped to Lab, and intersected with a plane L=L0; then it is mapped back to RGB.


