//
//  PhotoViewModel.swift
//  KakaoInsuranceAssignment
//
//  Created by yoon on 2022/02/10.
//  Copyright © 2022 com.kakaoinsurance. All rights reserved.
//

import Foundation

struct PhotoViewModel {
    let id: String
    let urls: Urls
    let likes: Int
    
    init(_ model: PhotoModel) {
        self.id = model.id
        self.urls = model.urls
        self.likes = model.likes
    }
}

extension PhotoViewModel: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}

func ==(lhs: PhotoViewModel, rhs: PhotoViewModel) -> Bool {
    return lhs.id == rhs.id
}
