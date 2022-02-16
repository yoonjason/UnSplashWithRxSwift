import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String,
                           platform: Platform,
                           additionalTargets: [String],
                           bundleId: String
    ) -> Project {
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: additionalTargets.map { TargetDependency.target(name: $0) },
                                     bundleId: bundleId
        )
        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform, bundleId: bundleId) })
        return Project(name: name,
                       organizationName: bundleId,
                       targets: targets)
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(
        name: String,
        platform: Platform,
        bundleId: String
    ) -> [Target] {
        let sources = Target(name: name,
                             platform: platform,
                             product: .framework,
                             bundleId: "\(bundleId).\(name)",
                             infoPlist: .default,
                             sources: ["Targets/\(name)/Sources/**"],
                             resources: [],
                             dependencies: [])
        let tests = Target(name: "\(name)Tests",
                           platform: platform,
                           product: .unitTests,
                           bundleId: "\(bundleId).\(name)Tests",
                           infoPlist: .default,
                           sources: ["Targets/\(name)/Tests/**"],
                           resources: [],
                           dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(
        name: String,
        platform: Platform,
        dependencies: [TargetDependency],
        bundleId: String
    ) -> [Target] {
        let platform: Platform = platform
        let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "13.0", devices: [.iphone])
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "0.0.1",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
        ]

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "\(bundleId).\(name)",
            deploymentTarget: deploymentTarget,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: [
                .rxSwift,
                .rxAppState,
            ]
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(bundleId).\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                    .target(name: "\(name)")
            ])
        return [mainTarget, testTarget]
    }
}
