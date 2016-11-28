# Uncomment this line to define a global platform for your project
 platform :ios, '8.0'
# Uncomment this line if you're using Swift

source 'https://github.com/CocoaPods/Specs.git'

 use_frameworks!

target 'wavelabs_ios_client_api' do

    pod 'Alamofire', '~> 4.0'
    pod 'MBProgressHUD'


end

target 'wavelabs_ios_client_apiTests' do

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

