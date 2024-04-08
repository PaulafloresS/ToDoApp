//
//  TasksViewController.swift
//  TodoApp
//
//  Created by Ana Paula Flores on 05/04/24.
//

import UIKit

class TasksViewController: UIViewController {
    
    @IBOutlet weak var tasksCollectionView: UICollectionView!
    var endTaskFieldValue: String?
    var tasks: [TaskResponse] = []
    var creationDate : String?
    let cellId = "CollectionViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllTasks()
        tasksCollectionView.dataSource = self
        tasksCollectionView.delegate = self
        let nibCell = UINib(nibName: cellId, bundle: nil)
        tasksCollectionView.register(nibCell, forCellWithReuseIdentifier: cellId)
    }
    func getAllTasks() {
            apiClient.getAllTasks() { result in
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success(let tasks):
                        self?.tasks = tasks
                        self?.tasksCollectionView.reloadData()
                    case .failure(let err):
                        print("Error: \(err.localizedDescription)")
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
        cell.status.text = tasks[indexPath.row].state.rawValue
        cell.Description.text = tasks[indexPath.row].description
        cell.title.text = tasks[indexPath.row].title
        
        return cell
    }
}
extension TasksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let numberOfColumns: CGFloat = 1
        let spacingBetweenCells: CGFloat = 10
        let totalSpacing = (2 * spacingBetweenCells) + ((numberOfColumns - 1) * spacingBetweenCells)
        let cellWidth = (collectionViewWidth - totalSpacing) / numberOfColumns
        let cellHeight: CGFloat = 100
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
extension TasksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Obtener la tarea seleccionada
        let selectedTask = tasks[indexPath.item]
        // Crear un alerta
        let alertController = UIAlertController(title: tasks[indexPath.item].title, message: "¿Qué acción deseas realizar?", preferredStyle: .alert)
        
        // Agregar acción para "Borrar"
        let deleteAction = UIAlertAction(title: "Borrar", style: .destructive) { _ in
            self.deleteTask(with: selectedTask.id)
        }
        alertController.addAction(deleteAction)
        
        // Agregar acción para "Actualizar estado"
        let inProgressStatusAction = UIAlertAction(title: "inProgress", style: .default) { _ in
            self.updateTaskStatus(forIndex: indexPath.item, with: selectedTask.id, newStatus: .inProgress)

        }
        alertController.addAction(inProgressStatusAction)
        let completeStatusAction = UIAlertAction(title: "complete", style: .default) { _ in
            self.updateTaskStatus(forIndex: indexPath.item, with: selectedTask.id, newStatus: .complete)

        }
        alertController.addAction(completeStatusAction)
        
        // Agregar acción de cancelar
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Presentar el alerta
        present(alertController, animated: true, completion: nil)
    }
    
    // Método para borrar la tarea
    private func deleteTask(with taskId: String) {
        apiClient.deleteTask(id: taskId) { result in
            switch result {
            case .success:
                print("Tarea eliminada exitosamente")
            case .failure(let error):
                print("Error al eliminar la tarea: \(error.localizedDescription)")
            }
        }
    }
    // Método para actualizar el estado de la tarea
    private func updateTaskStatus(forIndex index: Int, with taskId: String, newStatus: TaskStatus) {
        let selectedTask = tasks[index]
        let updateRequest = UpdateTaskRequest(title: selectedTask.title, description: selectedTask.description, status: newStatus)
        apiClient.updateTask(id: taskId, newStatus: newStatus, request: updateRequest) { result in
            switch result {
            case .success(let updatedTask):
                print("Task updated successfully: \(updatedTask)")
            case .failure(let error):
                print("Error updating task: \(error.localizedDescription)")
            }
        }
    }
}
