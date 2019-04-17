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
    public func products(categoryId: Int, offset: Int = 0) -> RequestResult<ProductModel> {
        let parameters = CollectParameters([
            "categories": categoryId,
            "offset": offset])
        return client.request(action: "", method: .get, type: ProductModel.self, parameters: parameters)
    }
    
    public func productBy(id: Int) -> RequestResult<ProductModel> {
        return client.request(action: "\(id)", method: .get, type: ProductModel.self, parameters: nil)
    }
    
    public func otherProducts(categoryId: Int, offset: Int = 0) -> RequestResult<OtherProductModel> {
        return client.request(action: "\(categoryId)", method: .get, type: OtherProductModel.self, parameters: nil)
    }
}
