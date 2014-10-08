/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 fgengine(Alexander Trifonov)  */
/*                                                  */
/* Permission is hereby granted, free of charge,    */
/* to any person obtaining a copy of this software  */
/* and associated documentation files               */
/* (the "Software"), to deal in the Software        */
/* without restriction, including without           */
/* limitation the rights to use, copy, modify,      */
/* merge, publish, distribute, sublicense,          */
/* and/or sell copies of the Software, and to       */
/* permit persons to whom the Software is furnished */
/* to do so, subject to the following conditions:   */
/*                                                  */
/* The above copyright notice and this permission   */
/* notice shall be included in all copies or        */
/* substantial portions of the Software.            */
/*                                                  */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT        */
/* WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,        */
/* INCLUDING BUT NOT LIMITED TO THE WARRANTIES      */
/* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR     */
/* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   */
/* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR   */
/* ANY CLAIM, DAMAGES OR OTHER LIABILITY,           */
/* WHETHER IN AN ACTION OF CONTRACT, TORT OR        */
/* OTHERWISE, ARISING FROM, OUT OF OR IN            */
/* CONNECTION WITH THE SOFTWARE OR THE USE OR       */
/* OTHER DEALINGS IN THE SOFTWARE.                  */
/*                                                  */
/*--------------------------------------------------*/

#import "MobilyBuilder.h"

/*--------------------------------------------------*/

#define MOBILY_BUILDER_PRESET_FILE_EXTENSION        @"mobily"

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_BUILDER_PRESET_ROOT_NAME             @"Presets"
#define MOBILY_BUILDER_PRESET_ELEMENT_NAME          @"Preset"

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static NSMutableDictionary* MOBILY_BUILDER_PRESET = nil;

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyBuilderPresetXML: NSObject < NSXMLParserDelegate >

@property(nonatomic, readwrite, assign) BOOL isFoundedRoot;

- (BOOL)loadFromFilename:(NSString*)filename;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyBuilderPreset

#pragma mark Standart

- (id)init {
    self = [super init];
    if(self != nil) {
    }
    return self;
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

+ (void)registerAttributes:(NSDictionary*)attributes {
    NSString* name = [attributes objectForKey:@"name"];
    if([name isKindOfClass:[NSString class]] == YES) {
        NSMutableDictionary* presetAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
        [presetAttributes removeObjectForKey:@"name"];
        
        [self registerByName:name attributes:[self mixinAttributes:presetAttributes]];
    } else {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_WARNING) != 0)
        NSLog(@"Not found preset name: %@", attributes);
#endif
    }
}

+ (void)registerByName:(NSString*)name attributes:(NSDictionary*)attributes {
    NSMutableDictionary* finalAttributes = [NSMutableDictionary dictionary];
    [attributes enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* value, BOOL* stop) {
        if(([value hasPrefix:@"${"] == YES) && ([value hasSuffix:@"}"] == YES)) {
            NSString* path = [value substringWithRange:NSMakeRange(2, [value length] - 3)];
            NSArray* partPath = [path componentsSeparatedByString:@"."];
            if([partPath count] == 2) {
                if(MOBILY_BUILDER_PRESET != nil) {
                    NSDictionary* preset = [MOBILY_BUILDER_PRESET objectForKey:[partPath objectAtIndex:0]];
                    NSString* presetValue = [preset objectForKey:[partPath objectAtIndex:1]];
                    if(presetValue != nil) {
                        [finalAttributes setObject:presetValue forKey:key];
                    } else {
                        [finalAttributes setObject:value forKey:key];
                    }
                } else {
                    [finalAttributes setObject:value forKey:key];
                }
            } else {
                [finalAttributes setObject:value forKey:key];
            }
        } else {
            [finalAttributes setObject:value forKey:key];
        }
    }];
    if(MOBILY_BUILDER_PRESET == nil) {
        MOBILY_BUILDER_PRESET = MOBILY_SAFE_RETAIN([NSMutableDictionary dictionaryWithObject:finalAttributes forKey:name]);
    } else {
        [MOBILY_BUILDER_PRESET setObject:finalAttributes forKey:name];
    }
}

+ (void)unregisterByName:(NSString*)name {
    if(MOBILY_BUILDER_PRESET != nil) {
        [MOBILY_BUILDER_PRESET removeObjectForKey:name];
    }
}

+ (NSDictionary*)mixinAttributes:(NSDictionary*)attributes {
    __block NSMutableDictionary* result = [NSMutableDictionary dictionaryWithDictionary:attributes];
    NSString* name = [result objectForKey:@"name"];
    if([name isKindOfClass:[NSString class]] == YES) {
        [result removeObjectForKey:@"name"];
    }
    NSString* preset = [result objectForKey:@"preset"];
    if([preset isKindOfClass:[NSString class]] == YES) {
        if(MOBILY_BUILDER_PRESET != nil) {
            NSArray* presets = [preset componentsSeparatedByString:@"|"];
            [presets enumerateObjectsUsingBlock:^(NSString* name, NSUInteger index, BOOL* stop) {
                NSDictionary* presetAttributes = [MOBILY_BUILDER_PRESET objectForKey:name];
                if(presetAttributes != nil) {
                    [result addEntriesFromDictionary:presetAttributes];
                }
            }];
        }
        [result removeObjectForKey:@"preset"];
    }
    return result;
}

+ (NSDictionary*)mixinByName:(NSString*)name attributes:(NSDictionary*)attributes {
    if(MOBILY_BUILDER_PRESET != nil) {
        NSDictionary* preset = [MOBILY_BUILDER_PRESET objectForKey:name];
        if(preset != nil) {
            NSMutableDictionary* result = [NSMutableDictionary dictionaryWithDictionary:preset];
            if(result != nil) {
                [result addEntriesFromDictionary:attributes];
                return result;
            }
        }
    }
    return attributes;
}

+ (BOOL)loadFromFilename:(NSString*)filename {
    BOOL result = NO;
    MobilyBuilderPresetXML* preset = [[MobilyBuilderPresetXML alloc] init];
    if(preset != nil) {
        result = [preset loadFromFilename:filename];
    }
    return result;
}

+ (void)applyPreset:(NSString*)preset object:(id)object {
    NSDictionary* presetAttributes = [MOBILY_BUILDER_PRESET objectForKey:preset];
    if([presetAttributes count] > 0) {
        [self applyPresetAttributes:presetAttributes object:object];
    }
}

+ (void)applyPresetAttributes:(NSDictionary*)presetAttributes object:(id)object {
    static NSCharacterSet* characterSet = nil;
    if(characterSet == nil) {
        characterSet = [NSCharacterSet characterSetWithCharactersInString:@":-"];
    }
    [presetAttributes enumerateKeysAndObjectsUsingBlock:^(NSString* key, id value, BOOL* stop) {
        __block NSString* validKey = [NSString string];
        NSArray* components = [key componentsSeparatedByCharactersInSet:characterSet];
        if([components count] > 1) {
            [components enumerateObjectsUsingBlock:^(NSString* component, NSUInteger index, BOOL* stop) {
                validKey = [validKey stringByAppendingString:[component stringByUppercaseFirstCharacterString]];
            }];
            validKey = [validKey stringByLowercaseFirstCharacterString];
        } else {
            validKey = [key stringByLowercaseFirstCharacterString];
        }
        if([validKey length] > 0) {
            if([object validateValue:&value forKey:validKey error:nil] == YES) {
                @try {
                    [object setValue:value forKey:validKey];
                }
                @catch(NSException *exception) {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
                    NSLog(@"Failure set value in property: '%@=%@'; object: '%@'", validKey, value, object);
#endif
                }
            } else {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
                NSLog(@"Not found property: '%@=%@'; object: '%@'", validKey, value, object);
#endif
            }
        }
    }];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyBuilderPresetXML

#pragma mark Standart

- (id)init {
    self = [super init];
    if(self != nil) {
    }
    return self;
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Private

- (BOOL)loadFromFilename:(NSString*)filename {
    BOOL result = NO;
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_INFO) != 0)
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
#endif
    NSURL* url = [[NSBundle mainBundle] URLForResource:filename withExtension:MOBILY_BUILDER_PRESET_FILE_EXTENSION];
    if(url != nil) {
        NSXMLParser* parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        if(parser != nil) {
            [parser setDelegate:self];
            result = [parser parse];
        }
    }
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_INFO) != 0)
    NSTimeInterval delta = [NSDate timeIntervalSinceReferenceDate] - now;
    NSLog(@"MobilyLoader:%@ (%lu ms)", filename, (unsigned long)(delta * 1000));
#endif
    return result;
}

#pragma mark NSXMLParserDelegate

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributes {
    if(_isFoundedRoot == NO) {
        if([elementName isEqualToString:MOBILY_BUILDER_PRESET_ROOT_NAME] == YES) {
            _isFoundedRoot = YES;
        } else {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
            NSLog(@"Unsupported element name: '%@'; lineNumber: %ld; columnNumber: %ld", elementName, (long)[parser lineNumber], (long)[parser columnNumber]);
#endif
            [parser abortParsing];
        }
    } else {
        if([elementName isEqualToString:MOBILY_BUILDER_PRESET_ELEMENT_NAME] == YES) {
            [MobilyBuilderPreset registerAttributes:attributes];
        } else {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
            NSLog(@"Unsupported element name: '%@'; lineNumber: %ld; columnNumber: %ld", elementName, (long)[parser lineNumber], (long)[parser columnNumber]);
#endif
            [parser abortParsing];
        }
    }
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName {
    if(_isFoundedRoot == YES) {
        if([elementName isEqualToString:MOBILY_BUILDER_PRESET_ROOT_NAME] == YES) {
            _isFoundedRoot = NO;
        }
    }
}

@end

/*--------------------------------------------------*/
