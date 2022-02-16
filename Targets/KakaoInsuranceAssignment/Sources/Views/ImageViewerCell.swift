//
//  ImageViewerCell.swift
//  KakaoInsuranceAssignment
//
//  Created by yoon on 2022/02/11.
//  Copyright © 2022 com.kakaoinsurance. All rights reserved.
//

import UIKit

class ImageViewerCell: UICollectionViewCell {

    static let reuseIdentifier = "ImageViewerCell"
    private let appearance = Appearance()
    private var pinchScale: CGFloat = 1.0

    var photoImage: PhotoViewModel? {
        didSet {
            if let photoImage = photoImage {
                updateImageViewWithImage(nil)
            }
        }
    }


    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let likeBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupPinchGesture()
        setupDoubleTapGesture()
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func updateImageViewWithImage(_ image: UIImage?) {
        if let image = image {
            imageView.image = image
            imageView.alpha = 0.2

            UIView.animate(withDuration: 0.2, animations: {
                self.imageView.alpha = 1.0
            }, completion: {
                _ in
            })
        } else {
            imageView.image = nil
            imageView.alpha = 0
        }
    }

    func setupViews() {
        self.addSubview(scrollView)
        scrollView.addSubview(imageView)
        self.addSubview(likeBtn)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            
            likeBtn.heightAnchor.constraint(equalToConstant: 100),
            likeBtn.widthAnchor.constraint(equalToConstant: 100),
            likeBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            likeBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -likeBtn.frame.width)
        ])
    }
}

extension ImageViewerCell {
    @objc func didTapLike() {
        print("like")
    }
}

extension ImageViewerCell: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let widthRatio = imageView.frame.width / image.size.width
                let heightRatio = imageView.frame.height / image.size.height

                let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let leftCondition = newWidth * scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (leftCondition ? newWidth - imageView.frame.width: (scrollView.frame.width - scrollView.contentSize.width))
                let topConditio = newHeight * scrollView.zoomScale > imageView.frame.height
                let top = 0.5 * (topConditio ? newHeight - imageView.frame.height: (scrollView.frame.height - scrollView.contentSize.height))
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.zoomScale <= appearance.miniumZoomScale {
            scrollView.zoomScale = appearance.miniumZoomScale
        }
        if scrollView.zoomScale >= appearance.maximumZoomScale {
            scrollView.zoomScale = appearance.maximumZoomScale
        }
    }

}

extension ImageViewerCell: UIGestureRecognizerDelegate {

    func setupDoubleTapGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapForZoom))
        tapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapRecognizer)
    }

    @objc private func doubleTapForZoom(gestureRecognizer: UITapGestureRecognizer) {

        let location = gestureRecognizer.location(in: imageView)

        scrollView.minimumZoomScale = appearance.miniumZoomScale
        scrollView.maximumZoomScale = appearance.maximumZoomScale

        if scrollView.zoomScale == appearance.miniumZoomScale {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
                self.scrollView.zoomScale = self.appearance.maximumZoomScale
                self.scrollView.setContentOffset(CGPoint(x: location.x, y: location.y), animated: true)
                self.scrollView.contentSize.height = self.bounds.height + self.imageView.frame.size.height
                self.scrollView.layoutIfNeeded()
            } completion: { _ in }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
                self.scrollView.zoomScale = self.appearance.miniumZoomScale
                self.scrollView.layoutIfNeeded()
            } completion: { _ in }
        }
    }

    func setupPinchGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didMovePinch(_:)))
        self.scrollView.addGestureRecognizer(pinch)
    }

    @objc func didMovePinch(_ pinch: UIPinchGestureRecognizer) {
        if pinch.state == .began || pinch.state == .changed {
            imageView.transform = imageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            pinchScale *= pinch.scale
            pinch.scale = 1.0
        } else if (pinchScale > 1.0 && pinch.scale < 1.0) {
            imageView.transform = (imageView.transform).scaledBy(x: pinch.scale, y: pinch.scale)
            pinchScale *= pinch.scale
            pinch.scale = 1.0
        }
    }
}

extension ImageViewerCell {
    private struct Appearance {
        let maximumZoomScale: CGFloat = 2.0
        let miniumZoomScale: CGFloat = 1.0
    }
}
