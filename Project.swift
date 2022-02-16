import ProjectDescription
import ProjectDescriptionHelpers



let bundleId = "com.kakaoinsurance"
// MARK: - Project

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "KakaoInsuranceAssignment",
                          platform: .iOS,
                          additionalTargets: [],
                          bundleId: bundleId
)
