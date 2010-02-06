//
//  Feed.h
//  RSSReader
//
//  Created by Jason Soo on 2/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Feed : NSObject {
	NSURL *feedURL;
	BOOL enabled;
	int limit;
}

@property (retain) NSURL *feedURL;
@property BOOL enabled;
@property int limit;

-(id)initWithDic:(NSDictionary *)dic;

@end
