//
//  ToDoTableViewController.swift
//  TableViewPratice-2
//
//  Created by Howe on 2024/2/20.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    // 用於儲存待辦事項的陣列
    var toDos = [ToDo]()
    
    // 視圖加載後的初始化工作
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 嘗試從持久化存儲加載待辦事項，如果沒有則加載示例待辦事項
        if let savedToDos = ToDo.loadToDos() {
            toDos = savedToDos
        } else {
            toDos = ToDo.loadSampleToDos()
        }
        
        // 設定導航條
        navigationSetting()
        
        // 註冊自定義待辦事項單元格
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.reuseIdentifier)
    }
    
    // MARK: - Table view data source
    
    // 設定表格只有一個區段
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // 設定表格的行數等於待辦事項的數量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    
    // 配置每一行的單元格
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 嘗試重用單元格，如果失敗則觸發錯誤
        guard let ToDoCell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.reuseIdentifier, for: indexPath) as? ToDoTableViewCell else { fatalError("dequeueReusable failed") }
        
        // 獲取對應行的待辦事項
        let toDo = toDos[indexPath.row]
        
        // 設定單元格標題和完成狀態
        ToDoCell.titleLabel.text = toDo.title
        ToDoCell.delegate = self
        ToDoCell.isCompleteButton.isSelected = toDo.isComplete
        
        // 更新完成按鈕的圖像
        ToDoCell.updateCompleteButtonImage()
        
        return ToDoCell
    }
    
    
    
    // MARK: - Editing
    // 啟用表格行的編輯模式，允許刪除或重新排序
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // 處理表格行的編輯操作，目前支持刪除操作
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 當用戶試圖刪除一行時
        if editingStyle == .delete {
            // 從數據源中移除該待辦事項
            toDos.remove(at: indexPath.row)
            // 從表格視圖中移除該行
            tableView.deleteRows(at: [indexPath], with: .fade)
            // 更新持久化存儲中的待辦事項
            ToDo.saveToDos(toDos)
        }
    }
    
    
    
    // MARK: - Reordering
    // 允許用戶重新排序表格行
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        // 獲取被移動的待辦事項
        let movedToDo = toDos.remove(at: fromIndexPath.row)
        // 將它插入到新位置
        toDos.insert(movedToDo, at: to.row)
        // 更新表格視圖以反映新順序
        tableView.moveRow(at: fromIndexPath, to: to)
        
        // 更新持久化存儲中的待辦事項
        ToDo.saveToDos(toDos)
    }
    
    
    // 啟用對所有行的重新排序功能
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // 設定表格每一行的高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // 固定行高為 50 點
    }
    
    
    // 處理表格行的選擇事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 當某一行被選擇時，創建一個詳細視圖控制器來顯示或編輯該待辦事項的詳細資料
        let detailViewController = ToDoDetailTableViewController(style: .grouped)
        
        // 設定詳細視圖控制器的代理為自己，以便於接收更新後的待辦事項
        detailViewController.delegate = self
        
        // 將被選中的待辦事項傳遞給詳細視圖控制器
        detailViewController.toDo = toDos[indexPath.row]
        
        // 將詳細視圖控制器推送到導航控制器堆棧中，實現畫面轉換
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
    // MARK: - Navigation
    // 設定導航條的外觀和按鈕
    func navigationSetting() {
        
        // 設置左上角的編輯按鈕，由系統提供的 editButtonItem 自動處理切換編輯模式
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // 設置右上角的新增按鈕，點擊後會調用 addNewNoteButtonTap 方法
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNoteButtonTap))
        
        // 設置導航欄使用大標題
        navigationController?.navigationBar.prefersLargeTitles = true
        // 設置大標題顯示模式為始終顯示
        navigationItem.largeTitleDisplayMode = .always
        // 設置導航項目的標題為“提醒清單”
        navigationItem.title = "提醒清單"
        
    }
    
    
    // 當用戶點擊新增按鈕時調用的方法
    @objc func addNewNoteButtonTap() {
        
        // 創建一個新的 ToDoDetailTableViewController 來讓用戶新增待辦事項
        let detailViewController = ToDoDetailTableViewController(style: .grouped)
        
        // 設定詳細視圖控制器的代理為自己，以便於接收更新後的待辦事項
        detailViewController.delegate = self
        
        // 將詳細視圖控制器推送到導航控制器堆棧中，實現畫面轉換
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
    
}



// MARK: - ToDoTableViewCellDelegate
// 擴展 ToDoTableViewController 以實現 ToDoTableViewCellDelegate 協定
extension ToDoTableViewController: ToDoTableViewCellDelegate {
    // 當待辦事項單元格中的勾選標記被點擊時調用
    func checkmarkTapped(sender: ToDoTableViewCell) {
        // 獲取發送事件的單元格對應的索引路徑
        if let indexPath = tableView.indexPath(for: sender) {
            // 獲取並更新待辦事項的完成狀態
            var toDo = toDos[indexPath.row]
            toDo.isComplete.toggle() // 切換完成狀態
            toDos[indexPath.row] = toDo
            // 重新加載該行，以更新顯示
            tableView.reloadRows(at: [indexPath], with: .automatic)
            // 保存更新後的待辦事項列表
            ToDo.saveToDos(toDos)
        }
    }
}



// MARK: - ToDoDetailTableViewControllerDelegate
// 擴展 ToDoTableViewController 以實現 ToDoDetailTableViewControllerDelegate 協定
extension ToDoTableViewController: ToDoDetailTableViewControllerDelegate {
    // 待辦事項詳細資料視圖控制器保存後調用
    func toDoDetailTableViewControllerDidSave(_ toDo: ToDo) {
        // 檢查待辦事項是否已存在於列表中
        if let index = toDos.firstIndex(of: toDo) {
            // 如果已存在，則更新該待辦事項
            toDos[index] = toDo
        } else {
            // 如果不存在，則添加到列表中
            toDos.append(toDo)
        }
        // 保存更新後的待辦事項列表
        ToDo.saveToDos(toDos)
        // 重新加載表格以顯示最新的數據
        tableView.reloadData()
    }
}

/*
 這裡的註解解釋了 ToDoTableViewController
 如何處理來自待辦事項單元格（ToDoTableViewCell）的委派事件，特別是當用戶點擊勾選標記時。
 它也說明了如何響應待辦事項詳細視圖控制器（ToDoDetailTableViewController）中的保存事件，
 包括更新現有待辦事項或添加新待辦事項到列表中，並重新加載表格視圖來反映變化。
 */
