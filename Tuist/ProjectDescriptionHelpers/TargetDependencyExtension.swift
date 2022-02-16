//
//  TargetDependencyExtension.swift
//  ProjectDescriptionHelpers
//
//  Created by Bradley.yoon on 2022/02/16.
//

import ProjectDescription

public extension TargetDependency {
    static let rxSwift: TargetDependency = .package(product: "RxSwift")
    static let rxAppState: TargetDependency = .package(product: "RxAppState")
}

public extension Package {
    static let rxSwift: Package = .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("6.5.0"))
    static let rxAppState: Package = .package(url: "https://github.com/pixeldock/RxAppState.git", .exact("1.7.1"))
}

public extension SourceFilesList {
    static let sources: SourceFilesList = "Sources/**"
    static let assets: SourceFilesList = "Resources/**"
}

