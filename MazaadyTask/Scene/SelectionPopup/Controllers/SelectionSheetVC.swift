//
//  SelectionSheetVC.swift
//  MazaadyTask
//
//  Created by Nevine on 05/02/2023.
//

import UIKit

protocol SelectionDelegate: NSObjectProtocol {
    func selectionPopupResult(popupType: ProductSectionType, selectedCategory: CategoryDetailsModel?, selectedOption: OptionsModel?, ownerOfDropDownIndex: Int)
}

final class SelectionSheetVC: BaseViewController {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    weak var SheetDelegate: SelectionDelegate?
    
    var popupType: ProductSectionType = .MainCategory
    
    var categoryList: [CategoryDetailsModel] = []
    var selectedCategory: CategoryDetailsModel?
    
    var optionList: [OptionsModel] = []
    var selectedOption: OptionsModel?
    
    var ownerOfDropDownIndex: Int = 0
    
    //MARK: - Variables
    lazy var viewModel: SelectionSheetVM = {
        return SelectionSheetVM(popupType: popupType, categoryList: categoryList, selectedCategory: selectedCategory, optionList: optionList , selectedOption: selectedOption)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    @IBAction func dissmisAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
//MARK: - Helpers
extension SelectionSheetVC {
    func initView() {
        setupSearchBar()
        initCommonTableView()
        bindViewModel()
    }
    
    func setupSearchBar() {
        self.searchBar.placeholder = "Search ..."
        self.searchBar.delegate = self
    }
    
    func initCommonTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 1000
        tableView.keyboardDismissMode = .onDrag
        
        tableView.registerNib(cell: SheetCell.self)
    }
    
    func bindViewModel() {
        // bind did select result
        viewModel.didSelectResult = { [weak self] (popupType, selectedCategory, selectedOption) in
            self?.SheetDelegate?.selectionPopupResult(popupType: popupType, selectedCategory: selectedCategory, selectedOption: selectedOption, ownerOfDropDownIndex: self?.ownerOfDropDownIndex ?? 0)
            self?.dismiss(animated: true)
        }
        
        // bind reloadTable
        viewModel.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
}
//MARK: - UISearchBarDelegate
extension SelectionSheetVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.search(searchText: searchBar.text ?? "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resetData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resetData()
    }
    
    private func resetData() {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.viewModel.resetSearch()
    }
}
//MARK: - UITableView Delegate, DataSource
extension SelectionSheetVC: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItem()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SheetCell
        cell.configCell(name: viewModel.getNameForRowAt(index: indexPath.row), isSelected: viewModel.getSelectedForRowAt(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
