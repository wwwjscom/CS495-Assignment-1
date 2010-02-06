#import <Foundation/Foundation.h>
#import "XMLDeligate.h"
#import	"Feed.h"

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
		Feed *feed = [[[Feed alloc] initWithDic:dic] autorelease];

		// Only continue if the feed is indeed enabled
		if (feed.enabled) {
			
			// Setup the XML parser
			NSXMLParser *parser = [[[NSXMLParser alloc] initWithContentsOfURL:feed.feedURL] autorelease];
			
			// Setup the deligate for the XML parsing
			XMLDeligate *myDeligate = [[XMLDeligate alloc] initWithLimit:feed.limit];
			[parser setDelegate:myDeligate];
			
			myDeligate.truncateAt = feed.truncateAt;
			
			// Begin the parsing & notify the deligate
			[parser parse];
			
			// Display the cached stories
			[myDeligate showStories];
			
			//[myDeligate release]; // Errors out...
		}
	}
	
    [pool drain];
    return 0;
}
