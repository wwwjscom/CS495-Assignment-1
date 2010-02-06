//
//  XMLDeligate.m
//  RSSReader
//
//  Created by Jason Soo on 2/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XMLDeligate.h"


@implementation XMLDeligate

BOOL feed_title_incoming = NO;
BOOL item_open = NO;
BOOL title_open = NO;
NSMutableString *title;

- (id)initWithLimit:(int *)theLimit {
	[super init];
	
	limit = theLimit;
	
	feed_title = [[[NSMutableString alloc] init] autorelease];
	stories = [[[NSMutableArray alloc] initWithCapacity:100] autorelease];
	title = [[NSMutableString alloc] init];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"]) {
		item_open = YES;
		return;
	}
	
	if (item_open && [elementName isEqualToString:@"title"]) {
		title = [[NSMutableString alloc] init];
		title_open = YES;
		return;
	}
	
	if (!item_open && !title_open && [elementName isEqualToString:@"title"]) {
		feed_title_incoming = YES;
	}
}
	
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (title_open) {
		[title appendString:string];
		return;
	}
	
	if (feed_title_incoming) {
		[feed_title appendString:string];
	}
}
	
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (item_open && [elementName isEqualToString:@"title"]) {
		title_open = NO;
		[stories addObject:title];
		[title release];
		return;
	}
	
	if (!feed_title_incoming && ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"])) {
		item_open = NO;
		return;
	}
	
	if (feed_title_incoming && [elementName isEqualToString:@"title"]) {
		feed_title_incoming = NO;
		return;
	}
}

- (void)showStories {

	int feed_size = (int)[stories count];
	
	NSLog(@"Feed: %@",feed_title);
	
	if (feed_size > limit) {
		// Need to truncate the feed
		
		NSUInteger breakAtSize = feed_size - limit;
		NSLog(@"Found %d stories; limiting to the most recent %d:",feed_size,limit);
		
		while (breakAtSize != [stories count]) {
			NSLog(@"- %@",[stories objectAtIndex:0]);
			[stories removeObjectAtIndex:0];
		}	
		
	} else {
		// No need to truncate feed
		
		NSLog(@"Found %d stories",feed_size);
		
		for (NSString *s in stories) {
			NSLog(@"- %@",s);
		}
	}
	
	NSLog(@"\n");
}
	
@end
