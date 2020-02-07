#import <Foundation/Foundation.h>
@import Security;
#import <CommonCrypto/CommonDigest.h>
@interface KeychainWrapper : NSObject
+ (NSData *)searchKeychainCopyMatchingIdentifier:(NSString *)identifier;
+ (NSString *)keychainStringFromMatchingIdentifier:(NSString *)identifier;
+ (BOOL)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;
+ (BOOL)updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;
+ (void)deleteItemFromKeychainWithIdentifier:(NSString *)identifier;
+ (NSString *)securedSHA256DigestHashForPIN:(NSUInteger)pinHash;
+ (NSString*)computeSHA256DigestForString:(NSString*)input;
+ (NSString*)computeSHA256DigestForData:(NSData*)data;
@end
