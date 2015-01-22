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

#pragma mark Standart

- (id)init {
    self = [super init];
    if(self != nil) {
        [self setNeedApplyParser:NO];
    }
    return self;
}

- (id)initWithExpression:(NSString*)expression pattern:(NSString*)pattern {
    self = [super init];
    if(self != nil) {
        MOBILY_SAFE_SETTER(_expression, expression);
        MOBILY_SAFE_SETTER(_pattern, pattern);
        [self setNeedApplyParser:NO];
    }
    return self;
}

- (id)initWithSting:(NSString*)string expression:(NSString*)expression pattern:(NSString*)pattern {
    self = [super init];
    if(self != nil) {
        MOBILY_SAFE_SETTER(_string, string);
        MOBILY_SAFE_SETTER(_expression, expression);
        MOBILY_SAFE_SETTER(_pattern, pattern);
        [self setNeedApplyParser:YES];
    }
    return self;
}

- (void)dealloc {
    [self setString:nil];
    [self setExpression:nil];
    [self setPattern:nil];
    [self setMatches:nil];
    [self setResult:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Property

- (void)setString:(NSString*)string {
    if([_string isEqualToString:string] == NO) {
        MOBILY_SAFE_SETTER(_string, string);
        [self setNeedApplyParser:YES];
    }
}

- (void)setExpression:(NSString*)expression {
    if([_expression isEqualToString:expression] == NO) {
        MOBILY_SAFE_SETTER(_expression, expression);
        [self setNeedApplyParser:YES];
    }
}

- (void)setPattern:(NSString*)pattern {
    if([_pattern isEqualToString:pattern] == NO) {
        MOBILY_SAFE_SETTER(_pattern, pattern);
        [self setNeedApplyParser:YES];
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
        [self setNeedApplyParser:NO];
        [self applyParser];
    }
}

- (void)applyParser {
    if([_string length] > 0) {
        NSMutableArray* resultMatches = [NSMutableArray array];
        NSMutableString* resultString = [NSMutableString stringWithString:_string];
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:_expression options:0 error:nil];
        if(regex != nil) {
            __block NSInteger offset = 0;
            [regex enumerateMatchesInString:_string options:0 range:NSMakeRange(0, [_string length]) usingBlock:^(NSTextCheckingResult* checkingResult, NSMatchingFlags flags, BOOL* stop) {
                NSUInteger numberOfRanges = [checkingResult numberOfRanges];
                
                NSString* matchOriginalString = [_string substringWithRange:[checkingResult range]];
                NSMutableArray* matchOriginalSubStrings = [NSMutableArray arrayWithCapacity:numberOfRanges];
                for(NSUInteger rangeIndex = 1; rangeIndex < numberOfRanges; rangeIndex++) {
                    NSRange range = [checkingResult rangeAtIndex:rangeIndex];
                    NSString* substring = [_string substringWithRange:range];
                    
                    [matchOriginalSubStrings addObject:substring];
                }
                NSRange matchOriginalRange = [checkingResult range];
                
                NSString* matchResultString = [regex replacementStringForResult:checkingResult inString:_string offset:0 template:(_pattern != nil) ? _pattern : @""];
                NSRange matchResultRange = NSMakeRange(matchOriginalRange.location + offset, [matchResultString length]);
                
                [resultString replaceCharactersInRange:NSMakeRange(matchOriginalRange.location + offset, matchOriginalRange.length) withString:matchResultString];
                
                MobilyRegExpMatch* match = [[MobilyRegExpMatch alloc] init];
                if(match != nil) {
                    [match setOriginalString:matchOriginalString];
                    [match setOriginalSubStrings:matchOriginalSubStrings];
                    [match setOriginalRange:matchOriginalRange];
                    [match setResultString:matchResultString];
                    [match setResultRange:matchResultRange];
                    
                    [resultMatches addObject:match];
                }
                
                offset += (matchResultRange.length - matchOriginalRange.length);
            }];
        }
        [self setMatches:[resultMatches copy]];
        [self setResult:[resultString copy]];
    } else {
        [self setMatches:nil];
        [self setResult:nil];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyRegExpMatch

#pragma mark Standart

- (void)dealloc {
    [self setOriginalString:nil];
    [self setOriginalSubStrings:nil];
    [self setResultString:nil];
    
    MOBILY_SAFE_DEALLOC;
}

@end

/*--------------------------------------------------*/