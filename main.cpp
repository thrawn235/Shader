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
#include <glm/gtx/rotate_vector.hpp>
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

vector<vec3> ReadObj(string Filepath)
{
	FILE* File = fopen(Filepath.c_str(), "r"); 
	
	vector<vec3>FileVertices;
	vector<vec3>Vertices;
	
	while(true)
	{
		char LinePrefix[256];	//char* geht nicht -.-
		int Result = fscanf(File ,"%s", LinePrefix);
		//cout<<LinePrefix<<" ";
		if(Result == EOF)
		{
			break;
		}
		if(strcmp(LinePrefix, "v") == 0)
		{
			//cout<<"Vertex found";
			vec3 Vertex;
			fscanf(File, "%f %f %f\n", &Vertex.x, &Vertex.y, &Vertex.z);
			//cout<<Vertex.x<<" "<<Vertex.y<<" "<<Vertex.z<<endl;
			FileVertices.push_back(Vertex);
		}
		if(strcmp(LinePrefix, "f") == 0)
		{
			//cout<<"Face found";
			int V1,V2,V3;
			fscanf(File, "%i %i %i\n", &V1, &V2, &V3);
			//cout<<V1<<" "<<V2<<" "<<V3<<endl;
			Vertices.push_back(FileVertices[V1-1]);
			Vertices.push_back(FileVertices[V2-1]);
			Vertices.push_back(FileVertices[V3-1]);
		}
		
	}
	return Vertices;
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
	GLuint PerspectiveMatrixLocation = glGetUniformLocation(ProgramID, "iPerspectiveMatrix");
	GLuint ViewMatrixLocation = glGetUniformLocation(ProgramID, "iViewMatrix");
	GLuint RotationMatrixLocation = glGetUniformLocation(ProgramID, "iRotationMatrix");
	
	glEnable(GL_DEPTH_TEST);
	// Accept fragment if it closer to the camera than the former one
	glDepthFunc(GL_LESS);
	
	//prepare Vertex Buffer: ------------------------------------
	vector<vec3> Vertices;
	
	Vertices.push_back(vec3(-0.5, -0.5, 0));
	Vertices.push_back(vec3( 0, 0.5, 0));
	Vertices.push_back(vec3( 0.5, -0.5, 0));
	
	
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
		
		//Create Perspective Matrix
		mat4 PerspectiveMatrix = perspective(45.0f, float(640/480), 0.1f, 100.0f);
		//Create Viewport Matrix
		mat4 ViewMatrix = lookAt(vec3(0,0,-10), vec3(0,0,0), vec3(0,1,0));
		//Create Rotation Matrix
		vec3 Direction(0,0,1);
		Direction = rotate(Direction, (float)Frames/50, vec3(0,1,0));
		mat4 RotationMatrix = glm::orientation(Direction, vec3(0,1,0));
		
		glUseProgram(ProgramID);
		glUniform1i(FramesLocation, Frames);
		glUniformMatrix4fv(PerspectiveMatrixLocation, 1, GL_FALSE, &PerspectiveMatrix[0][0]);
		glUniformMatrix4fv(ViewMatrixLocation, 1, GL_FALSE, &ViewMatrix[0][0]);
		glUniformMatrix4fv(RotationMatrixLocation, 1, GL_FALSE, &RotationMatrix[0][0]);
		
		glEnableVertexAttribArray(0);
		glVertexAttribPointer(0,3, GL_FLOAT, GL_FALSE, 0, 0);
		glDrawArrays(GL_TRIANGLES, 0, Vertices.size());
		
		SDL_GL_SwapWindow(Window);
		Frames++;
	}
	
	cout<<"Shutting down..."<<endl;
	//Aufraumen...
	return 0;
}
