//
//  UIView+Tools.m
//  iSub
//
//  Created by Ben Baron on 12/22/10.
//  Copyright 2010 Ben Baron. All rights reserved.
//

#import "UIView+Tools.h"


@implementation UIView (Tools)

#define DEFAULT_SHADOW_ALPHA 0.5
#define DEFAULT_SHADOW_WIDTH 17.0

// creates vertical shadow
+ (CAGradientLayer *)verticalShadowWithAlpha:(CGFloat)shadowAlpha inverse:(BOOL)inverse
{
	CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
    newShadow.startPoint = CGPointMake(0, 0.5);
    newShadow.endPoint = CGPointMake(1.0, 0.5);
	CGColorRef darkColor  = (CGColorRef)CFRetain([UIColor colorWithWhite:0.0f alpha:shadowAlpha].CGColor);
	CGColorRef lightColor = (CGColorRef)CFRetain([UIColor clearColor].CGColor);
	newShadow.colors = [NSArray arrayWithObjects:
                        (__bridge id)(inverse ? lightColor : darkColor),
                        (__bridge id)(inverse ? darkColor : lightColor),
                        nil];
    
    CFRelease(darkColor);
    CFRelease(lightColor);
	return newShadow;
}

- (void)addLeftShadowWithWidth:(CGFloat)shadowWidth alpha:(CGFloat)shadowAlpha
{
	// Draw the shadows
	CAGradientLayer *leftShadow = [UIView verticalShadowWithAlpha:shadowAlpha inverse:YES];
	leftShadow.frame = CGRectMake(-shadowWidth, 0, shadowWidth + ISMSiPadCornerRadius, 1024.);
	[self.layer insertSublayer:leftShadow atIndex:0];
}

- (void)addLeftShadow
{
	[self addLeftShadowWithWidth:DEFAULT_SHADOW_WIDTH alpha:DEFAULT_SHADOW_ALPHA];
}

- (void)addRightShadowWithWidth:(CGFloat)shadowWidth alpha:(CGFloat)shadowAlpha
{
	CAGradientLayer *rightShadow = [UIView verticalShadowWithAlpha:shadowAlpha inverse:NO];
	rightShadow.frame = CGRectMake(self.width - ISMSiPadCornerRadius, 0, DEFAULT_SHADOW_WIDTH + ISMSiPadCornerRadius, 1024.);
	[self.layer insertSublayer:rightShadow atIndex:0];
}

- (void)addRightShadow
{
	[self addRightShadowWithWidth:DEFAULT_SHADOW_WIDTH alpha:DEFAULT_SHADOW_ALPHA];
}

+ (CAGradientLayer *)horizontalShadowWithAlpha:(CGFloat)shadowAlpha inverse:(BOOL)inverse
{
	CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
    newShadow.startPoint = CGPointMake(0.5, 0);
    newShadow.endPoint = CGPointMake(0.5, 1.0);
	CGColorRef darkColor  = (CGColorRef)CFRetain([UIColor colorWithWhite:0.0f alpha:shadowAlpha].CGColor);
	CGColorRef lightColor = (CGColorRef)CFRetain([UIColor clearColor].CGColor);
	newShadow.colors = [NSArray arrayWithObjects:
                        (__bridge id)(inverse ? lightColor : darkColor),
                        (__bridge id)(inverse ? darkColor : lightColor),
                        nil];
    
    CFRelease(darkColor);
    CFRelease(lightColor);
	return newShadow;
}

- (void)addBottomShadowWithWidth:(CGFloat)shadowWidth alpha:(CGFloat)shadowAlpha
{
	// Draw the shadows
	CAGradientLayer *bottomShadow = [UIView verticalShadowWithAlpha:shadowAlpha inverse:YES];
	bottomShadow.frame = CGRectMake(-shadowWidth, 0, shadowWidth + ISMSiPadCornerRadius, 1024.);
	[self.layer insertSublayer:bottomShadow atIndex:0];
}

- (void)addBottomShadow
{
	[self addBottomShadowWithWidth:DEFAULT_SHADOW_WIDTH alpha:DEFAULT_SHADOW_ALPHA];
}

- (void)addTopShadowWithWidth:(CGFloat)shadowWidth alpha:(CGFloat)shadowAlpha
{
	CAGradientLayer *topShadow = [UIView verticalShadowWithAlpha:shadowAlpha inverse:NO];
	topShadow.frame = CGRectMake(self.width - ISMSiPadCornerRadius, 0, DEFAULT_SHADOW_WIDTH + ISMSiPadCornerRadius, 1024.);
	[self.layer insertSublayer:topShadow atIndex:0];
}

- (void)addTopShadow
{
	[self addTopShadowWithWidth:DEFAULT_SHADOW_WIDTH alpha:DEFAULT_SHADOW_ALPHA];
}

- (CGFloat)left 
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x 
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top 
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y 
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right 
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right 
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom 
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom 
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGFloat)x
{
	return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    if (!isfinite(x))
        return;
    
	CGRect newFrame = self.frame;
	newFrame.origin.x = x;
	self.frame = newFrame;
}

- (CGFloat)y
{
	return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    if (!isfinite(y))
        return;
    
	CGRect newFrame = self.frame;
	newFrame.origin.y = y;
	self.frame = newFrame;
}

- (CGPoint)origin
{
	return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
	if (!isfinite(origin.x) || !isfinite(origin.y))
		return;
	
	CGRect newFrame = self.frame;
	newFrame.origin = origin;
	self.frame = newFrame;
}

- (CGFloat)width
{
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    if (!isfinite(width))
        return;
    
	CGRect newFrame = self.frame;
	newFrame.size.width = width;
	self.frame = newFrame;
}

- (CGFloat)height
{
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    if (!isfinite(height))
        return;
    
	CGRect newFrame = self.frame;
	newFrame.size.height = height;
	self.frame = newFrame;
}

- (CGSize)size
{
	return self.frame.size;
}

- (void)setSize:(CGSize)size
{
	if (!isfinite(size.width) || !isfinite(size.height))
		return;
	
	CGRect newFrame = self.frame;
	newFrame.size = size;
	self.frame = newFrame;
}

- (UIViewController *)viewController;
{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) 
	{
        return nextResponder;
    } 
	else 
	{
        return nil;
    }
}

@end