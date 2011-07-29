//
//  GLViewController.m
//  openGL_tut
//
//  Created by J L on 11-02-14.
//  Copyright Home 2011. All rights reserved.
//

#import "GLViewController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"

extern city * c;

@implementation GLViewController

void drawModel(model * mod, GLuint texNames[])
{
	Vertex3D * v_temp;
	Triangle3D t_temp;
	TextureCoord3D * tex_temp;
	Vertex3D * normalVect;
	
	for (int i=0; i < [mod.modelTriangles count]; i++) {
		
		glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);    
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);	// Linear Filtering
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);	// Linear Filtering
		
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_NORMAL_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		
		t_temp = [mod getTriangle:i];
		
		v_temp = malloc(sizeof(Vertex3D) * 3);
		Vertex3DSet(&v_temp[0], t_temp.v1.x, t_temp.v1.y, t_temp.v1.z);
		Vertex3DSet(&v_temp[1], t_temp.v2.x, t_temp.v2.y, t_temp.v2.z);
		Vertex3DSet(&v_temp[2], t_temp.v3.x, t_temp.v3.y, t_temp.v3.z);
		
		tex_temp = malloc(sizeof(TextureCoord3D) * 3);
		tex_temp[0].s = t_temp.t1.s;
		tex_temp[0].t = t_temp.t1.t;
		tex_temp[1].s = t_temp.t2.s;
		tex_temp[1].t = t_temp.t2.t;
		tex_temp[2].s = t_temp.t3.s;
		tex_temp[2].t = t_temp.t3.t;
		
		normalVect = malloc(sizeof(Vertex3D) * 3);
		Vertex3DSet(&normalVect[0], t_temp.normal.x, t_temp.normal.y, t_temp.normal.z);
		Vertex3DSet(&normalVect[1], t_temp.normal.x, t_temp.normal.y, t_temp.normal.z);
		Vertex3DSet(&normalVect[2], t_temp.normal.x, t_temp.normal.y, t_temp.normal.z);
		
		glBindTexture(GL_TEXTURE_2D, *([mod textureNameStorage] + t_temp.textNum));
		glVertexPointer(3, GL_FLOAT, 0, v_temp);
		glNormalPointer(GL_FLOAT, 0, normalVect);
		glTexCoordPointer(2, GL_FLOAT, 0, tex_temp);
		glDrawArrays(GL_TRIANGLES, 0, 9);
		
		glDisableClientState(GL_VERTEX_ARRAY);
		glDisableClientState(GL_NORMAL_ARRAY);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		
		if (v_temp != NULL) {
			free(v_temp);
		}
		if (tex_temp != NULL) {
			free(tex_temp);
		}
		if (normalVect != NULL) {
			free(normalVect);
		}
		
	}
}

void drawAxis()
{
	glMatrixMode(GL_MODELVIEW);
	
	Line3D * axisLines = malloc(sizeof(Line3D) * 3);
	Vertex3DSet(&axisLines[0].v1, 0.0f, 0.0f, 0.0f);
	Vertex3DSet(&axisLines[0].v2, 1.0f, 0.0f, 0.0f);
	Vertex3DSet(&axisLines[1].v1, 0.0f, 0.0f, 0.0f);
	Vertex3DSet(&axisLines[1].v2, 0.0f, 1.0f, 0.0f);
	Vertex3DSet(&axisLines[2].v1, 0.0f, 0.0f, 0.0f);
	Vertex3DSet(&axisLines[2].v2, 0.0f, 0.0f, 1.0f);
	
	glEnableClientState(GL_VERTEX_ARRAY); // set to draw arrays
	
	glColor4f(1.0, 0.0, 0.0, 1.0); // x = red
	glVertexPointer(3, GL_FLOAT, 0, &axisLines[0]);
	glDrawArrays(GL_LINES, 0, 2);
	
	glColor4f(0.0, 1.0, 0.0, 1.0); // y = green
	glVertexPointer(3, GL_FLOAT, 0, &axisLines[1]);
	glDrawArrays(GL_LINES, 0, 2);
	
	glColor4f(0.0, 0.0, 1.0, 1.0); // z = blue
	glVertexPointer(3, GL_FLOAT, 0, &axisLines[2]);
	glDrawArrays(GL_LINES, 0, 2);
	
	glDisableClientState(GL_VERTEX_ARRAY); // disable draw arrays (code housed in between will be draw with)
	
	if(axisLines != NULL)
		free(axisLines);
	
	return;
}

void drawGrid(GLfloat unitSize, int sideLength){
	
	glMatrixMode(GL_MODELVIEW);

	glColor4f(1.0f, 1.0f, 1.0f, 1.0); // white
	
	// zero lines
	Line3D * zeroLines = malloc(sizeof(Line3D) * 2);
	Vector3DSet(&zeroLines[0].v1, unitSize * (GLfloat)(sideLength/2), 0.0f, 0.0f);
	Vector3DSet(&zeroLines[0].v2, -unitSize * (GLfloat)(sideLength/2), 0.0f, 0.0f);
	Vector3DSet(&zeroLines[1].v1, 0.0f, 0.0f, unitSize * (GLfloat)(sideLength/2));
	Vector3DSet(&zeroLines[1].v2, 0.0f, 0.0f, -unitSize * (GLfloat)(sideLength/2));
	
	glEnableClientState(GL_VERTEX_ARRAY); // set to draw arrays
	
	glVertexPointer(3, GL_FLOAT, 0, &zeroLines[0]);
	glDrawArrays(GL_LINES, 0, 2);
	glVertexPointer(3, GL_FLOAT, 0, &zeroLines[1]);
	glDrawArrays(GL_LINES, 0, 2);
	
	if(zeroLines != NULL)
		free(zeroLines);
	
	// vertical & horizontol loops
	for(int i = sideLength/2; i--; i >= 0){
		Line3D * hLines = malloc(sizeof(Line3D) * 2);
		Vector3DSet(&hLines[0].v1, (unitSize)*(float)(sideLength/2), 0.0f, (unitSize)*(float)(sideLength/2) - i);
		Vector3DSet(&hLines[0].v2, -(unitSize)*(float)(sideLength/2), 0.0f, (unitSize)*(float)(sideLength/2) - i);
		Vector3DSet(&hLines[1].v1, (unitSize)*(float)(sideLength/2), 0.0f, -((unitSize)*(float)(sideLength/2) - i));
		Vector3DSet(&hLines[1].v2, -(unitSize)*(float)(sideLength/2), 0.0f, -((unitSize)*(float)(sideLength/2) - i));
	
		glVertexPointer(3, GL_FLOAT, 0, &hLines[0]);
		glDrawArrays(GL_LINES, 0, 2);
		glVertexPointer(3, GL_FLOAT, 0, &hLines[1]);
		glDrawArrays(GL_LINES, 0, 2);
		
		if(hLines != NULL)
			free(hLines);
	}
	
	// vertical & horizontol loops
	for(int i = sideLength/2; i--; i >= 0){
		Line3D * vLines = malloc(sizeof(Line3D) * 2);
		Vector3DSet(&vLines[0].v1, (unitSize)*(float)(sideLength/2) - i, 0.0f, (unitSize)*(float)(sideLength/2));
		Vector3DSet(&vLines[0].v2, (unitSize)*(float)(sideLength/2) - i, 0.0f, -(unitSize)*(float)(sideLength/2));
		Vector3DSet(&vLines[1].v1, -((unitSize)*(float)(sideLength/2) - i), 0.0f, (unitSize)*(float)(sideLength/2));
		Vector3DSet(&vLines[1].v2, -((unitSize)*(float)(sideLength/2) - i), 0.0f, -(unitSize)*(float)(sideLength/2));
		
		glVertexPointer(3, GL_FLOAT, 0, &vLines[0]);
		glDrawArrays(GL_LINES, 0, 2);
		glVertexPointer(3, GL_FLOAT, 0, &vLines[1]);
		glDrawArrays(GL_LINES, 0, 2);
		
		if(vLines != NULL)
			free(vLines);
	}
	
	glDisableClientState(GL_VERTEX_ARRAY); // disable draw arrays (code housed in between will be draw with)

}

- (void)drawView:(UIView *)theView
{
	
	static GLfloat rotationY = 0.0f;
	
	glColor4f(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Drawing code here
	glLoadIdentity(); // first step
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // clears color buffer and z-buffer (needed each time)
	
	glPushMatrix();
		glTranslatef(0.0f, 0.0f, -20.0f);
		// constant tilt
		glRotatef(35.0, 1.0f, 0.0f, 0.0f);
		glRotatef(rotationY, 0.0f, 1.0f, 0.0f);
		
		for (int k = 0; k < [c numModels]; k++) {
			glPushMatrix();
				//Translate
				glTranslatef(c.modelStructList[k].translate[0], c.modelStructList[k].translate[1], c.modelStructList[k].translate[2]);
				//Scale
				glScalef(c.modelStructList[k].scale[0], c.modelStructList[k].scale[1], c.modelStructList[k].scale[2]);
				//Rotate
				glRotatef(c.modelStructList[k].rotate[2], 0, 0, 1);
				glRotatef(c.modelStructList[k].rotate[1], 0, 1, 0);
				glRotatef(c.modelStructList[k].rotate[0], 1, 0, 0);
				//draw model
				drawModel(c.modelStructList[k].m, NULL);
			glPopMatrix();
		}
		drawAxis();
		drawGrid(1.0, 25);
	glPopMatrix();
	
	rotationY += 0.25f;
		
	// flush drawing routines to the window
	glFlush();
}

-(void)setupView:(GLView*)view
{
	const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0; 
	GLfloat size; 
	glEnable(GL_DEPTH_TEST);
	
	/*texture stuff*/
	glEnable(GL_TEXTURE_2D);
    //glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_SRC_COLOR);
	
	glMatrixMode(GL_PROJECTION); 
	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = view.bounds; 
	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
			   (rect.size.width / rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height);  
	glMatrixMode(GL_MODELVIEW);
	
	//glDisable(GL_LIGHTING);
	glEnable(GL_LIGHTING);
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	
	glLoadIdentity(); 
}

- (void)dealloc 
{
    [super dealloc];
}

@end
