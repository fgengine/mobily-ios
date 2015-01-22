Pod::Spec.new do |s|
	s.name = 'Mobily'
	s.version = '2.0.6'
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
	s.default_subspec = 'All'
    s.requires_arc = true
    ss.public_header_files = 'Classes/Mobily.h'

	s.subspec 'All' do |ss|
		ss.dependency 'Mobily/NS'
		ss.dependency 'Mobily/CG'
		ss.dependency 'Mobily/UI'
	end
  
	s.subspec 'Core' do |ss|
		ss.public_header_files = 'Classes/Core/**/*.h'
		ss.source_files = 'Classes/Core/**/*.{h,m}'
		ss.frameworks = 'Foundation'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_CORE' }
	end

	s.subspec 'NS' do |ss|
		ss.public_header_files = 'Classes/NS/Core/**/*.h'
		ss.source_files = 'Classes/NS/Core/**/*.{h,m}'
        ss.dependency 'Mobily/Core'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_NS' }
	end

	s.subspec 'CG' do |ss|
		ss.public_header_files = 'Classes/CG/Core/**/*.h'
		ss.source_files = 'Classes/CG/Core/**/*.{h,m}'
		ss.frameworks = 'CoreGraphics'
        ss.dependency 'Mobily/Core'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_GC' }
	end

	s.subspec 'UI' do |ss|
		ss.public_header_files = 'Classes/UI/Core/**/*.h'
		ss.source_files = 'Classes/UI/Core/**/*.{h,m}'
		ss.frameworks = 'UIKit'
		ss.dependency 'Mobily/Core'
		ss.dependency 'Mobily/NS'
        ss.dependency 'Mobily/CG'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_UI' }
	end

    s.subspec 'UIDynamicsDrawerController' do |ss|
        ss.public_header_files = 'Classes/UI/DynamicsDrawerController/**/*.h'
        ss.source_files = 'Classes/UI/DynamicsDrawerController/**/*.{h,m}'
        ss.dependency 'MSDynamicsDrawerViewController'
        ss.dependency 'Mobily/UI'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_UI_DYNAMIC_DRAWER_CONTROLLER' }
    end

    s.subspec 'UISlideMenuController' do |ss|
        ss.public_header_files = 'Classes/UI/SlideMenuController/**/*.h'
        ss.source_files = 'Classes/UI/SlideMenuController/**/*.{h,m}'
        ss.resources = 'Classes/UI/SlideMenuController/**/*.{png}'
        ss.dependency 'Mobily/UI'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_UI_SLIDE_MENU_CONTROLLER' }
    end

    s.subspec 'UIElementsView' do |ss|
        ss.public_header_files = 'Classes/UI/ElementsView/**/*.h'
        ss.source_files = 'Classes/UI/ElementsView/**/*.{h,m}'
        ss.dependency 'Mobily/UI'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_UI_ELEMENTS_VIEW' }
    end

    s.subspec 'AV' do |ss|
        ss.public_header_files = 'Classes/AV/Core/**/*.h'
        ss.source_files = 'Classes/AV/Core/**/*.{h,m}'
        ss.frameworks = 'AVFoundation'
        ss.dependency 'Mobily/NS'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_AV' }
    end

    s.subspec 'AVAudioRecorder' do |ss|
        ss.public_header_files = 'Classes/AV/AudioRecorder/**/*.h'
        ss.source_files = 'Classes/AV/AudioRecorder/**/*.{h,m}'
        ss.dependency 'Mobily/AV'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_AV_AUDIO_RECORDER' }
    end

    s.subspec 'AVAudioPlayer' do |ss|
        ss.public_header_files = 'Classes/AV/AudioPlayer/**/*.h'
        ss.source_files = 'Classes/AV/AudioPlayer/**/*.{h,m}'
        ss.dependency 'Mobily/AV'
        ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MOBILY_POD_AV_AUDIO_PLAYER' }
    end
end
