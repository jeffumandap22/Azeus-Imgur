//
//  MainController.swift
//  JeffUmandapImgur
//
//  Created by Jeff Umandap on 5/5/21.
//

import Foundation

import UIKit
import Foundation

protocol MainControllerDelegate: class {
    //
}

extension MainController: MainControllerDelegate {
    //
}

class MainController: UIViewController {
    
    var screenNavigationDelegate: ScreenNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? ScreenNavigation, segue.identifier == "ScreenNavigation" {
            //
        }
        
    }
    
}
