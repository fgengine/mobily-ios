Pod::Spec.new do |s|
    s.name = 'Mobily'
    s.version = '2.0.81'
    s.summary = 'Mobily framework for iOS'
    s.homepage = 'https://github.com/fgengine/mobily-ios/tree/v2'
    s.license = {
        :type => 'MIT',
        :file => 'LICENSE'
    }
    s.author = {
        'Username' => 'fgengine@gmail.com'
    }
    s.platform = :ios, 7.0
    s.source = {
        :git => 'https://github.com/fgengine/mobily-ios.git',
        :branch => 'v2',
        :tag => s.version.to_s
    }
    s.requires_arc = true
    s.default_subspec = 'Core'

    s.subspec 'Development' do |ss|
        ss.dependency 'Mobily/CocoaPods'
        ss.dependency 'Mobily/Core'
        ss.dependency 'Mobily/Social'
    end

    s.subspec 'CocoaPods' do |ss|
        ss.public_header_files = 'Classes/CocoaPods/**/*.h'
        ss.source_files = 'Classes/CocoaPods/**/*.{h,m}'
    end

    s.subspec 'Core' do |ss|
        ss.public_header_files = 'Classes/Core/**/*.h'
        ss.source_files = 'Classes/Core/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_CORE' }
        ss.frameworks = 'Foundation', 'CoreGraphics', 'UIKit', 'AVFoundation'
        ss.dependency 'Mobily/CocoaPods'
    end

    s.subspec 'Social' do |ss|
        ss.public_header_files = 'Classes/Social/**/*.h'
        ss.source_files = 'Classes/Social/**/*.{h,m}'
        ss.resource = 'Classes/Social/Twitter/Frameworks/TwitterKitResources.bundle'
        ss.vendored_frameworks = 'Classes/Social/Facebook/Frameworks/FacebookSDK.framework', 'Classes/Social/Facebook/Frameworks/FBAudienceNetwork.bundle', 'Classes/Social/Twitter/Frameworks/TwitterKit.framework'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_SOCIAL' }
        ss.frameworks = 'CoreData', 'Accounts', 'Social', 'TwitterKit'
        ss.dependency 'Mobily/Core'
        ss.dependency 'VK-ios-sdk'
    end
end
