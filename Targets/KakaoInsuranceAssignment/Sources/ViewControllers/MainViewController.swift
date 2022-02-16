//
//  MainViewController.swift
//  KakaoInsuranceAssignment
//
//  Created by yoon on 2022/02/09.
//  Copyright © 2022 com.kakaoinsurance. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState


class MainViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel: PhotoListVewModel
    private let cellSpacing: CGFloat = 0
    private let columns: CGFloat = 3
    var imageProviders = Set<ImageProvider>()
    let layout = UICollectionViewFlowLayout()

    private lazy var collectionView: UICollectionView = {
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        let width = (UIScreen.main.bounds.width - cellSpacing * 2) / columns
        layout.itemSize = CGSize(width: width, height: width)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        return collectionView
    }()

    private let searchController: UISearchController = {
        return UISearchController(searchResultsController: nil)
    }()

    init(viewModel: PhotoListVewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let fetchNext = collectionView.rx.willDisplayCell
            .filter { [weak self] cell, indexPath -> Bool in
            guard let self = self else { return false }
            return indexPath.row == self.collectionView.numberOfItems(inSection: 0) - 6
        }
            .map { _ in }

        let output = viewModel.transform(
            input: PhotoListVewModel.Input(
                fetchFirst: rx.viewDidLoad,
                fetchNext: fetchNext
            ),
            query: viewModel.searchText.value
        )

        output.photoList
            .drive(collectionView.rx.items(cellIdentifier: PhotoCell.reuseIdentifier, cellType: PhotoCell.self)) { index, item, cell in
            cell.photoImage = item
        }
            .disposed(by: disposeBag)

        collectionView.rx.willDisplayCell.subscribe(onNext: { [weak self] cell, indexPath in
            guard let cell = cell as? PhotoCell else { return }
//            let imageOP = ImageOperation(inputImageURL: cell.photoImage?.urls.thumb ?? "") { image in
//                cell.updateImageViewWithImage(image)
//            }
//            OperationQueue.main.addOperation(imageOP)
            cell.updateImage(cell.photoImage?.urls.thumb ?? "")

//            let imageProvider = ImageProvider(photoViewModel: cell.photoImage!) { image in
//                OperationQueue.main.addOperation {
//                    cell.updateImageViewWithImage(image)
//                }
//            }
//            self?.imageProviders.insert(imageProvider)
        })
            .disposed(by: disposeBag)

        collectionView.rx.didEndDisplayingCell.subscribe(onNext: { [weak self] cell, indexPath in
            guard let cell = cell as? PhotoCell else { return }
            for provider in self!.imageProviders.filter({ $0.photoViewModel == cell.photoImage }) {
                provider.cancel()
                self?.imageProviders.remove(provider)
            }
        })
            .disposed(by: disposeBag)


        Observable
            .zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(PhotoViewModel.self))
            .bind { [weak self] indexPath, model in
            guard let cell = self?.collectionView.cellForItem(at: indexPath) else { return }
            guard let cell = cell as? PhotoCell else { return }
            viewModel.currentPageIndexPath.accept(indexPath.row)
            let detailVC = ImageViewerController(viewModel, cellIndex: indexPath.row)
            detailVC.modalPresentationStyle = .fullScreen
            self?.present(detailVC, animated: true, completion: nil)
        }
            .disposed(by: disposeBag)

        viewModel.currentPageIndexPath
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
            if viewModel.photoList.value.count > 0 {
                self.collectionView.scrollToItem(at: IndexPath(item: $0, section: 0), at: .centeredVertically, animated: true)
            }
        })
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setSearchContrller()
    }

    func setupViews() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setSearchContrller() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        searchController.searchBar.placeholder = "이미지 검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }


}

extension MainViewController: UIScrollViewDelegate { }

extension MainViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
    }

    func willDismissSearchController(_ searchController: UISearchController) {

    }

    func didDismissSearchController(_ searchController: UISearchController) {
//        print(#function, "updateQueriesSuggestions")
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel.page = 1
        viewModel.searchText.accept(searchText)
        viewModel.photoList.accept([])
        print(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.page = 1
        viewModel.searchText.accept("")
        print("cancel")
    }
}



