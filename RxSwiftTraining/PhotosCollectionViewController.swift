//
//  PhotosCollectionViewController.swift
//  RxSwiftTraining
//
//  Created by Anadea Lukačević on 14/01/2021.
//

import UIKit
import Photos
import SnapKit
import RxSwift

class PhotosCollectionViewController: UIViewController {
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/5)
        return layout
    }()
    
    private lazy var photosCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collection.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()
    
    private var images = [PHAsset]()
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage> {
        selectedPhotoSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Photos"
        addSubviews()
        makeConstraints()
        populatePhotos()
    }
    
    private func addSubviews() {
        view.addSubview(photosCollectionView)
    }
    
    private func makeConstraints() {
        photosCollectionView.snp.makeConstraints {
            $0.top.leading.equalTo(15)
            $0.trailing.bottom.equalTo(-15)
        }
    }
    
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.photosCollectionView.reloadData()
                }
            }
        }
    }
}

extension PhotosCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCollectionViewCell else { fatalError("Photos not found") }
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/5), contentMode: .aspectFill, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.photo.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.images[indexPath.row]
        PHImageManager
            .default()
            .requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] image, info in
                guard let info = info else { return }
                let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
                if !isDegradedImage {
                    if let image = image {
                        self?.selectedPhotoSubject.onNext(image)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
    }
}
