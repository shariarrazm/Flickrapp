//
//  DetailCell.swift
//  FlickrApp
//
//  Created by Shariar Razm1 on 2018-06-22.
//  Copyright © 2018 Shariar Razm. All rights reserved.
//

import UIKit

class DetailCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Info"
        label.numberOfLines = 0
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        addSubview(containerView)
        containerView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        
        [infoLabel, separatorView, imageView].forEach {containerView.addSubview($0)}

        imageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 2, left: 2, bottom: 0, right: 2))


        separatorView.anchor(top: imageView.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 5, left: 3, bottom: 0, right: 3), size: .init(width: 0, height: 1))


        infoLabel.anchor(top: separatorView.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 5, right: 5), size: .init(width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



