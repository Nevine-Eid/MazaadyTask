//
//  CategoryApi.swift
//  MazaadyTask
//
//  Created by Nevine on 05/02/2023.
//

import Foundation
import Moya

enum EndPoints: String, CaseIterable {
    case mainCategories = "get_all_cats"
    case subCategories = "properties"
    case optionsChildren = "get-options-child"
}

enum CategoryApi {
    case getAllCategory
    case getSubCategory(catId: Int)
    case getOptions(id: Int)
}


extension CategoryApi: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseUrl) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getAllCategory:
            return EndPoints.mainCategories.rawValue
        case .getSubCategory:
            return EndPoints.subCategories.rawValue
        case .getOptions(let id):
            return EndPoints.optionsChildren.rawValue + "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllCategory:
            return .get
        case .getSubCategory:
            return .get
        case .getOptions:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getAllCategory:
            return .requestPlain
        case .getSubCategory(let catId):
            return .requestParameters(parameters: ["cat": catId], encoding: URLEncoding.queryString)
        case .getOptions:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json", "private-key": "3%o8i}_;3D4bF]G5@22r2)Et1&mLJ4?$@+16"]
    }
    
}
