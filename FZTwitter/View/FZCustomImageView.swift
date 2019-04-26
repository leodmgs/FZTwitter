//
//  FZCustomImageView.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/25/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class FZCustomImageView: UIImageView {
    
    private var imageUrl: URL?
    private let imageCache = NSCache<NSString, UIImage>()
    
    func fetchImage(_ url: URL) {
        imageUrl = url
        if let imageCached =
            imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                self.image = imageCached
            }
            return
        }
        
        self.image = nil
        
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let httpResp = response as? HTTPURLResponse,
                (200...299).contains(httpResp.statusCode) else {
                    print(response.debugDescription)
                    return
            }
            if let mimeType = httpResp.mimeType,
                ["image/jpg", "image/jpeg", "image/png", "image/gif"].contains(mimeType),
                let data = data {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    if let imageToCache = imageToCache {
                        self.imageCache.setObject(
                            imageToCache,
                            forKey: url.absoluteString as NSString)
                    }
                    if self.imageUrl == url {
                        self.image = imageToCache
                    }
                }
            }
        }
        task.resume()
    }
    
}
