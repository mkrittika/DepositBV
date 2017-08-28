# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

target 'DepositBeverage' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DepositBeverage
  pod 'Alamofire', '~> 4.0'
  pod 'SwiftHTTP'
  pod 'SwiftyJSON', :git => 'https://github.com/BaiduHiDeviOS/SwiftyJSON.git', :branch => 'swift3'
  pod 'Toucan', :git => 'https://github.com/kean/Toucan.git', :branch => 'swift3'
 
  target 'DepositBeverageTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DepositBeverageUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
	installer.pods_project.targets.each do |target|
	    target.build_configurations.each do |config|
	        config.build_settings['SWIFT_VERSION'] = '3.0'
	    end
	end
end
