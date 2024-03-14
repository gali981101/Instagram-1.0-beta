//
//  Post.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/21.
//

import Foundation

struct Post {
    
    // MARK: - Properties
    
    var postID: String
    var imageFileURL: String
    var user: String
    var likes: Int
    var timestamp: Int
    
    // MARK: - Firebase Info Keys
    
    enum PostInfoKey {
        static let imageFileURL = "imageFileURL"
        static let user = "user"
        static let likes = "likes"
        static let timestamp = "timestamp"
    }
    
    // MARK: - Inits
    
    init(postID: String, imageFileURL: String, user: String, likes: Int, timestamp: Int = Int(Date().timeIntervalSince1970 * 1000)) {
        self.postID = postID
        self.imageFileURL = imageFileURL
        self.user = user
        self.likes = likes
        self.timestamp = timestamp
    }
    
    init?(postID: String, postInfo: [String: Any]) {
        guard let imageFileURL = postInfo[PostInfoKey.imageFileURL] as? String,
        let user = postInfo[PostInfoKey.user] as? String,
        let likes = postInfo[PostInfoKey.likes] as? Int,
        let timestamp = postInfo[PostInfoKey.timestamp] as? Int else {
            return nil
        }
        
        self = Post(postID: postID, imageFileURL: imageFileURL, user: user, likes: likes, timestamp: timestamp)
    }
    
}

