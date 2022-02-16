//
//  PhotoCell.swift
//  KakaoInsuranceAssignment
//
//  Created by yoon on 2022/02/10.
//  Copyright © 2022 com.kakaoinsurance. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    static let reuseIdentifier = "PhotoCell"

    var photoImage: PhotoViewModel? {
        didSet {
            if let photoImage = photoImage {
                updateImageViewWithImage(nil)
            }
        }
    }
    
    

    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    func updateImage(_ image: String) {
        
        let imageOp = ImageOperation(inputImageURL: image) { image in
            
                self.updateImageViewWithImage(image)
        }
        OperationQueue.main.addOperation(imageOp)
//        OperationQueue.main.addOperation { [weak self] in
//            if let imageURL = URL(string: image) {
//                let data = try? Data(contentsOf: imageURL)
//                let image = UIImage(data: data!)
//                self?.imageView.image = image
//            }
//        }

    }
    
    

    func updateImageViewWithImage(_ image: UIImage?) {
        if let image = image {
            imageView.image = image
            imageView.alpha = 0.2

            UIView.animate(withDuration: 0.2, animations: {
                self.imageView.alpha = 1.0
                self.activityIndicator.alpha = 0
            }, completion: {
                _ in
                self.activityIndicator.stopAnimating()
            })
        } else {
            imageView.image = nil
            imageView.alpha = 0
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        self.addSubview(activityIndicator)
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
