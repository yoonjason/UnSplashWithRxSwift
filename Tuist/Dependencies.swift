
import ProjectDescription


let dependencies = Dependencies(
    carthage: nil,
    swiftPackageManager: [
        .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.5.0")),
        .remote(url: "https://github.com/pixeldock/RxAppState.git", requirement: .exact("1.7.1"))
    ],
    platforms: [.iOS]
)
