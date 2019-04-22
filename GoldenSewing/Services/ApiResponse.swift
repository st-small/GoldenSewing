//
//  ApiResponse.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/25/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Gloss
import Alamofire

public class ApiResponse<TData> {
    
    public let statusCode: HttpStatusCode
    public var data: TData?
    
    public let response: DataResponse<Any>?
    public let responseContent: String
    
    public required init(json: JSON, response: DataResponse<Any>?, content: String) {
        
        self.data = nil
        
        if let code = response?.response?.statusCode {
            self.statusCode = HttpStatusCode(rawValue: code)!
        } else {
            self.statusCode = .BadRequest
        }
        self.response = response
        self.responseContent = content
    }
    public init(statusCode: HttpStatusCode, response: DataResponse<Any>?) {
        self.statusCode = statusCode
        self.data = nil
        
        self.response = response
        self.responseContent = ""
    }
    
    public var isSuccess: Bool {
        return statusCode == .OK
    }
    public var isFail: Bool {
        return !isSuccess
    }
}
