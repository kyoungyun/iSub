//
//  ChatMessage.h
//  iSub
//
//  Created by bbaron on 8/16/10.
//  Copyright 2010 Ben Baron. All rights reserved.
//

#import "TBXML.h"

@interface ChatMessage : NSObject <NSCopying> 
{
	NSInteger timestamp;
	NSString *user;
	NSString *message;
}

@property NSInteger timestamp;
@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *message;

- (id)initWithTBXMLElement:(TBXMLElement *)element;
-(id) copyWithZone: (NSZone *) zone;

@end
