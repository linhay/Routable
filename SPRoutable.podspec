Pod::Spec.new do |s|
s.name             = 'SPRoutable'
s.version          = '0.7.7'
s.summary          = '基础的路由服务'


s.homepage         = 'https://github.com/bigL055/Routable'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'lin' => 'linhan.bigl055@outlook.com' }
s.source = { :git => 'https://github.com/bigL055/Routable.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = ["Sources/*/**","Sources/*/*/**","Sources/**"]

s.public_header_files = ["Sources/Routable.h"]
s.requires_arc = true
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
