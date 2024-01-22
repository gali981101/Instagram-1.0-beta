//
//  PostCell.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/19.
//

import UIKit

class PostCell: UITableViewCell {
    
    private var currentPost: Post?
    
    // MARK: - @IBOulet
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var likeButton: UIButton! {
        didSet {
            likeButton.tintColor = .white
        }
    }
    
    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
            avatarImageView.clipsToBounds = true
        }
    }
    
}

// MARK: - Override Methods

extension PostCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

// MARK: - Setting Methods

extension PostCell {
    
    func configure(post: Post) {
        selectionStyle = .none
        
        currentPost = post
        
        nameLabel.text = post.user
        
        likeButton.setTitle("\(post.likes)", for: .normal)
        likeButton.tintColor = .white
        
        downloadImage(post)
    }
    
    private func downloadImage(_ post: Post) {
        // 重設圖片視圖的圖片
        photoImageView.image = nil
        
        // 下載貼文圖片
        if let image = CacheManager.shared.getFromCache(key: post.imageFileURL) as? UIImage {
            photoImageView.image = image
        } else {
            guard let url = URL(string: post.imageFileURL) else { fatalError() }
            
            let downloadTask = URLSession.shared.dataTask(with: url) { data, res, error in
                guard let imageData = data else { return }
                
                OperationQueue.main.addOperation {
                    guard let image = UIImage(data: imageData) else { return }
                    
                    if self.currentPost?.imageFileURL == post.imageFileURL {
                        self.photoImageView.image = image
                    }
                    
                    // 加入下載圖片至快取
                    CacheManager.shared.cache(object: image, key: post.imageFileURL)
                }
            }
            
            downloadTask.resume()
        }
    }
    
}
