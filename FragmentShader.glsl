//fragment========================================
#version 330

layout(location = 0) out vec4 Color;

//Buit in (inputs):
//in vec4 gl_FragCoord;		//Aktuelle Position
//in bool gl_FrontFacing;
//in vec2 gl_PointCoord;	//Hat vermutlich nur was bei GL_POINTS zu tun

//7uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform int       iFrame;                // shader playback frame

in vec3 oInterpolatedPos;
//flat in vec2 oFlatPos;

void Circle(vec3 CirclePos, float Radius)
{
	if(length(oInterpolatedPos - CirclePos) < Radius && length(oInterpolatedPos - CirclePos) > Radius*0.9)
	{
		Color = vec4(1,0,0,1);
	}
}

void Bubble(vec3 CirclePos, float Radius)
{
	CirclePos = CirclePos;
	float i = float(iFrame)/1000;
	i = mod(i, 0.9);
	Circle(CirclePos+vec3(i,-i,0), Radius);
}

void main()
{
	Color = vec4(0.4,0.5,0,1); //Background
	if(oInterpolatedPos.x + oInterpolatedPos.y > 0.95)
	{
		Color = vec4(1,1,1,1);
	}
	if(oInterpolatedPos.y + oInterpolatedPos.z > 0.95)
	{
		Color = vec4(1,1,1,1);
	}
	if(oInterpolatedPos.z + oInterpolatedPos.x > 0.95)
	{
		Color = vec4(1,1,1,1);
	}
	Circle(vec3(0.5,0.5,0.5),0.5);
	Bubble(vec3(0,0.5,0.5),0.2);
}
//==============================================

