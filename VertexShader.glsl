//============= Vertex Shader ==============
#version 330
layout(location = 0) in vec3 iVertex;
layout(location = 1) in vec3 iNormal;

uniform mat4 iPerspectiveMatrix;
uniform mat4 iViewMatrix;
uniform mat4 iRotationMatrix;

out Vertex
{
	vec3 normal;
}vertex;

void main()
{
	vertex.normal = iNormal;
	gl_Position = vec4(iVertex, 1);
}
//==========================================
