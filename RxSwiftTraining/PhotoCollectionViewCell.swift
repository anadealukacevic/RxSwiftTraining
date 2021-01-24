//
//  PhotoCollectionViewCell.swift
//  RxSwiftTraining
//
//  Created by Anadea Lukačević on 15/01/2021.
//

import UIKit
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    internal lazy var photo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(photo)
    }
    
    func makeConstraints() {
        photo.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(0)
        }
    }
}
