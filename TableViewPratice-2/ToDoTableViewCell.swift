//
//  ToDoTableViewCell.swift
//  TableViewPratice-2
//
//  Created by Howe on 2024/2/20.
//

import UIKit

protocol ToDoTableViewCellDelegate: AnyObject {
    func checkmarkTapped(sender: ToDoTableViewCell)
}


class ToDoTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String { "\(Self.self)" }
    
    weak var delegate: ToDoTableViewCellDelegate?
    
    let titleLabel = UILabel()
    let isCompleteButton = UIButton()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    
    func commonInit() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(isCompleteButton)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        isCompleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        
        isCompleteButton.setImage(UIImage(systemName: "circle"), for: .normal)
        isCompleteButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            
            isCompleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            isCompleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            isCompleteButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            isCompleteButton.heightAnchor.constraint(equalTo: isCompleteButton.widthAnchor, multiplier: 1),
            
            titleLabel.leadingAnchor.constraint(equalTo: isCompleteButton.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
        ])
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    func updateCompleteButtonImage() {
        let buttonStateImageName = isCompleteButton.isSelected ? "checkmark.circle.fill" : "circle"
        isCompleteButton.setImage(UIImage(systemName: buttonStateImageName), for: .normal)
    }
    
    
    @objc func completeButtonTapped(sender: UIButton){
        isCompleteButton.isSelected.toggle()
        updateCompleteButtonImage()
        delegate?.checkmarkTapped(sender: self)
        
    }
    
    
}
