//
//  model.h
//  openGL_tut
//
//  Created by J L on 11-02-15.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLCommon.h"

typedef struct {
	unsigned char * data;
	int width;
	int height;
} texture;

@interface model : NSObject {
	NSString * name;
	int numVertices;
	NSMutableArray * modelVertices;
	NSMutableArray * modelTriangles;
	int numTextures;
	NSMutableArray * textureFileNames;
	GLuint textureNameStorage[50];
}

-(id)init;
-(bool)loadModel:(NSString*)filePath;
-(GLuint *)textureNameStorage;
-(Vertex3D) getVertex:(int) index;
-(Triangle3D) getTriangle:(int)index;

@property (nonatomic, retain) NSString * name;
@property (readwrite, assign) int numVertices;
@property (nonatomic, retain) NSMutableArray * modelVertices;
@property (nonatomic, retain) NSMutableArray * modelTriangles;
@property (readwrite, assign) int numTextures;
@property (nonatomic, retain) NSMutableArray * textureFileNames;

@end
