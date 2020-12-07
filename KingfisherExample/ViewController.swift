//
//  ViewController.swift
//  KingfisherExample
//
//  Created by Volodymyr Ostapyshyn on 05.12.2020.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var label: UILabel!
    
    let urlImage = "https://unsplash.com/photos/TIMCZe9JghI/download?force=true&w=640"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func grabImage(_ sender: UIButton) {
        guard let downloadURL = URL(string: urlImage) else { return }
        
        let resource = ImageResource(downloadURL: downloadURL)
        KingfisherManager.shared.retrieveImage(with: resource) { (result) in
            switch result {
            case .success(let retrieveImageResult):
                let image = retrieveImageResult.image
                self.mainImage.image = image
                let cacheType = retrieveImageResult.cacheType
                let source = retrieveImageResult.source
                let originalSource = retrieveImageResult.originalSource
                let message = """
                Image size:
                \(image.size)
                
                Cashe:
                \(cacheType)

                Source:
                \(source)

                Original source:
                \(originalSource)
                """
                
                print(message)
                self.label.text = message

            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    @IBAction func fetchImage(_ sender: UIButton) {
        guard let downloadURL = URL(string: urlImage) else { return }
        
        let resource = ImageResource(downloadURL: downloadURL)
        let placeholder = UIImage(named: "logo")
        let processor = RoundCornerImageProcessor(cornerRadius: 200)
        mainImage.kf.indicatorType = .activity
        mainImage.kf.setImage(with: resource, placeholder: placeholder, options: [.processor(processor)]) { (receivedSize, totalSize) in
            let percentage = (Float(receivedSize) / Float(totalSize)) * 100.0
            print("Downloading progress: \(percentage)%")
        } completionHandler: { result in
            switch result {
            case .success(let retrieveImageResult):
                let image = retrieveImageResult.image
                let cacheType = retrieveImageResult.cacheType
                let source = retrieveImageResult.source
                let originalSource = retrieveImageResult.originalSource
                let message = """
                Image size:
                \(image.size)
                
                Cashe:
                \(cacheType)

                Source:
                \(source)

                Original source:
                \(originalSource)
                """
                
                print(message)
                self.label.text = message

            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
