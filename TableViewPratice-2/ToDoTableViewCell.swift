//
//  ToDoTableViewCell.swift
//  TableViewPratice-2
//
//  Created by Howe on 2024/2/20.
//

import UIKit


// 定義一個代理協定，當完成按鈕被點擊時，通知代理對象
protocol ToDoTableViewCellDelegate: AnyObject {
    func checkmarkTapped(sender: ToDoTableViewCell)
}


// 自定義的 ToDoTableViewCell 類別
class ToDoTableViewCell: UITableViewCell {
    
    // 提供一個靜態屬性來識別重用的 cell
    static var reuseIdentifier: String { "\(Self.self)" }
    
    // 定義一個代理，用於當完成按鈕被點擊時的通知
    weak var delegate: ToDoTableViewCellDelegate?
    
    // 標題標籤和完成按鈕的宣告
    let titleLabel = UILabel()
    let isCompleteButton = UIButton()
    
    
    // 初始化函式
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()  // 呼叫共同初始化設定
    }
    
    // 需要的解碼器初始化，用於從故事板加載
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()  // 呼叫共同初始化設定
    }
    
    
    // 共同的初始化函式設定 UI 元件
    func commonInit() {
        // 將標題標籤和完成按鈕加入到 contentView
        contentView.addSubview(titleLabel)
        contentView.addSubview(isCompleteButton)
        
        // 禁用自動轉換為約束
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        isCompleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 設定標題標籤的字體和顏色
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        
        // 為完成按鈕設置初始圖像和動作
        isCompleteButton.setImage(UIImage(systemName: "circle"), for: .normal)
        isCompleteButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        // 啟用 Auto Layout 約束
        NSLayoutConstraint.activate([
            isCompleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            isCompleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            isCompleteButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            isCompleteButton.heightAnchor.constraint(equalTo: isCompleteButton.widthAnchor, multiplier: 1),
            
            titleLabel.leadingAnchor.constraint(equalTo: isCompleteButton.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    
    // UITableViewCell 的子類別方法，用於設置選中狀態
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // 此處可以根據需要添加額外的設置，當 cell 的選中狀態改變時
    }
    
    
    // 更新完成按鈕的圖像，根據當前的選中狀態決定使用哪個圖標
    func updateCompleteButtonImage() {
        
        // 根據 isCompleteButton 的選中狀態來決定使用的圖標
        let buttonStateImageName = isCompleteButton.isSelected ? "checkmark.circle.fill" : "circle"
        isCompleteButton.setImage(UIImage(systemName: buttonStateImageName), for: .normal)
    }
    
    
    // 完成按鈕被點擊時調用的方法
    @objc func completeButtonTapped(sender: UIButton) {
        
        // 通知代理完成按鈕已被點擊，傳遞當前 cell 作為參數
        delegate?.checkmarkTapped(sender: self)
        
        // 更新完成按鈕的圖像以反映當前的選中狀態
        updateCompleteButtonImage()
    }
    
}
