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
        print("1111")
        let containerView = transitionContext.containerView
        print("2222")
        
        guard let toVC = transitionContext.viewController(forKey: .to) as? ImageViewerController else { return }
        guard let fromVC = transitionContext.viewController(forKey: .from) as? UINavigationController else { return }
        guard let mainVC = fromVC.viewControllers.first as? MainViewController else { return }
        guard let selectedCell = mainVC.selectedCell else { return }
        guard let indexPath = mainVC.currentIndexPath else { return }
        
        let frame = selectedCell.convert(selectedCell.frame, from: fromVC.view)
        toVC.view.frame = frame
        
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: timeDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseInOut]) {
            toVC.view.frame = UIScreen.main.bounds
            toVC.view.layer.cornerRadius = 20
            
        } completion: { completed in
            transitionContext.completeTransition(completed)
        }

        
//        print("3333")
//        guard
//            let toSelectedCell = toCollectionView.cellForItem(at: indexPath) as? ImageViewerCell else {
//                print("not found")
//                return }
        print("4444")
//        let snapshotContentView = UIView()
//        snapshotContentView.backgroundColor = .blue
//        snapshotContentView.frame = containerView.convert(selectedCell.contentView.frame, from: selectedCell)
//        snapshotContentView.layer.cornerRadius = selectedCell.layer.cornerRadius
//
//        var snapshotCollectionView = UICollectionView()
//        snapshotCollectionView = toVC.collectionView
//        snapshotCollectionView.frame = containerView.convert(snapshotCollectionView.frame, from: selectedCell)
//
//        containerView.addSubview(toVC.view)
//        containerView.addSubview(snapshotContentView)
//        containerView.addSubview(snapshotCollectionView)
//
//        toVC.view.isHidden = true
//
//        let animator = UIViewPropertyAnimator(duration: timeDuration, curve: .easeInOut) {
//            snapshotContentView.frame = containerView.convert(toVC.view.frame, from: toVC.view)
//            snapshotCollectionView.frame = containerView.convert(snapshotCollectionView.frame, from: toCollectionView)
//
//        }
//
//        animator.addCompletion { position in
//            toVC.view.isHidden = false
//            snapshotCollectionView.removeFromSuperview()
//            snapshotContentView.removeFromSuperview()
//            transitionContext.completeTransition(position == .end)
//        }
//
//        animator.startAnimation()
    }

    func animationDismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? ImageViewerController,
            let toVC = transitionContext.viewController(forKey: .to) as? UINavigationController,
            let mainVC = toVC.viewControllers.first as? MainViewController,
            let selectedCell = mainVC.selectedCell
        else {
            return
        }
        
        UIView.animate(withDuration: timeDuration/0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: []) {
            let frame = selectedCell.convert(selectedCell.frame, from: fromVC.view)
            fromVC.view.frame = UIScreen.main.bounds
        } completion: { completed in
            transitionContext.completeTransition(completed)
        }

    }

}

extension Animator: UIViewControllerAnimatedTransitioning {
    //애니메이션에 걸릴 시간을 설정한다.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return timeDuration
    }

    //애니메이션이 이뤄지는 화면들을 결정하고, 프레임, 위치 좌표등을 설정한다.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if animationType == .present {
            animationPresent(using: transitionContext)
        } else {
            animationDismiss(using: transitionContext)
        }
    }
}
