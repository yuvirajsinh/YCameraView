//
//  PhotoShapViewController.m
//  NoshedItStaging
//
//  Created by yuvraj on 08/01/14.
//  Copyright (c) 2014 limbasiya.nirav@gmail.com. All rights reserved.
//

#import "YCameraViewController.h"
#import "FlashButtonController.h"
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

#define DegreesToRadians(x) ((x) * M_PI / 180.0)


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


@interface YCameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
  UIInterfaceOrientation orientationLast, orientationAfterProcess;
  
  /**
   This is used so that photos taken in landscape are rotated to portrait. Not sure why accelerator reading is used (instead of
   UIDeviceOrientationDidChangeNotification).
   */
  CMMotionManager *motionManager;
  
  UIImagePickerController *imgPicker;
  BOOL pickerDidShow;
  
  BOOL FrontCamera;
  BOOL haveImage;
  BOOL initializeCamera, photoFromCam;
  AVCaptureSession *session;
  AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
  AVCaptureStillImageOutput *stillImageOutput;
  UIImage *croppedImageWithoutOrientation;
}

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *toggleGridButton;
@property (strong, nonatomic) FlashButtonController* flashButtonController;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *confirmPhotoBar;

@end


@implementation YCameraViewController

- (instancetype)init
{
  return [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.navigationController.navigationBarHidden = YES;
  [self.navigationController setNavigationBarHidden:YES];
  
  // Do any additional setup after loading the view.
  pickerDidShow = NO;
  
  FrontCamera = NO;
  self.captureImage.hidden = YES;
  
  // Setup UIImagePicker Controller
  imgPicker = [UIImagePickerController new];
  imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  imgPicker.delegate = self;
  imgPicker.allowsEditing = YES;
  
  croppedImageWithoutOrientation = [[UIImage alloc] init];
  
  initializeCamera = YES;
  photoFromCam = YES;

  [self initializeMotionManager];
  
  if (self.gridInitiallyHidden) {
    [self gridToogle:self.toggleGridButton];
  }
  
  [self setupFlashButton];
}

- (void)setupFlashButton
{
  self.flashButtonController = [[FlashButtonController alloc] initWithButton:self.flashToggleButton];
  __weak typeof(self) weakSelf = self;
  self.flashButtonController.buttonPressedBlock = ^() {
    [weakSelf toggleFlash:nil];
    [weakSelf updateFlashButtonStateText];
  };
  [self updateFlashButtonStateText];
  
  [self.flashStateButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
  [self.flashStateButton addTarget:self action:@selector(flashStateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)flashStateButtonPressed:(id)sender
{
  [self.flashButtonController triggerButtonPress];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (initializeCamera){
        initializeCamera = NO;
        [self initializeCamera];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [session stopRunning];
}

- (void)dealloc
{
    [_imagePreview release];
    [_captureImage release];
    [imgPicker release];
    imgPicker = nil;
    
    if (session)
        [session release], session=nil;
    
    if (captureVideoPreviewLayer)
        [captureVideoPreviewLayer release], captureVideoPreviewLayer=nil;
    
    if (stillImageOutput)
        [stillImageOutput release], stillImageOutput=nil;
}

- (BOOL)prefersStatusBarHidden
{
  return _prefersStatusBarHidden;
}

- (BOOL)shouldAutorotate
{
  return _shouldAutorotate;
}

#pragma mark - CoreMotion Task

- (void)initializeMotionManager{
  motionManager = [[CMMotionManager alloc] init];
  motionManager.accelerometerUpdateInterval = .2;
  motionManager.gyroUpdateInterval = .2;
  
  [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                      withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                        if (!error) {
                                          [self outputAccelertionData:accelerometerData.acceleration];
                                        }
                                        else{
                                          NSLog(@"%@", error);
                                        }
                                      }];
}

#pragma mark - UIAccelerometer callback

- (void)outputAccelertionData:(CMAcceleration)acceleration{
  UIInterfaceOrientation orientationNew;
  
  if (acceleration.x >= 0.75) {
    orientationNew = UIInterfaceOrientationLandscapeLeft;
  }
  else if (acceleration.x <= -0.75) {
    orientationNew = UIInterfaceOrientationLandscapeRight;
  }
  else if (acceleration.y <= -0.75) {
    orientationNew = UIInterfaceOrientationPortrait;
  }
  else if (acceleration.y >= 0.75) {
    orientationNew = UIInterfaceOrientationPortraitUpsideDown;
  }
  else {
    // Consider same as last time
    return;
  }
  
  if (orientationNew == orientationLast)
    return;
  
  //    NSLog(@"Going from %@ to %@!", [[self class] orientationToText:orientationLast], [[self class] orientationToText:orientationNew]);
  
  orientationLast = orientationNew;
}

#ifdef DEBUG
+(NSString*)orientationToText:(const UIInterfaceOrientation)ORIENTATION {
  switch (ORIENTATION) {
    case UIInterfaceOrientationPortrait:
      return @"UIInterfaceOrientationPortrait";
    case UIInterfaceOrientationPortraitUpsideDown:
      return @"UIInterfaceOrientationPortraitUpsideDown";
    case UIInterfaceOrientationLandscapeLeft:
      return @"UIInterfaceOrientationLandscapeLeft";
    case UIInterfaceOrientationLandscapeRight:
      return @"UIInterfaceOrientationLandscapeRight";
  }
  return @"Unknown orientation!";
}
#endif

#pragma mark - Camera Initialization

//AVCaptureSession to show live video feed in view
- (void) initializeCamera {
    if (session)
        [session release], session=nil;
    
    session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetPhoto;
	
    if (captureVideoPreviewLayer)
        [captureVideoPreviewLayer release], captureVideoPreviewLayer=nil;
    
	captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
	captureVideoPreviewLayer.frame = self.imagePreview.bounds;
	[self.imagePreview.layer addSublayer:captureVideoPreviewLayer];
	
    UIView *view = [self imagePreview];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera=nil;
    AVCaptureDevice *backCamera=nil;
    
    // check if device available
    if (devices.count==0) {
        NSLog(@"No Camera Available");
        [self disableCameraDeviceControls];
        return;
    }
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    if (!FrontCamera) {
        
        if ([backCamera hasFlash]){
            [backCamera lockForConfiguration:nil];
            [backCamera setFlashMode:self.flashButtonController.flashMode];
            [backCamera unlockForConfiguration];
            
            [self.flashToggleButton setEnabled:YES];
            [self.flashStateButton setEnabled:YES];
        }
        else{
            if ([backCamera isFlashModeSupported:AVCaptureFlashModeOff]) {
                [backCamera lockForConfiguration:nil];
                [backCamera setFlashMode:AVCaptureFlashModeOff];
                [backCamera unlockForConfiguration];
            }
            [self.flashToggleButton setEnabled:NO];
            [self.flashStateButton setEnabled:NO];
        }
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    if (FrontCamera) {
        [self.flashToggleButton setEnabled:NO];
        [self.flashStateButton setEnabled:NO];
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    if (stillImageOutput)
        [stillImageOutput release], stillImageOutput=nil;
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil] autorelease];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
	[session startRunning];
}

- (IBAction)snapImage:(id)sender {
    [self.photoCaptureButton setEnabled:NO];
    
    if (!haveImage) {
        self.captureImage.image = nil; //remove old image from view
        self.captureImage.hidden = NO; //show the captured image view
        self.imagePreview.hidden = YES; //hide the live video feed
        [self capImage];
    }
    else {
        self.captureImage.hidden = YES;
        self.imagePreview.hidden = NO;
        haveImage = NO;
    }
}

- (void) capImage { //method to capture image from AVCaptureSession video feed
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}

- (UIImage*)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)processImage:(UIImage *)image { //process captured image, crop, resize and rotate
    haveImage = YES;
    photoFromCam = YES;
    
    // Resize image to 640x640
    // Resize image
    //    NSLog(@"Image size %@",NSStringFromCGSize(image.size));
    
    UIImage *smallImage = [self imageWithImage:image scaledToWidth:640.0f]; //UIGraphicsGetImageFromCurrentImageContext();
    
    CGRect cropRect = CGRectMake(0, 105, 640, 640);
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    
    croppedImageWithoutOrientation = [[UIImage imageWithCGImage:imageRef] copy];
    
    UIImage *croppedImage = nil;
    //    assetOrientation = ALAssetOrientationUp;
    
    // adjust image orientation
    NSLog(@"orientation: %d",orientationLast);
    orientationAfterProcess = orientationLast;
    switch (orientationLast) {
        case UIInterfaceOrientationPortrait:
            NSLog(@"UIInterfaceOrientationPortrait");
            croppedImage = [UIImage imageWithCGImage:imageRef];
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            NSLog(@"UIInterfaceOrientationPortraitUpsideDown");
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationDown] autorelease];
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            NSLog(@"UIInterfaceOrientationLandscapeLeft");
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationRight] autorelease];
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            NSLog(@"UIInterfaceOrientationLandscapeRight");
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationLeft] autorelease];
            break;
            
        default:
            croppedImage = [UIImage imageWithCGImage:imageRef];
            break;
    }
    
    CGImageRelease(imageRef);
    
    [self.captureImage setImage:croppedImage];
    
    [self setCapturedImage];
}

- (void)setCapturedImage{
    // Stop capturing image
    [session stopRunning];
    
    // Hide Top/Bottom controller after taking photo for editing
    [self hideControllers];
  
    [self showConfirmPhotoBar];
}

#pragma mark - Accessors

- (BOOL)gridEnabled
{
  return !(self.toggleGridButton.selected);
}

#pragma mark - Device Availability Controls

- (void)disableCameraDeviceControls{
    self.cameraToggleButton.enabled = NO;
    self.flashToggleButton.enabled = NO;
    self.flashStateButton.enabled = NO;
    self.photoCaptureButton.enabled = NO;
}

#pragma mark - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (info) {
        photoFromCam = NO;
        
        UIImage* outputImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (outputImage == nil) {
            outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (outputImage) {
            self.captureImage.hidden = NO;
            self.captureImage.image=outputImage;
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            // Hide Top/Bottom controller after taking photo for editing
            [self hideControllers];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    initializeCamera = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button clicks

- (IBAction)gridToogle:(UIButton *)sender {
    CGFloat gridToggleAnimationDuration = 0.2;
  
    if (sender.selected) {
        sender.selected = NO;
        [UIView animateWithDuration:gridToggleAnimationDuration delay:0.0 options:0 animations:^{
            self.ImgViewGrid.alpha = 1.0f;
        } completion:nil];
    }
    else{
        sender.selected = YES;
        [UIView animateWithDuration:gridToggleAnimationDuration delay:0.0 options:0 animations:^{
            self.ImgViewGrid.alpha = 0.0f;
        } completion:nil];
    }
  
    if ([self.delegate respondsToSelector:@selector(yCameraController:didToggleGridEnabled:)]) {
        [self.delegate yCameraController:self didToggleGridEnabled:sender.selected];
    }
}

-(IBAction)switchToLibrary:(id)sender {
  if (session) {
    [session stopRunning];
  }
  [self presentViewController:imgPicker animated:YES completion:NULL];
}

- (IBAction)skipped:(id)sender {
  if ([self.delegate respondsToSelector:@selector(yCameraControllerdidSkipped:)]) {
    [self.delegate yCameraControllerDidSkip:self];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cancel:(id)sender {
  if ([self.delegate respondsToSelector:@selector(yCameraControllerDidCancel:)]) {
    [self.delegate yCameraControllerDidCancel:self];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)donePhotoCapture:(id)sender {
  if ([self.delegate respondsToSelector:@selector(yCameraController:didFinishPickingImage:)]) {
    [self.delegate yCameraController:self didFinishPickingImage:self.captureImage.image];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)retakePhoto:(id)sender {
    [self.photoCaptureButton setEnabled:YES];
    self.captureImage.image = nil;
    self.imagePreview.hidden = NO;
  
    [self showControllers];
    [self hideConfirmPhotoBar];
  
    haveImage=NO;
    FrontCamera = NO;
//    [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.001];
    [session startRunning];
}

- (IBAction)switchCamera:(UIButton *)sender { //switch cameras front and rear cameras
    // Stop current recording process
    [session stopRunning];
    
    if (sender.selected) {  // Switch to Back camera
        sender.selected = NO;
        FrontCamera = NO;
        [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.001];
    }
    else {                  // Switch to Front camera
        sender.selected = YES;
        FrontCamera = YES;
        [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.001];
    }
}

- (void)toggleFlash:(id)sender {
  if (FrontCamera) {
    return;
  }
  
  NSArray *devices = [AVCaptureDevice devices];
  for (AVCaptureDevice *device in devices) {
    
    NSLog(@"Device name: %@", [device localizedName]);
    
    if ([device hasMediaType:AVMediaTypeVideo]) {
      
      if ([device position] == AVCaptureDevicePositionBack) {
        NSLog(@"Device position : back");
        if ([device hasFlash]){
          
          [device lockForConfiguration:nil];
          [device setFlashMode:self.flashButtonController.flashMode];
          [device unlockForConfiguration];
          
          break;
        }
      }
    }
  }
}

- (void)updateFlashButtonStateText
{
  NSDictionary *flashStateToTextMapping = @{
                            @(FlashButtonStateAuto) : @"Auto",
                            @(FlashButtonStateOn) : @"On",
                            @(FlashButtonStateOff) : @"Off"
                           };
  NSString *flashText = flashStateToTextMapping[@(self.flashButtonController.state)];
  [self.flashStateButton setTitle:flashText forState:UIControlStateNormal];
}

#pragma mark - UI Control Helpers

- (void)hideControllers{
  [UIView animateWithDuration:0.2 animations:^{
    //1)animate them out of screen
    self.photoBar.center = CGPointMake(self.photoBar.center.x, self.photoBar.center.y+116.0);
    self.topBar.center = CGPointMake(self.topBar.center.x, self.topBar.center.y-44.0);
    
    //2)actually hide them
    self.photoBar.alpha = 0.0;
    self.topBar.alpha = 0.0;
    
  } completion:nil];
}

- (void)showControllers{
  [UIView animateWithDuration:0.2 animations:^{
    //1)animate them into screen
    self.photoBar.center = CGPointMake(self.photoBar.center.x, self.photoBar.center.y-116.0);
    self.topBar.center = CGPointMake(self.topBar.center.x, self.topBar.center.y+44.0);
    
    //2)actually show them
    self.photoBar.alpha = 1.0;
    self.topBar.alpha = 1.0;
    
  } completion:nil];
}

- (void)showConfirmPhotoBar
{
  self.confirmPhotoBar.hidden = NO;
}

- (void)hideConfirmPhotoBar
{
  self.confirmPhotoBar.hidden = YES;
}

@end
