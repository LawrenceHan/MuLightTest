//
//  PhotoTableViewController.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/1.
//  Copyright © 2019 hanguang. All rights reserved.
//

import UIKit
import CoreData

final class PhotoTableViewController: UITableViewController, MuLightContext {
    
    static func storyboardInstance() -> PhotoTableViewController {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "PhotoTableViewController") as? PhotoTableViewController else {
            fatalError()
        }
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: Private
    
    fileprivate var dataSource: TableViewDataSource<PhotoTableViewController>!
//    fileprivate var observer: ManagedObjectObserver?
    
    fileprivate func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")
        let request = Image.sortedFetchRequest
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: muLightContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: "PhotoCell", fetchedResultsController: controller, delegate: self)
    }
}

extension PhotoTableViewController: TableViewDataSourceDelegate {
    func configure(_ cell: PhotoCell, for object: Image) {
        cell.configure(for: object)
    }
}
