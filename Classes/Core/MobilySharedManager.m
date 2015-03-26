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

#import "MobilySharedManager.h"

/*--------------------------------------------------*/

static NSString*  const MobilySharedManagerNotification = @"MobilySharedManagerNotification";

/*--------------------------------------------------*/

@interface MobilySharedManager ()

@property(nonatomic, readwrite, copy) NSString* applicationGroupIdentifier;
@property(nonatomic, readwrite, copy) NSString* directory;
@property(nonatomic, readwrite, strong) NSFileManager* fileManager;
@property(nonatomic, readwrite, strong) NSMutableDictionary* listenerBlocks;

- (NSString*)_messagePassingDirectoryPath;
- (NSString*)_filePathForIdentifier:(NSString*)identifier;
- (void)_writeMessageObject:(id)messageObject toFileWithIdentifier:(NSString*)identifier;
- (id)_messageObjectFromFileWithIdentifier:(NSString*)identifier;
- (void)_deleteFileForIdentifier:(NSString*)identifier;

- (void)_sendNotificationForMessageWithIdentifier:(NSString*)identifier;
- (void)_registerForNotificationsWithIdentifier:(NSString*)identifier;
- (void)_unregisterForNotificationsWithIdentifier:(NSString*)identifier;
- (void)_didReceiveMessageNotification:(NSNotification*)notification;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

void MobilySharedManagerNotificationCallback(CFNotificationCenterRef center, void*  observer, CFStringRef name, void const*  object, CFDictionaryRef userInfo) {
    [[NSNotificationCenter defaultCenter] postNotificationName:MobilySharedManagerNotification object:nil userInfo:@{ @"identifier" : (__bridge NSString*)name }];
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySharedManager

#pragma mark Init / Free

- (instancetype)initWithApplicationGroupIdentifier:(NSString*)identifier optionalDirectory:(NSString*)directory {
    self = [super init];
    if(self != nil) {
        _applicationGroupIdentifier = [identifier copy];
        _directory = [directory copy];
    }
    return self;
}

- (void)setup {
    _fileManager = [[NSFileManager alloc] init];
    _listenerBlocks = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didReceiveMessageNotification:) name:MobilySharedManagerNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    CFNotificationCenterRemoveEveryObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void*)self);
}

#pragma mark Public static

+ (BOOL)isSupported {
    return [[NSFileManager defaultManager] respondsToSelector:@selector(containerURLForSecurityApplicationGroupIdentifier:)];
}

#pragma mark Public

- (void)passMessageObject:(id< NSCoding >)messageObject identifier:(NSString*)identifier {
    if((messageObject != nil) && (identifier.length > 0)) {
        [self _writeMessageObject:messageObject toFileWithIdentifier:identifier];
    }
}

- (id)messageWithIdentifier:(NSString*)identifier {
    if(identifier.length > 0) {
        return [self _messageObjectFromFileWithIdentifier:identifier];
    }
    return nil;
}

- (void)clearMessageContentsForIdentifier:(NSString*)identifier {
    if(identifier.length > 0) {
        [self _deleteFileForIdentifier:identifier];
    }
}

- (void)clearAllMessageContents {
    if(_directory != nil) {
        NSString* directoryPath = [self _messagePassingDirectoryPath];
        NSArray* messageFiles = [_fileManager contentsOfDirectoryAtPath:directoryPath error:NULL];
        for(NSString* path in messageFiles) {
            [self.fileManager removeItemAtPath:[directoryPath stringByAppendingPathComponent:path] error:NULL];
        }
    }
}

- (void)listenForMessageWithIdentifier:(NSString*)identifier listener:(MobilySharedManagerListenerBlock)listener {
    if(identifier.length > 0) {
        [_listenerBlocks setValue:listener forKey:identifier];
        [self _registerForNotificationsWithIdentifier:identifier];
    }
}

- (void)stopListeningForMessageWithIdentifier:(NSString*)identifier {
    if(identifier.length > 0) {
        [_listenerBlocks setValue:nil forKey:identifier];
        [self _unregisterForNotificationsWithIdentifier:identifier];
    }
}

#pragma mark Private

- (NSString*)_messagePassingDirectoryPath {
    NSURL* appGroupContainer = [_fileManager containerURLForSecurityApplicationGroupIdentifier:_applicationGroupIdentifier];
    NSString* directoryPath = appGroupContainer.path;
    if(_directory != nil) {
        directoryPath = [directoryPath stringByAppendingPathComponent:_directory];
    }
    if([_fileManager fileExistsAtPath:directoryPath] == NO) {
        [_fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return directoryPath;
}

- (NSString*)_filePathForIdentifier:(NSString*)identifier {
    return [[self _messagePassingDirectoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive", identifier]];
}

- (void)_writeMessageObject:(id)messageObject toFileWithIdentifier:(NSString*)identifier {
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:messageObject];
    if([data writeToFile:[self _filePathForIdentifier:identifier] atomically:YES] == YES) {
        [self _sendNotificationForMessageWithIdentifier:identifier];
    }
}

- (id)_messageObjectFromFileWithIdentifier:(NSString*)identifier {
    NSData* data = [NSData dataWithContentsOfFile:[self _filePathForIdentifier:identifier]];
    if(data != nil) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (void)_deleteFileForIdentifier:(NSString*)identifier {
    [_fileManager removeItemAtPath:[self _filePathForIdentifier:identifier] error:NULL];
}

- (void)_sendNotificationForMessageWithIdentifier:(NSString*)identifier {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge CFStringRef)identifier, NULL, NULL, YES);
}

- (void)_registerForNotificationsWithIdentifier:(NSString*)identifier {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void*)self, MobilySharedManagerNotificationCallback, (__bridge CFStringRef)identifier, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

- (void)_unregisterForNotificationsWithIdentifier:(NSString*)identifier {
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void*)self, (__bridge CFStringRef)identifier, NULL);
}

- (void)_didReceiveMessageNotification:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    NSString* identifier = [userInfo valueForKey:@"identifier"];
    if(identifier != nil) {
        MobilySharedManagerListenerBlock listenerBlock = [_listenerBlocks valueForKey:identifier];
        if(listenerBlock != nil) {
            listenerBlock([self _messageObjectFromFileWithIdentifier:identifier]);
        }
    }
}

@end

/*--------------------------------------------------*/
