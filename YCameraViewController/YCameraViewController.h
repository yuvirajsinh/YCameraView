//
//  PhotoShapViewController.h
//  NoshedItStaging
//
//  Created by yuvraj on 08/01/14.
//  Copyright (c) 2014 limbasiya.nirav@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YCameraViewControllerDelegate;


@interface YCameraViewController : UIViewController

@property (nonatomic, assign) id <YCameraViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL prefersStatusBarHidden;
@property (nonatomic, assign) BOOL gridInitiallyHidden;

@property (nonatomic, strong) IBOutlet UIButton *photoCaptureButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *cameraToggleButton;
@property (nonatomic, strong) IBOutlet UIButton *libraryToggleButton;
@property (nonatomic, strong) IBOutlet UIButton *flashToggleButton;
@property (retain, nonatomic) IBOutlet UIImageView *ImgViewGrid;
@property (nonatomic, strong) IBOutlet UIView *photoBar;
@property (nonatomic, strong) IBOutlet UIView *topBar;
@property (retain, nonatomic) IBOutlet UIView *imagePreview;
@property (retain, nonatomic) IBOutlet UIImageView *captureImage;

@end


@protocol YCameraViewControllerDelegate <NSObject>

@optional
- (void)yCameraControllerDidFinishPickingImage:(UIImage *)image;
- (void)yCameraControllerDidCancel;
- (void)yCameraControllerdidSkipped;

@end
