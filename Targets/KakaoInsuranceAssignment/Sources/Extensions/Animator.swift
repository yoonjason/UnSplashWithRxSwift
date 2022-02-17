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

enum AnimationType {
    case present
    case dismiss
}

class Animator: NSObject {
    let animationType: AnimationType

    init(animationType: AnimationType) {
        self.animationType = animationType
        super.init()
    }
}

extension Animator {

    func animationPresent(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? MainViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? ImageViewerController,
            let selectedCell = fromVC.selectedCell,
            let indexPath = fromVC.currentIndexPath,
            let toCollectionView = toVC.collectionView.subviews.first as? UICollectionView,
            let toSelectedCell = toCollectionView.cellForItem(at: indexPath) as? ImageViewerCell
            else {
            return
        }
        let snapshotContentView = UIView()
        snapshotContentView.backgroundColor = .blue
        snapshotContentView.frame = containerView.convert(selectedCell.contentView.frame, from: selectedCell)
        snapshotContentView.layer.cornerRadius = selectedCell.layer.cornerRadius

        var snapshotCollectionView = UICollectionView()
        snapshotCollectionView = toVC.collectionView
        snapshotCollectionView.frame = containerView.convert(snapshotCollectionView.frame, from: selectedCell)

        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshotContentView)
        containerView.addSubview(snapshotCollectionView)

        toVC.view.isHidden = true

        let animator = UIViewPropertyAnimator(duration: timeDuration, curve: .easeInOut) {
            snapshotContentView.frame = containerView.convert(toVC.view.frame, from: toVC.view)
            snapshotCollectionView.frame = containerView.convert(snapshotCollectionView.frame, from: toCollectionView)

        }

        animator.addCompletion { position in
            toVC.view.isHidden = false
            snapshotCollectionView.removeFromSuperview()
            snapshotContentView.removeFromSuperview()
            transitionContext.completeTransition(position == .end)
        }

        animator.startAnimation()
    }

    func animationDismiss(using transitionContext: UIViewControllerContextTransitioning) {
        
    }

    func presentController(_ toVC: ImageViewerController, fromVC: MainViewController, with transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? MainViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? ImageViewerController,
            let selectedCell = fromVC.selectedCell,
            let indexPath = fromVC.currentIndexPath,
            let toCollectionView = toVC.collectionView.subviews.first as? UICollectionView,
            let toSelectedCell = toCollectionView.cellForItem(at: indexPath) as? ImageViewerCell
            else {
            return
        }
        let snapshotContentView = UIView()
        snapshotContentView.backgroundColor = .blue
        snapshotContentView.frame = containerView.convert(selectedCell.contentView.frame, from: selectedCell)
        snapshotContentView.layer.cornerRadius = selectedCell.layer.cornerRadius

        var snapshotCollectionView = UICollectionView()
        snapshotCollectionView = toVC.collectionView
        snapshotCollectionView.frame = containerView.convert(snapshotCollectionView.frame, from: selectedCell)

        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshotContentView)
        containerView.addSubview(snapshotCollectionView)

        toVC.view.isHidden = true

        let animator = UIViewPropertyAnimator(duration: timeDuration, curve: .easeInOut) {
            snapshotContentView.frame = containerView.convert(toVC.view.frame, from: toVC.view)
            snapshotCollectionView.frame = containerView.convert(snapshotCollectionView.frame, from: toCollectionView)

        }

        animator.addCompletion { position in
            toVC.view.isHidden = false
            snapshotCollectionView.removeFromSuperview()
            snapshotContentView.removeFromSuperview()
            transitionContext.completeTransition(position == .end)
        }

        animator.startAnimation()
    }



}

extension Animator: UIViewControllerAnimatedTransitioning {
    //애니메이션에 걸릴 시간을 설정한다.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return timeDuration
    }

    //애니메이션이 이뤄지는 화면들을 결정하고, 프레임, 위치 좌표등을 설정한다.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    }
}
