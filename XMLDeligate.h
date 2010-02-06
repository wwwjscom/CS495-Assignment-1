//
//  XMLDeligate.h
//  RSSReader
//
//  Created by Jason Soo on 2/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Story.h"

@interface XMLDeligate : NSObject <NSXMLParserDelegate> {
	NSMutableString *feed_title;
	NSMutableString *title;
	NSMutableString *date;
	NSMutableArray *stories;
	Story *story;
	int limit;
	BOOL feed_title_incoming;
	BOOL item_open;
	BOOL title_open;
	BOOL date_open;
}

- (id)initWithLimit:(int)theLimit;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)showStories;
//- (void)dealloc;

@end
