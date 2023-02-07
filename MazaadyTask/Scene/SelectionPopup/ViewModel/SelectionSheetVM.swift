//
//  SelectionPopupVM.swift
//  MazaadyTask
//
//  Created by Nevine on 05/02/2023.
//

import Foundation

class SelectionSheetVM {
    
    var reloadTable: (() -> Void)?
    
    var didSelectResult: ((ProductSectionType, CategoryDetailsModel?, OptionsModel?) -> Void)?
    
    var popupType: ProductSectionType = .MainCategory
    
    var categoryList: [CategoryDetailsModel] = []
    var filteredCategoryList: [CategoryDetailsModel] = []
    var selectedCategory: CategoryDetailsModel?
    
    var optionList: [OptionsModel] = []
    var filteredOptionList: [OptionsModel] = []
    var selectedOption: OptionsModel?
    
    init(popupType: ProductSectionType ,categoryList: [CategoryDetailsModel] = [], selectedCategory: CategoryDetailsModel?, optionList: [OptionsModel] = [], selectedOption: OptionsModel? ) {
        self.popupType = popupType
        self.categoryList = categoryList
        self.filteredCategoryList = categoryList
        self.selectedCategory = selectedCategory
        self.optionList = optionList
        self.filteredOptionList = optionList
        self.selectedOption = selectedOption
        self.setBeforeSelectedCateory()
        self.setBeforeSelectedOption()
    }
    
    private func setBeforeSelectedCateory() {
        if let cat = selectedCategory {
            for (index, item) in filteredCategoryList.enumerated() {
                if cat.catId == item.catId {
                    filteredCategoryList[index].IsSelected = true
                    reloadTable?()
                    break
                }
            }
        }
    }
    
    private func setBeforeSelectedOption() {
        if let option = selectedOption {
            for (index, item) in filteredOptionList.enumerated() {
                if option.optionId == item.optionId {
                    filteredOptionList[index].IsSelected = true
                    reloadTable?()
                    break
                }
            }
        }
    }
    
    func numberOfItem() -> Int {
        switch popupType {
        case .MainCategory, .SubCategory:
            return filteredCategoryList.count
        case .OptionsChildren:
            return filteredOptionList.count
        }
    }
    
    func getNameForRowAt(index: Int) -> String {
        switch popupType {
        case .MainCategory, .SubCategory:
            return filteredCategoryList[index].nameStr
        case .OptionsChildren:
            return filteredOptionList[index].nameStr
        }
    }
    
    func getSelectedForRowAt(index: Int) -> Bool {
        switch popupType {
        case .MainCategory, .SubCategory:
            return filteredCategoryList[index].isSelected
        case .OptionsChildren:
            return filteredOptionList[index].isSelected
        }
    }
    
    func didSelectRowAt(index: Int) {
        switch popupType {
        case .MainCategory, .SubCategory:
            removeAllCategoriesSelection()
            selectCategoryAtRow(index: index)
        case .OptionsChildren:
            removeAllOptionSelection()
            selectOptionAtRow(index: index)
        }
    }
    
    private func removeAllCategoriesSelection() {
        for (index, _) in filteredCategoryList.enumerated() {
            filteredCategoryList[index].IsSelected = false
        }
    }
    
    private func selectCategoryAtRow(index: Int) {
        filteredCategoryList[index].IsSelected = true
        selectedCategory = filteredCategoryList[index]
        reloadTable?()
        didSelectResult?(popupType, selectedCategory, selectedOption)
    }
    
    private func removeAllOptionSelection() {
        for (index, _) in filteredOptionList.enumerated() {
            filteredOptionList[index].IsSelected = false
        }
    }
    
    private func selectOptionAtRow(index: Int) {
        filteredOptionList[index].IsSelected = true
        selectedOption = filteredOptionList[index]
        reloadTable?()
        didSelectResult?(popupType, selectedCategory, selectedOption)
    }
    
    func search(searchText: String) {
        if searchText.isEmpty {
            resetSearch()
        } else {
            query(keyword: searchText)
        }
    }
    
    private func query(keyword: String) {
        switch popupType {
        case .MainCategory, .SubCategory:
            filterCategoryListWith(keyword: keyword)
        case .OptionsChildren:
            filterOptionListWith(keyword: keyword)
        }
        reloadTable?()
    }
    
    private func filterCategoryListWith(keyword: String) {
        filteredCategoryList = categoryList.filter {($0.nameStr.lowercased().contains(keyword.lowercased()))}
    }
    
    private func filterOptionListWith(keyword: String) {
        filteredOptionList = optionList.filter {($0.nameStr.lowercased().contains(keyword.lowercased()))}
    }
    
    func resetSearch() {
        switch popupType {
        case .MainCategory, .SubCategory:
            filteredCategoryList = categoryList
        case .OptionsChildren:
            filteredOptionList = optionList
        }
        reloadTable?()
    }
}
