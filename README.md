YCameraView
===========

![Version](https://img.shields.io/badge/pod-v1.1.0-green.svg) ![License](http://img.shields.io/badge/license-MIT-orange.png)

Custom Camera Controller

YCameraviewController is a custom Image picker controller that allows you to quickly switch between Camera and iPhone Photo Library.
This Controller only useful for capturing Square Image.

Required Framework
==================

AVFoundation.framework

ImageIO.framework

CoreMotion.framework

## Installation

#### [CocoaPods](http://cocoapods.org)

```objc
pod 'YCameraView', '~> 1.1.0'
````

How to Use it
=============

Import "YCameraViewController.h" in your ViewController.h file where you want to use this.
```objc
#import "YCameraViewController.h"

@interface ViewController : UIViewController <YCameraViewControllerDelegate>

@end
```
In ViewController.m file

To open YCameraViewController
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

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=TLYC7S2GS34A4&name=os0=Coffe)
