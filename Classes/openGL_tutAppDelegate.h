//
//  openGL_tutAppDelegate.h
//  openGL_tut
//
//  Created by J L on 11-02-14.
//  Copyright Home 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model.h"
#import "city.h"

@class GLView;
@class model;

@interface openGL_tutAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLView *glView;

@end

