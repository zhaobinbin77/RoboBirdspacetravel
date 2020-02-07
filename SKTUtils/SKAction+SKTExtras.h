#import <SpriteKit/SpriteKit.h>
@interface SKAction (SKTExtras)
+ (instancetype)skt_afterDelay:(NSTimeInterval)duration perform:(SKAction *)action;
+ (instancetype)skt_afterDelay:(NSTimeInterval)duration runBlock:(dispatch_block_t)block;
+ (instancetype)skt_removeFromParentAfterDelay:(NSTimeInterval)duration;
@end
