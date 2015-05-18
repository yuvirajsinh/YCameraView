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
@property (nonatomic, assign) BOOL shouldAutorotate;

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *photoCaptureButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *cancelButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *cameraToggleButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *libraryToggleButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *flashToggleButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *flashStateButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *ImgViewGrid;
@property (nonatomic, unsafe_unretained) IBOutlet UIView *photoBar;
@property (nonatomic, unsafe_unretained) IBOutlet UIView *topBar;
@property (nonatomic, unsafe_unretained) IBOutlet UIView *imagePreview;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *captureImage;

- (BOOL)gridEnabled;

@end


@protocol YCameraViewControllerDelegate <NSObject>

@optional
- (void)yCameraController:(YCameraViewController *)cameraController didFinishPickingImage:(UIImage *)image;
- (void)yCameraControllerDidCancel:(YCameraViewController *)cameraController;
- (void)yCameraControllerDidSkip:(YCameraViewController *)cameraController;
- (void)yCameraController:(YCameraViewController *)cameraController didToggleGridEnabled:(BOOL)gridEnabled;

@end
