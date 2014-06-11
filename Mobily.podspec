Pod::Spec.new do |spec|
	spec.name = 'Mobily'
	spec.version = '0.1.2'
	spec.summary = 'Mobily framework for iOS'
	spec.homepage = 'https://github.com/fgengine/mobily-ios'
	spec.license = {
		:type => 'MIT',
		:file => 'LICENSE'
	}
	spec.author = {
		'Username' => 'fgengine@gmail.com'
	}
	spec.platform = :ios, 7.0
	spec.source = {
		:git => 'https://github.com/fgengine/mobily-ios.git',
		:tag => spec.version.to_s
	}
	spec.default_subspec = 'All'
	spec.requires_arc = true

	spec.subspec 'All' do |all|
		all.dependency 'Mobily/UI'
		all.dependency 'Mobily/UI/ControllerDynamicsDrawer'
		all.dependency 'Mobily/UI/ViewFieldText'
		all.dependency 'Mobily/UI/ViewFieldDate'
		all.dependency 'Mobily/UI/ViewFieldList'
		all.dependency 'Mobily/UI/ViewImage'
		all.dependency 'Mobily/UI/ViewElements'
	end
  
	spec.subspec 'Core' do |core|
		core.public_header_files = 'Classes/Core/*.h'
		core.source_files = 'Classes/Core/*.{h,m}'
		core.frameworks = 'Foundation'
	end

	spec.subspec 'NS' do |ns|
		ns.public_header_files = 'Classes/NS/Core/*.h'
		ns.source_files = 'Classes/NS/Core/*.{h,m}'
		ns.dependency 'Mobily/Core'
	end

	spec.subspec 'CG' do |cg|
		cg.public_header_files = 'Classes/CG/Core/*.h'
		cg.source_files = 'Classes/CG/Core/*.{h,m}'
		cg.frameworks = 'CoreGraphics'
		cg.dependency 'Mobily/Core'
	end

	spec.subspec 'UI' do |ui|
		ui.public_header_files = 'Classes/UI/Core/*.h'
		ui.source_files = 'Classes/UI/Core/*.{h,m}'
		ui.frameworks = 'UIKit'
		ui.dependency 'Mobily/Core'
		ui.dependency 'Mobily/NS'
		ui.dependency 'Mobily/CG'
        
        spec.subspec 'ControllerDynamicsDrawer' do |controller_dynamics_drawer|
            controller_dynamics_drawer.public_header_files = 'Classes/UI/ControllerDynamicsDrawer/*.h'
            controller_dynamics_drawer.source_files = 'Classes/UI/ControllerDynamicsDrawer/*.{h,m}'
            controller_dynamics_drawer.dependency 'MSDynamicsDrawerViewController'
            controller_dynamics_drawer.dependency 'Mobily/UI'
            controller_dynamics_drawer.requires_arc = true
        end
        
        spec.subspec 'ViewFieldText' do |view_field_text|
            view_field_text.public_header_files = 'Classes/UI/ViewFieldText/*.h'
            view_field_text.source_files = 'Classes/UI/ViewFieldText/*.{h,m}'
            view_field_text.dependency 'Mobily/UI'
        end
        
        spec.subspec 'ViewFieldDate' do |view_field_date|
            view_field_date.public_header_files = 'Classes/UI/ViewFieldDate/*.h'
            view_field_date.source_files = 'Classes/UI/ViewFieldDate/*.{h,m}'
            view_field_date.dependency 'Mobily/UI'
        end
        
        spec.subspec 'ViewFieldList' do |view_field_list|
            view_field_list.public_header_files = 'Classes/UI/ViewFieldList/*.h'
            view_field_list.source_files = 'Classes/UI/ViewFieldList/*.{h,m}'
            view_field_list.dependency 'Mobily/UI'
        end
        
        spec.subspec 'ViewImage' do |view_image|
            view_image.public_header_files = 'Classes/UI/ViewImage/*.h'
            view_image.source_files = 'Classes/UI/ViewImage/*.{h,m}'
            view_image.dependency 'Mobily/UI'
        end
        
        spec.subspec 'ViewImage' do |view_elements|
            view_elements.public_header_files = 'Classes/UI/ViewImage/*.h'
            view_elements.source_files = 'Classes/UI/ViewImage/*.{h,m}'
            view_elements.dependency 'Mobily/UI'
        end
	end
end
