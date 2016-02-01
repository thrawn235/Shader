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
uniform vec3 iCamPos;

in vec3 oNormalizedPos;
in vec3 oNormal;
in vec3 oColor;
in vec3 oLightDirection;

void main()
{
	Color = vec4(1,1,1,1);
	
	vec4 CamPos = vec4(iCamPos,1);
	CamPos = iViewMatrix*CamPos;
	CamPos = iPerspectiveMatrix*CamPos;
	
	float Brightness = 0; 
	float AmbientComponent = 0.05;
	float DiffuseComponent = clamp(dot(oLightDirection, oNormal),0,1);
	float SpecularComponent = pow(clamp(dot(normalize(CamPos.xyz),reflect(-oLightDirection, oNormal)), 0,1),5);
	
	Brightness = AmbientComponent + SpecularComponent + DiffuseComponent;
	
	Color = vec4(oColor*Brightness,1);
}
//==============================================

