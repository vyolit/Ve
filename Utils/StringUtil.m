//
//  StringUtil.m
//  Vē
//
//  Created by Alexandra Aurora Göttlicher
//

#import "StringUtil.h"

@implementation StringUtil
/**
 * Returns a random string with given length.
 *
 * @param length The length of the string.
 *
 * @return The random string.
 */
+ (NSString *)getRandomStringWithLength:(NSUInteger)length {
    NSString* characters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString* string = [NSMutableString stringWithCapacity:length];

    for (NSUInteger i = 0; i < length; i++) {
        [string appendFormat:@"%c", [characters characterAtIndex:arc4random_uniform([characters length])]];
    }

    return string;
}
@end
