
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "ResourcesLoader.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer<ResourceLoaderDelegate>
{
	CCProgressTimer *_progress;
	CCLabelTTF *_loadingLabel;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
