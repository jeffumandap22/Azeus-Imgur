//
//  DataFetcher.swift
//  JeffUmandapImgur
//
//  Created by Jeff Umandap on 5/5/21.
//

import Foundation

class DataFetcher {
    
    func getData(withQuery queryStr:String, andHeaders headers:[(String,String)], onCompletion:@escaping (Data)->Void, onError:@escaping (Error)->Void) {
        
        if let url = URL(string: queryStr) {
            var request = URLRequest(url: url)
            for header in headers {
                request.addValue(header.0, forHTTPHeaderField: header.1)
            }
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, res, err)  in
                
                if let error = err {
                    onError(error)
                } else {
                
                    guard let data = data else {
                        return
                    }
                    
                    return onCompletion(data)
                }
            }).resume()
        }
    }
}
