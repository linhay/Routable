Pod::Spec.new do |s|
s.name             = 'SPRoutable'
s.version          = '0.9.8'
s.summary          = '基础的路由服务'

s.homepage         = 'https://github.com/linhay/Routable'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'linhey' => 'linheyhan.linhey@outlook.com' }
s.source = { :git => 'https://github.com/linhay/Routable.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'
s.requires_arc = true

s.source_files = 'Sources/Core/*.{swift,h}'
s.dependency 'RoutableAssist'

s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
end
