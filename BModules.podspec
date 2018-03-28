Pod::Spec.new do |s|
s.name             = 'BModules'
s.version          = '0.1.0'
s.summary          = '测试B'


s.homepage         = 'https://github.com/linhay/Routable'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'linhey' => 'linheyhan.linhey@outlook.com' }
s.source = { :git => 'https://github.com/linhay/Routable.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = ["SourcesB/*/**","SourcesB/*/*/**","SourcesB/**"]

s.public_header_files = ["SourcesB/BModules.h"]
s.frameworks = ['UIKit']
s.requires_arc = true
s.dependency 'SPRoutable'
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
