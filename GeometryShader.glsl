//============= Geometry Shader ==============
#version 330
layout(triangles) in;
layout(line_strip, max_vertices = 6) out;

uniform mat4 iPerspectiveMatrix;
uniform mat4 iViewMatrix;
uniform mat4 iRotationMatrix;

out vec3 oInterpolatedPos;

in Vertex
{
	vec3 normal;
}vertex[];

void main()
{
    gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*gl_in[0].gl_Position;
    oInterpolatedPos = vec3(1,0,0);
    EmitVertex();
    
	gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*gl_in[1].gl_Position;
	oInterpolatedPos = vec3(0,1,0);
    EmitVertex();
    
    gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*gl_in[2].gl_Position;
    oInterpolatedPos = vec3(0,0,1);
    EmitVertex();

    EndPrimitive();
    
    /*gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*gl_in[0].gl_Position;
    EmitVertex();
    gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*(gl_in[0].gl_Position+vec4(vertex[0].normal,0));
    EmitVertex();
    EndPrimitive();
    
    gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*gl_in[1].gl_Position;
    EmitVertex();
    gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*(gl_in[1].gl_Position+vec4(vertex[1].normal,0));
    EmitVertex();
    EndPrimitive();
    
     gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*gl_in[2].gl_Position;
    EmitVertex();
    gl_Position =  iPerspectiveMatrix*iViewMatrix*iRotationMatrix*(gl_in[2].gl_Position+vec4(vertex[2].normal,0));
    EmitVertex();
    EndPrimitive();*/
}
//==========================================
