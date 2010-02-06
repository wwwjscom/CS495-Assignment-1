//
//  XMLDeligate.h
//  RSSReader
//
//  Created by Jason Soo on 2/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XMLDeligate : NSObject <NSXMLParserDelegate> {
	NSMutableString *feed_title;
	NSMutableString *title;
	NSMutableArray *stories;
	int limit;
}

- (id)initWithLimit:(int *)theLimit;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)showStories;

@end
