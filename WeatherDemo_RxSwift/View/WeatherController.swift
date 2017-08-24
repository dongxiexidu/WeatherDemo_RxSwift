//
//  WeatherController.swift
//  WeatherDemo_RxSwift
//
//  Created by fashion on 2017/8/22.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherController: UIViewController {

 // MARK: Vars
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var realFeelLabel: UILabel!
    @IBOutlet private weak var precipitationLabel: UILabel!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    @IBOutlet private weak var refreshButton: UIButton!
    
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var tableButton: UIButton!
    @IBOutlet weak var delegateButton: UIButton!
    @IBOutlet weak var RxDataButton: UIButton!
    @IBOutlet weak var contactsButton: UIButton!
    @IBOutlet weak var datePickerButton: UIButton!
    
    fileprivate let weatherDataService : WeatherDataService!
    fileprivate var viewModel : WeatherViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    // 3.xib自定义init方法初始类
    init(weatherDataService: WeatherDataService) {
        self.weatherDataService = weatherDataService
        super.init(nibName: "WeatherController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        configureBindings()
    }
    
    fileprivate func configureViewModel() {
        let refreshDriver = self.refreshButton.rx.tap.asDriver()
        self.viewModel = WeatherViewModel(weatherDataService : self.weatherDataService,refreshDriver : refreshDriver)
    }

    fileprivate func configureBindings() {
        
        // 建议使用addDisposableTo
        self.viewModel.locationName.drive(self.locationLabel.rx.text).disposed(by: disposeBag)
        self.viewModel.temperature.drive(self.temperatureLabel.rx.text).disposed(by: disposeBag)
        self.viewModel.realFeel.drive(self.realFeelLabel.rx.text).disposed(by: disposeBag)
        self.viewModel.precipitation.drive(self.precipitationLabel.rx.text).disposed(by: disposeBag)
        self.viewModel.updatedAt.drive(self.updatedAtLabel.rx.text).disposed(by: disposeBag)
        self.viewModel.isLoading.map{ !$0 }.drive(self.loadingView.rx.isHidden).disposed(by: disposeBag)
        self.viewModel.isLoading.map{ !$0 }.drive(self.refreshButton.rx.isEnabled).disposed(by: disposeBag)
        self.viewModel.hasFailed.map{ !$0 }.drive(self.errorView.rx.isHidden).disposed(by: disposeBag)
        
        // 注意格式
        self.tapButton.rx.tap.subscribe({ [unowned self] _ in
            let tapVC = TapCountController.init(nibName: "TapCountController", bundle: nil)
            self.navigationController?.pushViewController(tapVC, animated: true)
        }).addDisposableTo(disposeBag)
        
        self.tableButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let sb = UIStoryboard(name: "EaseTableController", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "EaseTableController")
                self.navigationController?.pushViewController(vc, animated: true)
            }).addDisposableTo(disposeBag)
        
        self.delegateButton.rx.tap
            .subscribe(onNext: {
                let sb = UIStoryboard(name: "TableListController", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "TableListController")
                self.navigationController?.pushViewController(vc, animated: true)
            }).addDisposableTo(disposeBag)
        
        self.RxDataButton.rx.tap
            .subscribe(onNext:{
                let sb = UIStoryboard.init(name: "RxDataSourcesTableController", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "RxDataSourcesTableController")
                self.navigationController?.pushViewController(vc, animated: true)
            }).addDisposableTo(disposeBag)
        
        self.contactsButton.rx.tap
            .subscribe(onNext:{
                let sb = UIStoryboard(name: "ContactsController",bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ContactsController")
                self.navigationController?.pushViewController(vc, animated: true)
            }).addDisposableTo(disposeBag)
        
        self.datePickerButton.rx.tap
            .subscribe(onNext: {
                let sb = UIStoryboard(name: "DatePickerController",bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "DatePickerController")
                self.navigationController?.pushViewController(vc, animated: true)
            }).addDisposableTo(disposeBag)
        
    }

}
