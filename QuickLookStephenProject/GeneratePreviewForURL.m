#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <QuickLook/QuickLook.h>
#import <Foundation/Foundation.h>
#import "yaml/YAMLSerialization.h"
#import "KitSpec.h"

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

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
	[props setObject:[NSNumber numberWithInt:500] forKey:(NSString *)kQLPreviewPropertyWidthKey];
	[props setObject:[NSNumber numberWithInt:500] forKey:(NSString *)kQLPreviewPropertyHeightKey];	

	if([[(NSURL *) url absoluteString] hasSuffix:@"KitSpec"]) 
	{
		text = [[[KitSpec alloc] initWithUrl:(NSURL *) url] html];
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
