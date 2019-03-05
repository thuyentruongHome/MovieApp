# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'MovieApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MovieApp
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Alamofire'
  pod 'AlamofireImage'
  pod 'Cosmos', '~> 18.0'

  abstract_target 'Tests' do
    pod 'OHHTTPStubs'
    pod 'Fakery'
    pod 'Nimble'

    target 'MovieAppTests' do
      pod 'Quick'
    end

    target 'MovieAppUITests' do
      pod 'KIF'
    end

    target 'ExtensionTests'
  end
end
