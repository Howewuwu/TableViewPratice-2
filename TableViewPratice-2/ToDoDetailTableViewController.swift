//
//  ToDoDetailTableViewController.swift
//  TableViewPratice-2
//
//  Created by Howe on 2024/2/20.
//

import UIKit
import PhotosUI

// 定義一個協定，當詳細資料頁面儲存資料時，通知代理物件。
protocol ToDoDetailTableViewControllerDelegate: AnyObject {
    func toDoDetailTableViewControllerDidSave(_ toDo: ToDo)
}


// 管理待辦事項詳細資料的表格視圖控制器
class ToDoDetailTableViewController: UITableViewController {
    
    // 存儲當前待辦事項，如果是新建則為nil
    var toDo: ToDo?
    
    // 委託物件，用於反向傳遞資料
    weak var delegate: ToDoDetailTableViewControllerDelegate?
    
    // 導航列上的儲存和取消按鈕
    var saveButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    // 用於標記待辦事項是否完成的按鈕
    var isCompleteButton = UIButton()
    // 輸入待辦事項標題的文字欄位
    var titleTextField = UITextField()
    
    // 儲存備註圖片的資料
    var noteImageData: Data?
    // 顯示備註圖片的圖像視圖
    var noteImageView = UIImageView()
    
    // 顯示日期標籤的靜態文字
    let staticDateLabel = UILabel()
    // 顯示選定日期的標籤
    var dueDateLabel = UILabel()
    // 目前選定的日期
    var dateDate = Date()
    // 選擇日期的日期選擇器
    let dueDateDatePicker = UIDatePicker()
    
    // 輸入備註的文字視圖
    var notesTextView = UITextView()
    
    // 控制日期選擇器顯示與隱藏的布林值
    var isDatePickerHidden = true
    
    // 用於識別特定的表格行
    let buttonTextfieldIndexPath = IndexPath(row: 0, section: 0)
    let imageViewIndexPath = IndexPath(row: 0, section: 1)
    let dateDateLabelIndexPath = IndexPath(row: 0, section: 2)
    let dueDatePickerIndexPath = IndexPath(row: 1, section: 2)
    let textViewIndexPath = IndexPath(row: 0, section: 3)
    
    // 视图加载后执行的设置
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 根據是否存在toDo物件來設定頁面標題和欄位值
        if let toDo = toDo {
            navigationItem.title = "事件"
            titleTextField.text = toDo.title
            isCompleteButton.isSelected = toDo.isComplete
            noteImageData = toDo.imageData
            dateDate = toDo.dueDate
            notesTextView.text = toDo.notes
        } else {
            navigationItem.title = "新事件"
            // 預設設定為明天
            dateDate = Calendar.current.date(byAdding: .day, value: 1, to: dateDate)!
        }
        
        // 初始化日期選擇器
        dueDateDatePicker.date = dateDate
        upDueDateLabel(date: dateDate)
        
        // 更新完成按鈕的圖像
        updateCompleteButtonImage()
        
        // 設定導航欄按鈕
        saveButton = UIBarButtonItem(title: "儲存", style: .done, target: self, action: #selector(saveAction))
        cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
        
        // 更新儲存按鈕的啟用狀態
        updateSaveButtonState()
        
        // 設定表格視圖為靜態樣式
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    
    // MARK: - Table view data source
    // 返回表格中的區段數量
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4  // 總共有四個區段：完成狀態與標題、圖片、日期、備註
    }
    
    
    // 返回每個區段中的行數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1  // 完成狀態與標題區段只有一行
        case 1:
            return 1  // 圖片區段只有一行
        case 2:
            return 2  // 日期區段有兩行，一行顯示日期，另一行放置日期選擇器
        case 3:
            return 1  // 備註區段只有一行
        default:
            return 0  // 預設情況下不應該有其他區段
        }
    }
    
    
    // 配置每行的單元格
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // 移除cell內所有之前添加的subview，這樣可以重用單元格而不會重複添加視圖
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        switch indexPath.section {
        case 0: // 完成狀態與標題
            // 配置完成狀態按鈕和標題文字欄位
            isCompleteButton.translatesAutoresizingMaskIntoConstraints = false
            titleTextField.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(isCompleteButton)
            cell.contentView.addSubview(titleTextField)
            
            titleTextField.placeholder = "記得要..."  // 設定提示文字
            titleTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)  // 文字變化時調用
            
            isCompleteButton.addTarget(self, action: #selector(isCompleteButtonTapped), for: .touchUpInside)  // 點擊按鈕時調用
            
            // 設定自動布局約束
            NSLayoutConstraint.activate([
                isCompleteButton.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
                isCompleteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                isCompleteButton.widthAnchor.constraint(equalToConstant: 30),
                isCompleteButton.heightAnchor.constraint(equalToConstant: 30),
                
                titleTextField.leadingAnchor.constraint(equalTo: isCompleteButton.trailingAnchor, constant: 20),
                titleTextField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                titleTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20)
            ])
            
        case 1: // 圖片
            // 配置備註圖片的顯示
            noteImageView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(noteImageView)
            
            noteImageView.contentMode = .scaleAspectFit  // 設定圖片的填充模式
            if let imageData = noteImageData {
                noteImageView.image = UIImage(data: imageData)  // 如果有圖片數據則顯示
            } else {
                noteImageView.image = UIImage(systemName: "photo.badge.plus")  // 默認圖像
            }
            
            // 設定自動布局約束
            NSLayoutConstraint.activate([
                noteImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                noteImageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                noteImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                noteImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
            ])
            
        case 2: // 日期
            if indexPath.row == 0 {
                // 配置日期標籤
                staticDateLabel.text = "日期"
                staticDateLabel.translatesAutoresizingMaskIntoConstraints = false
                dueDateLabel.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(staticDateLabel)
                cell.contentView.addSubview(dueDateLabel)
                
                // 設定自動布局約束
                NSLayoutConstraint.activate([
                    staticDateLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
                    staticDateLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                    
                    dueDateLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
                    dueDateLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
                ])
            } else {
                // 配置日期選擇器
                dueDateDatePicker.preferredDatePickerStyle = .wheels
                dueDateDatePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
                dueDateDatePicker.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(dueDateDatePicker)
                
                // 設定自動布局約束
                NSLayoutConstraint.activate([
                    dueDateDatePicker.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    dueDateDatePicker.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                    dueDateDatePicker.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                    dueDateDatePicker.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
                ])
            }
            
        case 3: // 備註
            // 配置備註文字視圖
            notesTextView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(notesTextView)
            
            notesTextView.font = .systemFont(ofSize: 18)  // 設定字體大小
            
            if notesTextView.text.isEmpty {
                notesTextView.text = "memo something"  // 預設文字
            }
            // 設定自動布局約束
            NSLayoutConstraint.activate([
                notesTextView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                notesTextView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                notesTextView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
                notesTextView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15)
            ])
            
        default:
            break  // 其他情況不處理
        }
        return cell
    }
    
    
    
    // MARK: - Table view delegate
    // 設定各行(row)的高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case buttonTextfieldIndexPath: // 完成狀態與標題行的高度
            return 45
        case imageViewIndexPath: // 圖片行的高度
            return 200
        case dateDateLabelIndexPath: // 日期標籤行的高度
            return 45
        case dueDatePickerIndexPath where isDatePickerHidden: // 日期選擇器行的高度，當選擇器隱藏時設為0
            return 0
        case textViewIndexPath: // 備註文本視圖行的高度
            return 100
        default: // 其他行的默認高度
            return UITableView.automaticDimension // 自動計算行高
        }
    }
    
    
    // 設定各行(row)的估計高度，有助於提高表格的加載效率
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case buttonTextfieldIndexPath: // 完成狀態與標題行的估計高度
            return 45
        case imageViewIndexPath: // 圖片行的估計高度
            return 200
        case dateDateLabelIndexPath: // 日期標籤行的估計高度
            return 45
        case dueDatePickerIndexPath: // 日期選擇器行的估計高度
            return 210 // 因為這一行包含一個日期選擇器，因此給予比其他行更大的估計值
        case textViewIndexPath: // 備註文本視圖行的估計高度
            return 100
        default: // 其他行的默認估計高度
            return UITableView.automaticDimension // 自動計算行高
        }
    }
    
    
    // 當用戶選擇某一行時執行的方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消選擇該行，使選擇效果消失
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 檢查選擇的是哪一行
        if indexPath == dateDateLabelIndexPath {
            // 如果是日期標籤行，則顯示或隱藏日期選擇器
            isDatePickerHidden.toggle() // 切換日期選擇器的顯示狀態
            upDueDateLabel(date: dueDateDatePicker.date) // 更新日期標籤上的日期
            
            tableView.beginUpdates() // 開始表格更新
            tableView.endUpdates() // 結束表格更新，這會導致表格重新檢查行的高度
            
        } else if indexPath == imageViewIndexPath {
            
            // 如果是圖片行，則打開圖片選擇器
            var configuration = PHPickerConfiguration() // 創建一個新的圖片選擇器配置
            configuration.filter = .images // 設置過濾器只顯示圖片
            let picker = PHPickerViewController(configuration: configuration) // 創建一個新的圖片選擇器視圖控制器
            picker.delegate = self // 設置代理以接收選擇的圖片
            present(picker, animated: true) // 顯示圖片選擇器
        }
    }
    
    
    // 當用戶更改日期選擇器中的日期時調用的方法
    @objc func selectDate(sender: UIDatePicker) {
        upDueDateLabel(date: sender.date) // 更新日期標籤上的日期
    }
    
    // 更新日期標籤上的日期
    func upDueDateLabel(date: Date) {
        
        // 使用 DateFormatter 格式化日期，並將其設定為日期標籤的文字
        dueDateLabel.text = date.formatted(.dateTime.month(.defaultDigits).day().year(.twoDigits).hour().minute())
    }
    
    
    // 當標題輸入框內容變化時調用
    @objc func editingChanged(sender: UITextField) {
        
        // 根據標題文字框是否有內容來啟用或禁用儲存按鈕
        updateSaveButtonState()
    }
    
    // 更新儲存按鈕的狀態
    func updateSaveButtonState() {
        
        // 檢查標題文字框是否有文字，若有，允許儲存；若無，禁止儲存
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    
    // 當完成狀態按鈕被點擊時調用
    @objc func isCompleteButtonTapped(_ sender: UIButton) {
        
        // 切換完成狀態按鈕的選中狀態
        isCompleteButton.isSelected.toggle()
        // 更新完成狀態按鈕的圖像以反映當前狀態
        updateCompleteButtonImage()
    }
    
    // 更新完成狀態按鈕的圖像
    func updateCompleteButtonImage() {
        
        // 根據完成狀態按鈕是否被選中來決定使用哪個圖標
        let buttonStateImageName = isCompleteButton.isSelected ? "checkmark.circle.fill" : "circle"
        // 設置完成狀態按鈕的圖像
        isCompleteButton.setImage(UIImage(systemName: buttonStateImageName), for: .normal)
    }
    
    
    
    // 當儲存按鈕被點擊時執行的動作
    @objc func saveAction() {
        
        // 從使用者介面元件中收集待辦事項資料
        let title = titleTextField.text!  // 強制解包，因為我們知道在這一點上標題字段不應該是空的
        let isComplete = isCompleteButton.isSelected  // 檢查待辦事項是否已標記為完成
        let dueDate = dueDateDatePicker.date  // 從日期選擇器獲取選擇的日期
        let notes = notesTextView.text  // 從文字視圖中獲取備註
        let noteImageData = noteImageData  // 從之前保存的變量中獲取備註圖片數據
        
        // 檢查當前是否正在編輯一個已存在的待辦事項
        if toDo != nil {
            // 如果是，則更新該待辦事項的資料
            toDo?.title = title
            toDo?.isComplete = isComplete
            toDo?.dueDate = dueDate
            toDo?.notes = notes
            toDo?.imageData = noteImageData
        } else {
            // 如果不是，則創建一個新的待辦事項實例
            toDo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes, imageData: noteImageData)
        }
        
        // 通過代理回調方法將更新後的或新建的待辦事項傳遞回前一個視圖控制器
        delegate?.toDoDetailTableViewControllerDidSave(toDo!)
        // 返回上一頁面
        navigationController?.popViewController(animated: true)
    }
    
    
    // 當取消按鈕被點擊時執行的動作
    @objc func cancelAction() {
        // 不保存任何更改，直接返回上一頁面
        navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - Extension PHPicker
extension ToDoDetailTableViewController: PHPickerViewControllerDelegate {
    // 當用戶從PHPickerViewController選擇完照片後調用
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 閉包圖片選擇器界面
        picker.dismiss(animated: true)
        
        // 將PHPickerResult轉換成itemProvider，以便後續獲取圖片數據
        let itemProviders = results.map(\.itemProvider)
        
        // 檢查是否有可用的項目提供者且該提供者能夠載入UIImage類型的物件
        if let itemProvider = itemProviders.first, itemProvider.canLoadObject(ofClass: UIImage.self) {
            // 保存當前圖片，以便後續比較，確認是否為同一張圖
            let previousImage = self.noteImageView.image
            
            // 使用itemProvider加載圖片
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                // 切換到主線程，因為我們將對UI進行更新
                DispatchQueue.main.async {
                    // 確保self存在，獲取的圖片是UIImage類型，且當前圖片仍是原來的圖片
                    // (這最後一條檢查是為了防止在圖片加載期間用戶再次選擇了不同的圖片)
                    guard let self = self, let image = image as? UIImage, self.noteImageView.image == previousImage else { return }
                    // 更新界面上的圖片顯示
                    self.noteImageView.image = image
                    // 將圖片轉換為數據並儲存，這裡設定壓縮質量為最高
                    self.noteImageData = image.jpegData(compressionQuality: 1.0)
                }
            }
        }
    }
}
