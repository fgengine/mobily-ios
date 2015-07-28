/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 Mobily TEAM                   */
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
#define MOBILY_SOURCE
/*--------------------------------------------------*/

#import <MobilyCore/MobilyBuilder.h>

/*--------------------------------------------------*/

#define MOBILY_BUILDER_FORM_FILE_EXTENSION          @"mobily"
#define MOBILY_BUILDER_FORM_CLASS                   @"Mobily%@"

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyBuilderForm ()

+ (BOOL)object:(id)object outletName:(NSString*)outletName outletObject:(id< MobilyBuilderObject >)outletObject;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyBuilderFormXML : NSObject < NSXMLParserDelegate > {
    NSMutableArray* _stackFormObjects;
    id< MobilyBuilderObject > _lastFormObject;
    id< MobilyBuilderObject > _rootFormObject;
    NSUInteger _ignoreSubObject;
}

- (id)objectFromFilename:(NSString*)filename owner:(id)owner;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyBuilderForm

#pragma mark Public

+ (id)objectFromFilename:(NSString*)filename owner:(id)owner {
    MobilyBuilderFormXML* loader = [MobilyBuilderFormXML new];
    if(loader != nil) {
        return [loader objectFromFilename:filename owner:owner];
    }
    return nil;
}

+ (id< MobilyBuilderObject >)object:(id< MobilyBuilderObject >)object forName:(NSString*)name {
    id< MobilyBuilderObject > result = nil;
    if([object respondsToSelector:@selector(objectName)] == YES) {
        if([object.objectName isEqualToString:name] == YES) {
            result = object;
        } else {
            for(id objectChild in object.objectChilds) {
                if([objectChild respondsToSelector:@selector(objectForName:)] == YES) {
                    id tempObjectChild = [objectChild objectForName:name];
                    if(tempObjectChild != nil) {
                        result = tempObjectChild;
                        break;
                    }
                }
            }
        }
    }
    return result;
}

+ (id< MobilyBuilderObject >)object:(id)object forSelector:(SEL)selector {
    if([object respondsToSelector:selector] == YES) {
        return object;
    }
    id< MobilyBuilderObject > objectParent = [object objectParent];
    if([objectParent respondsToSelector:@selector(objectForSelector:)] == YES) {
        return [objectParent objectForSelector:selector];
    }
    return nil;
}

#pragma mark Private

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
+ (BOOL)object:(id)object outletName:(NSString*)outletName outletObject:(id< MobilyBuilderObject >)outletObject {
    BOOL isLinked = NO;
    SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", outletName.moStringByUppercaseFirstCharacterString]);
    if([object respondsToSelector:setter] == YES) {
        [object performSelector:setter withObject:outletObject];
        isLinked = YES;
    }
    id objectParent = [object objectParent];
    if(objectParent != nil) {
        isLinked = [self object:objectParent outletName:outletName outletObject:outletObject];
    }
    return isLinked;
}
#pragma clang diagnostic pop

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyBuilderFormXML

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        _stackFormObjects = NSMutableArray.array;
    }
    return self;
}

#pragma mark Private

- (id)objectFromFilename:(NSString*)filename owner:(id)owner {
    id result = nil;
    
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_INFO) != 0)
    NSTimeInterval now = NSDate.timeIntervalSinceReferenceDate;
#endif
    NSString* filePath = [NSBundle.mainBundle pathForResource:filename ofType:MOBILY_BUILDER_FORM_FILE_EXTENSION];
    if([NSFileManager.defaultManager fileExistsAtPath:filePath] == YES) {
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        if(data != nil) {
            _lastFormObject = owner;
            
            NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
            if(parser != nil) {
                parser.delegate = self;
                if([parser parse] == YES) {
                    result = _rootFormObject;
                }
            }
        }
    }
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_INFO) != 0)
    NSTimeInterval delta = NSDate.timeIntervalSinceReferenceDate - now;
    NSLog(@"MobilyLoader:%@ (%lu ms)", filename, (unsigned long)(delta * 1000));
#endif
    return result;
}

#pragma mark NSXMLParserDelegate

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString* __unused)namespaceURI qualifiedName:(NSString* __unused)qualifiedName attributes:(NSDictionary*)attributes {
    if(_ignoreSubObject == 0) {
        Class targetClass = nil;
        Class customClass = NSClassFromString(elementName);
        if(customClass != nil) {
            targetClass = customClass;
        } else {
            Class defaultClass = NSClassFromString([NSString stringWithFormat:MOBILY_BUILDER_FORM_CLASS, elementName]);
            if(defaultClass != nil) {
                targetClass = defaultClass;
            }
        }
        id< MobilyBuilderObject > target = nil;
        if([targetClass conformsToProtocol:@protocol(MobilyBuilderObject)] == YES) {
            target = [targetClass new];
        }
        if(target != nil) {
            if(_rootFormObject == nil) {
                _rootFormObject = target;
            }
            target.objectParent = _lastFormObject;
            NSString* targetName = attributes[@"name"];
            if(targetName.length > 0) {
                target.objectName = targetName;
                [MobilyBuilderForm object:_lastFormObject outletName:targetName outletObject:target];
            }
            if(attributes.count > 0) {
                NSDictionary* mixinAttirutes = [MobilyBuilderPreset mixinAttributes:attributes];
                if(mixinAttirutes.count > 0) {
                    [MobilyBuilderPreset applyPresetAttributes:mixinAttirutes object:target];
                }
            }
            [target willLoadObjectChilds];
            
            [_lastFormObject addObjectChild:target];
            [_stackFormObjects addObject:target];
            _lastFormObject = target;
        } else {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
            NSLog(@"Not found class: '%@'; lineNumber: %ld; columnNumber: %ld", elementName, (long)parser.lineNumber, (long)parser.columnNumber);
#endif
            _ignoreSubObject = 1;
        }
    } else {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
        NSLog(@"Ignore loading element: '%@'; lineNumber: %ld; columnNumber: %ld", elementName, (long)parser.lineNumber, (long)parser.columnNumber);
#endif
        _ignoreSubObject++;
    }
}

- (void)parser:(NSXMLParser* __unused)parser didEndElement:(NSString* __unused)elementName namespaceURI:(NSString* __unused)namespaceURI qualifiedName:(NSString* __unused)qualifiedName {
    if(_ignoreSubObject == 0) {
        [_lastFormObject didLoadObjectChilds];
        [_stackFormObjects removeObject:_lastFormObject];
        _lastFormObject = [_stackFormObjects lastObject];
    } else {
        _ignoreSubObject--;
    }
}

@end

/*--------------------------------------------------*/
