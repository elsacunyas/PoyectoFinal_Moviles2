//
//  ToDoItemManager.swift
//  proyecto-damii
//
//  Created by Analia Fiestas Calle on 04/12/24.
//
import UIKit

class ToDoItemManager {
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }
    
    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()
    
    // Ruta al archivo .plist en el directorio de documentos
    var toDoPathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {
            fatalError("Algo salió mal. No se pudo encontrar la URL de los documentos")
        }
        return documentURL.appendingPathComponent("toDoItems.plist")
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        
        // Cargar datos desde el archivo .plist al inicializar
        loadToDoItems()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }
    
    @objc func save() {
        // Crear un array de diccionarios desde los elementos
        let nsToDoItems = toDoItems.map { $0.plistDict }
        
        guard nsToDoItems.count > 0 else {
            // Si no hay elementos, eliminar el archivo .plist
            try? FileManager.default.removeItem(at: toDoPathURL)
            return
        }
        
        do {
            // Serializar a formato Property List (.plist)
            let plistData = try PropertyListSerialization.data(
                fromPropertyList: nsToDoItems,
                format: .xml,
                options: 0
            )
            // Escribir los datos al archivo
            try plistData.write(to: toDoPathURL, options: .atomic)
            print("Datos guardados correctamente en: \(toDoPathURL)")
        } catch {
            print("Error al guardar el archivo .plist: \(error.localizedDescription)")
        }
    }
    
    private func loadToDoItems() {
        // Verificar si el archivo existe antes de intentar cargarlo
        guard FileManager.default.fileExists(atPath: toDoPathURL.path) else {
            print("Archivo .plist no encontrado, comenzando con una lista vacía.")
            print("Ruta del archivo .plist: \(toDoPathURL.path)")
            return
        }
        
        do {
            // Leer datos del archivo
            let data = try Data(contentsOf: toDoPathURL)
            if let nsToDoItems = try PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            ) as? [[String: Any]] {
                // Convertir los diccionarios en objetos ToDoItem
                for dict in nsToDoItems {
                    if let toDoItem = ToDoItem(dict: dict) {
                        toDoItems.append(toDoItem)
                    }
                }
                print("Datos cargados correctamente desde: \(toDoPathURL)")
            }
        } catch {
            print("Error al cargar el archivo .plist: \(error.localizedDescription)")
        }
    }
    
    func add(_ item: ToDoItem) {
        toDoItems.append(item)
        NotificationCenter.default.post(name: .newItemAdded, object: nil)
    }
    
    func item(at index: Int) -> ToDoItem {
        return toDoItems[index]
    }
    
    func doneItem(at index: Int) -> ToDoItem {
        return doneItems[index]
    }
    
    func checkItem(at index: Int) {
        let checkedItem = toDoItems.remove(at: index)
        doneItems.append(checkedItem)
    }
    
    func uncheckItem(at index: Int) {
        let uncheckedItem = doneItems.remove(at: index)
        toDoItems.append(uncheckedItem)
    }
    
    func removeAll() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }
}
