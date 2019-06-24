//
//  UserSearchCell.swift
//  Instagram
//
//  Created by Findl MAC on 17/04/2019.
//  Copyright © 2019 YD. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {

    var user: User? {
        didSet{
            guard let username = user?.username else {return}
            usernameLabel.text = username
            guard let imageUrl = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: imageUrl)
        }
    }
    
    
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .purple
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 50 / 2
        return iv
    }()
    
    let usernameLabel: UILabel = {
       let label = UILabel()
       label.text = "username"
       label.font = UIFont.boldSystemFont(ofSize: 14)
       return label
    }()
    
    let separatorView = UIView()
    override init(frame : CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
