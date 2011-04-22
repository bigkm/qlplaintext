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
	NSString *text;
	NSURL *urlPath = (NSURL *) url;
	NSMutableDictionary *props = [[NSMutableDictionary alloc] init];

	[props setObject:@"UTF-8" forKey:(NSString *)kQLPreviewPropertyTextEncodingNameKey];
	[props setObject:@"text/plain" forKey:(NSString *)kQLPreviewPropertyMIMETypeKey];
	[props setObject:[NSNumber numberWithInt:700] forKey:(NSString *)kQLPreviewPropertyWidthKey];
	[props setObject:[NSNumber numberWithInt:500] forKey:(NSString *)kQLPreviewPropertyHeightKey];	
	
	NSString *baseName = [[urlPath path] lastPathComponent];
	Class module = NSClassFromString(baseName);
	
	if(module && [module conformsToProtocol:@protocol(PlainTextToHTML)]) 
	{	
		id generator = [[module alloc] initWithUrl:(NSURL *) url];
		text = [generator html];
		[generator release];
		
		[props setObject:@"text/html" forKey:(NSString *)kQLPreviewPropertyMIMETypeKey];
	} 
	else 
	{
		text = [NSString stringWithContentsOfURL:(NSURL *)url
										encoding:NSUTF8StringEncoding
										   error:nil];
	}
	
	QLPreviewRequestSetDataRepresentation(preview,
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
