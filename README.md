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

<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="TLYC7S2GS34A4">
<table>
<tr><td><input type="hidden" name="on0" value="Want to buy me">Want to buy me</td></tr><tr><td><select name="os0">
	<option value="Coffe">Coffe $5.00 USD</option>
	<option value="Beer">Beer $10.00 USD</option>
</select> </td></tr>
</table>
<input type="hidden" name="currency_code" value="USD">
<input type="image" src="https://www.paypalobjects.com/en_GB/i/btn/btn_buynow_LG.gif" border="0" name="submit" alt="PayPal – The safer, easier way to pay online.">
<img alt="" border="0" src="https://www.paypalobjects.com/en_GB/i/scr/pixel.gif" width="1" height="1">
</form>
