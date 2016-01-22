//fragment========================================
#version 330

layout(location = 0) out vec4 diffuseColor;

//Buit in (inputs):
//in vec4 gl_FragCoord;		//Aktuelle Position
//in bool gl_FrontFacing;
//in vec2 gl_PointCoord;	//Hat vermutlich nur was bei GL_POINTS zu tun

//7uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform int       iFrame;                // shader playback frame

in vec4 oVertices[4];

void Circle(int PosX, int PosY, int Radius)
{
	vec4 CircPos;
	CircPos.x = PosX;
	CircPos.y = PosY;
	CircPos.z = 0;
	CircPos.w = 0;
	if(length(CircPos - gl_FragCoord) < Radius && length(CircPos - gl_FragCoord) > Radius*0.9)
	{
		diffuseColor = vec4(1,0,0,1);
	}
}

void Flake(int width, int Start, int depth)
{
	int height = -(10*depth) + ((iFrame+Start)*depth)%480+2*10*depth;
	Circle(width, height, 10*depth);
}

void main()
{
	diffuseColor = vec4(1,0,1,1);
	if(gl_FragCoord.x < iFrame%640)
	{
		diffuseColor = vec4(1,1,0,1);
	}
	if(length(gl_FragCoord+oVertices[0]) < 10)
	{
		diffuseColor = vec4(1,1,1,1);
	}
	Flake(10,40,1);
	Flake(15,50,2);
	Flake(100,10,2);
	Flake(40,100,3);
	Flake(103,90,2);
	Flake(310,76,5);
	Flake(500,45,3);
	Flake(630,400,10);
	Flake(367,145,4);
	Flake(222,430,3);
}
//==============================================

