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

#import <MobilyCore/MobilyModel.h>
#import <MobilyCore/MobilyModelJson.h>

/*--------------------------------------------------*/

@interface MobilyModel () {
    NSString* _userDefaultsKey;
    NSString* _fileName;
    NSString* _filePath;
    __weak NSArray* compareMap;
    __weak NSArray* serializeMap;
    __weak NSArray* copyMap;
    __weak NSDictionary* jsonMap;
}

@property(nonatomic, readonly, weak) NSArray* compareMap;
@property(nonatomic, readonly, weak) NSArray* serializeMap;
@property(nonatomic, readonly, weak) NSArray* copyMap;
@property(nonatomic, readonly, weak) NSDictionary* jsonMap;

+ (NSArray*)_arrayMap:(NSMutableDictionary*)cache class:(Class)class selector:(SEL)selector;
+ (NSDictionary*)_dictionaryMap:(NSMutableDictionary*)cache class:(Class)class selector:(SEL)selector;
+ (NSArray*)_buildCompareMap;
+ (NSArray*)_buildSerializeMap;
+ (NSArray*)_buildCopyMap;
+ (NSDictionary*)_buildJsonMap;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelCollection () {
    NSString* _userDefaultsKey;
    NSString* _fileName;
    NSString* _filePath;
    NSMutableArray* _models;
    BOOL _needLoad;
}

- (NSMutableArray*)_mutableModels;
- (void)_loadIsNeed;
- (void)_load;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelQuery () {
    __weak MobilyModelCollection* _collection;
    __weak id< MobilyModelQueryDelegate > _delegate;
    MobilyModelQueryReloadBlock _reloadBlock;
    MobilyModelQueryResortBlock _resortBlock;
    BOOL _resortInvert;
    NSMutableArray* _models;
    BOOL _needReload;
    BOOL _needResort;
}

- (void)_reload;
- (void)_resort;

@end

/*--------------------------------------------------*/
