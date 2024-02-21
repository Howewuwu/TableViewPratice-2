//
//  ToDoTableViewController.swift
//  TableViewPratice-2
//
//  Created by Howe on 2024/2/20.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    var toDos = [ToDO]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
        
        if let saveToDos = ToDO.loadToDos(){
            toDos = saveToDos
            if toDos.count == 0 { toDos = ToDO.loadSampleToDos()}
        } else {
            toDos = ToDO.loadSampleToDos()
        }
        
        
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.reuseIdentifier)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ToDoCell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.reuseIdentifier, for: indexPath) as? ToDoTableViewCell else { fatalError("dequeueReusable failed") }
        
        let toDo = toDos[indexPath.row]
        ToDoCell.titleLabel.text = toDo.title
        ToDoCell.isCompleteButton.isSelected = toDo.isComplete
        
        return ToDoCell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDO.saveToDos(toDos)
        }
    }
    
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    @objc func addButtonTap() {
        
    }
    
    
    
    
     // MARK: - Navigation
    func navigationSetting() {
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTap))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.style = .navigator
        navigationItem.title = "My To Do"
        
        
        
    }
    
    
    
     
    
}
