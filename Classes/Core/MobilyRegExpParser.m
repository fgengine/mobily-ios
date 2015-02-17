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

#import "MobilyRegExpParser.h"

/*--------------------------------------------------*/

@interface MobilyRegExpParser ()

@property(nonatomic, readwrite, strong) NSArray* matches;
@property(nonatomic, readwrite, strong) NSString* result;
@property(nonatomic, readwrite, assign, getter=isNeedApplyParser) BOOL needApplyParser;

- (void)applyParserIfNeed;
- (void)applyParser;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyRegExpMatch ()

@property(nonatomic, readwrite, strong) NSString* originalString;
@property(nonatomic, readwrite, strong) NSArray* originalSubStrings;
@property(nonatomic, readwrite, assign) NSRange originalRange;
@property(nonatomic, readwrite, strong) NSString* resultString;
@property(nonatomic, readwrite, assign) NSRange resultRange;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyRegExpParser

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        self.needApplyParser = NO;
        [self setup];
    }
    return self;
}

- (instancetype)initWithExpression:(NSString*)expression pattern:(NSString*)pattern {
    self = [super init];
    if(self != nil) {
        self.expression = expression;
        self.pattern = pattern;
        self.needApplyParser = NO;
        [self setup];
    }
    return self;
}

- (instancetype)initWithSting:(NSString*)string expression:(NSString*)expression pattern:(NSString*)pattern {
    self = [super init];
    if(self != nil) {
        self.string = string;
        self.expression = expression;
        self.pattern = pattern;
        self.needApplyParser = YES;
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.string = nil;
    self.expression = nil;
    self.pattern = nil;
    self.matches = nil;
    self.result = nil;
}

#pragma mark Property

- (void)setString:(NSString*)string {
    if([_string isEqualToString:string] == NO) {
        _string = string;
        self.needApplyParser = YES;
    }
}

- (void)setExpression:(NSString*)expression {
    if([_expression isEqualToString:expression] == NO) {
        _expression = expression;
        self.needApplyParser = YES;
    }
}

- (void)setPattern:(NSString*)pattern {
    if([_pattern isEqualToString:pattern] == NO) {
        _pattern = pattern;
        self.needApplyParser = YES;
    }
}

- (NSArray*)matches {
    [self applyParserIfNeed];
    return _matches;
}

- (NSString*)result {
    [self applyParserIfNeed];
    return _result;
}

#pragma mark Private

- (void)applyParserIfNeed {
    if(_needApplyParser == YES) {
        self.needApplyParser = NO;
        [self applyParser];
    }
}

- (void)applyParser {
    if(_string.length > 0) {
        NSMutableArray* resultMatches = NSMutableArray.array;
        NSMutableString* resultString = [NSMutableString stringWithString:_string];
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:_expression options:0 error:nil];
        if(regex != nil) {
            __block NSInteger offset = 0;
            [regex enumerateMatchesInString:_string options:0 range:NSMakeRange(0, _string.length) usingBlock:^(NSTextCheckingResult* checkingResult, NSMatchingFlags flags, BOOL* stop) {
                NSUInteger numberOfRanges = checkingResult.numberOfRanges;
                
                NSString* matchOriginalString = [_string substringWithRange:checkingResult.range];
                NSMutableArray* matchOriginalSubStrings = [NSMutableArray arrayWithCapacity:numberOfRanges];
                for(NSUInteger rangeIndex = 1; rangeIndex < numberOfRanges; rangeIndex++) {
                    NSRange range = [checkingResult rangeAtIndex:rangeIndex];
                    NSString* substring = [_string substringWithRange:range];
                    
                    [matchOriginalSubStrings addObject:substring];
                }
                NSRange matchOriginalRange = checkingResult.range;
                
                NSString* matchResultString = [regex replacementStringForResult:checkingResult inString:_string offset:0 template:(_pattern != nil) ? _pattern : @""];
                NSRange matchResultRange = NSMakeRange(matchOriginalRange.location + offset, matchResultString.length);
                
                [resultString replaceCharactersInRange:NSMakeRange(matchOriginalRange.location + offset, matchOriginalRange.length) withString:matchResultString];
                
                MobilyRegExpMatch* match = [MobilyRegExpMatch new];
                if(match != nil) {
                    match.originalString = matchOriginalString;
                    match.originalSubStrings = matchOriginalSubStrings;
                    match.originalRange = matchOriginalRange;
                    match.resultString = matchResultString;
                    match.resultRange = matchResultRange;
                    
                    [resultMatches addObject:match];
                }
                
                offset += (matchResultRange.length - matchOriginalRange.length);
            }];
        }
        self.matches = [resultMatches copy];
        self.result = [resultString copy];
    } else {
        self.matches = nil;
        self.result = nil;
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyRegExpMatch

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.originalString = nil;
    self.originalSubStrings = nil;
    self.resultString = nil;
}

@end

/*--------------------------------------------------*/
