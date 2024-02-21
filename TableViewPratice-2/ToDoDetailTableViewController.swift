//
//  ToDoDetailTableViewController.swift
//  TableViewPratice-2
//
//  Created by Howe on 2024/2/20.
//

import UIKit
import PhotosUI

class ToDoDetailTableViewController: UITableViewController {
    
    
    var toDo: ToDO?
    
    var isCompleteButton = UIButton()
    var titleTextField = UITextField()
    
    var noteImageName: String?
    var noteImageView = UIImageView()
    
    let staticDateLabel = UILabel()
    var dueDateLabel = UILabel()
    var dateDate = Date()
    let dueDateDatePicker = UIDatePicker()
    
    var notesTextView = UITextView()
    
    
    var isDatePickerHidden = true
    
    let buttonTextfieldIndexPath = IndexPath(row: 0, section: 0)
    let imageViewIndexPath = IndexPath(row: 0, section: 1)
    let dateDateLabelIndexPath = IndexPath(row: 0, section: 2)
    let dueDatePickerIndexPath = IndexPath(row: 1, section: 2)
    let textViewIndexPath = IndexPath(row: 0, section: 3)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toDo = toDo {
            navigationItem.title = "To - Do"
            titleTextField.text = toDo.title
            isCompleteButton.isSelected = toDo.isComplete
            dateDate = toDo.dueDate
            notesTextView.text = toDo.notes
            noteImageName = toDo.imageName
        } else {
            dateDate = Calendar.current.date(byAdding: .day, value: 1, to: dateDate)!
        }
        
        dueDateDatePicker.date = dateDate
        upDueDateLabel(date: dateDate)
        
        // 設定導航欄按鈕
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style: .done, target: self, action: #selector(saveAction))
        
        // 設定表格視圖為靜態樣式
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 1
        default :
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // 移除cell內所有subview
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        switch indexPath.section {
            
        // MARK: - complete Button & title Textfield
        case 0:
            isCompleteButton.translatesAutoresizingMaskIntoConstraints = false
            titleTextField.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(isCompleteButton)
            cell.contentView.addSubview(titleTextField)
            
            titleTextField.placeholder = "記得要..."
            isCompleteButton.setImage(UIImage(systemName: "circle"), for: .normal)
            
            
            NSLayoutConstraint.activate([
                isCompleteButton.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 1),
                isCompleteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                isCompleteButton.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.1),
                isCompleteButton.heightAnchor.constraint(equalTo: isCompleteButton.widthAnchor, multiplier: 1),
                
                titleTextField.leadingAnchor.constraint(equalTo: isCompleteButton.trailingAnchor, constant: 20),
                titleTextField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            ])
            
        // MARK: - note ImageView
        case 1:
            noteImageView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(noteImageView)
            
            noteImageView.contentMode = .scaleAspectFit
            noteImageView.image = UIImage(systemName: "photo.badge.plus")
            
            NSLayoutConstraint.activate([
                noteImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                noteImageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                noteImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                noteImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            ])
            
        // MARK: - static Date Label, due Date Label & due datePicker
        case 2:
            // static Date Label, due Date Label
            if indexPath.row == 0 {
                staticDateLabel.text = "日期"
                staticDateLabel.translatesAutoresizingMaskIntoConstraints = false
                dueDateLabel.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(staticDateLabel)
                cell.contentView.addSubview(dueDateLabel)
                
                NSLayoutConstraint.activate([
                    staticDateLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
                    staticDateLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                    
                    
                    dueDateLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
                    dueDateLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
                ])
            } else {
                //  due datePicker
                dueDateDatePicker.preferredDatePickerStyle = .wheels
                dueDateDatePicker.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(dueDateDatePicker)
                
                NSLayoutConstraint.activate([
                    dueDateDatePicker.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    dueDateDatePicker.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                    dueDateDatePicker.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                    dueDateDatePicker.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                ])
                
                
            }
            
        // MARK: - notes TextView
        case 3:
            notesTextView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(notesTextView)
            
            notesTextView.font = .systemFont(ofSize: 18)
            notesTextView.text = "memo something"
            
            NSLayoutConstraint.activate([
                notesTextView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                notesTextView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                notesTextView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
                notesTextView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                
            ])
            
        default:
            break
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
            
        case buttonTextfieldIndexPath:
            return 45
        case imageViewIndexPath:
            return 200
        case dateDateLabelIndexPath:
            return 45
        case dueDatePickerIndexPath where isDatePickerHidden == true:
            return 0
        case textViewIndexPath:
            return 100
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case buttonTextfieldIndexPath:
            return 45
        case imageViewIndexPath:
            return 200
        case dateDateLabelIndexPath:
            return 45
        case dueDatePickerIndexPath where isDatePickerHidden == true:
            return 210
        case textViewIndexPath:
            return 100
        default:
            return UITableView.automaticDimension
        }
    }
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == dateDateLabelIndexPath {
            isDatePickerHidden.toggle()
            upDueDateLabel(date: dueDateDatePicker.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        } else if indexPath == imageViewIndexPath {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true)
        }
    }

    
    
    
    func upDueDateLabel(date: Date) {
        
        dueDateLabel.text = date.formatted(.dateTime.month(.defaultDigits).day().year(.twoDigits).hour().minute())
        
    }
    
    
    
    @objc func saveAction() {
        // 儲存按鈕的動作
    }
    
    
    
    @objc func cancelAction() {
        // 取消按鈕的動作
    }
    
    
    
    
}



// MARK: - Extension PHPicker
extension ToDoDetailTableViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvides = results.map(\.itemProvider)
        if let itemProvider = itemProvides.first, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            let previousImage = self.noteImageView.image
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage, self.noteImageView.image == previousImage else { return }
                    self.noteImageView.image = image
                    
                }
            }
            
        }
        
    }
}
