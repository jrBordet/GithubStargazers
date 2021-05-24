# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

source 'https://github.com/jrBordet/Sources.git'
source 'https://cdn.cocoapods.org/'

def shared_pods
		pod 'SceneBuilder', '1.0.0'
		pod 'RxComposableArchitecture', '2.1.2'
end

def caprice
		pod 'Caprice', '0.0.6'
end

target 'GithubStargazers' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  shared_pods


  pod 'RxDataSources', '4.0.1'
	pod 'Tabman', '~> 2.9'
	pod "SwiftPrettyPrint", "~> 1.1.0" #, :configuration => "Debug"
	
	# add the Firebase pod for Google Analytics
	pod 'Firebase/Analytics'
	# add pods for any other desired Firebase products
	# https://firebase.google.com/docs/ios/setup#available-pods
	
  target 'GithubStargazersTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'SnapshotTesting', '~> 1.7.2'
    pod 'RxComposableArchitectureTests', '2.1.2'
		pod 'RxBlocking'
		pod 'RxTest'
		pod 'Difference'

    caprice
  end

end

target 'GithubStargazersMock' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  shared_pods


  pod 'RxDataSources', '4.0.1'
	pod 'Tabman', '~> 2.9'
	pod "SwiftPrettyPrint", "~> 1.1.0" #, :configuration => "Debug"
	
	# add the Firebase pod for Google Analytics
	pod 'Firebase/Analytics'

end