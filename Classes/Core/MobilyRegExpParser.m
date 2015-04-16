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

#import <Mobily/MobilyRegExpParser.h>

/*--------------------------------------------------*/

@interface MobilyRegExpParser () {
@protected
    NSString* _string;
    NSString* _expression;
    NSString* _pattern;
    NSArray* _matches;
    NSString* _result;
    BOOL _needApplyParser;
}

- (void)applyParserIfNeed;
- (void)applyParser;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyRegExpMatch () {
@protected
    NSString* _originalString;
    NSArray* _originalSubStrings;
    NSRange _originalRange;
    NSString* _resultString;
    NSRange _resultRange;
}

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

#pragma mark Synthesize

@synthesize string = _string;
@synthesize expression = _expression;
@synthesize pattern = _pattern;
@synthesize matches = _matches;
@synthesize result = _result;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        _needApplyParser = NO;
        [self setup];
    }
    return self;
}

- (instancetype)initWithExpression:(NSString*)expression pattern:(NSString*)pattern {
    self = [super init];
    if(self != nil) {
        _expression = expression;
        _pattern = pattern;
        _needApplyParser = NO;
        [self setup];
    }
    return self;
}

- (instancetype)initWithSting:(NSString*)string expression:(NSString*)expression pattern:(NSString*)pattern {
    self = [super init];
    if(self != nil) {
        _string = string;
        _expression = expression;
        _pattern = pattern;
        _needApplyParser = YES;
        [self setup];
    }
    return self;
}

- (void)setup {
}

#pragma mark Property

- (void)setString:(NSString*)string {
    if([_string isEqualToString:string] == NO) {
        _string = string;
        _needApplyParser = YES;
    }
}

- (void)setExpression:(NSString*)expression {
    if([_expression isEqualToString:expression] == NO) {
        _expression = expression;
        _needApplyParser = YES;
    }
}

- (void)setPattern:(NSString*)pattern {
    if([_pattern isEqualToString:pattern] == NO) {
        _pattern = pattern;
        _needApplyParser = YES;
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
        _needApplyParser = NO;
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
            [regex enumerateMatchesInString:_string options:0 range:NSMakeRange(0, _string.length) usingBlock:^(NSTextCheckingResult* checkingResult, NSMatchingFlags flags __unused, BOOL* stop __unused) {
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
        _matches = [resultMatches copy];
        _result = [resultString copy];
    } else {
        _matches = nil;
        _result = nil;
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyRegExpMatch

#pragma mark Synthesize

@synthesize originalString = _originalString;
@synthesize originalSubStrings = _originalSubStrings;
@synthesize originalRange = _originalRange;
@synthesize resultString = _resultString;
@synthesize resultRange = _resultRange;

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

@end

/*--------------------------------------------------*/
