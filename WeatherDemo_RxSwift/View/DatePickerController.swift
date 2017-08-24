//
//  DatePickerController.swift
//  WeatherDemo_RxSwift
//
//  Created by fashion on 2017/8/23.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DatePickerController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    fileprivate let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        
        // MMM 是英文月比如Oct  MM 会显示数字,比如10
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        // 不用subscribe ? 还可以用bind ??? 
        button.rx.tap
            .bind { [unowned self] in
                let selectedDate = dateFormatter.string(from: self.datePicker.date)
                self.title = selectedDate
        }.addDisposableTo(disposeBag)
    }


    deinit {
        print("\(self) 释放")
    }

}
