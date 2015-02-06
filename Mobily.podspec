Pod::Spec.new do |s|
	s.name = 'Mobily'
	s.version = '2.0.18'
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
        ss.dependency 'Mobily/API'
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

        ss.subspec 'DynamicsDrawerController' do |sss|
            sss.public_header_files = 'Classes/UI/DynamicsDrawerController/**/*.h'
            sss.source_files = 'Classes/UI/DynamicsDrawerController/**/*.{h,m}'
            sss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_UI_DYNAMIC_DRAWER_CONTROLLER' }
            sss.dependency 'MSDynamicsDrawerViewController'
        end

        ss.subspec 'SlideMenuController' do |sss|
            sss.public_header_files = 'Classes/UI/SlideMenuController/**/*.h'
            sss.source_files = 'Classes/UI/SlideMenuController/**/*.{h,m}'
            sss.resources = 'Classes/UI/SlideMenuController/**/*.{png}'
            sss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_UI_SLIDE_MENU_CONTROLLER' }
        end

        ss.subspec 'ElementsView' do |sss|
            sss.public_header_files = 'Classes/UI/ElementsView/**/*.h'
            sss.source_files = 'Classes/UI/ElementsView/**/*.{h,m}'
            sss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_UI_ELEMENTS_VIEW' }
        end
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

        ss.subspec 'AudioRecorder' do |sss|
            sss.public_header_files = 'Classes/AV/AudioRecorder/**/*.h'
            sss.source_files = 'Classes/AV/AudioRecorder/**/*.{h,m}'
            sss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_AV_AUDIO_RECORDER' }
        end

        ss.subspec 'AudioPlayer' do |sss|
            sss.public_header_files = 'Classes/AV/AudioPlayer/**/*.h'
            sss.source_files = 'Classes/AV/AudioPlayer/**/*.{h,m}'
            sss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_AV_AUDIO_PLAYER' }
        end
    end

    s.subspec 'Social' do |ss|
        ss.public_header_files = 'Classes/Social/Core/**/*.h'
        ss.source_files = 'Classes/Social/Core/**/*.{h,m}'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_SOCIAL' }
        ss.frameworks = 'AVFoundation'
        ss.dependency 'Mobily/NS'
        ss.dependency 'Mobily/CG'
        ss.dependency 'Mobily/UI'

        ss.subspec 'Facebook' do |sss|
            sss.public_header_files = 'Classes/Social/Facebook/*.h'
            sss.source_files = 'Classes/Social/Facebook/*.{h,m}'
            sss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_SOCIAL_FACEBOOK' }
            sss.vendored_frameworks = 'Classes/Social/Facebook/Frameworks/FacebookSDK.bundle', 'Classes/Social/Facebook/Frameworks/FBAudienceNetwork.bundle'
        end

        ss.subspec 'VKontakte' do |sss|
            sss.public_header_files = 'Classes/Social/VKontakte/*.h'
            sss.source_files = 'Classes/Social/VKontakte/*.{h,m}'
            sss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_SOCIAL_VKONTAKTE' }
            sss.dependency 'VK-ios-sdk'
        end

        ss.subspec 'Twitter' do |sss|
            sss.public_header_files = 'Classes/Social/Twitter/*.h'
            sss.source_files = 'Classes/Social/Twitter/*.{h,m}'
            sss.resource = "Classes/Social/Twitter/Frameworks/TwitterKit.bundle/Resources/TwitterKitResources.bundle"
            sss.vendored_frameworks = 'Classes/Social/Twitter/Frameworks/TwitterKit.bundle'
            sss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_SOCIAL_TWITTER' }
            sss.frameworks = 'TwitterKit', 'Accounts', 'CoreData', 'Social'
        end
    end
end
