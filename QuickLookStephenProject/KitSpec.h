//
//  KitSpec.h
//  QuickLookStephen
//
//  Created by Kim Hunter on 17/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PlainTextToHTML.h"
#import "KitSpecItem.h"

#define kKIT_NAME @"name"
#define kKIT_VERSION @"version"
#define kKIT_DEP @"dependencies"

@interface KitSpec : NSObject<PlainTextToHTML> {
	NSMutableArray *yaml;
	KitSpecItem *baseKit;
	NSMutableArray *dependencies;
	NSMutableDictionary *optionalKeys;
	NSString *rawText;
}

@property (nonatomic, retain) KitSpecItem *baseKit;
@property (nonatomic, retain) NSString *rawText;

-(void)build;
-(void) replaceInString:(NSMutableString *)str placeHolder:(NSString *)place withString:(NSString *)replace;

@end
