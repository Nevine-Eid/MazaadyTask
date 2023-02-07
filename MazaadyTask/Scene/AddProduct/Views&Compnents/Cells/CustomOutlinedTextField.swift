//
//  CustomOutlinedTextField.swift
//  MazaadyTask
//
//  Created by Nevine on 06/02/2023.
//

import UIKit
import MaterialComponents

protocol CustomOutlinedDropDownTextFieldDelegate: NSObjectProtocol {
    func dropDownPressed()
}

protocol CustomOutlinedEditingTextFieldDelegate: NSObjectProtocol {
    func textFieldTxtEditingValue(text: String)
}

class CustomOutlinedTextField: UIView {

    var textField: MDCOutlinedTextField!

    @IBInspectable var placeHolder: String!
    @IBInspectable var value: String!
    @IBInspectable var primaryColor: UIColor! = .lightGray
    @IBInspectable var isDropDown: Bool = false
    
    weak var dropDownDelegate: CustomOutlinedDropDownTextFieldDelegate?
    weak var textEditingDelegate: CustomOutlinedEditingTextFieldDelegate?

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)

    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setUpProperty()
    }
    
    func setUpProperty() {
        
        textField = MDCOutlinedTextField(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        textField.verticalDensity = 1
        textField.preferredContainerHeight = self.frame.size.height
        
        textField.containerRadius = 8
        
        textField.setOutlineColor(primaryColor, for: .normal)
        textField.setOutlineColor(primaryColor, for: .editing)
        
        textField.label.text = placeHolder
        textField.label.font = UIFont.systemFont(ofSize: 14)
        textField.setNormalLabelColor(primaryColor, for: .normal)
        textField.setFloatingLabelColor(primaryColor, for: .editing)
        textField.setFloatingLabelColor(primaryColor, for: .normal)
        
        textField.text = value
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.delegate = self
        
        if isDropDown {
            showDropDown()
        }
        
        self.addSubview(textField)
    }
    
    func setTextFieldPlaceholder(text: String) {
        textField.label.text = text
    }

   func setTextFieldValue(text: String) {
        textField.text = text
    }
    
    func showDropDown() {
        isDropDown = true
        let arrowDownIcon = UIImageView(image: UIImage(systemName: "arrow.down"))
        arrowDownIcon.tintColor = .lightGray
        textField.trailingView = arrowDownIcon
        textField.trailingViewMode = .always
    }
    
    func hideDropDown() {
        isDropDown = false
        textField.trailingView = nil
    }
}
//MARK: - UITextFieldDelegate
extension CustomOutlinedTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = ((self.textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        if isDropDown {
            return false
        }
        textEditingDelegate?.textFieldTxtEditingValue(text: searchText)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      if isDropDown {
          dropDownDelegate?.dropDownPressed()
          return false
      }
      return true
    }
}
