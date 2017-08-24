//
//  ContactsController.swift
//  WeatherDemo_RxSwift
//
//  Created by fashion on 2017/8/23.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

/*
 
 
 
 RxDataSources 使用
 1. 创建dataSources 
 2. dataSources配置cell
 3. viewModel创建出数据Observable,发出序列,绑定到dataSource上
 
 */


class ContactsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,[String: String]>>()
    let sectionOne =
        SectionModel(model: "RECENT", items: [
            [
                "name":"Mrs. Carolyn Tillman",
                "avatar":"avatar13",
                "mobile":"1-764-949-9148",
                "email":"ardella.mueller@hotmail.com",
                "notes":"Quod pickled vel post-ironic et. Sit consequatur consectetur quod. Et salvia small batch exercitationem."
            ],
            [
                "name":"Geovanni Will",
                "avatar":"avatar14",
                "mobile":"905-253-0435", "email":"antonina@hotmail.com",
                "notes":"Et gentrify enim art party dolorum sint sunt wes anderson. Et cray literally id totam."
            ],
            [
                "name":"Edythe Stoltenberg",
                "avatar":"avatar15",
                "mobile":"696-408-8248",
                "email":"viviane_lockman@gmail.com",
                "notes":"Farm-to-table ea non nesciunt chambray quia. Bitters voluptatem paleo sed."
            ]
        ])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "联系人列表"

        let dictArray = loadDictArray(fileName: "dict") as! [[String : String]]
        let items = Observable.just([sectionOne,SectionModel(model: "Friends", items: dictArray)])
        configureDataSources()
        
        items.bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                
                let sb = UIStoryboard(name:"ContactsController", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ContactsDetailController") as! ContactsDetailController
                let item = self.dataSource[indexPath]
                vc._name = item["name"]!
                vc._avatar = item["avatar"]!
                vc._note = item["notes"]!
                vc._email = item["email"]!
                vc._mobile = item["mobile"]!
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }).addDisposableTo(disposeBag)
        _ = tableView.rx.setDelegate(self)
        
    }
    
    fileprivate func configureDataSources () {
        dataSource.configureCell = { (_,tableView,indexPath,element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Content")!
            cell.textLabel?.text = element["name"]
            
            let image = UIImage(named: element["avatar"]!)
            let imageSize = CGSize.init(width: 36, height: 36)
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
            let imageRect = CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            image?.draw(in: imageRect)
            
            cell.imageView?.layer.cornerRadius = 18
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return cell
        }
    }

    
    // 本地json数据解析
    fileprivate func loadDictArray(fileName: String) -> [NSDictionary]? {
    
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                  let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                    return jsonResult
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    
        return nil
    }
    
    deinit {
        print("\(self) 释放")
    }

    

}

extension ContactsController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Header")
        let greenColour = UIColor(red: 139/255, green: 87/255, blue: 42/255, alpha: 1)
        let attributedColour = [NSForegroundColorAttributeName : greenColour];
        let attributedString = NSAttributedString(string: dataSource[section].model, attributes: attributedColour)
        cell!.textLabel?.attributedText = attributedString
        return cell
    }
}
