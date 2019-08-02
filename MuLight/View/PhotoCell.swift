//
//  PhotoCell.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/2.
//  Copyright © 2019 hanguang. All rights reserved.
//

import UIKit

final class PhotoCell: UITableViewCell {}

// TODO: change to use image store
extension PhotoCell {
    func configure(for image: Image) {
        // this can be easily refactored to SDWebImage or something else
        imageView?.image = ImageStore.imageForKey(key: image.id)
        textLabel?.text = image.caption
        detailTextLabel?.text = dateFormatter.string(from: image.date)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.doesRelativeDateFormatting = true
    formatter.formattingContext = .standalone
    return formatter
}()
