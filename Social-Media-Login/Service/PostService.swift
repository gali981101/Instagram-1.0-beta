//
//  PostService.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/21.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

final class PostService {
    
    // MARK: - Properties
    
    static let shared: PostService = PostService()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Firebase Database Ref
    
    let BASE_DB_REF: DatabaseReference = Database.database().reference()
    let POST_DB_REF: DatabaseReference = Database.database().reference().child("posts")
    
    // MARK: - Firebase Storage Ref
    
    let PHOTO_STORAGE_REF: StorageReference = Storage.storage().reference().child("photos")
    
}

// MARK: - Upload

extension PostService {
    
    func uploadImage(image: UIImage, completionHandler: @escaping () -> Void) {
        
        // 產生一個貼文的唯一ID 並準備貼文 Database 的參照
        let postDatabaseRef = POST_DB_REF.childByAutoId()
        
        // 使用唯一個 key 作為圖片名稱
        guard let imageKey = postDatabaseRef.key else { return }
        
        // 準備 Storage 參照
        let imageStorageRef = PHOTO_STORAGE_REF.child("\(imageKey).jpg")
        
        // 調整圖片大小
        let scaledImage = image.scale(newWidth: 640.0)
        
        guard let imageData = scaledImage.jpegData(compressionQuality: 0.9) else { return }
        
        // 建立檔案元資料
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // 準備上傳任務
        let uploadTask = imageStorageRef.putData(imageData, metadata: metadata) { metadata, error in
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            imageStorageRef.downloadURL { url, error in
                guard let displayName = Auth.auth().currentUser?.displayName else { return }
                guard let url = url else { return }
                
                // 在資料庫中加上一個參照
                let imageFileURL = url.absoluteString
                let timestamp = Int(Date().timeIntervalSince1970 * 1000)
                
                let post: [String: Any] = [
                    Post.PostInfoKey.imageFileURL: imageFileURL,
                    Post.PostInfoKey.likes: Int(0),
                    Post.PostInfoKey.user: displayName,
                    Post.PostInfoKey.timestamp: timestamp
                ]
                
                postDatabaseRef.setValue(post)
            }
            
            completionHandler()
        }
        
        let _ = uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("上傳 \(imageKey).jpg... \(percentComplete)% 完成")
        }
        
    }
    
}

// MARK: - Get Recent Posts

extension PostService {
    
    func getRecentPosts(start timestamp: Int? = nil, limit: UInt, completionHandler: @escaping ([Post]) -> Void) {
        
        var postQuery = POST_DB_REF.queryOrdered(byChild: Post.PostInfoKey.timestamp)
        
        if let latestPostTimestamp = timestamp, latestPostTimestamp > 0 {
            // 如果有指定時戳，將會以比給定值來的新的時戳來取得貼文
            postQuery = postQuery
                .queryStarting(atValue: latestPostTimestamp + 1, childKey: Post.PostInfoKey.timestamp)
                .queryLimited(toLast: limit)
        } else {
            // 否則的話，將會取得最近的貼文
            postQuery = postQuery.queryLimited(toLast: limit)
        }
        
        loadRecentPostData(postQuery: postQuery, completionHandler: completionHandler)
    }
    
}

// MARK: - Get Old Posts

extension PostService {
    
    func getOldPosts(start timestamp: Int, limit: UInt, completionHandler: @escaping ( [Post]) -> Void) {
        
        let postOrderedQuery = POST_DB_REF.queryOrdered(byChild: Post.PostInfoKey.timestamp)
        let postLimitedQuery = postOrderedQuery.queryEnding(atValue: timestamp - 1, childKey: Post.PostInfoKey.timestamp)
        
        postLimitedQuery.observeSingleEvent(of: .value) { snapshot in
            var oldPosts: [Post] = []
            
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let postInfo = item.value as? [String: Any] ?? [:]
                
                if let post = Post(postID: item.key, postInfo: postInfo) {
                    oldPosts.append(post)
                }
            }
            
            oldPosts.sort(by: { $0.timestamp > $1.timestamp })
            
            completionHandler(oldPosts)
        }
    }
    
}

// MARK: - Helper Methods

extension PostService {
    
    private func loadRecentPostData(postQuery: DatabaseQuery, completionHandler: @escaping ([Post]) -> Void) {
        
        // 呼叫 Firebase API 來取得最新的資料記錄
        postQuery.observeSingleEvent(of: .value) { snapshot in
            var newPosts: [Post] = []
            
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let postInfo = item.value as? [String: Any] ?? [:]
                guard let post = Post(postID: item.key, postInfo: postInfo) else { fatalError() }
                
                newPosts.append(post)
            }
            
            if newPosts.count > 0 {
                // 以降冪排序 (也就是第一則貼文為最新貼文)
                newPosts.sort(by: { $0.timestamp > $1.timestamp })
            }
            
            completionHandler(newPosts)
        }
        
    }
    
}
