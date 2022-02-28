//
//  ImageOperation.swift
//  KakaoInsuranceAssignment
//
//  Created by yoon on 2022/02/11.
//  Copyright © 2022 com.kakaoinsurance. All rights reserved.
//

import Foundation
import UIKit

class ImageOperation: Operation {
    fileprivate var inputImageURL: String
    var outputImage: UIImage?
    fileprivate let completion: ((UIImage?) -> ())?

    init(inputImageURL: String, completion: ((UIImage?) -> ())? = nil) {
        self.inputImageURL = inputImageURL
        self.completion = completion
        super.init()
    }

    override func main() {
        if self.isCancelled { return }
        if let imageURL = URL(string: inputImageURL) {
            if self.isCancelled { return }
            let data = try? Data(contentsOf: imageURL)
            if self.isCancelled { return }
            let image = UIImage(data: data!)
            outputImage = image
            completion?(outputImage)
        }
    }

}
