//fragment========================================
#version 330

layout(location = 0) out vec4 diffuseColor;

//Buit in (inputs):
//in vec4 gl_FragCoord;		//Aktuelle Position
//in bool gl_FrontFacing;
//in vec2 gl_PointCoord;	//Hat vermutlich nur was bei GL_POINTS zu tun

//7uniform vec3      iResolution;           // viewport resolution (in pixels)
//uiform int       iFrame;                // shader playback frame

void Circle(int PosX, int PosY, int Radius)
{
	vec4 CircPos;
	CircPos.x = PosX;
	CircPos.y = PosY;
	if(length(CircPos - gl_FragCoord) < Radius)
	{
		diffuseColor = vec4(1,0,0,1);
	}
}

void main()
{
	diffuseColor = vec4(1,0,1,1);
	Circle(200,200,50);
	Circle(500, 100, 100);
	Circle(150, 500, 75);
}
//==============================================

