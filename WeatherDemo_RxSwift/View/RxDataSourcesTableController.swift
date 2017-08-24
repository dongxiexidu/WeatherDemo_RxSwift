//
//  RxDataSourcesTableController.swift
//  WeatherDemo_RxSwift
//
//  Created by fashion on 2017/8/23.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RxDataSourcesTableController: UIViewController,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    // 数据流 just用法
    let items = Observable.just([
        SectionModel(model: "B",items:[
            "Barbara Cole",
            "Barbara Cooper",
            "Barbara Diaz",
            "Barbara Edwards",
            "Barbara Garcia",
            "Barbara Gray",
            "Barbara Griffin",
            "Barbara Hill",
            "Barbara Howard",
            "Barbara Hughes"
            ]),
        SectionModel(model:"C",items:[
            "Carol Lopez", "Carol Lopez"
            ]),
        SectionModel(model: "E", items: [
            "Elizabeth Jenkins", "Elizabeth Kelly"
            ]),
        SectionModel(model: "H", items: ["Helen Anderson", "Helen Bailey", "Helen Cole", "Helen Cox"]),
        SectionModel(model: "J", items: ["James Anderson", "James Barnes", "James Bell"]),
        SectionModel(model: "K", items: ["Karen Green", "Karen Jenkins", "Karen Jones", "Karen Jordan"]),
        SectionModel(model: "L", items: ["Linda Taylor", "Linda Taylor", "Linda Torres", "Linda West", "Lisa Brooks"]),
        SectionModel(model: "M", items: ["Margaret Bell", "Margaret Coleman", "Margaret Cox", "Margaret Foster"]),
        SectionModel(model: "R", items: ["Robert Clark", "Robert Coleman", "Robert Cook", "Robert Cook"]),
        SectionModel(model: "S", items: ["Susan Fisher", "Susan Ford", "Susan Ford", "Susan Hernandez", "Susan Howard"]),
        ])
    
    // 固定写法
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,String>>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RxDataSources用法"
        
        // 其实dataSource并没有变化,只是对cell的配置做处理
        setupDataSource()
        
        // 数据绑定到dataSource
        items.bind(to: tableView.rx.items(dataSource: dataSource))
        .addDisposableTo(disposeBag)
        
       _ = tableView.rx.setDelegate(self)
        
    }
    
    fileprivate func setupDataSource() {
        
        // 参数必须4个,_占位用
        dataSource.configureCell =  { (_,tableView,IndexPath,element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = element
            return cell
        }
        
        // 监听右侧边缘小字母点击事件
        dataSource.sectionForSectionIndexTitle = { (dataSource,title,index) -> Int in
            print("\(index)")
            return index
        }
        
        dataSource.sectionIndexTitles = { data -> [String]? in
            return data.sectionModels.map{ $0.model }
        }
    }
    

}

extension RxDataSourcesTableController{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header")!
        cell.textLabel?.text = dataSource[section].model
        return cell
    }
}
