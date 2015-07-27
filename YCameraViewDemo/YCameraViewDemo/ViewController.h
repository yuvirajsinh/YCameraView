//
//  ViewController.h
//  YCameraViewDemo
//
//  Created by yuvraj on 27/07/15.
//  Copyright (c) 2015 rapidops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YCameraView/YCameraViewController.h>

@interface ViewController : UIViewController <YCameraViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

