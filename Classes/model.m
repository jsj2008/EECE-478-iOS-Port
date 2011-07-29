//
//  model.m
//  openGL_tut
//
//  Created by J L on 11-02-15.
//  Copyright 2011 Home. All rights reserved.
//

#import "model.h"

@interface model()
bool isComment(NSString * line);
bool isVerticesStart(NSString * line);
bool isVerticesEnd(NSString * line);
bool isTrianglesStart(NSString * line);
bool isTrianglesEnd(NSString * line);
bool isTexturesStart(NSString * line);
bool isTexturesEnd(NSString * line);
bool isNameStart(NSString * line);
bool isNameEnd(NSString * line);
@end

@implementation model

@synthesize name;
@synthesize numVertices;
@synthesize modelVertices;
@synthesize modelTriangles;
@synthesize numTextures;
@synthesize textureFileNames;

-(Vertex3D) getVertex:(int)index
{
	NSValue * boxedVertex = [self.modelVertices objectAtIndex:index];
	Vertex3D v_temp;
	if (strcmp([boxedVertex objCType], @encode(Vertex3D)) == 0) {
		[boxedVertex getValue:&v_temp];
	}
	return v_temp;
}

-(Triangle3D) getTriangle:(int)index
{
	NSValue * boxedTriangle = [self.modelTriangles objectAtIndex:index];
	Triangle3D t_temp;
	if (strcmp([boxedTriangle objCType], @encode(Triangle3D)) == 0) {
		[boxedTriangle getValue:&t_temp];
	}
	return t_temp;
}

-(id)init
{
	if(self = [super init])
	{
		modelVertices = [[NSMutableArray alloc] init];
		modelTriangles = [[NSMutableArray alloc] init];
		textureFileNames = [[NSMutableArray alloc] init];
	}
	return self;
}

-(GLuint *)textureNameStorage
{
	return textureNameStorage;
}

-(bool)loadModel:(NSString*)filePath
{
	NSString * fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];	
	NSArray * contentLines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

	if ([contentLines count] == 0) {
		return FALSE;
	}
	
	NSMutableString * line;

	for (int i = 0; i<[contentLines count]; i++) {		
		
		line = [contentLines objectAtIndex:i];
		
		// assign model name
		if (isNameStart(line)) {
			
			i++;
			line = [contentLines objectAtIndex:i];
			
			while ([line length] == 0) {
				i++;
				line = [contentLines objectAtIndex:i];
				self.name = line;
			}
			
			NSLog(@"Name found:");
			//NSLog(self.name);
			continue;
		}
		
		// found comment
		if (isComment(line)) {
			NSLog(@"Comment found");
			continue;
		}
		
		/* Parse Vertices */
		if (isVerticesStart(line)) {
			
			NSLog(@"Vertices Start found");
			
			while (!isVerticesEnd(line)) {
				i++;
				line = [contentLines objectAtIndex:i];
				
				if (!isComment(line) && [line length] > 0 && !isVerticesEnd(line)) {
					//NSArray * vertexTokenized = [[line componentsSeparatedByString:@" "] mutableCopy];			
					NSArray * vertexTokenized = [line componentsSeparatedByString:@" "];					
					Vertex3D tempVertex = Vertex3DMake([[vertexTokenized objectAtIndex:0] floatValue], [[vertexTokenized objectAtIndex:1] floatValue], [[vertexTokenized objectAtIndex:2] floatValue]);
					NSValue * boxedVertex3D = [NSValue valueWithBytes:&tempVertex objCType:@encode(Vertex3D)]; // box up Vertex3D object
					[self.modelVertices addObject:boxedVertex3D];
					
					//free(vertexTokenized);
				}
			}

		}
		
		/* Parse Textures */
		if (isTexturesStart(line)) {
			NSLog(@"Textures Start found");
			
			while(!isTexturesEnd(line)){
				i++;
				line = [contentLines objectAtIndex:i];
				
				if (!isComment(line) && [line length] > 0 && !isTexturesEnd(line)) {
					[self.textureFileNames addObject:line];
				}
			}
				  
		}
		
		/* Parse Triangles */
		if (isTrianglesStart(line)) {
			NSLog(@"Triangles Start found");
			NSArray * triangleTokenized;
			
			while (!isTrianglesEnd(line)) {
			
			i++;
			line = [contentLines objectAtIndex:i];
			
				if (!isComment(line) && [line length] > 0 && !isTrianglesEnd(line)) {
					
					triangleTokenized = [line componentsSeparatedByString:@" "];
					//NSString * emptyStr = [triangleTokenized objectAtIndex:3];
					//[triangleTokenized removeObjectIdenticalTo:emptyStr];
					Triangle3D tempTriangle;
					// get vertices from vertices list
					Vertex3D v1;
					Vertex3D v2;
					Vertex3D v3;
					
					NSValue * boxedV1 = [self.modelVertices objectAtIndex:[[triangleTokenized objectAtIndex:0] intValue]];
					NSValue * boxedV2 = [self.modelVertices objectAtIndex:[[triangleTokenized objectAtIndex:1] intValue]];
					NSValue * boxedV3 = [self.modelVertices objectAtIndex:[[triangleTokenized objectAtIndex:2] intValue]];
					
					if (strcmp([boxedV1 objCType], @encode(Vertex3D)) == 0)
						[boxedV1 getValue:&v1];
					if (strcmp([boxedV2 objCType], @encode(Vertex3D)) == 0)
						[boxedV2 getValue:&v2];
					if (strcmp([boxedV3 objCType], @encode(Vertex3D)) == 0)
						[boxedV3 getValue:&v3];
					
					tempTriangle.v1 = v1;
					tempTriangle.v2 = v2;
					tempTriangle.v3 = v3;
					
					// set normal vector
					tempTriangle.normal = Vertex3DMake([[triangleTokenized objectAtIndex:3] floatValue], [[triangleTokenized objectAtIndex:4] floatValue], [[triangleTokenized objectAtIndex:5] floatValue]);
					// texture index num
					tempTriangle.textNum = [[triangleTokenized objectAtIndex:6] intValue];
					// text coords
					tempTriangle.t1.s = [[triangleTokenized objectAtIndex:7] floatValue];
					tempTriangle.t1.t = [[triangleTokenized objectAtIndex:8] floatValue];
					tempTriangle.t2.s = [[triangleTokenized objectAtIndex:9] floatValue];
					tempTriangle.t2.t = [[triangleTokenized objectAtIndex:10] floatValue];
					tempTriangle.t3.s = [[triangleTokenized objectAtIndex:11] floatValue];
					tempTriangle.t3.t = [[triangleTokenized objectAtIndex:12] floatValue];
					// box up Triangle3D object
					NSValue * boxedTriangle3D = [NSValue valueWithBytes:&tempTriangle objCType:@encode(Triangle3D)]; 
					[self.modelTriangles addObject:boxedTriangle3D];
					
				}
				
			}
			
		}
		
	}
	
	self.numTextures = [self.textureFileNames count];
	
	return TRUE;
}

bool isComment(NSString * line)
{
	if (![line length] == 0) {
		if ([line characterAtIndex:0] == '#') {
			return TRUE;
		}
		else {
			return FALSE;
		}

	}
	else {
		return FALSE;
	}

}

bool isVerticesStart(NSString * line)
{
	if ([line isEqualToString:@"<vertices>"]) {
		return TRUE;
	}
	else {
		return FALSE;
	}

}

bool isVerticesEnd(NSString * line)
{
	if ([line isEqualToString:@"</vertices>"]) {
		return TRUE;
	}
	else {
		return FALSE;
	}
}

bool isTrianglesStart(NSString * line)
{
	if ([line isEqualToString:@"<triangles>"]) {
		return TRUE;
	}
	else {
		return FALSE;
	}
}

bool isTrianglesEnd(NSString * line)
{
	if ([line isEqualToString:@"</triangles>"]) {
		return TRUE;
	}
	else {
		return FALSE;
	}
}

bool isTexturesStart(NSString * line)
{
	if ([line isEqualToString:@"<textures>"]) {
		return TRUE;
	}
	else {
		return FALSE;
	}
}

bool isTexturesEnd(NSString * line)
{
	if ([line isEqualToString:@"</textures>"]) {
		return TRUE;
	}
	else {
		return FALSE;
	}
}

bool isNameStart(NSString * line)
{
	if ([line isEqualToString:@"<name>"]) {
		return TRUE;
	}
	else {
		return FALSE;
	}
}

bool isNameEnd(NSString * line)
{
	if ([line isEqualToString:@"</name>"]) {
		return TRUE;
	}
	else {
		return FALSE;
	}
}
	
@end
