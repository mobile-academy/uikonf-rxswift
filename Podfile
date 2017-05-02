source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'

use_frameworks!

abstract_target 'Workshops' do
    pod 'RxSwift', '~> 3.0'
    pod 'RxCocoa', '~> 3.0'
    pod 'Marshal', '~> 1.0'
    pod 'SwiftDate',     '~> 4.0'

    target 'RxSwiftWorkshop' do
        pod 'RxDataSources', '~> 1.0'
        pod 'SnapKit', '~> 3.2.0'
    end

    target 'RxSwiftWorkshopTests' do
        pod 'Quick'
        pod 'Nimble'
        pod 'Mimus'
        pod 'RxTest'
    end
end

plugin 'cocoapods-keys', {
    :project => "RxSwiftWorkshop",
    :keys => [
        "IATACodesAPIKey",
        "SchipholAPIAppID",
        "SchipholAPIAppKey",
    ]
}
