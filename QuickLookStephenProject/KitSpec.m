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
}

-(id)initWithUrl:(NSURL *)url
{
	self = [super init];
	if (self != nil) {
		NSData *data = [NSData dataWithContentsOfURL:(NSURL *) url];
		yaml = [[YAMLSerialization YAMLWithData: data options:kYAMLReadOptionStringScalars error: nil] retain];		
		dependencies = [[NSMutableArray alloc] init];
		baseKit = [[KitSpecItem alloc] init];
	}
	return self;	
}

-(NSString *)html
{
	return @"To Do...";
}

-(void)build
{
	NSDictionary *dic = [yaml objectAtIndex:0];
	baseKit.name = [dic objectForKey:kKIT_NAME];
	baseKit.version = [dic objectForKey:kKit_VERSION];
	
}

@end
