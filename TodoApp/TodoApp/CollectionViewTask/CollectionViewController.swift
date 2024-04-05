import Foundation
import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let apiClient = APIClient()
    var tasks: [TaskResponse] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func createTaskButtonTapped(_ sender: UIButton) {
        // Crear un objeto CreateTaskRequest con los datos de los UITextField
          guard let description = description.text, !description.isEmpty else {
            // Manejar caso en que los campos estén vacíos
            return
        }
        
        let createTaskRequest = CreateTaskRequest(title: title ?? "Otra tarea", description: description)
        
        // Enviar la solicitud a través de la API
        CollectionViewController.apiClient.createTask(request: createTaskRequest) { result in
            switch result {
            case .success(let task):
                // Actualizar  CollectionView con los datos de la nueva tarea
                tasks.append(task)
                collectionView.reloadData()
            case .failure(let error):
                // Manejar error
                print("Error creating task: \(error)")
            }
        }
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        // Configura la celda con los datos de la tarea correspondiente
        let task = tasks[indexPath.item]
        cell.Description.text = tasks.description
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
}


