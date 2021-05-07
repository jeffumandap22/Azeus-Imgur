//
//  DetailView.swift
//  JeffUmandapImgur
//
//  Created by Jeff Umandap on 5/5/21.
//

import Foundation
import UIKit
import PDFKit


class DetailView: UIViewController, UIScrollViewDelegate {
    
    var mainControllerDelegate: MainControllerDelegate?
    var screenNavigationDelegate: ScreenNavigationDelegate?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var viewPDF: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pdfView: PDFView? = nil
    var dataName: String?
    var image:Image?
    var isPdf: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.delegate = self
        
        if isPdf {
            initPDF()
            initDocument(name: dataName)
        } else {
            if let image = image {
                screenNavigationDelegate?.setHomeImage(image: image)
                imageView.isHidden = false
                imageView.imageFromServerURL(urlString: image.imageURL)
            }
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        self.screenNavigationDelegate?.pop()
    }
    
    private func initPDF() {
        pdfView = PDFView(frame: viewPDF.bounds)
        pdfView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewPDF.addSubview(pdfView!)
        pdfView?.autoScales = true
    }
    
    private func initDocument(name: String?) {
        screenNavigationDelegate?.setHomePdf(name: name)
        let fileURL = Bundle.main.url(forResource: name?.replacingOccurrences(of: ".pdf", with: ""), withExtension: "pdf")
        if fileURL != nil {
            pdfView?.document = PDFDocument(url: fileURL!)
        } else {
            Common.quickAlert(self, mtitle: "Error", message: "File not found", onDone: nil)
        }
    }
    
    func hideButton(isHidden: Bool) {
        closeButton.isHidden = isHidden
    }

}
