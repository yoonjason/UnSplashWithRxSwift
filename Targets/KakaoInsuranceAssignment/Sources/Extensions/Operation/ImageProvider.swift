//
//  ImageProvider.swift
//  KakaoInsuranceAssignment
//
//  Created by yoon on 2022/02/11.
//  Copyright © 2022 com.kakaoinsurance. All rights reserved.
//

import Foundation
import UIKit

class ImageProvider {
    fileprivate let operationQueue = OperationQueue()
    let photoViewModel: PhotoViewModel

    init(photoViewModel: PhotoViewModel, completion: @escaping (UIImage?) -> ()) {
        self.photoViewModel = photoViewModel
        let imageOperation = ImageOperation(inputImageURL: self.photoViewModel.urls.thumb, completion: completion)
        operationQueue.addOperation(imageOperation)
    }

    func cancel() {
        operationQueue.cancelAllOperations()
    }
}

extension ImageProvider: Hashable {
    var hashValue: Int {
        return photoViewModel.id.hashValue
    }
}
//
func == (lhs: ImageProvider, rhs: ImageProvider) -> Bool {
    return lhs.photoViewModel.id == rhs.photoViewModel.id
}
