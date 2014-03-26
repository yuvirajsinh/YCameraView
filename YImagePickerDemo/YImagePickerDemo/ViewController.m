//
//  ViewController.m
//  YImagePickerDemo
//
//  Created by yuvraj on 26/03/14.
//  Copyright (c) 2014 rapidops. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button clicks

- (IBAction)takePhoto:(id)sender{
    YCameraViewController *camController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
    camController.delegate=self;
    [self presentViewController:camController animated:YES completion:^{
        // completion code
    }];
}


#pragma mark - YCameraViewController Delegate
- (void)didFinishPickingImage:(UIImage *)image{
    [self.imageView setImage:image];
}

- (void)yCameraControllerdidSkipped{
    [self.imageView setImage:nil];
}

- (void)yCameraControllerDidCancel{
    
}
@end
