//============= Geometry Shader ==============
#version 330
layout(triangles) in;
layout(line_strip, max_vertices = 24) out;

uniform mat4 iPerspectiveMatrix;
uniform mat4 iViewMatrix;
uniform mat4 iRotationMatrix;
uniform vec3 iLight;


out vec3 oInterpolatedPos;
out vec3 iNormal;
out vec3 oColor;

in Vertex
{
	vec3 normal;
}vertex[];

void main()
{	
	//----- Model Space -------
	//Rotate
	vec4 Vertex1 = iRotationMatrix*gl_in[0].gl_Position;
	vec4 Vertex2 = iRotationMatrix*gl_in[1].gl_Position;
	vec4 Vertex3 = iRotationMatrix*gl_in[2].gl_Position;
	
	vec4 Normal1 = iRotationMatrix*vec4(vertex[0].normal,0);
	vec4 Normal2 = iRotationMatrix*vec4(vertex[1].normal,0);
	vec4 Normal3 = iRotationMatrix*vec4(vertex[2].normal,0);
	//Move
	//nothing to move right now
	//----- World Space -------
	vec4 LightPos = vec4(iLight,1);
	
	//Camera
	Vertex1 = iViewMatrix*Vertex1;
	Vertex2 = iViewMatrix*Vertex2;
	Vertex3 = iViewMatrix*Vertex3;
	Normal1 = iViewMatrix*Normal1;
	Normal2 = iViewMatrix*Normal2;
	Normal3 = iViewMatrix*Normal3;
	LightPos = iViewMatrix*LightPos;
	//Perspective
	Vertex1 = iPerspectiveMatrix*Vertex1;
	Vertex2 = iPerspectiveMatrix*Vertex2;
	Vertex3 = iPerspectiveMatrix*Vertex3;
	Normal1 = iPerspectiveMatrix*Normal1;
	Normal2 = iPerspectiveMatrix*Normal2;
	Normal3 = iPerspectiveMatrix*Normal3;
	LightPos = iPerspectiveMatrix*LightPos;
	
	//sollte ich nicht brauchen!!!
	Normal1 = normalize(Normal1);
	Normal2 = normalize(Normal2);
	Normal3 = normalize(Normal3);
	
	//Draw Light:
	gl_Position = LightPos - vec4(-0.1, -0.1, 0, 0);
	oColor = vec3(1,1,0);
    EmitVertex();
	gl_Position = LightPos - vec4(-0.1,  0.1, 0, 0);
	oColor = vec3(1,1,0);
    EmitVertex();
    gl_Position = LightPos - vec4( 0.1,  0.1, 0, 0);
    oColor = vec3(1,1,0);
    EmitVertex();
    gl_Position = LightPos - vec4( 0.1, -0.1, 0, 0);
    oColor = vec3(1,1,0);
    EmitVertex();
    gl_Position = LightPos - vec4(-0.1, -0.1, 0, 0);
    oColor = vec3(1,1,0);
    EmitVertex();
    EndPrimitive();
    
    //Draw Light Vectors:
    /*gl_Position = Vertex1;
    oColor = vec3(0.1, 0.1, 0);
    EmitVertex();
    gl_Position = Vertex1 + vec4(0.01, 0, 0, 0);
    oColor = vec3(0.1, 0.1, 0);
    EmitVertex();
    gl_Position = LightPos;
    oColor = vec3(0.5, 0.1, 0);
    EmitVertex();
    EndPrimitive();*/
    
    gl_Position = Vertex1;
    oColor = vec3(0.1, 0.1, 0.5);
    EmitVertex();
    gl_Position = Vertex1 + vec4(0.01, 0, 0, 0);
    oColor = vec3(0.1, 0.1, 0.5);
    EmitVertex();
    gl_Position = normalize(LightPos)+Vertex1;
    oColor = vec3(1, 1, 0.5);
    EmitVertex();
    EndPrimitive();
	
	//Draw Vertices:
    gl_Position = Vertex1;
    oColor = vec3(1,1,1);
    EmitVertex();
	gl_Position = Vertex2;
	oColor = vec3(1,1,1);
    EmitVertex();
    gl_Position = Vertex3;
    oColor = vec3(1,1,1);
    EmitVertex();
    EndPrimitive();
    
    //Draw Normals:
    gl_Position = Vertex1;
    oColor = vec3(0.1,0,0);
    EmitVertex();
    gl_Position = Vertex1 + vec4(0.01, 0, 0, 0);
    oColor = vec3(0,0,0);
    EmitVertex();
    gl_Position = Normal1+Vertex1;
    oColor = vec3(1,0,0);
    EmitVertex();
    EndPrimitive();
    
    gl_Position = Vertex2;
    oColor = vec3(0.1,0,0);
    EmitVertex();
    gl_Position = Vertex2 + vec4(0.01, 0, 0, 0);
    oColor = vec3(0,0,0);
    EmitVertex();
    gl_Position = Normal2+Vertex2;
    oColor = vec3(0.5,0,0);
    EmitVertex();
    EndPrimitive();
    
    gl_Position = Vertex3;
    oColor = vec3(0.1,0,0);
    EmitVertex();
    gl_Position = Vertex3 + vec4(0.01, 0, 0, 0);
    oColor = vec3(0,0,0);
    EmitVertex();
    gl_Position = Normal3+Vertex3;
    oColor = vec3(0.5,0,0);
    EmitVertex();
    EndPrimitive();
}
//==========================================
