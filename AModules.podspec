Pod::Spec.new do |s|
s.name             = 'AModules'
s.version          = '0.1.0'
s.summary          = '测试A'


s.homepage         = 'https://github.com/bigL055/Routable'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'lin' => 'linhan.bigl055@outlook.com' }
s.source = { :git => 'https://github.com/bigL055/Routable.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = ["SourcesA/*/**","SourcesA/*/*/**","SourcesA/**"]

s.public_header_files = ["SourcesA/AModules.h"]
s.frameworks = ['UIKit']
s.requires_arc = true
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }

end
