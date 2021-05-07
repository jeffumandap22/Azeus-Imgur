//
//  ScreenNavigation.swift
//  JeffUmandapImgur
//
//  Created by Jeff Umandap on 5/5/21.
//

import Foundation
import UIKit

protocol ScreenNavigationDelegate:class {
    func loadHomeView()
    func pop()
    func loadPDF(pdfName: String?)
    func loadImage(image: Image?)
    
    func setHomePdf(name: String?)
    func setHomeImage(image: Image?)
    func setHomeDelegate(homeDelegate: HomeControllerDelegate?)
}


class ScreenNavigation: UINavigationController, ScreenNavigationDelegate {
    func setHomeDelegate(homeDelegate: HomeControllerDelegate?) {
        self.homeControllerDelegate = homeDelegate
    }
    
    var homeDelegate: HomeControllerDelegate?
    
    func loadPDF(pdfName: String?) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailView
        vc?.screenNavigationDelegate = self
        vc?.dataName = pdfName
        vc?.isPdf = true
        vc?.screenNavigationDelegate = self
        self.pushViewController(vc!, animated: true)
    }
    
    func loadImage(image: Image?) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailView
        vc?.screenNavigationDelegate = self
        vc?.image = image
        vc?.isPdf = false
        vc?.screenNavigationDelegate = self
        self.pushViewController(vc!, animated: true)
    }
    
    
    func pop(){
        self.popViewController(animated: true)
    }
    
    func setHomePdf(name: String?){
        self.homeControllerDelegate?.setPdfData(data: name)
    }
    
    func setHomeImage(image: Image?){
        self.homeControllerDelegate?.setImageData(data: image)
    }
    
    var homeVC: HomeController?
    var homeControllerDelegate: HomeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHomeView()
    }
    
    var image: Image?
    var pdf: String?
    
    func loadHomeView(){
        if let _ = homeVC {
            //
        } else {
            homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeController") as? HomeController
        }
        
        homeVC?.screenNavigationDelegate = self
        self.pushViewController(homeVC!, animated: true)
    }
    
    
    
}
