//
//  GLViewController.h
//  openGL_tut
//
//  Created by J L on 11-02-14.
//  Copyright Home 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"
#import "city.h"

@interface GLViewController : UIViewController <GLViewDelegate>
{

}
void drawAxis();
void drawGrid(GLfloat unitSize, int sideLength);
void drawModel(model * m, GLuint texNames[]);
@end
