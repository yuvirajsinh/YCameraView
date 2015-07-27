//
//  PhotoShapViewController.h
//  NoshedItStaging
//
//  Created by yuvraj on 08/01/14.
//  Copyright (c) 2014 yuviraj.jadeja@gmail.com. All rights reserved.
//

//
//  ARC Helper
#ifndef ah_retain
#if __has_feature(objc_arc)
#define ah_retain self
#define ah_dealloc self
#define release self
#define autorelease self
#else
#define ah_retain retain
#define ah_dealloc dealloc
#define __bridge
#endif
#endif

//  ARC Helper ends

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

@protocol YCameraViewControllerDelegate;

@interface YCameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    
    UIImagePickerController *imgPicker;
    BOOL pickerDidShow;
    
    //Today Implementation
    BOOL FrontCamera;
    BOOL haveImage;
    BOOL initializeCamera, photoFromCam;
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    AVCaptureStillImageOutput *stillImageOutput;
    UIImage *croppedImageWithoutOrientation;
}
@property (nonatomic, readwrite) BOOL dontAllowResetRestaurant;
@property (nonatomic, assign) id delegate;

#pragma mark -
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

@protocol YCameraViewControllerDelegate
- (void)didFinishPickingImage:(UIImage *)image;
- (void)yCameraControllerDidCancel;
- (void)yCameraControllerdidSkipped;
@end
