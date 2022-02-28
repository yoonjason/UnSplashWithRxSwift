//
//  NetworkService.swift
//  KakaoInsuranceAssignment
//
//  Created by yoon on 2022/02/10.
//  Copyright © 2022 com.kakaoinsurance. All rights reserved.
//

import Foundation
import RxSwift

enum NetworkEndPoint: String {
    case getPhoto = "/photos"
    case getSearchPhoto = "/search/photos"
}

struct NetworkService {

    static let baseURL = "https://api.unsplash.com"
    static let client_id = "AqzzK8Iv3d61GEwrMMurhBnVnN1MRMoRkjDJj8bNLf0"

    static func getSearchPhotoList(_ page: Int = 1, query: String) -> Observable<[PhotoModel]> {
        return Observable.create { observer in

            let urlString = "\(baseURL)\(NetworkEndPoint.getSearchPhoto.rawValue)?client_id=\(client_id)&query=\(query)&per_page=10&page=\(page)"
            let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print("#@#@# ==== ",encodedUrlString)
            let task = URLSession.shared.dataTask(with: URL(string: encodedUrlString ?? "")!) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    print(error)
                    return
                }
                guard let data = data else {
                    observer.onCompleted()
                    return
                }
                let response = try? JSONDecoder().decode(SearchModel.self, from: data)

                guard let response = response else {
                    observer.onCompleted()
                    return
                }

                if response.results.count < 1 {
                    return
                }
                observer.onNext(response.results)
                observer.onCompleted()

            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }

    }

    static func getPhotoList(_ page: Int = 1) -> Observable<[PhotoModel]> {

        return Observable.create { observer in

            let urlString = "\(baseURL)\(NetworkEndPoint.getPhoto.rawValue)?client_id=\(client_id)&per_page=10&page=\(page)"
            let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let task = URLSession.shared.dataTask(with: URL(string: encodedUrlString ?? "")!) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    print(error)
                    return
                }
                guard let data = data else {
                    print("data === ",data)
                    observer.onCompleted()
                    return
                }
                let response = try? JSONDecoder().decode([PhotoModel].self, from: data)
                
                guard let response = response else {
                    observer.onNext([])
                    observer.onCompleted()
                    return
                }

                observer.onNext(response)
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }

}
