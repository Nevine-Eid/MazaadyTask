//
//  ProductSubmitValuesVC.swift
//  MazaadyTask
//
//  Created by Nevine on 05/02/2023.
//

import UIKit

class ProductReviewVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var valuesList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

}

//MARK: - Helpers
extension ProductReviewVC {
    func initView() {
        initCommonTableView()
    }
    
    
    func initCommonTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 1000
        
        tableView.registerNib(cell: SheetCell.self)
        
        tableView.reloadData()
    }
    
}

//MARK: - UITableView Delegate, DataSource
extension ProductReviewVC: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valuesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SheetCell
        cell.popupCellLabel.text = valuesList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
