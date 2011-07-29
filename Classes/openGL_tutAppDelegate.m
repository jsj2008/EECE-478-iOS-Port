//
//  openGL_tutAppDelegate.m
//  openGL_tut
//
//  Created by J L on 11-02-14.
//  Copyright Home 2011. All rights reserved.
//

#import "openGL_tutAppDelegate.h"
#import "GLView.h"

city * c;

@interface openGL_tutAppDelegate()
void loadTexturesIntoMemory(texture * tex, model * m, GLuint names[], NSString * modelDir);
@end

@implementation openGL_tutAppDelegate

@synthesize window;
@synthesize glView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	glView.animationInterval = 1.0 / kRenderingFrequency;
	
	NSString * filePath = @"";
	NSString * fileRoot = [[NSBundle mainBundle] pathForResource:filePath ofType:@"city"];
	NSString * resPath = [[NSBundle mainBundle] resourcePath];
	c = [[city alloc] init];
	
	[c loadCity:fileRoot];
	
	
	for (int cnt = 0; cnt < [c numModels]; cnt++) {
		texture tmp;
		NSString * modelPath = [NSString stringWithFormat:@"%@/%@/", resPath, c.modelStructList[cnt].modelDirName];
		loadTexturesIntoMemory(&tmp, c.modelStructList[cnt].m, [c.modelStructList[cnt].m textureNameStorage], modelPath);
	}
	
	
	[glView startAnimation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / kInactiveRenderingFrequency;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / 60.0;
}


- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

unsigned char * Read(NSString * filename, int * width, int * height)
{
	FILE *ifp;
	char buffer[80];
	int i;
	int header[3]; // width, height, maxval
	int tmp;
	
	// Warning - Number of references to this class might cause problems when reading images
	
	ifp = fopen([filename UTF8String], "rb");
	if( !ifp ) {
		NSLog(@"Error opening texture file");
		return nil;
	}
	
	i = 0;
	fgets(buffer, 80, ifp);
	if( strncmp(buffer, "P6", 2) ) {
		fclose(ifp);
		NSLog(@"File is not PPM format");
		return nil;
	}
	
	while( (i < 3) ) {
		if( (tmp=fgetc(ifp)) == '#' ) {
			fgets(buffer, 80, ifp); // read out comment
			continue;
		} else {
			ungetc(tmp, ifp);
			fscanf(ifp, "%d", &header[i++]);
		}
	}
	fgets(buffer, 80, ifp); // read to newline
	
	// Renew image
	*width = header[0];
	*height = header[1];
	unsigned char * img = malloc(sizeof(char) * (*width) * (*height) * 3);
	
	fread(img, 3, (*width) * (*height), ifp);
	
	fclose(ifp);
	return img;
}

void loadTexturesIntoMemory(texture * tex, model * m, GLuint names[], NSString * modelDir)
{
	int cnt = 0;
	NSString * texName;
	NSString * fileName;
	glGenTextures(m.numTextures, [m textureNameStorage]);
	
	for (cnt = 0; cnt < m.numTextures; cnt++) {
		texName = [[m textureFileNames] objectAtIndex:cnt];
		fileName = [NSString stringWithFormat:@"%@/%@", modelDir, texName];
		tex->data = Read(fileName, &(tex->width), &(tex->height));
		
		glBindTexture(GL_TEXTURE_2D, *([m textureNameStorage] +cnt ));
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST_MIPMAP_NEAREST);	// Mipmap Filtering
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);	// Linear Filtering
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);	// Linear Filtering
		
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, tex->width, tex->height, 0, GL_RGB, GL_UNSIGNED_BYTE, tex->data);
		
		//NSLog(texName);
		
		// don't forget to delete tex->data
		free(tex->data);
	}
}


@end
