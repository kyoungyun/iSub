//
//  Objective-C exception handling for Swift, from http://stackoverflow.com/a/36454808
//

#import <Foundation/Foundation.h>

@interface ObjC : NSObject

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error;

@end