/*--------------------------------------------------*/

// imports

/*--------------------------------------------------*/

// success
typedef void (^ManagerSuccess)();
typedef void (^ManagerMessageSuccess)(NSString* message);

// failure
typedef void (^ManagerFailure)(NSString* message, NSError* httpError);

/*--------------------------------------------------*/

@interface ___FILEBASENAMEASIDENTIFIER___ : MobilyModel

+ (instancetype)shared;

@end

/*--------------------------------------------------*/