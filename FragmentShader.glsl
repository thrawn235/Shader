//fragment========================================
#version 330

layout(location = 0) out vec4 Color;

//Buit in (inputs):
//in vec4 gl_FragCoord;		//Aktuelle Position
//in bool gl_FrontFacing;
//in vec2 gl_PointCoord;	//Hat vermutlich nur was bei GL_POINTS zu tun

//7uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform int       iFrame;                // shader playback frame

in vec2 oInterpolatedPos;
flat in vec2 oFlatPos;

void Circle(vec2 CirclePos, float Radius)
{
	if(length(oInterpolatedPos - CirclePos) < Radius && length(oInterpolatedPos - CirclePos) > Radius*0.9)
	{
		Color = vec4(1,1,1,1);
	}
}

void Bubble(float PosX, float StartPosY)
{
	float Fract = float(iFrame);
	Fract = Fract/480;
	Fract = mod(Fract, 2.0+0.6);
	Circle(vec2(PosX, -1.3+Fract), 0.3);
}

void main()
{
	Color = vec4(0.4,0.5,0,1); //Background
	
	if(oInterpolatedPos.x < -0.5)
	{
		Color = vec4(1,0,0,1);
	}
	if(oInterpolatedPos.x > 0.5)
	{
		Color = vec4(0,1,0,1);
	}
	Circle(vec2(0.5,0.5), 0.2);
	Circle(vec2(0,0), 0.4);
	
	Bubble(-0.3, 1);
}
//==============================================

