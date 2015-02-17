Pod::Spec.new do |s|
    s.name = 'Mobily'
    s.version = '2.0.25'
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
    s.default_subspec = 'Standart'

    s.subspec 'Standart' do |ss|
        ss.dependency 'Mobily/NS'
        ss.dependency 'Mobily/CG'
        ss.dependency 'Mobily/UI'
        ss.dependency 'Mobily/UI-DataView'
        ss.dependency 'Mobily/API'
    end

    s.subspec 'Development' do |ss|
        ss.dependency 'Mobily/NS'
        ss.dependency 'Mobily/CG'
        ss.dependency 'Mobily/UI'
        ss.dependency 'Mobily/UI-DataView'
        ss.dependency 'Mobily/UI-DynamicsDrawerController'
        ss.dependency 'Mobily/UI-SlideMenuController'
        ss.dependency 'Mobily/AV'
        ss.dependency 'Mobily/AV-AudioRecorder'
        ss.dependency 'Mobily/AV-AudioPlayer'
        ss.dependency 'Mobily/API'
        ss.dependency 'Mobily/Social'
        ss.dependency 'Mobily/Social-Facebook'
        ss.dependency 'Mobily/Social-VKontakte'
        ss.dependency 'Mobily/Social-Twitter'
    end

    s.subspec 'CocoaPods' do |ss|
        ss.public_header_files = 'Classes/CocoaPods/**/*.h'
        ss.source_files = 'Classes/CocoaPods/**/*.{h,m}'
    end

    s.subspec 'Core' do |ss|
        ss.public_header_files = 'Classes/Core/**/*.h'
        ss.source_files = 'Classes/Core/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_CORE' }
        ss.frameworks = 'Foundation'
        ss.dependency 'Mobily/CocoaPods'
    end

    s.subspec 'NS' do |ss|
        ss.public_header_files = 'Classes/NS/Core/**/*.h'
        ss.source_files = 'Classes/NS/Core/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_NS' }
        ss.dependency 'Mobily/Core'
    end

    s.subspec 'CG' do |ss|
        ss.public_header_files = 'Classes/CG/Core/**/*.h'
        ss.source_files = 'Classes/CG/Core/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_GC' }
        ss.frameworks = 'CoreGraphics'
        ss.dependency 'Mobily/Core'
    end

    s.subspec 'UI' do |ss|
        ss.public_header_files = 'Classes/UI/Core/**/*.h'
        ss.source_files = 'Classes/UI/Core/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_UI' }
        ss.frameworks = 'UIKit'
        ss.dependency 'Mobily/NS'
        ss.dependency 'Mobily/CG'
    end

    s.subspec 'UI-DataView' do |ss|
        ss.public_header_files = 'Classes/UI/DataView/**/*.h'
        ss.source_files = 'Classes/UI/DataView/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_UI_DATA_VIEW' }
        ss.dependency 'Mobily/UI'
    end

    s.subspec 'UI-DynamicsDrawerController' do |ss|
        ss.public_header_files = 'Classes/UI/DynamicsDrawerController/**/*.h'
        ss.source_files = 'Classes/UI/DynamicsDrawerController/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_UI_DYNAMIC_DRAWER_CONTROLLER' }
        ss.dependency 'Mobily/UI'
        ss.dependency 'MSDynamicsDrawerViewController'
    end

    s.subspec 'UI-SlideMenuController' do |ss|
        ss.public_header_files = 'Classes/UI/SlideMenuController/**/*.h'
        ss.source_files = 'Classes/UI/SlideMenuController/**/*.{h,m}'
        ss.resources = 'Classes/UI/SlideMenuController/**/*.{png}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_UI_SLIDE_MENU_CONTROLLER' }
        ss.dependency 'Mobily/UI'
    end

    s.subspec 'API' do |ss|
        ss.public_header_files = 'Classes/API/**/*.h'
        ss.source_files = 'Classes/API/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_API' }
        ss.dependency 'Mobily/NS'
    end

    s.subspec 'AV' do |ss|
        ss.public_header_files = 'Classes/AV/Core/**/*.h'
        ss.source_files = 'Classes/AV/Core/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_AV' }
        ss.frameworks = 'AVFoundation'
        ss.dependency 'Mobily/NS'
    end

    s.subspec 'AV-AudioRecorder' do |ss|
        ss.public_header_files = 'Classes/AV/AudioRecorder/**/*.h'
        ss.source_files = 'Classes/AV/AudioRecorder/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_AV_AUDIO_RECORDER' }
        ss.dependency 'Mobily/AV'
    end

    s.subspec 'AV-AudioPlayer' do |ss|
        ss.public_header_files = 'Classes/AV/AudioPlayer/**/*.h'
        ss.source_files = 'Classes/AV/AudioPlayer/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_AV_AUDIO_PLAYER' }
        ss.dependency 'Mobily/AV'
    end

    s.subspec 'Social' do |ss|
        ss.public_header_files = 'Classes/Social/Core/**/*.h'
        ss.source_files = 'Classes/Social/Core/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_SOCIAL' }
        ss.frameworks = 'AVFoundation'
        ss.dependency 'Mobily/NS'
        ss.dependency 'Mobily/CG'
        ss.dependency 'Mobily/UI'
    end

    s.subspec 'Social-Facebook' do |ss|
        ss.public_header_files = 'Classes/Social/Facebook/*.h'
        ss.source_files = 'Classes/Social/Facebook/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_SOCIAL_FACEBOOK' }
        ss.vendored_frameworks = 'Classes/Social/Facebook/Frameworks/FacebookSDK.framework', 'Classes/Social/Facebook/Frameworks/FBAudienceNetwork.bundle'
        ss.dependency 'Mobily/Social'
    end

    s.subspec 'Social-VKontakte' do |ss|
        ss.public_header_files = 'Classes/Social/VKontakte/*.h'
        ss.source_files = 'Classes/Social/VKontakte/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_SOCIAL_VKONTAKTE' }
        ss.dependency 'Mobily/Social'
        ss.dependency 'VK-ios-sdk'
    end

    s.subspec 'Social-Twitter' do |ss|
        ss.public_header_files = 'Classes/Social/Twitter/*.h'
        ss.source_files = 'Classes/Social/Twitter/*.{h,m}'
        ss.resource = "Classes/Social/Twitter/Frameworks/TwitterKit.bundle/Resources/TwitterKitResources.bundle"
        ss.vendored_frameworks = 'Classes/Social/Twitter/Frameworks/TwitterKit.framework'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_SOCIAL_TWITTER' }
        ss.frameworks = 'TwitterKit', 'Accounts', 'CoreData', 'Social'
        ss.dependency 'Mobily/Social'
    end
end
