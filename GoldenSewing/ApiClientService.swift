//
//  ApiClientService.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/25/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

public typealias RequestResult<T> = Task<ApiResponse<T>>

public class ApiClientService {
    
    private let url: String
    private let tag: String
    
    public init(url: String, tag: String) {
        self.url = url
        self.tag = tag
    }
    
    public func request<T: JSONDecodable>(action: String, method: HTTPMethod, type: T.Type, parameters: Parameters? = nil) -> RequestResult<T> {
        return customGenericMethod(action, method: method, parameters: parameters, parser: InitT())
    }
    
    private func InitT<T: JSONDecodable>() -> (_:Any?) -> T {
        return { json in T(json: json as! JSON)! }
    }
    
    public func customGenericMethod<TData>(_ path: String, method: HTTPMethod, parameters: [String: Any]?, parser:@escaping (_:Any?) -> TData) -> RequestResult<TData> {
        
        let url = Build(url: self.url, path: path)
        let headers: HTTPHeaders = ["Content-type": "application/x-www-form-urlencoded"]
        
        return Task { (handler: @escaping (_:ApiResponse<TData>) -> Void) in
            
            Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                
                switch response.result {
                case .success:
                    print("Success")
                    if let httpStatus = response.response?.statusCode,
                        httpStatus != 200 {
                        
                        print(self.tag, "Response status code is \(httpStatus)")
                        print(self.tag, "Response status code is not success.")
                        handler(ApiResponse(statusCode: .InternalServerError, response: response))
                        return
                    }
                    
                    print(self.tag, "Response from \(url)")
                    
                    let content = String(data: response.data!, encoding: .utf8)!
                    let json = response.value as! [[String:AnyObject]]
                    
                    for jsonValue in json {
                        let apiResponse = ApiResponse<TData>(json: jsonValue, response: response, content: content)
                        if (apiResponse.statusCode == .OK) {
                            apiResponse.data = parser(jsonValue)
                        }
                        
                        handler(apiResponse)
                    }
                    
                case .failure:
                    print("Failure")
                    if let error = response.error {
                        
                        print(self.tag, "Fundamental problem with request.")
                        print(self.tag, "Error: \(error)")
                        handler(ApiResponse(statusCode: .ConnectionError, response: response))
                        return
                    }
                }
            }
        }
    }
    
    private func Build(url: String, path: String) -> URL {
        
        var builded = "\(url)"
        
        if !path.isEmpty {
            builded.append("/\(path)")
        }
        
        return URL(string: builded)!
    }
}
