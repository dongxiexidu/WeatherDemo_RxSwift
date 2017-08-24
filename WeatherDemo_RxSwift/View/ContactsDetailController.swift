//
//  ContactsDetailController.swift
//  WeatherDemo_RxSwift
//
//  Created by fashion on 2017/8/23.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import UIKit

class ContactsDetailController: UIViewController {

    // 此处命名不规范,属性后应加Label
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var note: UILabel!
    
    var _name : String = ""
    var _avatar: String = ""
    var _mobile: String = ""
    var _email: String = ""
    var _note: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "联系人详情"
        name.text = _name
        avatar.image = UIImage(named: _avatar)
        avatar.layer.cornerRadius = avatar.frame.height / 2
        avatar.layer.masksToBounds = true
        mobile.text = _mobile
        email.text = _email
        note.text = _note
        
        note.lineBreakMode = .byWordWrapping
        note.numberOfLines = 0
    }

    deinit {
        print("\(self) 释放")
    }


}
