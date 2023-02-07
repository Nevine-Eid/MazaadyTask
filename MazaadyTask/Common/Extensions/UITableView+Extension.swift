//
//  UITableView+Extension.swift
//  MazaadyTask
//
//  Created by Nevine on 05/02/2023.
//


import UIKit

extension UITableView {
    func registerNib<Cell: UITableViewCell>(cell: Cell.Type) {
        let nibName = String(describing: Cell.self)
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func dequeue<Cell: UITableViewCell>() -> Cell{
        let identifier = String(describing: Cell.self)
        
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error in dequeue cell")
        }
        
        return cell
    }
}
