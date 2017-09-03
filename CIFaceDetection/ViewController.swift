//
//  ViewController.swift
//  CIFaceDetection
//
//  Created by Deepak JOSHI on 8/19/17.
// 
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
   @IBOutlet weak var eyeText: UILabel!
   @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUP()
        
    }
    
    func setUP(){
        
        let th = Bundle.main.url(forResource: "face", withExtension: "jpg")
        let url = th!.absoluteString
        let mainurl = NSURL(string : url)
        let image = CIImage(contentsOf: mainurl! as URL)
        imageView.image = UIImage(ciImage : image!)
    
        
        
        let cid = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh , CIDetectorSmile : true , CIDetectorTypeFace  : true  ] )
        
        
        let faces = cid!.features(in: image!, options: [CIDetectorSmile : true , CIDetectorEyeBlink : true , CIDetectorImageOrientation : 1])
        
       
        
        let ciImageSize = image?.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -(ciImageSize?.height)!)
        
        for face in faces as! [CIFaceFeature] {
            print("Left eye closed : \(face.leftEyeClosed)")
            print("Right eye closed : \(face.rightEyeClosed)")
            print("Left eye position : \(face.leftEyePosition)")
            print("Right eye position : \(face.rightEyePosition)")
            print("Smile : \(face.hasSmile)")
            print("Mouth position : \(face.mouthPosition)")
            print("Number of faces : \(faces.count)")
            
            eyeText.text = " Left Eye Closed = \(face.leftEyeClosed) \n Right eye closed = \(face.rightEyeClosed)\n Has Smile = \(face.hasSmile)"

            // Apply the transform to convert the coordinates
            var faceViewBounds = face.bounds.applying(transform)
            
            // Calculate the actual position and size of the rectangle in the image view
            let viewSize = imageView.bounds.size
            let scale = min(viewSize.width / (ciImageSize?.width)!,
                            viewSize.height / (ciImageSize?.height)!)
            let offsetX = (viewSize.width - (ciImageSize?.width)! * scale) / 2
            let offsetY = (viewSize.height - (ciImageSize?.height)! * scale) / 2
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            

            
            let box = UIView(frame: faceViewBounds)
            
            box.layer.borderColor = UIColor.red.cgColor
            box.layer.borderWidth = 2
            box.backgroundColor = UIColor.clear
            imageView.addSubview(box)
  
        }
    }
}

