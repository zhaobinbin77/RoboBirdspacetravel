#import "Star.h"
#import "MyScene.h"
#import "SKTUtils.h"
#import "GameData.h"
@implementation Star
-(instancetype)initWithImageNamed:(NSString *)name {
    if (self = [super initWithImageNamed:name]) {
        float rotateDuration = 4.0;
        [self configurePhyscicBody];
        [self runAction:[SKAction repeatActionForever:[SKAction  rotateByAngle:DegreesToRadians(360) duration:rotateDuration]]];
    }
    return self;
}
-(void)configurePhyscicBody {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.height /2];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryStar;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = 0;
}
-(void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact {
    [self destroy];
    __weak MyScene *scene = (MyScene *)self.scene;
    if (scene.volume == YES) {
        [self runAction:scene.specialStar];
    }
    [scene.starLabelImage runAction:scene.starEffect];
    [scene.starLabel runAction:scene.starEffect];
    [GameData sharedGameData].score = [GameData sharedGameData].score + 1;
    NSString *starScore = [NSString stringWithFormat:@"x %li",[GameData sharedGameData].score];
    scene.starLabel.text = starScore;
    scene.scoreLabel.text = starScore;
}
-(void)cleanup {
    [super cleanup];
}
@end
