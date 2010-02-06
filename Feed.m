//
//  Feed.m
//  RSSReader
//
//  Created by Jason Soo on 2/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Feed.h"


@implementation Feed

@synthesize feedURL;
@synthesize enabled;
@synthesize limit;

-(id)initWithDic:(NSDictionary *)dic {
	feedURL = [NSURL URLWithString:[dic objectForKey:@"FeedURL"]];
	enabled = [[dic objectForKey:@"Enabled"] boolValue];
	limit	= [[dic objectForKey:@"MaxNewsItems"] intValue];
	return self;
}

@end