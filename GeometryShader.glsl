//============= Geometry Shader ==============
#version 330
layout(triangles) in;
layout(line_strip, max_vertices = 12) out;

uniform mat4 iPerspectiveMatrix;
uniform mat4 iViewMatrix;
uniform mat4 iRotationMatrix;
uniform vec3 iLight;


out vec3 oInterpolatedPos;
out vec3 iNormal;

in Vertex
{
	vec3 normal;
}vertex[];

void main()
{	
	vec4 Vertex1 = iPerspectiveMatrix*iViewMatrix*iRotationMatrix*gl_in[0].gl_Position;
	vec4 Vertex2 = iPerspectiveMatrix*iViewMatrix*iRotationMatrix*gl_in[1].gl_Position;
	vec4 Vertex3 = iPerspectiveMatrix*iViewMatrix*iRotationMatrix*gl_in[2].gl_Position;
	
	vec4 LightPos = iPerspectiveMatrix*iViewMatrix*vec4(iLight, 1);
	
    gl_Position = Vertex1;
    EmitVertex();
    
	gl_Position = Vertex2;
    EmitVertex();
    
    gl_Position = Vertex3;
    EmitVertex();

    EndPrimitive();
    
    
    gl_Position = Vertex1;
    EmitVertex();
    
    gl_Position = Vertex1+vec4(0.01, 0, 0, 1);
    EmitVertex();
    
    vec4 LightDirection = LightPos - Vertex1;
    gl_Position = LightDirection.xyz;
    EmitVertex();
    
    EndPrimitive();
    
    /*gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*gl_in[1].gl_Position;
    EmitVertex();
    gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*(gl_in[1].gl_Position+vec4(0.01, 0, 0, 0));
    EmitVertex();
    gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*(gl_in[1].gl_Position+vec4(vertex[1].normal/3,0));
    EmitVertex();
    EndPrimitive();
    
     gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*gl_in[2].gl_Position;
    EmitVertex();
    gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*(gl_in[2].gl_Position+vec4(0.01, 0, 0, 0));
    EmitVertex();
    gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*(gl_in[2].gl_Position+vec4(vertex[2].normal/3,0));
    EmitVertex();
    EndPrimitive();*/
}
//==========================================
