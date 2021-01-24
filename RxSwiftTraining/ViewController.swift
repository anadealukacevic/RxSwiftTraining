//
//  ViewController.swift
//  RxSwiftTraining
//
//  Created by Anadea Lukačević on 14/01/2021.
//

import UIKit
import RxSwift
import SnapKit

class ViewController: UIViewController {
    
    private lazy var photoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var applyFilterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("Apply Filter", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        return button
    }()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Camera Filter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(didTap))
        applyFilterButton.isHidden = true
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(photoImageView)
        view.addSubview(applyFilterButton)
    }
    
    private func makeConstraints() {
        photoImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(0)
            $0.bottom.equalTo(-200)
        }
        applyFilterButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(150)
            $0.height.equalTo(70)
            $0.bottom.equalTo(-100)
        }
    }
    
    @objc private func didTap() {
        let vc = PhotosCollectionViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc
            .selectedPhoto
            .subscribe(onNext: { [weak self] photo in
                DispatchQueue.main.async {
                    self?.updateUI(with: photo)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }
    
    @objc func applyFilter() {
        guard let sourceImage = self.photoImageView.image else { return }
        FilterService()
            .applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
    }
}
