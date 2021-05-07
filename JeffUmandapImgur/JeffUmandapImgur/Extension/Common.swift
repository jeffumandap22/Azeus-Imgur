//
//  Common.swift
//  JeffUmandapImgur
//
//  Created by Jeff Umandap on 5/5/21.
//

import Foundation
import UIKit

public class Common: NSObject {

    static func quickAlert(_ vc:UIViewController, mtitle:String, message:String, onDone: (()->())?){
        let alert = UIAlertController(title: mtitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
            if let onDone = onDone{
                onDone()
            }
        }
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }


}

extension UIViewController {
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)
    }
}
