//
//  DetailViewModel.swift
//  Demo
//
//  Created by COMQUAS on 2/6/20.
//  Copyright © 2020 COMQUAS. All rights reserved.
//

import Moya
import RxSwift

// MARK: - AppServerClient
class AppServerClient {
    
    enum GetFailureReason: Int, Error {
     
        case notFound = 404
    }

    func getWonders() -> Observable<WonderModel> {
        return Observable.create { observer -> Disposable in
             let provider = MoyaProvider<WonderApi>()
                                 provider.request(.bins) { result in
                                     // do something with the result (read on for more details)
                                     switch result {
                                        
                                     case let .success(response):
                                        // let data = response.data
                                        // let statusCode = response.statusCode
                                        let data = response.data
                                       
                                      do {
                                        let jsonResponse = try JSONSerialization.jsonObject(with:
                                                               data, options: [])
                                        print(jsonResponse) //Response result
                                        
                                          let wonders = try JSONDecoder().decode(WonderModel.self, from: data)
                                         Shared.instance.saveData(data: wonders)
                                                  observer.onNext(wonders)
                                              } catch {
                                                  observer.onError(error)
                                          }
                                     
                                     case let .failure(error):
                                        
                                        if let wonders = Shared.instance.getData() {
                                           
                                                            observer.onNext(wonders)
                                                        
                                            
                                        }
                                        else {
                                            observer.onError(error)
                                        }
                                        
                                    
                                     }
                                 }
            return Disposables.create()
        }
    }

  

}
