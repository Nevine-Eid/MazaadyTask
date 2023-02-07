//
//  AddProductViewController.swift
//  MazaadyTask
//
//  Created by Nevine on 05/02/2023.
//

import UIKit

class AddProductViewController: BaseViewController {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    lazy var viewModel: AddProductVM = {
       return AddProductVM()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    @IBAction func staticScreenPressed(_ sender: Any) {
        let vc = ProductDetailsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func submitPressed(_ sender: Any) {
        viewModel.submit()
    }
    
}
//MARK: - Helpers
extension AddProductViewController {
    func initView() {
        initCommonTableView()
        bindViewModel()
        viewModel.getAllCategory()
    }
    
    func initCommonTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 1000
        tableView.keyboardDismissMode = .onDrag
        tableView.registerNib(cell: CustomTextFieldCell.self)
    }
    
    private func bindViewModel() {
        viewModel.showLoading.bind { [weak self] visible in
            if let `self` = self {
                visible ? self.showIndicator() : self.hideIndicator()
            }
        }
        
        viewModel.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.successSubmit = { [weak self] valuesList in
            let vc = ProductReviewVC()
            vc.valuesList = valuesList
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func expandCategorySheet(cellType: ProductSectionType) {
        let vc = SelectionSheetVC()
        vc.popupType = cellType
        vc.categoryList = viewModel.categoryList
        vc.selectedCategory = viewModel.selectedCategory
        vc.SheetDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    private func expandSubCategorySheet(cellType: ProductSectionType) {
        let vc = SelectionSheetVC()
        vc.popupType = cellType
        vc.categoryList = viewModel.subCategoryList
        vc.selectedCategory = viewModel.selectedSubCategory
        vc.SheetDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    private func expandOptionsSheet(cellType: ProductSectionType, ownerOfDropDownIndex: Int) {
        let vc = SelectionSheetVC()
        vc.popupType = cellType
        vc.ownerOfDropDownIndex = ownerOfDropDownIndex
        vc.optionList = viewModel.getOptionListFromSubCategoryOption(index: ownerOfDropDownIndex)
        vc.selectedOption = viewModel.getSelectedOptionFromSubCategoryOption(index: ownerOfDropDownIndex)
        vc.SheetDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
    }

}
//MARK: - UITableView Delegate, DataSource
extension AddProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.productSectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.productSectionList[section] {
        case .MainCategory:
            return 1
        case .SubCategory:
            return 1
        case .OptionsChildren:
            return viewModel.subCategoryOptionList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as CustomTextFieldCell
        switch viewModel.productSectionList[indexPath.section] {
        case .MainCategory:
            cell.selectedMainCategoryVM = viewModel.selectedCategory
        case .SubCategory:
            cell.selectedSubCategoryVM = viewModel.selectedSubCategory
        case .OptionsChildren:
            cell.subCatOptionIndex = indexPath.row
            cell.subCatOptionVM = viewModel.subCategoryOptionList[indexPath.row]
        }
        cell.cellDropDownDelegate = self
        cell.cellEditTextChangedDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: - Dropdown
extension AddProductViewController: CustomTextFieldCellDropDownDelegate {
    func cellDropDownPressed(cellType: ProductSectionType, index: Int) {
        switch cellType {
        case .MainCategory:
            expandCategorySheet(cellType: cellType)
        case .SubCategory:
            if viewModel.checkIfSelectedMainCategoryFirst() {
                expandSubCategorySheet(cellType: cellType)
            }
        case .OptionsChildren:
            expandOptionsSheet(cellType: cellType, ownerOfDropDownIndex: index)
        }
    }
}
//MARK: - Edit TextField delegate
extension AddProductViewController: CustomTextFieldCellEditTextChangeDelegate {
    func cellEditTextChanged(text: String, index: Int) {
        viewModel.updateEditTextValueForSubCategoryOptionList(text: text, index: index)
    }
}
//MARK: - Selection sheet delegate
extension AddProductViewController: SelectionDelegate {
    func selectionPopupResult(popupType: ProductSectionType, selectedCategory: CategoryDetailsModel?, selectedOption: OptionsModel?, ownerOfDropDownIndex: Int) {
        switch popupType {
        case .MainCategory:
            if let cat = selectedCategory {
                viewModel.setupSelectMainCategory(selectedCat: cat)
            }
        case .SubCategory:
            if let cat = selectedCategory {
                viewModel.setupSelectSubCategory(selectedCat: cat)
            }
        case .OptionsChildren:
            if let option = selectedOption {
                viewModel.setupSelectedSubCategoryOptionAt(index: ownerOfDropDownIndex, selectOption: option)
            }
        }
    }

}

