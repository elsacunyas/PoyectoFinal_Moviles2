//
//  ItemListViewController.swift
//  proyecto-damii
//
//  Created by Analia Fiestas Calle on 06/12/24.
//
import UIKit
import CoreData

struct TodoItem{
    var descripcion: String?
    var locacion: String?
    var titulo: String?
}

class ItemListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: ItemListDataProvider!
      
    var todoEntidadList: [TodoItemEntity] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView.dataSource = dataProvider
        // tableView.delegate = dataProvider
        tableView.dataSource = self
        tableView.delegate = self
        listarTodos()
        
        dataProvider.itemManager = ToDoItemManager()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetails(_:)), name: Notification.ItemSelectedNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewItemAdded), name: .newItemAdded, object: nil)
    }
    
    @objc func handleNewItemAdded() {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
      }
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoEntidadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ItemCellIdentifier, for: indexPath) as! TodoItemViewCell
        
        let todoitem = todoEntidadList[indexPath.row]
        cell.titleLabel.text = todoitem.titulo
        cell.locationLabel.text = todoitem.locacion
        cell.dateLabel.text = todoitem.descripcion
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: Constants.DetailViewControllerIdentifier) as! DetailViewController
        
        vc.detalleTitulo = todoEntidadList[indexPath.row].titulo
        vc.detalleLocation = todoEntidadList[indexPath.row].locacion
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func guardarTodoItem(titulo: String? , descripcion: String?, locacion: String?) {
        if let title = titulo, let description = descripcion, let location = locacion {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistenContainer.viewContext
            let todoitem = TodoItemEntity(context: managedContext)
            todoitem.titulo = title
            todoitem.descripcion = description
            todoitem.locacion = location
            
            do {
                try managedContext.save()
                todoEntidadList.append(todoitem)
            }catch {
                print("No fue posible guardar contacto \(error), \(error)")
            }
            
            tableView.reloadData()
        }
    }
    	
    func listarTodos(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistenContainer.viewContext
        
        do{
            let results = try managedContext.fetch(TodoItemEntity.fetchRequest())
            todoEntidadList = results as! [TodoItemEntity]
        }
        catch let error as NSError{
            print("No fue posible guardar los datos")
        }
        
        tableView.reloadData()
        
    }
    
    @objc func showDetails(_ sender: Notification) {
        
        /*guard let index = sender.userInfo?["index"] as? Int else {
          fatalError()
        }
        
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: Constants.DetailViewControllerIdentifier) as? DetailViewController,
          let itemManager = dataProvider.itemManager {
          
          guard index < itemManager.toDoCount else {
            return
          }
          
          nextViewController.item = itemManager.item(at: index)
            
          navigationController?.pushViewController(nextViewController, animated: true)
        }*/
      }
        
      @IBAction func addItem(_ sender: UIBarButtonItem) {
          
          var tituloTextField = UITextField()
          var descripcionTextField = UITextField()
          var locacionTextField = UITextField()
          
          let alerta = UIAlertController(title: "Registrar Nota", message: "Completa todos los campos", preferredStyle: .alert)
          
          alerta.addTextField{
              alertaTextField in alertaTextField.placeholder = "Ingrese titulo"
              tituloTextField = alertaTextField
          }
          alerta.addTextField{
              alertaTextField in alertaTextField.placeholder = "Ingrese descripcion"
              descripcionTextField = alertaTextField
          }
          alerta.addTextField{
              alertaTextField in alertaTextField.placeholder = "Ingrese locacion"
              locacionTextField = alertaTextField
          }
          
          let action = UIAlertAction(title: "Registrar", style: .default, handler: {
              action in
              let titulo = tituloTextField.text
              let descripcion = descripcionTextField.text
              let locacion = locacionTextField.text
              self.guardarTodoItem(titulo: titulo, descripcion: descripcion, locacion: locacion)
          })
          
          alerta.addAction(action)
          
          alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
          
          present(alerta, animated: true, completion: nil)
          
     //   guard let inputViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController else {
     //     return
     //   }
     //   inputViewController.itemManager = dataProvider.itemManager
     //             present(inputViewController, animated: true, completion: nil)
      }
}
