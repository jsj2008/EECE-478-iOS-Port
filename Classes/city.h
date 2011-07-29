//
//  city.h
//  EECE478_iOS_Port
//
//  Created by J L on 11-02-17.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "model.h";

typedef struct {
	GLfloat scale[3];
	GLfloat rotate[3];
	GLfloat translate[3];
	
	NSString * modelDirName;
	NSString * modelFileName;
	model * m;
} modelTriple;


@interface city : NSObject {
	NSMutableArray * modelList;
	int numModels;
	modelTriple * modelStructList;
}

-(id)init;
-(bool)loadCity:(NSString*)filePath;

@property (readwrite, assign) modelTriple * modelStructList;
@property (readwrite, assign) int numModels;

@end
