//
//  ImageViewerController.swift
//  KakaoInsuranceAssignment
//
//  Created by yoon on 2022/02/11.
//  Copyright © 2022 com.kakaoinsurance. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ImageViewerController: UIViewController {

    let layout = UICollectionViewFlowLayout()
    private let disposeBag = DisposeBag()
    private let viewModel: PhotoListVewModel
    var currnetIndexPath: Int
    var draggingDownDismiss = false

    private let closeBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()

    lazy var collectionView: UICollectionView = {
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .black
        collectionView.register(ImageViewerCell.self, forCellWithReuseIdentifier: "ImageViewerCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        return collectionView
    }()
    
    private lazy var dismissGesture: UIPanGestureRecognizer = {
       let gesture = UIPanGestureRecognizer()
        gesture.maximumNumberOfTouches = 1
        gesture.delegate = self
        gesture.addTarget(self, action: #selector(handleDismiss))
        return gesture
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    init(_ viewModel: PhotoListVewModel, cellIndex: Int) {
        self.viewModel = viewModel
        self.currnetIndexPath = cellIndex
        super.init(nibName: nil, bundle: nil)

        viewModel.photoList.bind(to: collectionView.rx.items(cellIdentifier: ImageViewerCell.reuseIdentifier, cellType: ImageViewerCell.self)) { index, item, cell in
            cell.photoImage = item
            self.currnetIndexPath = index
        }
            .disposed(by: disposeBag)

        viewModel.currentPageIndexPath
            .delay(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
            self.collectionView.scrollToItem(
                at: IndexPath(item: $0, section: 0),
                at: .centeredHorizontally,
                animated: false)
        })
            .disposed(by: disposeBag)

        collectionView.rx.willDisplayCell.subscribe(onNext: { [weak self] cell, indexPath in
            guard let cell = cell as? ImageViewerCell else { return }
            let imageOP = ImageOperation(inputImageURL: cell.photoImage?.urls.regular ?? "") { image in
                cell.updateImageViewWithImage(image)
            }
            OperationQueue.main.addOperation(imageOP)

            if indexPath.row == (self?.collectionView.numberOfItems(inSection: 0))! - 2 {
                viewModel.getPhotoList()
            }
        })
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addGestureRecognizer(dismissGesture)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeBtn.heightAnchor.constraint(equalToConstant: 100),
            closeBtn.widthAnchor.constraint(equalToConstant: 70),
            closeBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -closeBtn.frame.width),
            closeBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }

    

}

extension ImageViewerController {
    @objc func didTapClose() {
        dismiss()
    }
    
    @objc func handleDismiss(gesture: UIPanGestureRecognizer) {
       dismiss()
    }
    
    func dismiss(){
        viewModel.currentPageIndexPath.accept(self.currnetIndexPath)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ImageViewerController: UIScrollViewDelegate { }

extension ImageViewerController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
