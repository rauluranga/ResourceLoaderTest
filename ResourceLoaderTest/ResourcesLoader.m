//
//  ResourcesLoader.m
//  Escape
//
//  Created by Bartłomiej Wilczyński on 7/25/10.
//  Copyright 2010 XPerienced. All rights reserved.
//

#import "ResourcesLoader.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "NSThread+BlockExtensions.h"


@implementation ResourcesLoader

static id _sharedLoader = nil;

@synthesize resources = _resources, loaders = _loaders;

+ (id)sharedLoader
{
	if (!_sharedLoader) {
		_sharedLoader = [[self alloc] init];
	}
	
	return _sharedLoader;	
}

- (id)init
{
	if ((self = [super init])) {
		_lock = [[NSLock alloc] init];
		
		self.resources = [NSMutableSet set];
		self.loaders = [NSDictionary dictionaryWithObjectsAndKeys:
						[TextureLoader loader], @"png",
						[SoundEffectLoader loader], @"wav", nil];
	}
	
	return self;
}

- (void)addResources:(NSString *)firstResource, ...
{
	if (firstResource)
	{
		[self.resources addObject: firstResource];
		
		NSString *eachObject;
		va_list argumentList;
		va_start(argumentList, firstResource);
		
		while ((eachObject = va_arg(argumentList, id))) {
			[self.resources addObject: eachObject];
		}
		
		va_end(argumentList);
	}
}

- (void)loadResources:(id<ResourceLoaderDelegate>)delegate
{
	_loadedResources = 0;
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	
	for (NSString *resource in self.resources) {
		NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
			NSString *key = [resource pathExtension];
			id<ResourceLoader> loader = [self.loaders objectForKey:key];
			[loader loadResource:resource];
			
			[_lock lock];
			@try {
				_loadedResources++;
				float progress = (float)_loadedResources / [self.resources count];		
				
				[[NSThread mainThread] performBlock:^ {
					[delegate didReachProgressMark:progress];
				} waitUntilDone:NO];
				
				if (_loadedResources == [self.resources count]) {
					[self.resources removeAllObjects];
				}
			}
			@finally {
				[_lock unlock];
			}
		}];
		
		[queue addOperation:operation];
	}
	
	[queue release];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	self.resources = nil;
	self.loaders = nil;
	[_lock release];
	
	_sharedLoader = nil;
	
	[super dealloc];
}

@end

@implementation TextureLoader

+ (id)loader
{
	return [[[self alloc] init] autorelease];
}

- (id)init
{
	if ((self = [super init])) {
		_lock = [[NSLock alloc] init];
	}
	
	return self;
}

- (void)loadResource:(NSString *)path
{
	if (![NSThread isMainThread]) {
		[_lock lock];
		
		if(_auxEAGLcontext == nil ) {
			_auxEAGLcontext = [[EAGLContext alloc]
							  initWithAPI:kEAGLRenderingAPIOpenGLES1
							  sharegroup:[[[[CCDirector sharedDirector] openGLView] context] sharegroup]];
		}
		
		[EAGLContext setCurrentContext: _auxEAGLcontext];
		[[CCTextureCache sharedTextureCache] addImage:path];
		[EAGLContext setCurrentContext:nil];
		
		[_lock unlock];
	}
	else {
		[[CCTextureCache sharedTextureCache] addImage:path];
	}
}

- (void)dealloc
{
	[_lock release];
	[_auxEAGLcontext release];
	_auxEAGLcontext = nil;
	
	[super dealloc];
}

@end

@implementation SoundEffectLoader

+ (id)loader
{
	return [[[self alloc] init] autorelease];
}

- (void)loadResource:(NSString *)path
{
	[[SimpleAudioEngine sharedEngine] preloadEffect:path];
}

@end

