//
//  ToDoTableViewController.swift
//  TableViewPratice-2
//
//  Created by Howe on 2024/2/20.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    var toDos = [ToDo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let saveToDos = ToDo.loadToDos(){
            toDos = saveToDos
            print(toDos.count)
        } else {
            toDos = ToDo.loadSampleToDos()
        }
        
        
        
        navigationSetting()
        
        
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.reuseIdentifier)
        
        
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if let savedToDos = ToDo.loadToDos() {
//            toDos = savedToDos
//        }
//        tableView.reloadData()
//        print(toDos.count)
//    }
    
    
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
        ToDoCell.delegate = self
        
        return ToDoCell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(toDos)
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
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let todo = toDos[indexPath.row]
        //        let detailViewController = ToDoDetailTableViewController(style: .grouped)
        //        detailViewController.toDo = todo
        //        navigationController?.pushViewController(detailViewController, animated: true)
        
        let detailViewController = ToDoDetailTableViewController(style: .grouped)
        detailViewController.delegate = self
        detailViewController.toDo = toDos[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
        
        
    }
    
    
    
    // MARK: - Navigation
    func navigationSetting() {
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNoteButtonTap))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.style = .navigator
        navigationItem.title = "提醒清單"
        
    }
    
    
    
    @objc func addNewNoteButtonTap() {
        
        let detailViewController = ToDoDetailTableViewController(style: .grouped)
        detailViewController.delegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
    
    
}



// MARK: - extension
extension ToDoTableViewController: ToDoTableViewCellDelegate {
    func checkmarkTapped(sender: ToDoTableViewCell) {
        
        if let indexPath = tableView.indexPath(for: sender) {
            var toDo = toDos[indexPath.row]
            toDo.isComplete.toggle()
            toDos[indexPath.row] = toDo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(toDos)
        }
    }
}



extension ToDoTableViewController: ToDoDetailTableViewControllerDelegate {
    func toDoDetailTableViewControllerDidSave(_ toDo: ToDo) {
        
        if let index = toDos.firstIndex(of: toDo) {
            toDos[index] = toDo
        } else {
            toDos.append(toDo)
        }
        ToDo.saveToDos(toDos)
        tableView.reloadData()
        
        
    }
    
    
}
