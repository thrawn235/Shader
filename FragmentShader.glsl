//fragment========================================
#version 330

layout(location = 0) out vec4 Color;

//Buit in (inputs):
//in vec4 gl_FragCoord;		//Aktuelle Position
//in bool gl_FrontFacing;
//in vec2 gl_PointCoord;	//Hat vermutlich nur was bei GL_POINTS zu tun

//7uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform int       iFrame;                // shader playback frame
uniform vec3 iLight;
uniform mat4 iRotationMatrix;

in vec3 oInterpolatedPos;
in vec3 iNormal;
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
	float CosTheta = dot(iRotationMatrix*vec4(iNormal, 1), vec4(iLight,1));
	Color = vec4(CosTheta,CosTheta,CosTheta,1); //Background
	if(oInterpolatedPos.x + oInterpolatedPos.y > 0.99)
	{
		Color = vec4(1,1,1,1);
	}
	if(oInterpolatedPos.y + oInterpolatedPos.z > 0.99)
	{
		Color = vec4(1,1,1,1);
	}
	if(oInterpolatedPos.z + oInterpolatedPos.x > 0.99)
	{
		Color = vec4(1,1,1,1);
	}
}
//==============================================

