//
//  HomeTableViewCell.swift
//  ToDo
//
//  Created by Александр Меренков on 9/15/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifire = "HomeTableViewCell"
    
    static func nib() -> UINib {
         return UINib(nibName: "HomeTableViewCell", bundle: nil)
    }
    
    var delegateText: GetTextProtocol?
    
    private let textFieldCell: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .lightGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        let text = NSAttributedString(string: "Please, add your mind", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.attributedPlaceholder = text
        textField.clearsOnBeginEditing = true
        textField.textColor = .white
        return textField
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldCell.delegate = self
//        backgroundColor = UIColor.blue
        backgroundColor = UIColor.init(red: 91/255, green: 192/255, blue: 190/255, alpha: 1)
        layer.borderColor = UIColor.black.cgColor
        addSubview(textFieldCell)
        textFieldCell.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textFieldCell.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textFieldCell.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textFieldCell.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textFieldCell.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: 10))
        textFieldCell.leftViewMode = .always
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldCell.endEditing(true)
        delegateText?.sendText(text: textFieldCell.text!, index: textFieldCell.tag)
        print(textFieldCell.tag)
        return false
    }
    
    internal func setTextFieldText(title: String, index: Int) {
        self.textFieldCell.text = title
        self.textFieldCell.tag = index
        print(textFieldCell.tag)
    }
}

