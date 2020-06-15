//
//  AlamofireManager.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/06.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RxSwift
import RxAlamofire

class AlamofireManager {
    static let shared: AlamofireManager = AlamofireManager()
    
    func getDataRequest(_ api: API,
                        headers: HTTPHeaders? = nil) -> DataRequest {
        return AF.request(api.url,
                          method: api.method,
                          parameters: api.parameters,
                          encoding: URLEncoding.default,
                          headers: headers)
    }
    
    func requestObject<T: BaseMappable>(_ api: API,
                                        keyPath: String? = nil,
                                        headers: HTTPHeaders? = nil,
                                        onSuccess: @escaping (_ response: T) -> (),
                                        onError: @escaping (_ error: Error) -> ()) {
        self.getDataRequest(api, headers: headers)
            .responseObject(keyPath: keyPath) { (dataResponse: AFDataResponse<T>) in
                switch dataResponse.result {
                case .success(let data):
                    onSuccess(data)
                case .failure(let error):
                    onError(error)
                }
        }
    }
    
    func rx_getDataRequest(_ api: API,
                           headers: HTTPHeaders? = nil) -> Observable<DataRequest> {
        return RxAlamofire.request(api.method,
                                   api.url,
                                   parameters: api.parameters,
                                   encoding: URLEncoding.default,
                                   headers: headers)
    }
    
    func rx_requestObject<T: Mappable>(_ api: API,
                                       keyPath: String? = nil,
                                       headers: HTTPHeaders? = nil) -> Observable<T> {
        return self.rx_getDataRequest(api, headers: headers)
            .responseMappable(as: T.self, keyPath: keyPath)
            .observeOn(MainScheduler())
    }
}
