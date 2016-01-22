//============= Geometry Shader ==============
#version 330
layout(points) in;
layout(triangle_strip, max_vertices = 4) out;

out vec4[4] oVertices;

void main()
{
    gl_Position = gl_in[0].gl_Position + vec4(-0.4,  0.4, 0.0, 0.0);
    oVertices[0] = gl_Position;
    EmitVertex();
	gl_Position = gl_in[0].gl_Position + vec4( 0.4,  0.4, 0.0, 0.0);
	oVertices[1] = gl_Position;
    EmitVertex();
    gl_Position = gl_in[0].gl_Position + vec4(-0.4, -0.4, 0.0, 0.0);
    oVertices[2] = gl_Position;
    EmitVertex();
    gl_Position = gl_in[0].gl_Position + vec4( 0.4, -0.4, 0.0, 0.0);
    oVertices[3] = gl_Position;
    EmitVertex();


    EndPrimitive();
}
//==========================================
