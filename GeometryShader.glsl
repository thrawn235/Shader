//============= Geometry Shader ==============
#version 330
layout(points) in;
layout(triangle_strip, max_vertices = 4) out;

out vec2 oInterpolatedPos;
flat out vec2 oFlatPos;

void main()
{
    gl_Position = gl_in[0].gl_Position + vec4(-0.4,  0.4, 0.0, 0.0);
    oInterpolatedPos = vec2(-1, 1);
    oFlatPos = vec2(-1, 1);
    EmitVertex();
	gl_Position = gl_in[0].gl_Position + vec4( 0.4,  0.4, 0.0, 0.0);
	oInterpolatedPos = vec2( 1, 1);
    oFlatPos = vec2( 1, 1);
    EmitVertex();
    gl_Position = gl_in[0].gl_Position + vec4(-0.4, -0.4, 0.0, 0.0);
    oInterpolatedPos = vec2(-1, -1);
    oFlatPos = vec2(-1, -1);
    EmitVertex();
    gl_Position = gl_in[0].gl_Position + vec4( 0.4, -0.4, 0.0, 0.0);
    oInterpolatedPos = vec2(1, -1);
    oFlatPos = vec2( 1, -1);
    EmitVertex();


    EndPrimitive();
}
//==========================================
