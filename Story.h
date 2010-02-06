//
//  Story.h
//  RSSReader
//
//  Created by Jason Soo on 2/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Story : NSObject {
	NSDictionary *story;
	NSString *title;
	NSString *date;
	NSString *content; // Truncated
}

- (void)toLog;
- (void)dealloc;

@property (retain) NSString *title;
@property (retain) NSString *date;
@property (retain) NSString *content;


@end
