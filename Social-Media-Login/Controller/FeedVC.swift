//
//  FeedVC.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/19.
//

import UIKit
import YPImagePicker
import Firebase
import FirebaseStorage

class FeedVC: UITableViewController {
    
    var postFeed: [Post] = []
    var arrayIndexPaths: [IndexPath] = []
    
    fileprivate var isLoadingPost: Bool = false
    
}

// MARK: - Life Cycle

extension FeedVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //設置下拉式更新
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.black
        refreshControl?.tintColor = UIColor.white
        refreshControl?.addTarget(self, action: #selector(loadRecentPosts), for: .valueChanged)
        
        // 載入最新的貼文
        loadRecentPosts()
    }
    
}

// MARK: - Camera

extension FeedVC {
    
    @IBAction func openCamera(_ sender: Any) {
        
        var config = YPImagePickerConfiguration()
        
        config.colors.tintColor = .black
        config.wordings.next = "OK"
        config.showsPhotoFilters = false
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            
            guard let photo = items.singlePhoto else {
                picker.dismiss(animated: true)
                return
            }
            
            PostService.shared.uploadImage(image: photo.image) {
                picker.dismiss(animated: true)
                self.loadRecentPosts()
            }
            
        }
        
        present(picker, animated: true)
        
    }
    
}

// MARK: - Download - 處理貼文下載與顯示

extension FeedVC {
    
    @objc fileprivate func loadRecentPosts() {
        // 開始下載貼文
        isLoadingPost = true
        
        PostService.shared.getRecentPosts(start: postFeed.first?.timestamp, limit: 10) { newPosts in
            if !(newPosts.isEmpty) {
                // 加入貼文陣列至陣列的開始處
                self.postFeed.insert(contentsOf: newPosts, at: 0)
            }
            
            self.isLoadingPost = false
            
            if let _ = self.refreshControl?.isRefreshing {
                // 讓動畫效果更佳，在結束更新之前延遲 0.5秒
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.refreshControl?.endRefreshing()
                    self.displayNewPosts(newPosts: newPosts)
                }
            } else {
                self.displayNewPosts(newPosts: newPosts)
            }
        }
    }
    
    private func displayNewPosts(newPosts posts: [Post]) {
        // 確認我們取得新的貼文來顯示
        guard posts.count > 0 else { return }
        
        // 將它們插入表格視圖中來顯示貼文
        var indexPaths: [IndexPath] = []
        
        tableView.beginUpdates()
        
        for num in 0...(posts.count - 1) {
            let indexPath = IndexPath(row: num, section: 0)
            indexPaths.append(indexPath)
        }
        
        tableView.insertRows(at: indexPaths, with: .fade)
        
        tableView.endUpdates()
    }
    
}

// MARK: - UITableViewDataSource

extension FeedVC {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let currentPost = postFeed[indexPath.row]
        
        cell.configure(post: currentPost)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postFeed.count
    }
    
}

// MARK: - UITableViewDelegate

extension FeedVC {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !(arrayIndexPaths.contains(indexPath)) {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 200, 0)
            
            cell.alpha = 0
            cell.layer.transform = rotationTransform
            
            UIView.animate(withDuration: 1.0, animations: {
                cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            })
            
            arrayIndexPaths.append(indexPath)
        }
        
        // 在使用者滑到最後兩列時，觸發加載舊貼文
        guard !isLoadingPost, postFeed.count - indexPath.row == 2 else { return }
        
        guard let lastPostTimestamp = postFeed.last?.timestamp else { return }
        loadOldPosts(timeStamp: lastPostTimestamp)
    }
    
}

// MARK: - Helper Methods

extension FeedVC {
    
    fileprivate func loadOldPosts(timeStamp: Int) {
        
        PostService.shared.getOldPosts(start: timeStamp, limit: 3) {
            // 加上貼文至目前陣列與表格視圖
            var indexPaths: [IndexPath] = []
            
            self.tableView.beginUpdates()
            
            for post in $0 {
                self.postFeed.append(post)
                
                let indexPath = IndexPath(row: self.postFeed.count - 1, section: 0)
                indexPaths.append(indexPath)
            }
            
            self.tableView.insertRows(at: indexPaths, with: .automatic)
            self.tableView.endUpdates()
            
            self.isLoadingPost = false
        }
        
    }
    
}







