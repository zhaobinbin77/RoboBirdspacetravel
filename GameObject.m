#import "GameObject.h"
@implementation GameObject
- (instancetype)initWithImageNamed:(NSString *)name {
    if ((self = [super initWithImageNamed:name])) {
    }
    return self;
}
-(void)update:(CFTimeInterval)dt {
}
-(void)cleanup {
    [self removeFromParent];
    [self removeAllActions];
}
-(void)destroy {
    self.physicsBody = nil;
    [self removeAllActions];
    [self runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0 duration:0.2],[SKAction runBlock:^{
        [self cleanup];
    }]
                                         ]]
     ];
}
-(void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact {
}
@end
