Pod::Spec.new do |spec|
	spec.name = 'Mobily'
	spec.version = '0.1.1'
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
	spec.default_subspec = 'UI'
	spec.requires_arc = true

	spec.subspec 'All' do |all|
		all.dependency 'Mobily/UI'
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
        end
	end
end
