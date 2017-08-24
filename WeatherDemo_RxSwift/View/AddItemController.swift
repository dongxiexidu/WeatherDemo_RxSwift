//
//  AddItemController.swift
//  WeatherDemo_RxSwift
//
//  Created by fashion on 2017/8/23.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import UIKit

/*
 
 需要把protocol 限制在 class 内,
 这是因为 Swift 的 protocol 是可以被除了 class 以外的其他类型遵守的，
 而对于像 struct 或是 enum 这样的类型，本身就不通过引用计数来管理内存，所以也不可能用 weak 这样的 ARC 的概念来进行修饰
 
 */

// 代理声明 必须要继承 class 否则报错
protocol DataEnteredDelegate: class {
    func userDidEnterInformation( info: String )
}

class AddItemController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!

    weak var delegate : DataEnteredDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }

    @IBAction func textOnExit(_ sender: Any) {
        delegate?.userDidEnterInformation(info: textField.text!)
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("\(self) 释放")
    }

}
