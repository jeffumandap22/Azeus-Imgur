//
//  ImgurApi.swift
//  JeffUmandapImgur
//
//  Created by Jeff Umandap on 5/5/21.
//

import Foundation

class ImgurApi {
    
    func getAlbums(withSearchText searchText:String, perPage:Int, onCompletion:@escaping (([Image]?)->Void), onError:@escaping (Error)->Void) {
        //NOTE:perPage parameter doesn't work
        //let query = "https://api.imgur.com/3/gallery/search?q=\(searchText)?perPage=\(perPage)"
        let query = "https://api.imgur.com/3/gallery/search?q=\(searchText)"
        imageAPIQuery(query, onCompletion, onError)
    }
    
    fileprivate func imageAPIQuery(_ query: String, _ onCompletion: @escaping (([Image]?) -> Void), _ onError: @escaping (Error) -> Void) {
        
        DataFetcher.init().getData(withQuery: query, andHeaders: [("Client-ID eea787310595c28","Authorization")], onCompletion: { data in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let responseData = try decoder.decode(ImgResponse.self, from: data)
                onCompletion(responseData.data)
            }  catch let error {
                print (error)
                onError(error)
            }
        }, onError: { error in
            onError(error)
        }
            
        )
    }
    
}
