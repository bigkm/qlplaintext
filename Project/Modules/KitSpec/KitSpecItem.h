//
//  KitSpecItem.h
//  QLPlainText
//
//  Created by Kim Hunter on 17/04/11.
//  Copyright 2011 Kim Hunter. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface KitSpecItem : NSObject {
	NSString *name;
	NSString *version;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *version;

@end
