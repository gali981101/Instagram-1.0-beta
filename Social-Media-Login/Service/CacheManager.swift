//
//  CacheManager.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/22.
//

import Foundation

enum CacheConfiguration {
    static let maxObjects = 100
    static let maxSize = 1024 * 1024 * 50
}

// MARK: - CacheManager

final class CacheManager {
    
    static let shared: CacheManager = CacheManager()
    
    private static var cache: NSCache<NSString, AnyObject> = {
        let cache = NSCache<NSString, AnyObject>()
        
        cache.countLimit = CacheConfiguration.maxObjects
        cache.totalCostLimit = CacheConfiguration.maxSize
        
        return cache
    }()
    
    private init() {}
    
}

// MARK: - Cache Methods

extension CacheManager {
    
    func cache(object: AnyObject, key: String) {
        CacheManager.cache.setObject(object, forKey: key as NSString)
    }
    
    func getFromCache(key: String) -> AnyObject? {
        return CacheManager.cache.object(forKey: key as NSString)
    }
    
}
