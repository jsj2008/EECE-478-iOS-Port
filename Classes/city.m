//
//  city.m
//  EECE478_iOS_Port
//
//  Created by J L on 11-02-17.
//  Copyright 2011 Home. All rights reserved.
//

#import "city.h"

@interface city()
bool isCommentCity(NSString * line);
@end

@implementation city

@synthesize modelStructList;
@synthesize numModels;

bool isCommentCity(NSString * line)
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
 

-(id)init
{
	if(self = [super init])
	{
		modelList = [[NSMutableArray alloc] init];
	}
	return self;
}

-(bool)loadCity:(NSString*)filePath
{
	NSString * fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];	
	NSArray * contentLines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	if ([contentLines count] == 0) {
		return FALSE;
	}
	
	NSMutableString * line;
	bool studentNumFlag = FALSE;
	bool cityNameFlag = FALSE;
	bool modelNumFlag = FALSE;
	int modelListIndex = 0;
	
	for (int i = 0; i < [contentLines count]; i++){
	
		line = [contentLines objectAtIndex:i];
		
		if (isCommentCity(line)) {
			continue;
		}
		
		if ([line isEqualToString:@""] || [line isEqualToString:@"\n"]) {
			continue;
		}
		
		if (!studentNumFlag) {
			studentNumFlag = TRUE;
			continue;
		}
		
		if (studentNumFlag && !cityNameFlag) {
			cityNameFlag = TRUE;
			continue;
		}
		
		if (studentNumFlag && cityNameFlag && !modelNumFlag) {
			self.numModels = [line integerValue];
			self.modelStructList = malloc(sizeof(modelTriple) * self.numModels);
			modelNumFlag = TRUE;
			continue;
		}
		
		if (studentNumFlag && cityNameFlag && modelNumFlag) {
			NSArray * lineTokenized = [line componentsSeparatedByString:@" "];
			NSArray * pathTokenized = [[lineTokenized objectAtIndex:0] componentsSeparatedByString:@"/"];
			
			self.modelStructList[modelListIndex].modelDirName = [pathTokenized objectAtIndex:0];
			self.modelStructList[modelListIndex].modelFileName = [pathTokenized objectAtIndex:1];
			
			self.modelStructList[modelListIndex].scale[0] = [[lineTokenized objectAtIndex:1] floatValue];
			self.modelStructList[modelListIndex].scale[1] = [[lineTokenized objectAtIndex:2] floatValue];
			self.modelStructList[modelListIndex].scale[2] = [[lineTokenized objectAtIndex:3] floatValue];
			
			self.modelStructList[modelListIndex].rotate[0] = [[lineTokenized objectAtIndex:4] floatValue];
			self.modelStructList[modelListIndex].rotate[1] = [[lineTokenized objectAtIndex:5] floatValue];
			self.modelStructList[modelListIndex].rotate[2] = [[lineTokenized objectAtIndex:6] floatValue];
			
			self.modelStructList[modelListIndex].translate[0] = [[lineTokenized objectAtIndex:7] floatValue];
			self.modelStructList[modelListIndex].translate[1] = [[lineTokenized objectAtIndex:8] floatValue];
			self.modelStructList[modelListIndex].translate[2] = [[lineTokenized objectAtIndex:9] floatValue];
			
			modelListIndex++;
		}
	
	}
	
	NSString * resPath = [[NSBundle mainBundle] resourcePath];
	
	// parse models in
	for (int j = 0; j < self.numModels; j++)
	{
		NSString * modelPath = [NSString stringWithFormat:@"%@/%@/%@", resPath, self.modelStructList[j].modelDirName, self.modelStructList[j].modelFileName];
		self.modelStructList[j].m = [[model alloc] init];
		[self.modelStructList[j].m loadModel:modelPath];
	}
	
	return TRUE;
}
@end
