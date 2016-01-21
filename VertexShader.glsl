//============= Vertex Shader ==============
#version 330
layout(location = 0) in vec3 iVertex;

void main()
{
	gl_Position = vec4(iVertex, 1);
}
//==========================================
