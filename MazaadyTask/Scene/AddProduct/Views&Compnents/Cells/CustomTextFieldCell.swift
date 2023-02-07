//
//  CustomTextFieldCell.swift
//  MazaadyTask
//
//  Created by Nevine on 06/02/2023.
//

import UIKit

protocol CustomTextFieldCellDropDownDelegate: NSObjectProtocol {
    func cellDropDownPressed(cellType: ProductSectionType, index: Int)
}

protocol CustomTextFieldCellEditTextChangeDelegate: NSObjectProtocol {
    func cellEditTextChanged(text: String, index: Int)
}


final class CustomTextFieldCell: UITableViewCell {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var textFieldView: CustomOutlinedTextField!
    @IBOutlet weak var otherTextFieldView: CustomOutlinedTextField!
    
    weak var cellDropDownDelegate: CustomTextFieldCellDropDownDelegate?
    weak var cellEditTextChangedDelegate : CustomTextFieldCellEditTextChangeDelegate?
    
    var cellType: ProductSectionType = .MainCategory
    
    var selectedMainCategoryVM: CategoryDetailsModel? {
        didSet {
            bindMainCategoryVM()
        }
    }
    
    var selectedSubCategoryVM: CategoryDetailsModel? {
        didSet {
            bindSubCategoryVM()
        }
    }
    
    
    var subCatOptionIndex: Int = 0
    
    var subCatOptionVM: SubCategoryModel? {
        didSet {
            bindSubCatOptionVM()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


//MARK: - Helpers
extension CustomTextFieldCell {
    private func bindMainCategoryVM() {
        cellType = .MainCategory
        allowDropDown()
        hideOtherTextField()
        checkIfMainCategorySelected()
        addCustomOutlinedTextFieldDropDownDelegate()
    }
    
    private func checkIfMainCategorySelected() {
        if let mainCat = selectedMainCategoryVM {
            setTextFieldViewPlaceholder(text: "Category")
            setTextFieldViewValue(text: mainCat.nameStr)
        }else {
            setTextFieldViewValue(text: "")
            setTextFieldViewPlaceholder(text: "Select category")
        }
    }
    
    private func bindSubCategoryVM() {
        cellType = .SubCategory
        allowDropDown()
        hideOtherTextField()
        checkIfSubCategorySelected()
        addCustomOutlinedTextFieldDropDownDelegate()
    }
    
    private func checkIfSubCategorySelected() {
        if let subCat = selectedSubCategoryVM {
            setTextFieldViewPlaceholder(text: "Subcategory")
            setTextFieldViewValue(text: subCat.nameStr)
        }else {
            setTextFieldViewValue(text: "")
            setTextFieldViewPlaceholder(text: "Select subcategory")
        }
    }
    
    func bindSubCatOptionVM() {
        cellType = .OptionsChildren
        addCustomOutlinedTextFieldDropDownDelegate()
        addCustomOutlinedEditingTextFieldDelegate()
        if let subCatOption = subCatOptionVM {
            setOptionTextFieldType(isDropDown: subCatOption.isDropDown)
            setOptionValueIfExists(subCatOption: subCatOption)
            setupSubCatOptionOtherTextField(subCatOption: subCatOption)
        }
    }
    
    private func setOptionTextFieldType(isDropDown: Bool) {
        isDropDown ? allowDropDown() : disableDropDown()
    }
    
    
    private func setOptionValueIfExists(subCatOption: SubCategoryModel) {
        setTextFieldViewPlaceholder(text: subCatOption.nameStr)
        setTextFieldViewValue(text: subCatOption.valueStr)
    }
    
    private func setupSubCatOptionOtherTextField(subCatOption: SubCategoryModel) {
        if subCatOption.valueStr == Constant.options.rawValue {
            showOtherTextField()
            setOptionOtherValueIfExists(otherValue: subCatOption.otherValueStr)
        }else {
            hideOtherTextField()
        }
    }
    
    private func setOptionOtherValueIfExists(otherValue: String) {
        setOtherTextFieldViewValue(text: otherValue)
    }
    

}

//MARK: - CustomTxtField 
extension CustomTextFieldCell {
    private func allowDropDown() {
        textFieldView.showDropDown()
    }
    
    private func disableDropDown() {
        textFieldView.hideDropDown()
    }
    
    private func addCustomOutlinedTextFieldDropDownDelegate() {
        textFieldView.dropDownDelegate = self
    }
    
    private func addCustomOutlinedEditingTextFieldDelegate() {
        textFieldView.textEditingDelegate = self
        otherTextFieldView.textEditingDelegate = self
    }
    
    private func showOtherTextField() {
        otherTextFieldView.isHidden = false
    }
    
    private func hideOtherTextField() {
        otherTextFieldView.isHidden = true
    }
    
    private func setTextFieldViewPlaceholder(text: String) {
        textFieldView.setTextFieldPlaceholder(text: text)
    }
    
    private func setTextFieldViewValue(text: String) {
        textFieldView.setTextFieldValue(text: text)
    }
    
    private func setOtherTextFieldViewValue(text: String) {
        otherTextFieldView.setTextFieldValue(text: text)
    }
}

//MARK: - CustomOutlined DropDown TextField Delegate
extension CustomTextFieldCell: CustomOutlinedDropDownTextFieldDelegate {
    func dropDownPressed() {
        cellDropDownDelegate?.cellDropDownPressed(cellType: cellType, index: cellType == .OptionsChildren ? subCatOptionIndex : 0)
    }
}
//MARK: - CustomOutlined Editing TextField Delegate
extension CustomTextFieldCell: CustomOutlinedEditingTextFieldDelegate {
    func textFieldTxtEditingValue(text: String) {
        cellEditTextChangedDelegate?.cellEditTextChanged(text: text, index: cellType == .OptionsChildren ? subCatOptionIndex : 0)
    }
}
