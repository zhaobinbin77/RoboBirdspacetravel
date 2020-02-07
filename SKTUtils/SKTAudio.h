#import "SKTAudio.h"
@import AVFoundation;
@interface SKTAudio : NSObject
+ (instancetype)sharedInstance;
- (void)playBackgroundMusic:(NSString *)filename;
- (void)pauseBackgroundMusic;
- (void)playSoundEffect:(NSString*)filename;
@end