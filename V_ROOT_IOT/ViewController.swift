//
//  ViewController.swift
//  V_ROOT_IOT
//
//  Created by Alex Vihlayew on 2/17/18.
//  Copyright © 2018 Alex Vihlayew. All rights reserved.
//

import UIKit
import Auk

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollViews: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!

    var visit: Visit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondLabel?.text = visit?.date.stringRepresentation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var facesCount = 0
        
        visit?.photos.forEach({ (image) in
            let detectedImage = detectFacesAndCalculate(onImage: image)
            scrollViews.auk.show(image: detectedImage.0)
            facesCount = (detectedImage.1 > facesCount) ? detectedImage.1 : facesCount
        })
        
        titleLabel.text = "You had a new visit with \(facesCount) guests at:"
    }
    
    func detectFacesAndCalculate(onImage: UIImage) -> (UIImage, Int) {
        let personPic = UIImageView(frame: CGRect(origin: CGPoint.zero, size: onImage.size))
        personPic.image = onImage
        let personciImage = CIImage(image: onImage)!
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)!
        let faces = faceDetector.features(in: personciImage)
        
        // For converting the Core Image Coordinates to UIView Coordinates
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        for face in faces as! [CIFaceFeature] {
            
            print("Found bounds are \(face.bounds)")
            
            // Apply the transform to convert the coordinates
            var faceViewBounds = face.bounds.applying(transform)
            
            // Calculate the actual position and size of the rectangle in the image view
            let viewSize = personPic.bounds.size
            let scale = min(viewSize.width / ciImageSize.width,
                            viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            let faceBox = UIView(frame: faceViewBounds)
            
            faceBox.layer.borderWidth = 6
            faceBox.layer.borderColor = UIColor.red.cgColor
            faceBox.backgroundColor = UIColor.clear
            personPic.addSubview(faceBox)
        }
        
        UIGraphicsBeginImageContextWithOptions(personPic.bounds.size, personPic.isOpaque, 0.0)
        personPic.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return (image!, faces.count)
    }

    @IBAction func share(_ sender: UIBarButtonItem) {
        let activityVC = UIActivityViewController(activityItems:[self.visit!.photos.first!, self.visit!.date.stringRepresentation()], applicationActivities:nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
}

