//============= Vertex Shader ==============
#version 330
layout(location = 0) in vec3 iVertex;

uniform mat4 iPerspectiveMatrix;
uniform mat4 iViewMatrix;
uniform mat4 iRotationMatrix;

void main()
{
	gl_Position = iPerspectiveMatrix*iViewMatrix*iRotationMatrix*vec4(iVertex, 1);
}
//==========================================
