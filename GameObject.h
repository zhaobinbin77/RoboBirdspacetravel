#import <SpriteKit/SpriteKit.h>
typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryPlayer = 1 << 0,
    CollisionCategoryWorld = 1 << 1,
    CollisionCategoryStarSpecial = 1 << 2,
    CollisionCategoryBatteryGreen = 1 << 3,
    CollisionCategoryAsteroid = 1 << 4,
    CollisionCategoyBoundaries = 1 << 5,
    CollisionCategoryStar = 1 << 6
};
@interface GameObject : SKSpriteNode
- (instancetype)initWithImageNamed:(NSString *)name;
- (void)update:(CFTimeInterval)dt;
-(void)cleanup;
-(void)destroy;
-(void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact *)contact;
@end
