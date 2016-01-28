//fragment========================================
#version 330

layout(location = 0) out vec4 Color;

//Buit in (inputs):
//in vec4 gl_FragCoord;		//Aktuelle Position
//in bool gl_FrontFacing;
//in vec2 gl_PointCoord;	//Hat vermutlich nur was bei GL_POINTS zu tun

uniform int iFrame;                // shader playback frame
uniform mat4 iPerspectiveMatrix;
uniform mat4 iViewMatrix;
uniform mat4 iRotationMatrix;
uniform vec3 iLight;

in vec3 oInterpolatedPos;
in vec3 oNormal;
in vec3 oColor;
in vec3 oLightDirection;

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
	Color = vec4(1,1,1,1);
	
	float Brightness = clamp(dot(oLightDirection, oNormal),0,1);
	
	Color = vec4(oColor*Brightness,1);
}
//==============================================

