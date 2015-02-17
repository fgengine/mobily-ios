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

#import "MobilyUI.h"

/*--------------------------------------------------*/

@protocol MobilyBuilderObject;

/*--------------------------------------------------*/

@interface MobilyBuilderPreset : NSObject

+ (void)registerAttributes:(NSDictionary*)attributes;
+ (void)registerByName:(NSString*)name attributes:(NSDictionary*)attributes;
+ (void)unregisterByName:(NSString*)name;

+ (NSDictionary*)mixinAttributes:(NSDictionary*)attributes;
+ (NSDictionary*)mixinByName:(NSString*)name attributes:(NSDictionary*)attributes;

+ (BOOL)loadFromFilename:(NSString*)filename;

+ (void)applyPreset:(NSString*)preset object:(id)object;
+ (void)applyPresetAttributes:(NSDictionary*)attributes object:(id)object;

@end

/*--------------------------------------------------*/

@interface MobilyBuilderForm : NSObject

+ (id)objectFromFilename:(NSString*)filename owner:(id)owner;

+ (id< MobilyBuilderObject >)object:(id< MobilyBuilderObject >)object forName:(NSString*)name;
+ (id< MobilyBuilderObject >)object:(id< MobilyBuilderObject >)object forSelector:(SEL)selector;

@end

/*--------------------------------------------------*/

@protocol MobilyBuilderObject < MobilyObject >

@property(nonatomic, readwrite, strong) NSString* objectName;

@property(nonatomic, readwrite, weak) id objectParent;
@property(nonatomic, readwrite, strong) NSArray* objectChilds;

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild;
- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild;

- (void)willLoadObjectChilds;
- (void)didLoadObjectChilds;

- (id< MobilyBuilderObject >)objectForName:(NSString*)name;
- (id< MobilyBuilderObject >)objectForSelector:(SEL)selector;

@end

/*--------------------------------------------------*/
