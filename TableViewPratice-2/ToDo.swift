//
//  ToDo.swift
//  TableViewPratice-2
//
//  Created by Howe on 2024/2/20.
//

import Foundation

struct ToDo: Equatable, Codable {
    // 唯一標識符，每個待辦事項的唯一標識
    let id: UUID
    // 待辦事項的標題
    var title: String
    // 標示待辦事項是否已完成
    var isComplete: Bool
    // 待辦事項的截止日期
    var dueDate: Date
    // 可選的待辦事項備註
    var notes: String?
    // 可選的待辦事項圖片數據
    var imageData: Data?
    
    // 初始化函數，用於創建一個新的待辦事項實例
    init(title: String, isComplete: Bool, dueDate: Date, notes: String?, imageData: Data?) {
        self.id = UUID() // 生成一個新的UUID
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
        self.imageData = imageData
    }
    
    // 文件管理器的默認目錄，用於存儲應用數據
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    // 存儲待辦事項的文件URL
    static let archiveURL = documentDirectory.appendingPathComponent("toDos").appendingPathExtension("plist")
    
    
    
    // 靜態方法，用於保存待辦事項數組到本地文件系統
    static func saveToDos(_ toDos: [ToDo]) {
        // 創建一個PropertyListEncoder實例用於將待辦事項數組編碼成Property List格式
        let propertyListEncoder = PropertyListEncoder()
        // 嘗試編碼待辦事項數組，可能會拋出錯誤，因此使用try?
        let codedToDos = try? propertyListEncoder.encode(toDos)
        // 將編碼後的待辦事項數據寫入到指定的URL，這裡不對文件進行保護
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
    }
    
    
    // 靜態方法，用於從本地文件系統加載待辦事項數組
    static func loadToDos() -> [ToDo]? {
        // 嘗試從archiveURL讀取數據，如果失敗則返回nil
        guard let codedToDos = try? Data(contentsOf: archiveURL) else { return nil }
        // 創建一個PropertyListDecoder實例用於將Property List格式的數據解碼成待辦事項數組
        let propertyListDecoder = PropertyListDecoder()
        // 嘗試解碼數據，如果成功則返回解碼後的待辦事項數組，如果失敗則返回nil
        return try? propertyListDecoder.decode([ToDo].self, from: codedToDos)
    }
    
    
    // 靜態方法，用於創建一個示例待辦事項數組
    static func loadSampleToDos() -> [ToDo] {
        // 創建三個示例ToDo項目，用於展示或測試
        let toDo1 = ToDo(title: "To-DO 1", isComplete: false, dueDate: Date(), notes: "note1", imageData: nil)
        let toDo2 = ToDo(title: "To-DO 2", isComplete: false, dueDate: Date(), notes: "note2", imageData: nil)
        let toDo3 = ToDo(title: "To-DO 3", isComplete: false, dueDate: Date(), notes: "note3", imageData: nil)
        
        // 返回包含三個示例待辦事項的數組
        return [toDo1, toDo2, toDo3]
    }
    
    
    // 靜態方法，用於比較兩個ToDo實例是否相等
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        // 比較兩個待辦事項是否有相同的id，如果是則認為它們是相同的
        return lhs.id == rhs.id
    }
    
    
}
