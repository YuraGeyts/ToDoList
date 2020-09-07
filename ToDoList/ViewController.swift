//
//  ViewController.swift
//  ToDoList
//
//  Created by Yura Geyts on 07.09.2020.
//  Copyright © 2020 Yura Geyts. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate {
    
    var context: NSManagedObjectContext!
    var tasks: [Task] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    let doneImage = "checkmark.circle"
    let unDoneImage = "circle"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addTask(_ sender: Any) {
        let alertController = UIAlertController(title: "New task", message: "Enter your new task", preferredStyle: .alert)
        
        alertController.addTextField()
        
        let addTaskAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let taskName = alertController.textFields!.first!.text, !taskName.isEmpty {
                print("Task name: " + taskName)
                self.saveTask(title: taskName)
            } else {
                print("something went wrong")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(addTaskAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func saveTask(title: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        taskObject.isDone = false
        
        do {
            try context.save()
            tasks.append(taskObject)
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your task list:"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        
        let task = tasks[indexPath.row]
        cell.taskLabel.text = task.title
        
        let isTaskDone = task.isDone
        if isTaskDone {
            cell.isDoneImage.image = UIImage(systemName: doneImage)
        } else {
            cell.isDoneImage.image = UIImage(systemName: unDoneImage)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            if let tasksToDelete = try? context.fetch(fetchRequest) {
                context.delete(tasksToDelete[indexPath.row])
            }
            do {
                try context.save()
                tasks.remove(at: indexPath.row) 
                tableView.reloadData()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
