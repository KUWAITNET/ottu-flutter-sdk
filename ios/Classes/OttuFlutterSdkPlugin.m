#import "OttuFlutterSdkPlugin.h"
#if __has_include(<ottu_flutter_sdk/ottu_flutter_sdk-Swift.h>)
#import <ottu_flutter_sdk/ottu_flutter_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ottu_flutter_sdk-Swift.h"
#endif

@implementation OttuFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOttuFlutterSdkPlugin registerWithRegistrar:registrar];
}
@end
