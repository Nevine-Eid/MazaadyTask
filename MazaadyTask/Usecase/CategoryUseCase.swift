//
//  CategoryRepo.swift
//  MazaadyTask
//
//  Created by Nevine on 05/02/2023.
//

import Foundation

protocol CategoryProtocol {
    func getAllCategory(completionHandler: @escaping ([CategoryDetailsModel]?, String?) -> ())
    func getSubCategory(catId: Int, completionHandler: @escaping ([SubCategoryModel]?, String?) -> ())
    func getOptions(childId: Int, completionHandler: @escaping ([SubCategoryModel]?, String?) -> ())
}


class CategoryUseCase:  CategoryProtocol{
    func getAllCategory(completionHandler: @escaping ([CategoryDetailsModel]?, String?) -> ()) {
        NetworkManager.beginRequest(withTarget: CategoryApi.getAllCategory, responseModel: BaseResponse<CategoryModel>.self) { result in
            NetworkManager.handleGeneralResponse(result: result) { (response, errorMessage) in
                completionHandler(response?.categories, errorMessage)
            }
        }
    }
    
    func getSubCategory(catId: Int, completionHandler: @escaping ([SubCategoryModel]?, String?) -> ()) {
        NetworkManager.beginRequest(withTarget: CategoryApi.getSubCategory(catId: catId), responseModel: BaseResponse<[SubCategoryModel]>.self) { result in
            NetworkManager.handleGeneralResponse(result: result) { (response, errorMessage) in
                completionHandler(response, errorMessage)
            }
        }
    }
    
    func getOptions(childId: Int, completionHandler: @escaping ([SubCategoryModel]?, String?) -> ()) {
        NetworkManager.beginRequest(withTarget: CategoryApi.getOptions(id: childId), responseModel: BaseResponse<[SubCategoryModel]>.self) { result in
            NetworkManager.handleGeneralResponse(result: result) { (response, errorMessage) in
                completionHandler(response, errorMessage)
            }
        }
    }
    
    
}
