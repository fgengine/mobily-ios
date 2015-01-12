Pod::Spec.new do |s|
	s.name = 'Mobily'
	s.version = '2.0.3'
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

	s.subspec 'All' do |ss|
		ss.dependency 'Mobily/NS'
        ss.dependency 'Mobily/NSModel'
		ss.dependency 'Mobily/NSRegExpParser'
		ss.dependency 'Mobily/CG'
		ss.dependency 'Mobily/UI'
        ss.dependency 'Mobily/UIButton'
		ss.dependency 'Mobily/UITextField'
		ss.dependency 'Mobily/UIDateField'
		ss.dependency 'Mobily/UIListField'
		ss.dependency 'Mobily/UIImageView'
        ss.dependency 'Mobily/UIScrollView'
        ss.dependency 'Mobily/UITableView'
	end
  
	s.subspec 'Core' do |ss|
		ss.public_header_files = 'Classes/Core/**/*.h'
		ss.source_files = 'Classes/Core/**/*.{h,m}'
		ss.frameworks = 'Foundation'
	end

	s.subspec 'NS' do |ss|
		ss.public_header_files = 'Classes/NS/Core/**/*.h'
		ss.source_files = 'Classes/NS/Core/**/*.{h,m}'
		ss.dependency 'Mobily/Core'
	end
        
    s.subspec 'NSModel' do |ss|
        ss.public_header_files = 'Classes/NS/Model/**/*.h'
        ss.source_files = 'Classes/NS/Model/**/*.{h,m}'
        ss.dependency 'Mobily/NS'
    end
        
    s.subspec 'NSTaskManager' do |ss|
        ss.public_header_files = 'Classes/NS/TaskManager/**/*.h'
        ss.source_files = 'Classes/NS/TaskManager/**/*.{h,m}'
        ss.dependency 'Mobily/NS'
    end
        
    s.subspec 'NSRegExpParser' do |ss|
        ss.public_header_files = 'Classes/NS/RegExpParser/**/*.h'
        ss.source_files = 'Classes/NS/RegExpParser/**/*.{h,m}'
        ss.frameworks = 'CoreText'
        ss.dependency 'Mobily/NS'
    end

	s.subspec 'CG' do |ss|
		ss.public_header_files = 'Classes/CG/Core/**/*.h'
		ss.source_files = 'Classes/CG/Core/**/*.{h,m}'
		ss.frameworks = 'CoreGraphics'
		ss.dependency 'Mobily/Core'
	end

	s.subspec 'UI' do |ss|
		ss.public_header_files = 'Classes/UI/Core/**/*.h'
		ss.source_files = 'Classes/UI/Core/**/*.{h,m}'
		ss.frameworks = 'UIKit'
		ss.dependency 'Mobily/Core'
		ss.dependency 'Mobily/NS'
		ss.dependency 'Mobily/CG'
	end
        
    s.subspec 'UIDynamicsDrawerController' do |ss|
        ss.public_header_files = 'Classes/UI/DynamicsDrawerController/**/*.h'
        ss.source_files = 'Classes/UI/DynamicsDrawerController/**/*.{h,m}'
        ss.dependency 'MSDynamicsDrawerViewController'
        ss.dependency 'Mobily/UI'
    end

    s.subspec 'UISlideMenuController' do |ss|
        ss.public_header_files = 'Classes/UI/SlideMenuController/**/*.h'
        ss.source_files = 'Classes/UI/SlideMenuController/**/*.{h,m}'
        ss.resources = 'Classes/UI/SlideMenuController/**/*.{png}'
        ss.dependency 'Mobily/UI'
    end

    s.subspec 'UIButton' do |ss|
        ss.public_header_files = 'Classes/UI/Button/**/*.h'
        ss.source_files = 'Classes/UI/Button/**/*.{h,m}'
        ss.dependency 'Mobily/UI'
    end

    s.subspec 'UITextField' do |ss|
        ss.public_header_files = 'Classes/UI/TextField/**/*.h'
        ss.source_files = 'Classes/UI/TextField/**/*.{h,m}'
        ss.dependency 'Mobily/UI'
    end
    
    s.subspec 'UIDateField' do |ss|
        ss.public_header_files = 'Classes/UI/DateField/**/*.h'
        ss.source_files = 'Classes/UI/DateField/**/*.{h,m}'
        ss.dependency 'Mobily/UITextField'
    end
    
    s.subspec 'UIListField' do |ss|
        ss.public_header_files = 'Classes/UI/ListField/**/*.h'
        ss.source_files = 'Classes/UI/ListField/**/*.{h,m}'
        ss.dependency 'Mobily/UITextField'
    end
    
    s.subspec 'UIImageView' do |ss|
        ss.public_header_files = 'Classes/UI/ImageView/**/*.h'
        ss.source_files = 'Classes/UI/ImageView/**/*.{h,m}'
        ss.dependency 'Mobily/UI'
        ss.dependency 'Mobily/NSTaskManager'
    end

    s.subspec 'UIScrollView' do |ss|
        ss.public_header_files = 'Classes/UI/ScrollView/**/*.h'
        ss.source_files = 'Classes/UI/ScrollView/**/*.{h,m}'
        ss.dependency 'Mobily/UI'
    end

    s.subspec 'UITableView' do |ss|
        ss.public_header_files = 'Classes/UI/TableView/**/*.h'
        ss.source_files = 'Classes/UI/TableView/**/*.{h,m}'
        ss.dependency 'Mobily/UI'
    end

    s.subspec 'UIElementsView' do |ss|
        ss.public_header_files = 'Classes/UI/ElementsView/**/*.h'
        ss.source_files = 'Classes/UI/ElementsView/**/*.{h,m}'
        ss.dependency 'Mobily/UI'
    end

    s.subspec 'AV' do |ss|
        ss.public_header_files = 'Classes/AV/Core/**/*.h'
        ss.source_files = 'Classes/AV/Core/**/*.{h,m}'
        ss.frameworks = 'AVFoundation'
        ss.dependency 'Mobily/NS'
    end

    s.subspec 'AVAudioRecorder' do |ss|
        ss.public_header_files = 'Classes/AV/AudioRecorder/**/*.h'
        ss.source_files = 'Classes/AV/AudioRecorder/**/*.{h,m}'
        ss.dependency 'Mobily/AV'
    end
end
