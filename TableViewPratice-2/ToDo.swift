//
//  ToDo.swift
//  TableViewPratice-2
//
//  Created by Howe on 2024/2/20.
//

import Foundation



struct ToDo: Equatable, Codable {
    let id: UUID
    var title: String
    var isComplete: Bool
    var imageName: String?
    var dueDate: Date
    var notes: String?
    
    
    init(title: String, imageName: String?, isComplete: Bool, dueDate: Date, notes: String?) {
        self.id = UUID()
        self.title = title
        self.imageName = imageName
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
    
    
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentDirectory.appendingPathComponent("toDos").appendingPathExtension("plist")
    
    
    static func saveToDos(_ toDos: [ToDo]) {
        
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(toDos)
        
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
        
    }
    
    
    static func loadToDos() -> [ToDo]? {
        
        guard let codedToDos = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        
        return try? propertyListDecoder.decode([ToDo].self, from: codedToDos)
        
    }
    
    
    static func loadSampleToDos() -> [ToDo] {
        
        let toDo1 = ToDo(title: "To-DO 1", imageName: "", isComplete: false, dueDate: Date(), notes: "note1")
        let toDo2 = ToDo(title: "To-DO 2", imageName: "", isComplete: false, dueDate: Date(), notes: "note2")
        let toDo3 = ToDo(title: "To-DO 3", imageName: "", isComplete: false, dueDate: Date(), notes: "note3")
        
        return [toDo1, toDo2, toDo3]
        
    }
    
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }
    
}
