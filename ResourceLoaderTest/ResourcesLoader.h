//
//  ResourcesLoader.h
//  Escape
//
//  Created by Bartłomiej Wilczyński on 7/25/10.
//  Copyright 2010 XPerienced. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAGLView.h"

@protocol ResourceLoaderDelegate;

@interface ResourcesLoader : NSObject {
	NSMutableSet *_resources;
	NSDictionary *_loaders;
	NSInteger _loadedResources;
	NSLock *_lock;
}

@property (nonatomic, retain) NSMutableSet *resources;
@property (nonatomic, retain) NSDictionary *loaders;

+ (id)sharedLoader;
- (void)addResources:(id)firstResource, ... NS_REQUIRES_NIL_TERMINATION;
- (void)loadResources:(id<ResourceLoaderDelegate>)delegate;

@end

@protocol ResourceLoaderDelegate

- (void)didReachProgressMark:(CGFloat)progressPercentage;

@end

@protocol ResourceLoader

- (void)loadResource:(NSString*)path;

@end

@interface TextureLoader : NSObject<ResourceLoader> {
	EAGLContext *_auxEAGLcontext;
	NSLock *_lock;
}

+ (id)loader;

@end

@interface SoundEffectLoader : NSObject<ResourceLoader>

+ (id)loader;

@end
