//
//  Observable.swift
//  ProNexus
//
//  Created by thanh cto on 10/10/2021.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire
import ObjectMapper

enum ApiResult<Value, Error>{
    case success(Value)
    case failure(Error)

    init(value: Value){
        self = .success(value)
    }

    init(error: Error){
        self = .failure(error)
    }
}

struct ApiErrorMessage: Codable{
    var error_message: String
}

extension ObservableType {
    public func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            let json = data as? AnyObject
            guard let object = Mapper<T>().map(JSONObject: json) else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "ObjectMapper can't mapping"]
                )
            }
            
            return Observable.just(object)
        }
    }
    
        
    public func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return flatMap { data -> Observable<[T]> in
            let json = data as? AnyObject
            guard let objects = Mapper<T>().mapArray(JSONObject: json) else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "ObjectMapper can't mapping"]
                )
            }
            
            return Observable.just(objects)
        }
    }
}


extension Observable where Element == (HTTPURLResponse, Data){
    fileprivate func expectingObject<T : Codable>(ofType type: T.Type) -> Observable<ApiResult<T, ApiErrorMessage>>{
        return self.map{ (httpURLResponse, data) -> ApiResult<T, ApiErrorMessage> in
            switch httpURLResponse.statusCode{
            case 200 ... 299:
                // is status code is successful we can safely decode to our expected type T
                let object = try JSONDecoder().decode(type, from: data)
                return .success(object)
            default:
                // otherwise try
                let apiErrorMessage: ApiErrorMessage
                do{
                    // to decode an expected error
                    apiErrorMessage = try JSONDecoder().decode(ApiErrorMessage.self, from: data)
                } catch _ {
                    // or not. (this occurs if the API failed or doesn't return a handled exception)
                    apiErrorMessage = ApiErrorMessage(error_message: "Server Error.")
                }
                return .failure(apiErrorMessage)
            }
        }
    }
}
