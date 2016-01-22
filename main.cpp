//Standard Includdes:
#include <iostream>				//cout<<
#include <vector>				//vector<>
#include <string>				//string
#include <fstream>
#include <math.h>				//sqrt(); sin(); cos() ...
using namespace std;
//SDL2 include:
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <GL/glew.h>
#include <SDL2/SDL_opengl.h>
//OpenGL Includes:
//#include <GL/gl.h>
//glm includes:
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
using namespace glm;

string ReadFile(char* Filepath)
{
	string Output;
	
	ifstream File;
	File.open(Filepath);
	string Line = "";
	while(getline(File, Line))
	{
		Output.append(Line);
		Output.append("\n");
	}
	File.close();
	//cout<<"Read: "<<Output<<endl;
	return Output;
}

void PrintShaderErrors(GLuint ShaderID)
{
	int Result = 0;
	GLsizei length = 0;
	glGetShaderiv(ShaderID, GL_COMPILE_STATUS, &Result);
	cout<<"Result = "<<Result<<endl;
	glGetShaderiv(ShaderID, GL_SHADER_SOURCE_LENGTH, &Result);
	cout<<"SourceLength = "<<Result<<endl;
	glGetShaderiv(ShaderID, GL_INFO_LOG_LENGTH, &Result);
	cout<<"LogLenght = "<<Result<<endl;
	vector<char> Error(Result+1);
	glGetShaderInfoLog(ShaderID, Result, &length, &Error[0]);
	cout<<&Error[0]<<endl;
}

GLuint LoadShaders()
{
	cout<<"Starting to load Shaders..."<<endl;
	cout<<"Create Shader Variables"<<endl;
	GLuint VertexShaderID = glCreateShader(GL_VERTEX_SHADER);
	GLuint FragmentShaderID = glCreateShader(GL_FRAGMENT_SHADER);
	GLuint GeometryShaderID = glCreateShader(GL_GEOMETRY_SHADER);
	GLuint ProgramID = glCreateProgram();

	cout<<"Read Vertex Source from File..."<<endl;
	string VertexSourceBuffer = ReadFile("VertexShader.glsl");
	const char* VertexSource = VertexSourceBuffer.c_str();
	cout<<"Load VertexShader Source in GL..."<<endl;
	glShaderSource(VertexShaderID, 1, &VertexSource, NULL);
	cout<<"Compile Vertex Shader..."<<endl;
	glCompileShader(VertexShaderID);
	cout<<"Vertex Shader Compile Log:"<<endl;
	PrintShaderErrors(VertexShaderID);
	
	cout<<"Read Fragment Source From File..."<<endl;
	string FragmentSourceBuffer = ReadFile("FragmentShader.glsl");
	char const* FragmentSource = FragmentSourceBuffer.c_str();
	cout<<"Load FragmentShader Source in GL..."<<endl;
	glShaderSource(FragmentShaderID, 1, &FragmentSource, NULL);
	cout<<"Compile Fragment Shader..."<<endl;
	glCompileShader(FragmentShaderID);
	cout<<"Fragment Shader Compile Log:"<<endl;
	PrintShaderErrors(FragmentShaderID);
	
	cout<<"Read Geometry Source From File..."<<endl;
	string GeometrySourceBuffer = ReadFile("GeometryShader.glsl");
	char const* GeometrySource = GeometrySourceBuffer.c_str();
	cout<<"Load GeometryShader Source in GL..."<<endl;
	glShaderSource(GeometryShaderID, 1, &GeometrySource, NULL);
	cout<<"Compile Geometry Shader..."<<endl;
	glCompileShader(GeometryShaderID);
	cout<<"Geometry Shader Compile Log:"<<endl;
	PrintShaderErrors(GeometryShaderID);
	
	cout<<"Link Shader Program..."<<endl;
	glAttachShader(ProgramID, VertexShaderID);
	glAttachShader(ProgramID, FragmentShaderID);
	glAttachShader(ProgramID, GeometryShaderID);
	glLinkProgram(ProgramID);
	
	cout<<"Cleanup. Clear unneeded Variables..."<<endl;
	glDetachShader(ProgramID, VertexShaderID);
	glDetachShader(ProgramID, FragmentShaderID);
	glDetachShader(ProgramID, GeometryShaderID);
	glDeleteShader(VertexShaderID);
	glDeleteShader(FragmentShaderID);
	glDeleteShader(GeometryShaderID);
	
	cout<<"Loading Shaders Complete!"<<endl;
	return ProgramID;
}

int main()
{
	cout<<"Start Execution"<<endl;
	
	//SDL Init: -----------------------------
	cout<<"SDL Init..."<<endl;
	SDL_Init(SDL_INIT_EVERYTHING);
	
	cout<<"SDL set GL Attributes..."<<endl;
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
	//SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
	
	cout<<"SDL create Window..."<<endl;
	SDL_Window* Window;
	Window = SDL_CreateWindow("test", 100, 100, 640, 480, SDL_WINDOW_OPENGL);
	cout<<"SDL: create GL context..."<<endl;
	SDL_GLContext* Context;
	SDL_GL_CreateContext(Window);
	
	cout<<"GLEW Init..."<<endl;
	glewExperimental = true;
	glewInit();
	//---------------------------------------
	
	cout<<"Load Shaders..."<<endl;
	GLuint ProgramID = LoadShaders();
	GLuint FramesLocation = glGetUniformLocation(ProgramID, "iFrame");
	
	//prepare Vertex Buffer: ------------------------------------
	vector<vec3> Vertices;
	Vertices.push_back(vec3(-0.9, 0.9,0));
	Vertices.push_back(vec3( 0.9, 0.9,0));
	Vertices.push_back(vec3(-0.9,-0.9,0));
	Vertices.push_back(vec3( 0.9,-0.9,0));
	
	GLuint VertexArrayID;
	glGenVertexArrays(1, &VertexArrayID);
	glBindVertexArray(VertexArrayID);
	
	GLuint VerticesBuffer;
	glGenBuffers(1, &VerticesBuffer);
	glBindBuffer(GL_ARRAY_BUFFER, VerticesBuffer);
	glBufferData(GL_ARRAY_BUFFER, Vertices.size() * sizeof(vec3), &Vertices[0], GL_STATIC_DRAW); 
	//--------------------------------------------------------
	
	
	cout<<"Start Main Loop..."<<endl;
	unsigned int Frames = 1;
	while(true)
	{
		glClearColor(0,0.3,0.3,1);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		
		glUseProgram(ProgramID);
		glUniform1i(FramesLocation, Frames);
		
		glEnableVertexAttribArray(0);
		glVertexAttribPointer(0,3, GL_FLOAT, GL_FALSE, 0, 0);
		glDrawArrays(GL_POINTS, 0, Vertices.size());
		
		SDL_GL_SwapWindow(Window);
		Frames++;
	}
	
	cout<<"Shutting down..."<<endl;
	//Aufraumen...
	return 0;
}
