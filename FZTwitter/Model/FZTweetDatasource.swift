//
//  FZTweetDatasource.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/22/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation

class FZTweetDatasource {
    
    // MARK: Attributes
    
    // Object of this class that allows other objects to access the functions of this class
    static let shared = FZTweetDatasource()
    
    // Custom Queue to perform thread safe operations
    private let concurrentQueue: DispatchQueue = {
        return DispatchQueue(
            label: "com.leodmgs.FZTwitter.FZTweetDatasource",
            attributes: .concurrent)
    }()
    
    // This object hasn't any protection against thread safe. 'datasource' object must be used to have access to the datasouce instead.
    private var unsafeDatasource = Array<FZTweet>()
    
    // Provide a thread safe object with the datasouce.
    var datasource: Array<FZTweet>? {
        var datasourceCopy = Array<FZTweet>()
        concurrentQueue.sync {
            datasourceCopy.append(contentsOf: unsafeDatasource)
        }
        return datasourceCopy
    }
    
    // Private initializer to create only the object of this class in shared property. This is the singleton pattern.
    private init() {
        unsafeDatasource.append(FZTweet(name: "John", text: "Twitter's John", profile_image: nil))
        unsafeDatasource.append(FZTweet(name: "Sara", text: "Twitter's Sara", profile_image: nil))
        unsafeDatasource.append(FZTweet(name: "Mike", text: "Twitter's Mike", profile_image: nil))
    }
    
    
    // MARK: Attributes
    
    // TODO: if the datasource was updated, an event needs to be performed
    // to the controller to update the view as well.
    
    func add(dataCollection: Array<FZTweet>) {
        concurrentQueue.sync {
            unsafeDatasource.removeAll()
            unsafeDatasource.append(contentsOf: dataCollection)
        }
    }
    
    func append(dataElement: FZTweet) {
        concurrentQueue.sync {
            unsafeDatasource.append(dataElement)
        }
    }
    
    func dropDatasource() {
        concurrentQueue.sync {
            unsafeDatasource.removeAll()
        }
    }
    
    func index(at: Int) -> FZTweet? {
        if at > unsafeDatasource.count-1 || at < 0 {
            return nil
        }
        var imageMetadata: FZTweet?
        concurrentQueue.sync {
            imageMetadata = unsafeDatasource[at]
        }
        if let img = imageMetadata {
            return img
        }
        return nil
    }
    
    
}
