//
//  Story.m
//  RSSReader
//
//  Created by Jason Soo on 2/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Story.h"


@implementation Story

@synthesize title;
@synthesize date;
@synthesize content;

//-(id)initWithDic:(NSDictionary *)dic {
-(void)toLog {
	NSLog(@"- %@",title);
	NSLog(@"-- Published on %@",date);
	NSLog(@"-- %@",content);
}

-(void)dealloc {
	[super dealloc];
}

@end
