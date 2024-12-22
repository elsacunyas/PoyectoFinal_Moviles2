//
//  DetailViewController.swift
//  proyecto-damii
//
//  Created by Analia Fiestas Calle on 09/12/24.
//

import UIKit
import MapKit
import Foundation
import CoreLocation

class DetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
     @IBOutlet var mapView: MKMapView!
     @IBOutlet var locationLabel: UILabel!
     
    var detalleTitulo: String?
    var detalleLocation: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleLabel.text = detalleTitulo
        
        locationLabel.text = detalleLocation
        
        obtenerCoordenadasDeLugar(lugar: detalleLocation!) { [weak self] coordenada in
            guard let self = self else { return }
                   
            if let coordenada = coordenada {
                self.centerMapOnLocation(with: coordenada)
            } else {
                print("No se pudieron obtener las coordenadas.")
            }
        }
        
    }
    
    /*
     override func viewDidLoad() {
       super.viewDidLoad()
       
       guard let item = item else {
         return
       }
       
       titleLabel.text = item.title
       
       if let location = item.location {
         locationLabel.text = location.name
         if let cooridnate = location.coordinate {
           centerMapOnLocation(with: cooridnate)
         }
       }
     }
     */
    
    // Función para centrar el mapa en una coordenada
    private func centerMapOnLocation(with coordinate: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 1000
        
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    // Función para obtener coordenadas de un lugar
    private func obtenerCoordenadasDeLugar(lugar: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let urlString = "https://nominatim.openstreetmap.org/search?q=\(lugar)&format=json"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al realizar la solicitud: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                   let firstResult = jsonArray.first,
                   let latString = firstResult["lat"] as? String,
                   let lonString = firstResult["lon"] as? String,
                   let lat = Double(latString),
                   let lon = Double(lonString) {
                    
                    // Crea una coordenada CLLocationCoordinate2D
                    let coordenada = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    completion(coordenada)  // Devuelve la coordenada mediante el completion handler
                } else {
                    completion(nil)  // Si no se encuentran coordenadas, pasa nil
                }
            } catch {
                print("Error al parsear la respuesta JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }

}
