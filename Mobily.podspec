Pod::Spec.new do |s|
	s.name = 'Mobily'
	s.version = '0.1.51'
	s.summary = 'Mobily framework for iOS'
	s.homepage = 'https://github.com/fgengine/mobily-ios'
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
		:tag => s.version.to_s
	}
	s.default_subspec = 'All'
	s.requires_arc = true

	s.subspec 'All' do |ss|
		ss.dependency 'Mobily/NS'
		ss.dependency 'Mobily/NSRegExpParser'
		ss.dependency 'Mobily/CG'
		ss.dependency 'Mobily/UI'
		ss.dependency 'Mobily/UIControllerDynamicsDrawer'
		ss.dependency 'Mobily/UIViewFieldText'
		ss.dependency 'Mobily/UIViewFieldDate'
		ss.dependency 'Mobily/UIViewFieldList'
		ss.dependency 'Mobily/UIViewImage'
        ss.dependency 'Mobily/UIViewScroll'
        ss.dependency 'Mobily/UIViewTable'
        ss.dependency 'Mobily/UIViewElements'
	end
  
	s.subspec 'Core' do |ss|
		ss.public_header_files = 'Classes/Core/*.h'
		ss.source_files = 'Classes/Core/*.{h,m}'
		ss.frameworks = 'Foundation'
	end

	s.subspec 'NS' do |ss|
		ss.public_header_files = 'Classes/NS/Core/*.h'
		ss.source_files = 'Classes/NS/Core/*.{h,m}'
		ss.dependency 'Mobily/Core'
	end
        
    s.subspec 'NSRegExpParser' do |ss|
        ss.public_header_files = 'Classes/NS/RegExpParser/*.h'
        ss.source_files = 'Classes/NS/RegExpParser/*.{h,m}'
        ss.frameworks = 'CoreText'
        ss.dependency 'Mobily/NS'
    end

	s.subspec 'CG' do |ss|
		ss.public_header_files = 'Classes/CG/Core/*.h'
		ss.source_files = 'Classes/CG/Core/*.{h,m}'
		ss.frameworks = 'CoreGraphics'
		ss.dependency 'Mobily/Core'
	end

	s.subspec 'UI' do |ss|
		ss.public_header_files = 'Classes/UI/Core/*.h'
		ss.source_files = 'Classes/UI/Core/*.{h,m}'
		ss.frameworks = 'UIKit'
		ss.dependency 'Mobily/Core'
		ss.dependency 'Mobily/NS'
		ss.dependency 'Mobily/CG'
	end
        
    s.subspec 'UIControllerDynamicsDrawer' do |ss|
        ss.public_header_files = 'Classes/UI/ControllerDynamicsDrawer/*.h'
        ss.source_files = 'Classes/UI/ControllerDynamicsDrawer/*.{h,m}'
        ss.dependency 'MSDynamicsDrawerViewController'
        ss.dependency 'Mobily/UI'
    end
    
    s.subspec 'UIViewFieldText' do |ss|
        ss.public_header_files = 'Classes/UI/ViewFieldText/*.h'
        ss.source_files = 'Classes/UI/ViewFieldText/*.{h,m}'
        ss.dependency 'Mobily/UI'
    end
    
    s.subspec 'UIViewFieldDate' do |ss|
        ss.public_header_files = 'Classes/UI/ViewFieldDate/*.h'
        ss.source_files = 'Classes/UI/ViewFieldDate/*.{h,m}'
        ss.dependency 'Mobily/UIViewFieldText'
    end
    
    s.subspec 'UIViewFieldList' do |ss|
        ss.public_header_files = 'Classes/UI/ViewFieldList/*.h'
        ss.source_files = 'Classes/UI/ViewFieldList/*.{h,m}'
        ss.dependency 'Mobily/UIViewFieldText'
    end
    
    s.subspec 'UIViewImage' do |ss|
        ss.public_header_files = 'Classes/UI/ViewImage/*.h'
        ss.source_files = 'Classes/UI/ViewImage/*.{h,m}'
        ss.dependency 'Mobily/UI'
    end

    s.subspec 'UIViewScroll' do |ss|
        ss.public_header_files = 'Classes/UI/ViewScroll/*.h'
        ss.source_files = 'Classes/UI/ViewScroll/*.{h,m}'
        ss.dependency 'Mobily/UI'
    end

    s.subspec 'UIViewTable' do |ss|
        ss.public_header_files = 'Classes/UI/ViewTable/*.h'
        ss.source_files = 'Classes/UI/ViewTable/*.{h,m}'
        ss.dependency 'Mobily/UI'
    end

    s.subspec 'UIViewElements' do |ss|
        ss.public_header_files = 'Classes/UI/ViewElements/*.h'
        ss.source_files = 'Classes/UI/ViewElements/*.{h,m}'
        ss.dependency 'Mobily/UI'
    end
end
