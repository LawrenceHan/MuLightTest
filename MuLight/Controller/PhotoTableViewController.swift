//
//  PhotoTableViewController.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/1.
//  Copyright © 2019 hanguang. All rights reserved.
//

import UIKit
import CoreData

final class PhotoTableViewController: UITableViewController, MuLightContext, StoryboardInitializable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: Private
    
    private var dataSource: TableViewDataSource<PhotoTableViewController>!
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        let request = Image.sortedFetchRequest
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: muLightContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: "PhotoCell", fetchedResultsController: controller, delegate: self)
    }
}

// MARK: - TableViewDataSourceDelegate

extension PhotoTableViewController: TableViewDataSourceDelegate {
    func configure(_ cell: PhotoCell, for object: Image) {
        cell.configure(for: object)
    }
}

// MARK: - TableView Delegate

extension PhotoTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)

        }
        guard let detail = PhotoDetailViewController.storyboardInstance() else { return }
        let image = dataSource.objectAtIndexPath(indexPath)
        detail.image = image
        navigationController?.pushViewController(detail, animated: true)
    }
}
