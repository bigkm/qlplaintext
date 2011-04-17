#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <QuickLook/QuickLook.h>
#import <Foundation/Foundation.h>
#import "yaml/YAMLSerialization.h"

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */
NSString *getHtmlFromYamlKit(NSMutableArray *baseYaml) 
{
	NSString *result;
	NSDictionary *kitspec;
	NSString *name;
	NSString *version;
	NSArray *depsArray;
	NSMutableString *tmp;

	if ([baseYaml count] == 0) {
		return @"<h1>INVALID NO CONTENT</h1>";
	}
	kitspec = [baseYaml objectAtIndex:0];
	name = [kitspec objectForKey:@"name"];
	version = [kitspec objectForKey:@"version"];
	depsArray = [kitspec objectForKey:@"dependencies"];
	if([depsArray count] > 0) {
		tmp = [[[NSMutableString alloc] init] autorelease];
		[tmp appendString:@"<ul>"];
		for (NSDictionary *dep in depsArray) {
			NSString *key = [[dep allKeys] lastObject];
			[tmp appendFormat:@"<li>%@ (%@)</li>", key, [dep objectForKey:key]];
		}
		[tmp appendString:@"</ul>"];
	}
	result = [NSString stringWithFormat:@"<html><body><h1>%@ (%@)</h1>%@</body></html>", name, version, tmp];
		
	return result;
}
OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, 
                               CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{	
	if (QLPreviewRequestIsCancelled(preview))
        return noErr;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSData *data;
	NSString *text;
	NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
	[props setObject:@"UTF-8" forKey:(NSString *)kQLPreviewPropertyTextEncodingNameKey];
	[props setObject:@"text/plain" forKey:(NSString *)kQLPreviewPropertyMIMETypeKey];
	[props setObject:[NSNumber numberWithInt:700] forKey:(NSString *)kQLPreviewPropertyWidthKey];
	[props setObject:[NSNumber numberWithInt:500] forKey:(NSString *)kQLPreviewPropertyHeightKey];	

	if([[(NSURL *) url absoluteString] hasSuffix:@"KitSpec"]) 
	{
		data = [NSData dataWithContentsOfURL:(NSURL *) url];
		NSMutableArray *yaml = [YAMLSerialization YAMLWithData: data options:kYAMLReadOptionStringScalars error: nil];
		//NSLog(@"%@", [[yaml objectAtIndex:0] objectForKey:@"dependencies"]);
		
		NSLog(@"Its a Kit Spec %@", (NSURL *) url);
		
		text = getHtmlFromYamlKit(yaml);
		[props setObject:@"text/html" forKey:(NSString *)kQLPreviewPropertyMIMETypeKey];
		
	} 
	else 
	{
		text = [NSString stringWithContentsOfURL:(NSURL *)url
										encoding:NSUTF8StringEncoding
										   error:nil];
	}
	
	QLPreviewRequestSetDataRepresentation(
										  preview,
										  (CFDataRef)[text dataUsingEncoding:NSUTF8StringEncoding],
										  kUTTypeHTML,
										  (CFDictionaryRef)props);

	
	[pool release];
	
	return noErr;
}

void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
    // implement only if supported
}
