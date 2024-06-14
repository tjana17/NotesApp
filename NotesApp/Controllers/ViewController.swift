//
//  ViewController.swift
//  NotesApp
//
//  Created by Jana's MacBook Pro on 6/10/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getStartedTapped(_ sender: UIButton) {
        //Presenting the Notes List VC
        let controller = storyboard?.instantiateViewController(withIdentifier: NotesListVC.identifier) as! NotesListVC
        let navVC = UINavigationController(rootViewController: controller)
        navVC.modalPresentationStyle = .fullScreen
        navVC.navigationBar.prefersLargeTitles = true
        self.present(navVC, animated: true)
        
    }

}

