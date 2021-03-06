Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "wavelabs_ios_client_api"
s.summary = "wavelabs_ios_client_api desc"
s.requires_arc = true

# 2
s.version = "0.1.3"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Afsara" => "afsarunnisa@nbostech.com" }

# For example,
# s.author = { "Joshua Greene" => "jrg.developer@gmail.com" }


# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/nbostech/wavelabs_ios_client_api"

# For example,
# s.homepage = "https://github.com/JRG-Developer/RWPickFlavor"


# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/nbostech/wavelabs_ios_client_api.git", :tag => "#{s.version}"}

# For example,
# s.source = { :git => "https://github.com/JRG-Developer/RWPickFlavor.git", :tag => "#{s.version}"}


# 7
s.framework = "UIKit"
s.dependency 'Alamofire', '~> 1.3.1'
s.dependency 'MBProgressHUD', '~> 0.9.0'

# 8
s.source_files = "wavelabs_ios_client_api/**/*.{swift}"

# 9
#s.resources = "wavelabs_ios_client_api/**/*.{png,jpeg,jpg,storyboard,xib}"
end
