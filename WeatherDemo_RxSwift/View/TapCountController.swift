//
//  TapCountController.swift
//  WeatherDemo_RxSwift
//
//  Created by fashion on 2017/8/22.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TapCountController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBindings()
    }

    // subscribe 硬敲出来的
    fileprivate func configureBindings() {
        
        // 2.订阅手势
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.rx.event
            .subscribe(onNext: { [unowned self] _ in
            
                let numStr : String = self.numberLabel.text!
                let number = Int(numStr)
                self.numberLabel.text = String(number! + 1)
                
            }).addDisposableTo(disposeBag)
        self.tapButton.addGestureRecognizer(longPressGesture)
        
        // 1.订阅点击事件
        tapButton.rx.tap
            .subscribe({ [unowned self] _ in
                let numStr : String = self.numberLabel.text!
                let number = Int(numStr)
                self.numberLabel.text = String(number! + 1)
            
            }).addDisposableTo(disposeBag)
        
        resetButton.rx.tap
            .subscribe({ [unowned self] _ in
                self.numberLabel.text = "0"
            }).addDisposableTo(disposeBag)
        
        /* onNext 只监听sequence发出的next事件中的element进行处理,他会忽略error和completed事件
        resetButton.rx.tap
            .subscribe(onNext:{ [unowned self] _ in
                self.numberLabel.text = "0"
            }).addDisposableTo(disposeBag)
        */
        
        // 3.循环引用,无法释放控制器
//        resetButton.rx.tap.subscribe({ _ in
//            self.numberLabel.text = "0"
//        }).addDisposableTo(disposeBag)
        
    }
    deinit {
        print("\(self) 释放")
    }


}
