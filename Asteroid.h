#import "GameObject.h"
typedef NS_ENUM(int32_t, AsteroidType)
{
    AsteroidTypeMedium = 0,
    AsteroidTypeLarge,
    NumAsteroidTypes
};
@interface Asteroid : GameObject
- (instancetype)initWithAsteroidType:(AsteroidType)asteroidType;
@end
