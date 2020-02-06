//
//  DetailViewModel.swift
//  Demo
//
//  Created by COMQUAS on 2/6/20.
//  Copyright © 2020 COMQUAS. All rights reserved.
//

import RxSwift
import RxCocoa


protocol WonderViewModel {
    var title: BehaviorRelay<String> { get }
    var location: BehaviorRelay<String> { get }
    var description: BehaviorRelay<String> { get }
    var image: BehaviorRelay<String> { get }
      var lat: BehaviorRelay<String> { get }
      var long: BehaviorRelay<String> { get }
   
    var onShowLoadingHud: Observable<Bool> { get }
   
    var onNavigateBack: PublishSubject<Void>  { get }
    var onShowError: PublishSubject<SingleButtonAlert>  { get }
}

final class UpdateWonderViewModel: WonderViewModel {
    let onShowError = PublishSubject<SingleButtonAlert>()
    let onNavigateBack = PublishSubject<Void>()
   
    let disposeBag = DisposeBag()

    var title = BehaviorRelay<String>(value: "Detail")
    var location = BehaviorRelay<String>(value: "")
     var description = BehaviorRelay<String>(value: "")
     var image = BehaviorRelay<String>(value: "")
     var lat = BehaviorRelay<String>(value: "")
     var long = BehaviorRelay<String>(value: "")
    
   
    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }


    private let loadInProgress = BehaviorRelay(value: false)
    private let appServerClient: AppServerClient
   

   

    init(wonderCellViewModel: WonderCellViewModel, appServerClient: AppServerClient = AppServerClient()) {
        self.long.accept(wonderCellViewModel.long!)
        self.location.accept(wonderCellViewModel.location!)
        self.lat.accept(wonderCellViewModel.lat!)
        self.image.accept(wonderCellViewModel.image!)
        self.description.accept(wonderCellViewModel.description!)
        self.appServerClient = appServerClient

    }

   
}


