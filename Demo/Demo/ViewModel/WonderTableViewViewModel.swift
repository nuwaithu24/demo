//

//  Demo
//
//  Created by COMQUAS on 2/6/20.
//  Copyright © 2020 COMQUAS. All rights reserved.
//


import RxSwift
import RxCocoa

enum WonderTableViewCellType {
    case normal(cellViewModel: WonderCellViewModel)
    case error(message: String)
    case empty
}

class WonderTableViewViewModel {
    var wonderCells: Observable<[WonderTableViewCellType]> {
        return cells.asObservable()
    }
    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }

    let onShowError = PublishSubject<SingleButtonAlert>()
    let appServerClient: AppServerClient
    let disposeBag = DisposeBag()

    private let loadInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay<[WonderTableViewCellType]>(value: [])

    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }

    func getWonders() {
        loadInProgress.accept(true)

        appServerClient
            .getWonders()
            .subscribe(
                onNext: { [weak self] wonder in
                    self?.loadInProgress.accept(false)
                    guard wonder.wonders!.count > 0 else {
                        self?.cells.accept([.empty])
                        return
                    }
                   
                    self?.cells.accept(wonder.wonders!.compactMap { .normal(cellViewModel: WonderCellViewModel(wonder: $0 )) })
                },
                onError: { [weak self] error in
                    self?.loadInProgress.accept(false)
                    self?.cells.accept([
                        .error(
                            message: (error as? AppServerClient.GetFailureReason)?.getErrorMessage() ?? "Loading failed, check network connection"
                        )
                    ])
                }
            )
            .disposed(by: disposeBag)
    }

   
}


fileprivate extension AppServerClient.GetFailureReason {
    func getErrorMessage() -> String? {
        switch self {
        case .notFound:
            return "Could not complete request, please try again."
        }
    }
}


