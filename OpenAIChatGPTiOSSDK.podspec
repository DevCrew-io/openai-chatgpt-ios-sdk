Pod::Spec.new do |s|
  s.name             = 'OpenAIChatGPTiOSSDK'
  s.version          = '1.0.5'
  s.summary          = 'OpenAIAPIManager'
  s.description      = 'A comprehensive SDK for integrating OpenAI APIs into iOS applications. It provides a convenient and easy-to-use interface for making API requests and handling responses.'
  
  s.homepage         = 'https://github.com/DevCrew-io/openai-chatgpt-ios-sdk'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { 'DevCrew.IO' => 'founders@devcrew.io' }
  
  s.requires_arc = true
  s.swift_version = "5.0"
  s.osx.deployment_target = "10.13"
  s.ios.deployment_target = "9.0"
  
  s.source           = { :git => "https://github.com/DevCrew-io/openai-chatgpt-ios-sdk.git", :tag => s.version }
  s.source_files     = 'Sources/**/*.swift'
end

