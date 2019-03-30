//
//  ApiRequestService.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/25/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Gloss
import Alamofire

public class ApiRequestService {
    
    internal var tag: String
    internal let client: ApiClientService
    
    public init(area: String, type: AnyObject.Type) {
    
        self.tag = String.tag(type)
        self.client = ApiClientService(url: "\(Constants.baseUrl)/\(area)", tag: tag)
    }
    
    internal func CollectParameters(_ values: Parameters? = nil) -> Parameters {
        var result = Parameters()
        
        if let values = values {
            for (key, value) in values {
                
                if let object = value as? JSONEncodable {
                    result[key] = object.toJSON()
                } else {
                    result[key] = value
                }
            }
        }
        
        return result
    }
    
    // Categories
    public func allCategories() -> RequestResult<CategoryModel> {
        let parameters = CollectParameters([
            "page": 1,
            "per_page": 50])
        return client.request(action: "", method: .get, type: CategoryModel.self, parameters: parameters)
    }
    
    // Products
    public func products() -> RequestResult<CategoryModel> {
        let parameters = CollectParameters([
            "page": 1,
            "per_page": 50])
        return client.request(action: "", method: .get, type: ProductModel.self, parameters: parameters)
    }
}
