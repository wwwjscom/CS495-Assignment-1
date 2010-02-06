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

@synthesize truncateAt;

- (id)initWithLimit:(int)theLimit {
	[super init];
	
	// Setup the bools
	feed_title_incoming = NO;
	item_open			= NO;
	title_open			= NO;
	date_open			= NO;
	content_open		= NO;
	
	limit				= theLimit;
	
	feed_title			= [[[NSMutableString alloc] init] autorelease];
	stories				= [[[NSMutableArray alloc] initWithCapacity:100] autorelease];
	story				= [[[Story alloc] init] autorelease];
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	// Opening an item/entry
	if ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"]) {
		item_open = YES;
		story				= [[[Story alloc] init] autorelease];
		return;
	}
	
	// Opening a title
	if (item_open && [elementName isEqualToString:@"title"]) {
		title = [[[NSMutableString alloc] init] autorelease];
		title_open = YES;
		return;
	}
	
	// Opening date
	if ([elementName isEqualToString:@"published"] || [elementName isEqualToString:@"pubDate"]) {
		date = [[[NSMutableString alloc] init] autorelease];
		date_open = YES;
		return;
	}
	
	// Opening content
	if ([elementName isEqualToString:@"content"] || [elementName isEqualToString:@"description"]) {
		content = [[[NSMutableString alloc] init] autorelease];
		content_open = YES;
		return;
	}
	
	// Opening feed title
	if (!item_open && !title_open && [elementName isEqualToString:@"title"]) {
		feed_title_incoming = YES;
	}
}
	
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	// Set title
	if (title_open) {
		[title appendString:string];
		return;
	}
	
	// Set date
	if (date_open) {
		[date appendString:string];
		return;
	}
	
	// Set content
	if (content_open) {
		[content appendString:string];
		return;
	}
	
	// Set feed title
	if (feed_title_incoming) {
		[feed_title appendString:string];
	}
}
	
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	// Close title
	if (item_open && [elementName isEqualToString:@"title"]) {
		title_open = NO;
		story.title = title;
		[title release];
		return;
	}
	
	// Close item/entry
	if (!feed_title_incoming && ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"])) {
		item_open = NO;
		// Push the story onto the stories array
		[stories addObject:story];
		return;
	}
	
	// Close date
	if (date_open && ([elementName isEqualToString:@"published"] || [elementName isEqualToString:@"pubDate"])) {
		story.date = date;
		[date release];
		date_open = NO;
	}
	
	// Close content
	if (content_open && ([elementName isEqualToString:@"content"] || [elementName isEqualToString:@"description"])) {
		
		// Get rid of new lines
		content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""]; // I'm aware of this notice, but to correct it would
																					   // yield at least 2 lines of useless code
		// Truncate
		if ([content length] > truncateAt) {
			story.content = [content substringToIndex:truncateAt];
		} else {
			story.content = content;
		}

		content_open = NO;
	}
	
	// Close feed title
	if (feed_title_incoming && [elementName isEqualToString:@"title"]) {
		feed_title_incoming = NO;
	}
}

// Formats the stories and outputs them to NSLog
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
