//
//  CommentController.swift
//  Instagram
//
//  Created by Findl MAC on 29/04/2019.
//  Copyright © 2019 YD. All rights reserved.
//

import UIKit
import Firebase


class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
    
    let cellId = "cellId"
    
    var post: Post?
    
    var comments = [Comment]()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        return textField
    }()
    
    lazy var containerView: UIView = {
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
       
       
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.addTarget(self, action: #selector(handleSubmitComment), for: .touchUpInside)
        
        
        let linesSeparatorView = UIView()
        linesSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        containerView.addSubview(linesSeparatorView)
        containerView.addSubview(commentTextField)
        containerView.addSubview(sendButton)
        
        linesSeparatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        sendButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
           return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
    
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        fetchComment()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func handleSubmitComment() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        guard let postId = post?.id else {return}
        
        let values = ["text": commentTextField.text ?? "","creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Failed to insert comment: ", error)
                return
            }
            
            print("Successfully insterted comment.")
        }
    }
    
    fileprivate func fetchComment() {
        
        guard let postId = self.post?.id else {return}
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            guard let uid = dictionary["uid"] as? String else {return}
            
            
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                
                let comment = Comment(user: user, dictionary: dictionary)
                
                self.comments.append(comment)
                
                self.collectionView.reloadData()
            })
            
        }) { (error) in
                print("Failed to fetch post's comments ", error)
        }
        
        
    }
    
    
    
    //TODO: UICollectionViewCell Datasource and Delegates methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        
        cell.comment = self.comments[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
