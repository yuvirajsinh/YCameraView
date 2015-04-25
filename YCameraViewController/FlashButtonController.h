
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


typedef NS_ENUM(NSInteger, FlashButtonState) {
  FlashButtonStateAuto,
  FlashButtonStateOn,
  FlashButtonStateOff,
  FlashButtonStateCount
};


@interface FlashButtonController : NSObject

@property (nonatomic, readonly) FlashButtonState state;
@property (nonatomic, readonly) AVCaptureFlashMode flashMode;
@property (nonatomic, copy) void (^buttonPressedBlock)();

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;

- (instancetype)initWithButton:(UIButton *)button;

@end
