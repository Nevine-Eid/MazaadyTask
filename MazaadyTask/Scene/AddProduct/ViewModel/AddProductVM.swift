//
//  AddProductVM.swift
//  MazaadyTask
//
//  Created by Nevine on 06/02/2023.
//

import Foundation


class AddProductVM: BaseViewModelProtocol {
    
    var showLoading: Bindable<Bool> = Bindable(false)
    
    var reloadTable: (() -> Void)?
    
    var successSubmit: (([String]) -> Void)?
    
    var categoryList: [CategoryDetailsModel] = []
    
    var selectedCategory: CategoryDetailsModel?
    
    var subCategoryList: [CategoryDetailsModel] = []
    
    var selectedSubCategory: CategoryDetailsModel?
    
    var subCategoryOptionList: [SubCategoryModel] = []
    
    var productSectionList: [ProductSectionType]
    
    var removedChildIDs: [Int] = []
    
    var useCase: CategoryProtocol
    
    init(useCase: CategoryProtocol = CategoryUseCase(), productSectionList: [ProductSectionType] = [.MainCategory, .SubCategory, .OptionsChildren]) {
        self.useCase = useCase
        self.productSectionList = productSectionList
    }
    
    func getAllCategory() {
        showLoading.value = true
        
        useCase.getAllCategory { [weak self] (response, error) in
            self?.showLoading.value = false
            
            guard let categories = response else {
                debugPrint(error)
                return
            }
            self?.populateCategoryList(categories: categories)
        }
    }
    
    private func populateCategoryList(categories: [CategoryDetailsModel]) {
        categoryList = categories
    }
    
    
    func checkIfSelectedMainCategoryFirst() -> Bool {
        if selectedCategory == nil {
            debugPrint("check main first")
            return false
        }else {
            return true
        }
    }
    
    func setupSelectMainCategory(selectedCat: CategoryDetailsModel) {
        if checkMainCategorySelectionEquality(selectedCat: selectedCat) {
            selectedCategory = selectedCat
            selectedSubCategory = nil
            subCategoryList = selectedCategory?.children ?? []
            reloadTable?()
        }
    }
    
    private func checkMainCategorySelectionEquality(selectedCat: CategoryDetailsModel) -> Bool {
        if selectedCategory == nil {
            return true
        } else if selectedCategory?.catId != selectedCat.catId {
            return true
        }else {
            return false
        }
    }
    
    func setupSelectSubCategory(selectedCat: CategoryDetailsModel) {
        if checkSubCategorySelectionEquality(selectedCat: selectedCat) {
            selectedSubCategory = selectedCat
            reloadTable?()
            getSubCategoryOptions()
        }
    }
    
    private func checkSubCategorySelectionEquality(selectedCat: CategoryDetailsModel) -> Bool {
        if selectedSubCategory == nil {
            return true
        } else if selectedSubCategory?.catId != selectedCat.catId {
            return true
        }else {
            return false
        }
    }
    
    func getSubCategoryOptions() {
        showLoading.value = true
        
        useCase.getSubCategory(catId: selectedSubCategory?.catId ?? 0) { [weak self] (response, error) in
            self?.showLoading.value = false
            
            guard let subCatOptions = response else {
                debugPrint(error)
                return
            }
            self?.populateSubCategoryOptionList(subCatOptions: subCatOptions)
        }
    }
    
    
    private func populateSubCategoryOptionList(subCatOptions: [SubCategoryModel]) {
        self.subCategoryOptionList = appendOtherOptionsToSubCategory(subCatOptions: subCatOptions)
        reloadTable?()
    }
    
    private func appendOtherOptionsToSubCategory(subCatOptions: [SubCategoryModel]) -> [SubCategoryModel] {
        var listAfterAppendOtherToOption: [SubCategoryModel] = subCatOptions
        for (index, item) in listAfterAppendOtherToOption.enumerated() {
            if item.isDropDown {
                listAfterAppendOtherToOption[index].options?.insert(OptionsModel(id: -1, name: Constant.options.rawValue), at: 0)
            }
        }
        return listAfterAppendOtherToOption
    }
    
    func getOptionListFromSubCategoryOption(index: Int) -> [OptionsModel] {
        return subCategoryOptionList[index].options ?? []
    }
    
    func getSelectedOptionFromSubCategoryOption(index: Int) -> OptionsModel? {
        return getOptionListFromSubCategoryOption(index: index).filter({$0.isSelected}).first
    }
    
    func setupSelectedSubCategoryOptionAt(index: Int, selectOption: OptionsModel) {
        if checkIfSelectedSubCatOptionNotEqualPrevSelectedBefore(index: index, selectedOption: selectOption) {
            removePrevSelectedSubCatOptionChildIfExist(index: index)
            if checkIfSelectedSubCatOptionHaveChild(selectedOption: selectOption) {
                getChildOption(id: selectOption.optionId, appendAfterIndex: index)
            }
            removeAllSelectedSubCategoryOptionList(index: index)
            updateSubCategoryOptionListWithSelectedOption(index: index, selectOption: selectOption)
            reloadTable?()
        }
    }
    
    
    private func checkIfSelectedSubCatOptionNotEqualPrevSelectedBefore(index: Int, selectedOption: OptionsModel) -> Bool {
        let prevSelectedOption = getSelectedOptionFromSubCategoryOption(index: index)
        if prevSelectedOption == nil {
            return true
        } else if prevSelectedOption?.optionId != selectedOption.optionId {
            return true
        }else {
            return false
        }
    }
    
    private func removePrevSelectedSubCatOptionChildIfExist(index: Int) {
        if let prevSelectedOption = getSelectedOptionFromSubCategoryOption(index: index) {
            if checkIfSelectedSubCatOptionHaveChild(selectedOption: prevSelectedOption) {
                removeAllAppendedChildOptionWithParentId(parentId: subCategoryOptionList[index].idValue)
            }
        }
    }
    
    private func checkIfSelectedSubCatOptionHaveChild(selectedOption: OptionsModel) -> Bool {
        return selectedOption.isHaveChild
    }
    
    private func updateSubCategoryOptionListWithSelectedOption(index: Int, selectOption: OptionsModel) {
        for (indexItem, item) in getOptionListFromSubCategoryOption(index: index).enumerated() {
            if item.optionId == selectOption.optionId {
                subCategoryOptionList[index].options?[indexItem].IsSelected = true
                break
            }
        }
        setValueForSubCategoryOptionList(index: index, value: selectOption.nameStr)
        setOtherValueForSubCategoryOptionList(index: index, otherValue: "")
    }
    
    private func setValueForSubCategoryOptionList(index: Int, value: String) {
        subCategoryOptionList[index].value = value
    }
    
    private func setOtherValueForSubCategoryOptionList(index: Int, otherValue: String) {
        subCategoryOptionList[index].otherValue = otherValue
    }
    
    private func removeAllSelectedSubCategoryOptionList(index: Int) {
        for (indexItem, _) in getOptionListFromSubCategoryOption(index: index).enumerated() {
            subCategoryOptionList[index].options?[indexItem].IsSelected = false
        }
    }
    
    func updateEditTextValueForSubCategoryOptionList(text: String, index: Int) {
        if checkIfEditForOtherValue(index: index) {
            setOtherValueForSubCategoryOptionList(index: index, otherValue: text)
        }else {
            setValueForSubCategoryOptionList(index: index, value: text)
        }
    }
    
    private func checkIfEditForOtherValue(index: Int) -> Bool {
        return subCategoryOptionList[index].value == Constant.options.rawValue
    }
    
    
    private func removeAllAppendedChildOptionWithParentId(parentId: Int) {
        removedChildIDs = getParentRemovedChildIds(parentId: parentId)
        getChildForParentRemovedIds(removedIds: removedChildIDs, list: subCategoryOptionList)
        subCategoryOptionList = subCategoryOptionList.filter { !removedChildIDs.contains($0.childParentId) }
        reloadTable?()
    }
    
    
    
    private func getParentRemovedChildIds(parentId: Int) -> [Int] {
        return subCategoryOptionList.filter({$0.childParentId == parentId}).map({$0.childParentId})
    }
    
    
    private func getChildForParentRemovedIds(removedIds: [Int], list: [SubCategoryModel]){
        var newArr: [Int] = []
        for item in list {
            for id in removedIds {
                if item.childParentId == id {
                    newArr.append(item.idValue)
                }
            }
        }
        removedChildIDs += newArr
        if newArr.isEmpty {
            return
        }
        return getChildForParentRemovedIds(removedIds: newArr, list: list)
    }
    
    
    func getChildOption(id: Int, appendAfterIndex: Int) {
        showLoading.value = true
        useCase.getOptions(childId: id) { [weak self] (response, error) in
            self?.showLoading.value = false
            
            guard let subCatOptions = response else {
                debugPrint(error)
                return
            }
            self?.populateOptionChildList(childOptions: subCatOptions, appendAfterIndex: appendAfterIndex)
        }
    }
    
    private func populateOptionChildList(childOptions: [SubCategoryModel], appendAfterIndex: Int) {
        let listAfterAppendOther = appendOtherOptionsToSubCategory(subCatOptions: childOptions)
        let listAfterAppendParentId = addParentIdToChild(parentId: subCategoryOptionList[appendAfterIndex].idValue, childOptions: listAfterAppendOther)
        if subCategoryOptionList.count >= (appendAfterIndex+1) {
            subCategoryOptionList.insert(contentsOf: listAfterAppendParentId, at: appendAfterIndex+1)
        }else {
            subCategoryOptionList.append(contentsOf: listAfterAppendParentId)
        }
        reloadTable?()
    }
    
    private func addParentIdToChild(parentId: Int, childOptions: [SubCategoryModel]) -> [SubCategoryModel] {
        var list = childOptions
        for (index, _) in list.enumerated() {
            list[index].childParent = parentId
        }
        return list
    }
    
    func submit() {
        if getAddProductValues().count > 0 {
            successSubmit?(getAddProductValues())
        }else {
           debugPrint("Nope")
        }
    }
    
    private func getAddProductValues() -> [String] {
        var values: [String] = []
        if let catName = getSelectedCategoryName() {
            values.append(catName)
        }
        
        if let subCatName = getSelectedSubCategoryName() {
            values.append(subCatName)
        }
        
        values += getAllSubCategoryOptionListValue()
        
        return values
    }
    
    private func getSelectedCategoryName() -> String? {
        if let name = selectedCategory?.nameStr {
            return "Main Category: \(name)"
        }
        return nil
    }
    
    private func getSelectedSubCategoryName() -> String? {
        if let name = selectedSubCategory?.nameStr {
            return "Sub Category: \(name)"
        }
        return nil
    }
    
    private func getAllSubCategoryOptionListValue() -> [String] {
        var optionValues: [String] = []
        for item in subCategoryOptionList {
            optionValues.append("\(item.nameStr): \(item.valueStr) \(item.otherValueStr)")
        }
        return optionValues
    }
}
