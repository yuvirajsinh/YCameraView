
#import "FlashButtonController.h"


@interface FlashButtonController ()

@property (nonatomic, weak) UIButton* button;
@property (nonatomic, assign) FlashButtonState state;

@end


@implementation FlashButtonController

- (instancetype)initWithButton:(UIButton *)aButton
{
  NSAssert(aButton != nil, @"invalid parameter");
  
  self = [super init];
  if (self) {
    _button = aButton;
    [aButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)dealloc
{
  [self.button removeTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonPressed
{
  self.state++;
  if (self.state >= FlashButtonStateCount) {
    self.state = FlashButtonStateAuto;
  }
  
  if (self.buttonPressedBlock) {
    self.buttonPressedBlock();
  }
}

- (AVCaptureFlashMode)flashMode
{
  NSAssert(self.state < FlashButtonStateCount, @"invalid button state");
  
  NSDictionary *mapping = @{
                            @(FlashButtonStateAuto) : @(AVCaptureFlashModeAuto),
                            @(FlashButtonStateOn) : @(AVCaptureFlashModeOn),
                            @(FlashButtonStateOff) : @(AVCaptureFlashModeOff)
                            };
  
  NSNumber *avState = mapping[@(self.state)];
  return avState.integerValue;
}

@end
