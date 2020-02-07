#import "GameData.h"
#import "KeychainWrapper.h"
@implementation GameData
static NSString *const GameDataHighScoreKey = @"highScore";
static NSString *const SSGameDataChecksumKey = @"SSGameDataCheckssumKey";
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:self.highScore forKey:GameDataHighScoreKey];
    }
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        _highScore = [aDecoder decodeDoubleForKey:GameDataHighScoreKey];
            }
    return self;
}
+(instancetype)sharedGameData {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    return sharedInstance;
}
-(void)reset {
    self.score = 0;
}
-(void)save {
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[GameData filePath] atomically:YES];
    NSString *checksum = [KeychainWrapper computeSHA256DigestForData:encodedData];
    if ([KeychainWrapper keychainStringFromMatchingIdentifier:SSGameDataChecksumKey]) {
        [KeychainWrapper updateKeychainValue:checksum forIdentifier:SSGameDataChecksumKey];
    } else {
        [KeychainWrapper createKeychainValue:checksum forIdentifier:SSGameDataChecksumKey];
    }
}
+(NSString *)filePath {
    static NSString *filePath = nil;
    if (!filePath) {
        filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}
+(instancetype)loadInstance {
    NSData *decodedData = [NSData dataWithContentsOfFile:[GameData filePath]];
    if (decodedData) {
        NSString *checksumOfSavedFile = [KeychainWrapper computeSHA256DigestForData:decodedData];
        NSString *checksumInKeychain = [KeychainWrapper keychainStringFromMatchingIdentifier:SSGameDataChecksumKey];
        if ([checksumOfSavedFile isEqualToString:checksumInKeychain]) {
            GameData *gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
            return gameData;
        }
    }
    return [[GameData alloc] init];
}
@end
