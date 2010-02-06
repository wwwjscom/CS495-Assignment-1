//
//  XMLDeligate.m
//  RSSReader
//
//  Created by Jason Soo on 2/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XMLDeligate.h"
#import	"Story.h"


@implementation XMLDeligate

- (id)initWithLimit:(int)theLimit {
	[super init];
	
	// Setup the bools
	feed_title_incoming = NO;
	item_open			= NO;
	title_open			= NO;
	date_open			= NO;
	
	limit				= theLimit;
	
	feed_title			= [[[NSMutableString alloc] init] autorelease];
	stories				= [[[NSMutableArray alloc] initWithCapacity:100] autorelease];
	//title				= [[[NSMutableString alloc] init] autorelease];
	story				= [[[Story alloc] init] autorelease];
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"]) {
		item_open = YES;
		story				= [[[Story alloc] init] autorelease];
		return;
	}
	
	if (item_open && [elementName isEqualToString:@"title"]) {
		title = [[NSMutableString alloc] init];
		title_open = YES;
		return;
	}
	
	if ([elementName isEqualToString:@"published"] || [elementName isEqualToString:@"pubDate"]) {
		date = [[[NSMutableString alloc] init] autorelease];
		date_open = YES;
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
	
	if (date_open) {
		[date appendString:string];
		return;
	}
	
	if (feed_title_incoming) {
		[feed_title appendString:string];
	}
}
	
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (item_open && [elementName isEqualToString:@"title"]) {
		title_open = NO;
		
		story.title = title;
		[title release];
		return;
	}
	
	if (!feed_title_incoming && ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"])) {
		item_open = NO;
		
		// Push the story onto the stories array
		[stories addObject:story];
		return;
	}
	
	if (date_open && ([elementName isEqualToString:@"published"] || [elementName isEqualToString:@"pubDate"])) {
		story.date = date;
		[date release];
		date_open = NO;
	}
	
	if (feed_title_incoming && [elementName isEqualToString:@"title"]) {
		feed_title_incoming = NO;
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
			Story *s = [stories objectAtIndex:0];
			s.toLog;
			[stories removeObjectAtIndex:0];
		}	
		
	} else {
		// No need to truncate feed
		NSLog(@"Found %d stories",feed_size);
		for (Story *s in stories)
			s.toLog;
	}
	NSLog(@"\n");
}

- (void)dealloc {
	[feed_title release];
	[stories release];
	[super dealloc];
}
	
@end
