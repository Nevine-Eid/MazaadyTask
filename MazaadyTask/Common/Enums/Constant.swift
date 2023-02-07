//
//  Constant.swift
//  MazaadyTask
//
//  Created by Nevine on 05/02/2023.
//

import UIKit


enum Constant: String {
    case options = "Other"
}

public var screenWidth: CGFloat { get { return UIScreen.main.bounds.size.width }}
public var iPhoneFactorX: CGFloat = screenWidth/360
