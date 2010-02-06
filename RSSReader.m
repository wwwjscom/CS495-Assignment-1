#import <Foundation/Foundation.h>
#import "XMLDeligate.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	// Read the plist into a dictionary
	NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:
								  @"settings.plist"];
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings registerDefaults:settingsDict];
	
	
	// Find the URL Feed
	NSArray *set = [settings arrayForKey:@"Feeds"];
	
	// Iterate over all the feeds
	for (NSDictionary *dic in set) {
		
		// Only continue if the feed is indeed enabled
		if ([[dic objectForKey:@"Enabled"] boolValue]) {
			
			NSString *url = [dic objectForKey:@"FeedURL"];
			NSURL *feedURL = [NSURL URLWithString:url];
			
			// Setup the XML parser
			NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:feedURL];
			
			// Setup the deligate for the XML parsing
			NSString *limit = [dic objectForKey:@"MaxNewsItems"];
			XMLDeligate *myDeligate = [[XMLDeligate alloc] initWithLimit:[limit intValue]];
			[parser setDelegate:myDeligate];
			
			// Begin the parsing & notify the deligate
			[parser parse];
			
			// Display the cached stories
			[myDeligate showStories];
		}
	}
	
    [pool drain];
    return 0;
}
