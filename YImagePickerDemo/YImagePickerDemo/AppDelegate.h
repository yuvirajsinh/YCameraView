//
//  AppDelegate.h
//  YImagePickerDemo
//
//  Created by yuvraj on 26/03/14.
//  Copyright (c) 2014 rapidops. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SET_DEFAULT_CAMERA_AS_FRONT YES

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
