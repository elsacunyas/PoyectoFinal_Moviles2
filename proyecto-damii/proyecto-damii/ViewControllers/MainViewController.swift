//
//  MainViewController.swift
//  proyecto-damii
//
//  Created by Analia Fiestas Calle on 12/12/24.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func exitButton(_ sender: Any) {
        if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
              let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
              sceneDelegate?.window?.rootViewController = loginViewController
              sceneDelegate?.window?.makeKeyAndVisible()
          }
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
