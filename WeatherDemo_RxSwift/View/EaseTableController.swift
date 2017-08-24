//
//  EaseTableController.swift
//  WeatherDemo_RxSwift
//
//  Created by fashion on 2017/8/22.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EaseTableController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate let disposeBag = DisposeBag()
    fileprivate let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let items = Variable(["Mike",
                              "Apples",
                              "Ham",
                              "Eggs"])
        let items2 = [
            "Fish",
            "Carrots",
            "Mike",
            "Apples",
            "Ham",
            "Eggs",
            "Bread",
            "Chiken",
            "Water"
        ]
        
        let editButton = UIButton.init(type: .custom)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(UIColor.red, for: .normal)
        editButton.sizeToFit()
       // editButton.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
       // let editButton = UIBarButtonItem.init(title: "编辑", style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: editButton)
        
        // 是否允许拖动编辑
        editButton.rx.tap
        .subscribe(onNext: { [unowned self] _ in
            let isEditing:Bool = !(self.tableView?.isEditing)!
            let title = isEditing ? "Done" : "Edit"
            editButton.setTitle(title, for: .normal)
            editButton.sizeToFit()
            self.tableView?.isEditing = isEditing
        }).addDisposableTo(disposeBag)

        
        // Variable是BehaviorSubject一个包装箱，就像是一个箱子一样，使用的时候需要调用asObservable()拆箱，里面的value是一个BehaviorSubject，他不会发出error事件，但是会自动发出completed事件。
        items.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell",cellType:UITableViewCell.self),curriedArgument: { (row, element, cell) in
                cell.textLabel?.text = element
            }).addDisposableTo(disposeBag)
        
        // 原生的refresh rx.controlEvent(.valueChanged)
        refreshControl.rx.controlEvent(.valueChanged)
        .subscribe(onNext: { [unowned self] _ in
            items.value = items2
            self.refreshControl.endRefreshing()
        }).addDisposableTo(disposeBag)
        
        tableView.addSubview(refreshControl)
        
        
        tableView.rx.itemDeleted
            .subscribe (onNext: {  indexPath in
            items.value.remove(at: indexPath.row)
        }).addDisposableTo(disposeBag)
        
        tableView.rx.itemMoved
        .subscribe(onNext: { sourceIndex, destinationIndex in
            let element = items.value.remove(at: sourceIndex.row)
            items.value.insert(element, at: destinationIndex.row)
        }).addDisposableTo(disposeBag)
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
    deinit {
        print("\(self) 释放")
    }


}
