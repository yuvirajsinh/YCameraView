//
//  ViewController.h
//  YCameraViewDemo
//
//  Created by yuvraj on 08/01/14.
//  Copyright (c) 2014 yuviraj.jadeja@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YCameraView/YCameraViewController.h>

@interface ViewController : UIViewController <YCameraViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

