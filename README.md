YCameraView
===========

Custom Camera Controller

YCameraviewController is a custom Image picker controller that allows you to quickly switch between Camera and iPhone Photo Library.
This Controller only useful for capturing Square Image.

Required Framework
==================

AVFoundation.framework

How to Use it
=============

Import "YCameraViewController.h" in your ViewController.h file where you want to use this.

e.x
```objc
import "YCameraViewController.h"

@interface ViewController : UIViewController <YCameraViewControllerDelegate>

@end
```
In ViewController.m file

To opne YCameraViewController
```objc
YCameraViewController *camController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
camController.delegate=self;
[self presentViewController:camController animated:YES completion:^{
    // completion code
}];
```
Using YCameraViewControllerDelegate
```objc
-(void)didFinishPickingImage:(UIImage *)image{
    // Use image as per your need
}
-(void)yCameraControllerdidSkipped{
    // Called when user clicks on Skip button on YCameraViewController view
}
-(void)yCameraControllerDidCancel{
    // Called when user clicks on "X" button to close YCameraViewController
}
```
