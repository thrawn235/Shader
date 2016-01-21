//fragment========================================
#version 330

layout(location = 0) out vec4 diffuseColor;

//Buit in (inputs):
//in vec4 gl_FragCoord;		//Aktuelle Position
//in bool gl_FrontFacing;
//in vec2 gl_PointCoord;	//Hat vermutlich nur was bei GL_POINTS zu tun

//7uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform uint       iFrame;                // shader playback frame

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

void Flake()
{
	int height = mod(iFrame, 480);
	Circle(height, 240, 30);
}

void main()
{
	diffuseColor = vec4(1,0,1,1);
	if(gl_FragCoord.x < iFrame)
	{
		diffuseColor = vec4(1,1,0,1);
	}
	Flake();
}
//==============================================

