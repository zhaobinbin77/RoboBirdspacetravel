#import "Asteroid.h"
#import "SKTUtils.h"
#import "SKEmitterNode+SKTExtras.h"
#import "MyScene.h"
#import "SKAction+SKTExtras.h"
#import "SKTAudio.h"
@implementation Asteroid {
    SKEmitterNode *_emitter;
}
-(instancetype)initWithAsteroidType:(AsteroidType)asteroidType {
    NSString *imageName;
    float rotateDuration;
    switch (asteroidType) {
        case AsteroidTypeMedium:
            imageName = @"mediumAsteroid";
            rotateDuration = 2;
            break;
        case AsteroidTypeLarge:
            imageName = @"largeAsteroid";
            rotateDuration = 8.0;
            break;
        default:
            return nil;
    }
    if ((self = [super initWithImageNamed:imageName])) {
        [self configureCollisionBody];
        [self runAction:[SKAction repeatActionForever:[SKAction  rotateByAngle:DegreesToRadians(360) duration:rotateDuration]]];
    }
    return self;
}
-(void)configureCollisionBody {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryAsteroid;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = 0;
    self.physicsBody.usesPreciseCollisionDetection = YES;
}
- (void)configureEmitterWithScale {
    _emitter = [SKEmitterNode skt_emitterNamed:@"asteroidExplosion"];
    _emitter.zPosition = -1;
    _emitter.targetNode = self;
    _emitter.position = CGPointMake(0.5, 0.5);
    [self addChild:_emitter];
    [_emitter resetSimulation];
    [_emitter runAction:[SKAction skt_removeFromParentAfterDelay:1.0]];
}
-(void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact {
   __weak MyScene *scene = (MyScene *)self.scene;
    if (scene.shieldActivated == YES) {
        [self destroy];
        [self configureEmitterWithScale];
        if (scene.volume == YES) {
            [self runAction:scene.explosionAsteroid];
        }
    }
}
-(void)update:(CFTimeInterval)dt {
}
-(void)cleanup {
    [super cleanup];
    [_emitter removeFromParent];
    _emitter = nil;
}
@end
