//
//  PlainTextToHTML.h
//  QuickLookStephen
//
//  Created by Kim Hunter on 17/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol PlainTextToHTML

@required
-(id)initWithUrl:(NSURL *) url;
-(NSString *) html;

@end
