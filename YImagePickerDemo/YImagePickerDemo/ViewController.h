//
//  ViewController.h
//  YImagePickerDemo
//
//  Created by yuvraj on 26/03/14.
//  Copyright (c) 2014 rapidops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCameraViewController.h"

@interface ViewController : UIViewController <YCameraViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
