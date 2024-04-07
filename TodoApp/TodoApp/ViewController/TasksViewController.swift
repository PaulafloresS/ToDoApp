//
//  TasksViewController.swift
//  TodoApp
//
//  Created by Ana Paula Flores on 05/04/24.
//

import UIKit

class TasksViewController: UIViewController {
    
    @IBOutlet weak var tasksCollectionView: UICollectionView!
    
    var tasks: [TaskResponse] = []
    
    let cellId = "CollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tasksCollectionView.dataSource = self
        tasksCollectionView.delegate = self
        let nibCell = UINib(nibName: cellId, bundle: nil)
        tasksCollectionView.register(nibCell, forCellWithReuseIdentifier: cellId)
        apiClient.getAllTasks() { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let tasks):
                    self.tasks = tasks
                    tasksCollectionView.reloadData()
                case .failure(let err):
                    print("err")
                }
            }
        }

    }

}

extension TasksViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tasksCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCell
        cell.id.text = tasks[indexPath.row].userId
        cell.status.text = "hola"
        cell.Description.text = tasks[indexPath.row].description
        cell.creationDate.text = "hola"
        cell.deliveryDate.text = "hola"
        cell.title.text = tasks[indexPath.row].title
        return cell
    }
    
}

extension TasksViewController: UICollectionViewDelegate {
    
}
