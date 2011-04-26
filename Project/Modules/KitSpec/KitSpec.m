//
//  KitSpec.m
//  QLPlainText
//
//  Created by Kim Hunter on 17/04/11.
//  Copyright 2011 Kim Hunter. All rights reserved.
//

#import "KitSpec.h"
#import "YAMLSerialization.h"


@implementation KitSpec
@synthesize baseKit;
@synthesize rawText;
@synthesize path;

-(void)dealloc
{
	[dependencies release];
	[baseKit release];
	[yaml release];
	[optionalKeys release];
	[rawText release];
	[path release];
	[super dealloc];
}


-(id)initWithUrl:(NSURL *)url
{
	self = [super init];
	if (self != nil) {
		
		NSData *data = [NSData dataWithContentsOfURL:url];
		self.rawText = [NSString stringWithContentsOfURL:url
												encoding:NSUTF8StringEncoding
												   error:nil];
		yaml = [[YAMLSerialization YAMLWithData:data options:kYAMLReadOptionStringScalars error: nil] retain];
		
		self.path = [[url path] stringByReplacingOccurrencesOfString:NSHomeDirectory() withString:@"~"];
		dependencies = [[NSMutableArray alloc] init];
		baseKit = [[KitSpecItem alloc] init];
		[self build];
	}
	return self;	
}
-(void) replaceInString:(NSMutableString *)str placeHolder:(NSString *)place withString:(NSString *)replace
{
	[str replaceCharactersInRange:[str rangeOfString:place] withString:replace];
}

-(NSString *)html
{
	NSMutableString *tmp = [[[NSMutableString alloc] init] autorelease];

	[tmp appendString:@"<ul>\n"];
	for (KitSpecItem *item in dependencies) {
		[tmp appendFormat:@"\t<li>%@ (%@)</li>\n", item.name, item.version];
	}
	[tmp appendString:@"</ul>\n"];
	if ([optionalKeys count]) {
		[tmp appendFormat:@"<h3>Variables</h3>\n"];
		for (NSString *k in [optionalKeys allKeys]) {
			[tmp appendFormat:@"<p> %@ : %@ </p>\n", k, [optionalKeys objectForKey:k]];
		}
	}
	NSMutableString *html = [NSMutableString stringWithContentsOfFile:[[NSBundle bundleWithIdentifier:@"info.kimhunter.qlplaintext"] pathForResource:@"kit" ofType:@"html"]
															 encoding:NSUTF8StringEncoding 
																error:nil];

	[self replaceInString:html placeHolder:@"__KIT_NAME__" withString:self.baseKit.name];
	[self replaceInString:html placeHolder:@"__FILE_NAME__" withString:self.path];
	[self replaceInString:html placeHolder:@"__KIT_VERSION__" withString:self.baseKit.version];
	[self replaceInString:html placeHolder:@"__DEPS__" withString:tmp];
	[self replaceInString:html placeHolder:@"__SOURCE__" withString:self.rawText];
	return html;
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
	NSMutableDictionary *otherKeys = [dic mutableCopy];
	[otherKeys removeObjectsForKeys:[NSArray arrayWithObjects:kKIT_NAME, kKIT_DEP, kKIT_VERSION, nil]];
	optionalKeys = otherKeys;
}

@end
