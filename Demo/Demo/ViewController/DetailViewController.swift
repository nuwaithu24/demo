//
//  DetailViewController.swift
//  Demo
//
//  Created by COMQUAS on 2/6/20.
//  Copyright © 2020 COMQUAS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameLB: UILabel!
    
    @IBOutlet weak var desLB: UILabel!
    
    var viewModel: WonderViewModel?
       var updateWonders = PublishSubject<Void>()

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    

    func bindViewModel() {
           guard let viewModel = viewModel else {
               return
           }

           title = viewModel.title.value

        bind(text: nameLB, to: viewModel.location)
        
        bind(text: desLB, to: viewModel.description)
        
        self.image.kf.setImage(with: URL(string: viewModel.image.value))

          
           viewModel
               .onShowLoadingHud
               .map { [weak self] in self?.setLoadingHud(visible: $0) }
               .subscribe()
               .disposed(by: disposeBag)

           viewModel
               .onNavigateBack
               .subscribe(
                   onNext: { [weak self] in
                       self?.updateWonders.onNext(())
                       let _ = self?.navigationController?.popViewController(animated: true)
                   }
               ).disposed(by: disposeBag)

           viewModel
               .onShowError
               .map { [weak self] in self?.presentSingleButtonDialog(alert: $0)}
               .subscribe()
               .disposed(by: disposeBag)
       }
    
    private func bind(text: UILabel, to behaviorRelay: BehaviorRelay<String>) {
           behaviorRelay.asObservable()
               .bind(to: text.rx.text)
               .disposed(by: disposeBag)
       }
    
   
    
    
    
   

    private func setLoadingHud(visible: Bool) {
           PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
           visible ? PKHUD.sharedHUD.show(onView: view) : PKHUD.sharedHUD.hide()
       }
}

extension DetailViewController: SingleButtonDialogPresenter { }
