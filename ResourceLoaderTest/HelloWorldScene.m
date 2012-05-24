//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "HelloWorldScene.h"

// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		// init view
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		_progress = [CCProgressTimer progressWithFile:@"Icon.png"];
		_progress.type = kCCProgressTimerTypeRadialCW;
		_progress.position = ccp(winSize.width / 2, winSize.height / 2);
		[self addChild:_progress];
		
		_loadingLabel = [CCLabelTTF labelWithString:@"Loading..." fontName:@"Marker Felt" fontSize:24];
		_loadingLabel.position = ccp(winSize.width / 2, winSize.height / 2 + [_progress contentSize].height / 2 + [_loadingLabel contentSize].height);
		[self addChild:_loadingLabel];
		
		// load resources
		ResourcesLoader *loader = [ResourcesLoader sharedLoader];
		NSArray *extensions = [NSArray arrayWithObjects:@"png", @"wav", nil];
		
		for (NSString *extension in extensions) {
			NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:extension inDirectory:nil];
			for (NSString *filename in paths) {
				filename = [[filename componentsSeparatedByString:@"/"] lastObject];
				[loader addResources:filename, nil];
			}
		}
		
		// load it async
		[loader loadResources:self];
	}
	return self;
}

- (void) didReachProgressMark:(CGFloat)progressPercentage
{
	[_progress setPercentage:progressPercentage * 100];
	
	if (progressPercentage == 1.0f) {
		[_loadingLabel setString:@"Loading complete"];
	}
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
