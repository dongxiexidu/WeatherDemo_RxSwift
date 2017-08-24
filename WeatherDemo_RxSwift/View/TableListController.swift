//
//  TableListController.swift
//  WeatherDemo_RxSwift
//
//  Created by fashion on 2017/8/23.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


// 遵守代理协议,实现代理方法
class TableListController: UIViewController,DataEnteredDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    let items = Variable([
        "Mike",
        "Apples",
        "Ham",
        "Eggs"
        ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "代理用法示例"
        
        let editButton = UIButton.init(type: .custom)
        editButton.setTitle("+", for: .normal)
        editButton.setTitleColor(UIColor.blue, for: .normal)
        editButton.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: editButton)
        
        editButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let sb = UIStoryboard.init(name: "AddItemController", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "AddItemController") as! AddItemController
                // 设置代理
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }).addDisposableTo(disposeBag)

        items.asObservable().bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self),curriedArgument: {
            (row,element,cell) in
            cell.textLabel?.text = element
        }).addDisposableTo(disposeBag)
    }
    
    // 实现代理方法
    func userDidEnterInformation(info: String) {
        items.value.append(info)
    }

    deinit {
        print("\(self) 释放")
    }
}
