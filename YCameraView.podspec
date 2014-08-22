#
#  Be sure to run `pod spec lint YCameraView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html

Pod::Spec.new do |s|
  s.name         = "YCameraView"
  s.version      = "0.1.0"

  s.summary      = "Custom Camera Controller similar to the camera View on Instagram."

  s.description  = <<-DESC
  YCameraViewController is a custom Image picker controller that allows you to quickly switch between Camera and iPhone Photo Library. This Controller only useful for capturing Square Image.
  DESC

  s.homepage     = "https://github.com/yuvirajsinh/YCameraView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = "yuvirajsinh"
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/yuvirajsinh/YCameraView.git", :tag => s.version.to_s }
  s.source_files  = "YCameraViewController/**/*.{h,m}"

  s.resources    = ["YCameraViewController/UI/**/*.png", "YCameraViewController/YCameraViewController.xib"]

  s.frameworks = "AVFoundation"
  s.requires_arc = true

end
