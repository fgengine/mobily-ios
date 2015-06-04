Pod::Spec.new do |s|
    s.name = 'Mobily'
    s.version = '3.0.0'
    s.summary = 'Mobily framework for iOS'
    s.homepage = 'https://github.com/fgengine/mobily-ios/tree/v3'
    s.license = {
        :type => 'MIT',
        :file => 'LICENSE'
    }
    s.author = {
        'username' => 'mobily.crew@gmail.com'
    }
    s.platform = :ios, 7.0
    s.requires_arc = true
    s.default_subspec = 'Core'

    s.subspec 'Core' do |ss|
        ss.public_header_files = 'Sources/MobilyCore/**/*.h'
        ss.source_files = 'Sources/MobilyCore/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_COCOAPODS_CORE' }
        ss.frameworks = 'Foundation', 'CoreGraphics', 'UIKit', 'AVFoundation', 'CoreLocation'
    end

    s.subspec 'Social' do |ss|
        ss.public_header_files = 'Sources/MobilySocial/**/*.h'
        ss.source_files = 'Sources/MobilySocial/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_COCOAPODS_SOCIAL' }
        ss.resource = 'Resources/FacebookSDKStrings.bundle', 'Resources/TwitterKitResources.bundle', 'Resources/VKSdkResources.bundle'
        ss.vendored_frameworks = 'Frameworks/FBSDKCoreKit.framework', 'Frameworks/FBSDKLoginKit.framework', 'Frameworks/TwitterCore.bundle', 'Frameworks/TwitterKit.framework', 'Frameworks/VKSdk.framework'
        ss.frameworks = 'CoreData', 'Accounts', 'Social', 'TwitterKit'
        ss.dependency 'Mobily/Core'
        ss.library = 'sqlite3'
    end
end