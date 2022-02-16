// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("6.5.0")),
        .package(url: "https://github.com/pixeldock/RxAppState.git", .exact("1.7.1")),
    ]
)