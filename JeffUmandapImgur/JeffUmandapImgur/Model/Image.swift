//
//  Image.swift
//  JeffUmandapImgur
//
//  Created by Jeff Umandap on 5/5/21.
//

import Foundation
import UIKit

struct ImgResponse : Codable {
    let data:[Image]?
}

struct Image : Codable {
    
    let id:String?
    let link:String?
    let title:String?
    let cover:String?
    let isAlbum:Bool?
    
    var imageURL:String {
        get {
            if let isAlbum = isAlbum, isAlbum, let cover = cover {
                return "http://i.imgur.com/\(cover).png"
            } else if let id = id {
                return "http://i.imgur.com/\(id).png"
            } else {
                return "http://www.stleos.uq.edu.au/wp-content/uploads/2016/08/image-placeholder-350x350.png"
            }
        }
    }
    
}


//PDF
struct Pdf {
    var filename: String
    var description: String
}

enum ViewMode {
    case AlbumSearch
}

class SearchViewModel {
    
    var images:[Image] = []
    let imgurAPI:ImgurApi = ImgurApi()
    
    var albumsCount:Int {
        get {
            return images.count
        }
    }
    
    func getImage(at index:Int) -> Image?  {
        return index < (images.count - 2)  ? images[index] : nil
    }
    
    func fetchAlbums(withQuery query:String, perPage:Int, onCompletion:@escaping ()->Void, onError:@escaping (Error)->Void) {
        
        self.imgurAPI.getAlbums( withSearchText: query,perPage: perPage, onCompletion: { [weak self] images in
            
            if let images = images {
                DispatchQueue.main.async {
                    self?.images = images
                    onCompletion()
                }
            }
        }) { error in
            onError(error)
        }
    }
    
    
}
