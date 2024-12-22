//
//  LoginViewController.swift
//  proyecto-damii
//
//  Created by Analia Fiestas Calle on 12/12/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    let storedUsuario = "admin"
    let storedPassword = "12345"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        let usuario = userTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // Validar credenciales
        if usuario == storedUsuario && password == storedPassword {
            // Credenciales correctas, navegar al UITabBarController
            navigateToMainTabBarController()
        } else {
            // Credenciales incorrectas, mostrar alerta
            showAlert(title: "Error", message: "Usuario o contraseña incorrectos.")
        }
    }
    
    func navigateToMainTabBarController() {
        // Instanciar el UITabBarController desde el Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
            tabBarController.modalPresentationStyle = .fullScreen
            present(tabBarController, animated: true, completion: nil)
        } else {
            print("Error: No se pudo cargar MainTabBarController. Verifica el Storyboard ID.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
