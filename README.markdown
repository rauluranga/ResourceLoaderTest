Works with the latest version of Cocos2D.

##Usage

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
