//
//  PhotoCell.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/2.
//  Copyright © 2019 hanguang. All rights reserved.
//

import UIKit

final class PhotoCell: UITableViewCell {}

extension PhotoCell {
    func configure(for image: Image) {
        imageView?.image = UIImage(data: image.thumbnail)
        textLabel?.text = image.caption
        let text = dateFormatter.string(from: image.date)
        detailTextLabel?.text = text
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
