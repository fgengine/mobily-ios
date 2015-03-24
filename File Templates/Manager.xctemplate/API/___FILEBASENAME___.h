/*--------------------------------------------------*/

// imports

/*--------------------------------------------------*/

// success
typedef void (^ApiSuccess)();
typedef void (^ApiMessageSuccess)(NSString* message);

// failure
typedef void (^ApiFailure)(NSString* message, NSError* httpError);

/*--------------------------------------------------*/

@interface ___FILEBASENAMEASIDENTIFIER___ : NSObject

+ (void)exampleRequestSuccess:(ApiSuccess)success failure:(ApiFailure)failure;

@end

/*--------------------------------------------------*/