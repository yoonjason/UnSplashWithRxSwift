//
//  Animator.swift
//  KakaoInsuranceAssignment
//
//  Created by Bradley.yoon on 2022/02/16.
//  Copyright © 2022 com.kakaoinsurance. All rights reserved.
//

import Foundation
import UIKit

fileprivate let timeDuration: TimeInterval = 1.0

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return timeDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? MainViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? ImageViewerController,
            let selectedCell = fromVC.selectedCell
            else {
            return
        }
        let snapshotContentView = UIView()
        snapshotContentView.backgroundColor = .blue
        snapshotContentView.frame = containerView.convert(selectedCell.contentView.frame, from: selectedCell)
        snapshotContentView.layer.cornerRadius = selectedCell.layer.cornerRadius
        
        

    }

}
