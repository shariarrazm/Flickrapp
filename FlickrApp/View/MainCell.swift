//
//  MainCell.swift
//  FlickrApp
//
//  Created by Shariar Razm1 on 2018-06-22.
//  Copyright © 2018 Shariar Razm. All rights reserved.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraintes()
    }
    
    func setupConstraintes() {
        
        addSubview(containerView)
        containerView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        
        [profileImageView, separatorView, nameLabel].forEach {containerView.addSubview($0)}

        profileImageView.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, leading: containerView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: 5, bottom: 5, right: 5), size: .init(width: 120, height: 130))
        
        separatorView.anchor(top: containerView.topAnchor, leading: profileImageView.trailingAnchor, bottom: containerView.bottomAnchor, trailing: nil, padding: .init(top: 3, left: 3, bottom: 3, right: 3), size: .init(width: 1, height: 0))

        nameLabel.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, leading: separatorView.trailingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 0, right: 5), size: .init(width: 0, height: self.contentView.bounds.height - 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

