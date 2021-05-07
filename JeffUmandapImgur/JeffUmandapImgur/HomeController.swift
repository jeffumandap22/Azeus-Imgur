//
//  ViewController.swift
//  JeffUmandapImgur
//
//  Created by Jeff Umandap on 5/5/21.
//

import UIKit
import Foundation
import PDFKit

protocol HomeControllerDelegate: class {
    func setPdfData(data: String?)
    func setImageData(data: Image?)
}

extension HomeController: HomeControllerDelegate {
    func setPdfData(data: String?) {
        self.detailViewShow(data: data)
    }
    
    func setImageData(data: Image?) {
        self.detailViewShow(data: data)
    }
}

class HomeController: UIViewController, UIScrollViewDelegate {
    
    var screenNavigationDelegate: ScreenNavigationDelegate?
    var mainControllerDelegate: MainControllerDelegate?
    
    private var model = SearchViewModel()
    private var shouldPresentTextSearch:Bool = true
    
    @IBOutlet weak var tableViewRows: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var viewPDF: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pdfView: PDFView? = nil
    var dataName: String?
    var image:Image?
    var isPdf: Bool = false
    
    var viewMode = ViewMode.AlbumSearch
   
    var pdf: [Pdf] = []
    var temporaryData: [Pdf] = []
    var elementName: String = String()
    var filename = String()
    var desc = String()
    
    var imageCount: Int?
    var willRetrieveImages: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenNavigationDelegate?.setHomeDelegate(homeDelegate: self)
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.delegate = self
        
        searchTxt.delegate = self
        tableViewRows.dataSource = self
        tableViewRows.delegate = self

        tableViewRows.rowHeight = UITableView.automaticDimension
        tableViewRows.register(UINib(nibName: "NameCell", bundle: nil), forCellReuseIdentifier: "NameCell")
        
        xmlParse()
    }
    
    func xmlParse() {
        if let path = Bundle.main.url(forResource: "contents", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            detailView.isHidden = false
            viewDidLayoutSubviews()
        } else {
            print("Portrait")
            detailView.isHidden = true
            viewDidLayoutSubviews()
        }
    }
    
    func detailViewShow(data: String?){
        imageView.image = nil
        initPDF()
        initDocument(name: data)
        viewDidLayoutSubviews()
    }
    
    func detailViewShow(data: Image?){
        for view in self.viewPDF.subviews {
            view.removeFromSuperview()
        }
        if let image = data {
            imageView.isHidden = false
            imageView.imageFromServerURL(urlString: image.imageURL)
        }
        viewDidLayoutSubviews()
    }
    
    private func initPDF() {
        pdfView = PDFView(frame: viewPDF.bounds)
        pdfView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewPDF.addSubview(pdfView!)
        pdfView?.autoScales = true
    }
    
    private func initDocument(name: String?) {
        let fileURL = Bundle.main.url(forResource: name?.replacingOccurrences(of: ".pdf", with: ""), withExtension: "pdf")
        if fileURL != nil {
            pdfView?.document = PDFDocument(url: fileURL!)
        } else {
            Common.quickAlert(self, mtitle: "Error", message: "File not found", onDone: nil)
        }
    }


}



extension HomeController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "pdf-item" {
            filename = String()
            desc = String()
        }

        self.elementName = elementName
        
        if elementName == "image-list"{
            self.imageCount = Int(attributeDict["image_count"] ?? "")
            self.willRetrieveImages = Bool(attributeDict["retrieve_images"] ?? "") ?? false 
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "pdf-item" {
            let data = Pdf(filename: filename, description: desc)
            pdf.append(data)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "filename" {
                filename += data
            } else if self.elementName == "description" {
                desc += data
            }
        }
    }
    
}


extension HomeController : UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pdf.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") as! NameCell
        
        if (indexPath.row < pdf.count) {
            let data = pdf[indexPath.row]
            cell.nameLabel.text = "\(data.filename)"
            cell.descLabel.text = data.description
        } else {
            cell.nameLabel.text = "Dummy Row"
            cell.nameLabel.textColor = .lightGray
            cell.descLabel.text  = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if detailView.isHidden {
            if (indexPath.row < pdf.count) {
                let data = pdf[indexPath.row]
                if data.filename.contains(".pdf") {
                    screenNavigationDelegate?.loadPDF(pdfName: data.filename)
                } else {
                    if let image = model.getImage(at: indexPath.row - 2) {
                        screenNavigationDelegate?.loadImage(image: image)
                    }
                }
            }  else {
                screenNavigationDelegate?.loadPDF(pdfName: "Dummy")
            }
            
        } else {
            
            let data = pdf[indexPath.row]
            if data.filename.contains(".pdf") {
                detailViewShow(data: data.filename)
            } else {
                if let image = model.getImage(at: indexPath.row - 2) {
                    detailViewShow(data: image)
                }
            }
        }
        
    }
    
    
}



extension HomeController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        if willRetrieveImages { //If "retrieve_images" xml parameter is set to true
            if let searchQuery = textField.text {
                self.pdf.removeAll()
                self.temporaryData.removeAll()
                self.xmlParse()
                model.fetchAlbums(withQuery: searchQuery, perPage: self.imageCount ?? 0) {
                    for img in self.model.images {
                        let data = Pdf(filename: img.title ?? "", description: img.link ?? "")
                        self.temporaryData.append(data)
                    }
                    self.pdf.append(contentsOf: self.temporaryData)
                    self.tableViewRows.reloadData()
                } onError: { (error) in
                    print("Error fetching albums")
                    Common.quickAlert(self, mtitle: "Error", message: error.localizedDescription, onDone: nil)
                }
            }
        }
    }
    

}
