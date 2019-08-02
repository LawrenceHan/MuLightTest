//
//  Image.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/1.
//  Copyright © 2019 hanguang. All rights reserved.
//

import UIKit
import CoreData

final class Image: NSManagedObject {
    @NSManaged private(set) var id: String
    @NSManaged private(set) var date: Date
    @NSManaged private(set) var caption: String
    @NSManaged private(set) var thumbnail: Data
    
    static func insert(into context: NSManagedObjectContext,
                       caption: String,
                       date: Date = Date(),
                       photo: UIImage) -> Image {
        let image: Image = context.insertObject()
        image.id = UUID().uuidString
        image.date = date
        image.caption = caption
        image.thumbnail = ImageStore.thumbnail(for: photo)
        
        return image
    }
}

extension Image: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: false)]
    }
}
