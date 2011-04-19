//
//  KitSpecItem.m
//  QuickLookStephen
//
//  Created by Kim Hunter on 17/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KitSpecItem.h"


@implementation KitSpecItem

@synthesize name;
@synthesize version;

-(void)dealloc
{
	self.name = nil;
	self.version = nil;
	[super dealloc];
}

@end
