//
//  ToDo.swift
//  TableViewPratice-2
//
//  Created by Howe on 2024/2/20.
//

import Foundation



struct ToDO: Equatable, Codable {
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
    
    
    static func saveToDos(_ toDos: [ToDO]) {
        
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(toDos)
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
        
    }
    
    
    static func loadToDos() -> [ToDO]? {
        
        guard let codedToDos = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        
        return try? propertyListDecoder.decode([ToDO].self, from: codedToDos)
        
    }
    
    
    static func loadSampleToDos() -> [ToDO] {
        
        let toDo1 = ToDO(title: "To-DO 1", imageName: "", isComplete: false, dueDate: Date(), notes: "note1")
        let toDo2 = ToDO(title: "To-DO 2", imageName: "", isComplete: false, dueDate: Date(), notes: "note2")
        let toDo3 = ToDO(title: "To-DO 3", imageName: "", isComplete: false, dueDate: Date(), notes: "note3")
        
        return [toDo1, toDo2, toDo3]
        
    }
    
    
    static func ==(lhs: ToDO, rhs: ToDO) -> Bool {
        return lhs.id == rhs.id
    }
    
}
