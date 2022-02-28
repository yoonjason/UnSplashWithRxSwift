//
//  PhotoListViewModel.swift
//  KakaoInsuranceAssignment
//
//  Created by yoon on 2022/02/10.
//  Copyright © 2022 com.kakaoinsurance. All rights reserved.
//

import RxSwift
import RxCocoa

final class PhotoListVewModel {

    private let disposeBag = DisposeBag()

    var page: Int = 1
    let photoList = BehaviorRelay<[PhotoViewModel]>(value: [])
    private let per_page: Int = 10
    var currentPageIndexPath = BehaviorRelay<Int>(value: 0)
    var searchText = BehaviorRelay<String>(value: "")

    struct Input {
        let fetchFirst: Observable<Void>
        let fetchNext: Observable<Void>
    }

    struct Output {
        let photoList: Driver<[PhotoViewModel]>
    }

    func transform(input: Input, query: String) -> Output {
        input.fetchFirst
            .subscribe(onNext: { [weak self] in
            self?.getPhotoList()
        })
            .disposed(by: disposeBag)

        input.fetchNext
            .subscribe(onNext: { [weak self] in
            if (self?.searchText.value == "") {
                self?.getPhotoList()
            } else {
                self?.getSearchPhotoList(self?.searchText.value ?? "")
            }
        })
            .disposed(by: disposeBag)

        searchText.subscribe(onNext: { [weak self] in
            if $0 == "" {
                self?.photoList.accept([])
                self?.getPhotoList()
            }
            if !$0.isEmpty && $0 != "" {
                self?.getSearchPhotoList($0)
            }
        })
            .disposed(by: disposeBag)

        return Output(photoList: photoList.asDriver(onErrorJustReturn: []))
    }

    func transform(input: Input) -> Output {

        input.fetchFirst
            .subscribe(onNext: { [weak self] in
            self?.getPhotoList(self!.photoList)
        })
            .disposed(by: disposeBag)

        input.fetchNext
            .subscribe(onNext: { [weak self] in
            self?.getPhotoList(self!.photoList)
        })
            .disposed(by: disposeBag)

        return Output (photoList: photoList.asDriver(onErrorJustReturn: []))
    }

    func search(input: Input, query: String) -> Output {
        input.fetchFirst
            .subscribe(onNext: { [weak self] in
            self?.getSearchPhotoList(query)
        })
            .disposed(by: disposeBag)

        input.fetchNext
            .subscribe(onNext: { [weak self] in
            self?.getSearchPhotoList(query)
        })
            .disposed(by: disposeBag)

        return Output(photoList: photoList.asDriver(onErrorJustReturn: []))
    }
}

extension PhotoListVewModel {

    func getPhotoList() {
        NetworkService.getPhotoList(page)
            .map { $0.map { PhotoViewModel($0) } }
            .subscribe(onNext: {
            var new = self.photoList.value
            new.append(contentsOf: $0)
            self.photoList.accept(new)
        })
            .disposed(by: disposeBag)
        page += 1
    }

    func getPhotoList(_ photoList: BehaviorRelay<[PhotoViewModel]>) {
        NetworkService.getPhotoList(page)
            .map { $0.map { PhotoViewModel($0) } }
            .subscribe(onNext: {
            var new = photoList.value
            new.append(contentsOf: $0)
            photoList.accept(new)
        })
            .disposed(by: disposeBag)

        page += 1

    }

    func getSearchPhotoList(_ query: String) {
        NetworkService.getSearchPhotoList(page, query: query)
            .map { $0.map { PhotoViewModel($0) } }
            .subscribe(onNext: { model in
            var new = self.photoList.value
            new.append(contentsOf: model)
            self.photoList.accept(new)
        })
            .disposed(by: disposeBag)

        page += 1
    }
}

