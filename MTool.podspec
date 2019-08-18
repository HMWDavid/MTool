
Pod::Spec.new do |s|
    s.name              = 'MTool'
    s.version           = '0.0.1'
    s.summary           = '自定义的工具库'
    s.description       = '这是一个swift版本自定义的工具库'
    s.homepage          = 'https://github.com/HMWDavid/MTool'

    s.license           = { :type => 'MIT', :file => 'LICENSE' }
    s.authors           = { "洪绵卫" => "244160918@qq.com" }
    s.platform          = :ios, '10.0'
    s.source            = {:git => 'https://github.com/HMWDavid/MTool.git', :tag => s.version}
    s.source_files      = ['Sources/**/*.{swift}']
    s.requires_arc      = true
    s.swift_versions    = "4.0"

end
