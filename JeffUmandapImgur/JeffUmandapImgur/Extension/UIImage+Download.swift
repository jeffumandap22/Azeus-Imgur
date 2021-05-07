//
//  UIImage+Download.swift
//  JeffUmandapImgur
//
//  Created by Jeff Umandap on 5/5/21.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// Loads the image from the url string asynchrously, and populates image
    ///
    /// - Parameter urlString: url for the image
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "Unknown error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }
    
    
}
