//
//  KitSpec.m
//  QuickLookStephen
//
//  Created by Kim Hunter on 17/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KitSpec.h"
#import "YAMLSerialization.h"


@implementation KitSpec
@synthesize baseKit;

-(void)dealloc
{
	[dependencies release];
	[baseKit release];
	[yaml release];
	[super dealloc];
}

-(id)initWithUrl:(NSURL *)url
{
	self = [super init];
	if (self != nil) {
		NSData *data = [NSData dataWithContentsOfURL:(NSURL *) url];
		yaml = [[YAMLSerialization YAMLWithData: data options:kYAMLReadOptionStringScalars error: nil] retain];		
		dependencies = [[NSMutableArray alloc] init];
		baseKit = [[KitSpecItem alloc] init];
		[self build];
	}
	return self;	
}

-(NSString *)html
{
	NSString *result;
	NSMutableString *tmp = [[[NSMutableString alloc] init] autorelease];
	[tmp appendString:@"<ul>"];
	for (KitSpecItem *item in dependencies) {
		[tmp appendFormat:@"<li>%@ (%@)</li>", item.name, item.version];
	}
	[tmp appendString:@"</ul>"];

	result = [NSString stringWithFormat:@"<html><body><br /><h1>%@ (%@)</h1> %@ </body></html>", self.baseKit.name, self.baseKit.version, tmp];	
	return result;
}

-(void)build
{
	NSDictionary *dic = [yaml objectAtIndex:0];
	baseKit.name = [dic objectForKey:kKIT_NAME];
	baseKit.version = [dic objectForKey:kKIT_VERSION];
	NSArray *deps = [dic objectForKey:kKIT_DEP];
	for (id dep in deps) {
		KitSpecItem *item = [[KitSpecItem alloc] init];
		switch ([dep count]) {
			case 1:
				item.name = [[dep allKeys] lastObject];
				item.version = [dep objectForKey:item.name];
				[dependencies addObject:item];
				break;
			case 2:
				item.name = [dep objectForKey:kKIT_NAME];
				item.version = [dep objectForKey:kKIT_VERSION];
				[dependencies addObject:item];
				break;
			default:
				break;
		}
		[item release];
	}	
	
}

@end
