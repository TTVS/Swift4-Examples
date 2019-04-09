//
//  Extensions.swift
//  Swift4-Examples
//
//  Created by Terranz on 9/4/19.
//  Copyright © 2019 Terra Dev. All rights reserved.
//

import UIKit
import AVFoundation

extension UIColor {
    // MARK: - Convenience method for calling rgb
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
        return UIColor.init(r: red, g: green, b: blue, a: alpha)
    }
}

extension UIView {
    
    // MARK: - Convinience method to set constraints with visual format
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIImage {
    
    // MARK: - Used to scale size of UIImages
    func scaleTo(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension URL {
    
    // MARK: - Provide URL details
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
    
    
    // MARK: - Video Compression
    // eg. AVAssetExportPresetLowQuality
    func compressVideoWithUrl(inputUrl: URL, outputUrl: URL, compressionQuality: String, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputUrl, options: nil)
        
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: compressionQuality) else {
            
            handler(nil)
            return
        }
        
        exportSession.outputURL = outputUrl
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}


// MARK: - Cache images object
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    // MARK: Cache images and load from cache using url string
    func loadImageUsingCacheWithUrlString(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        self.image = nil
        
        // check if image exist in cache before requesting
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // otherwise fire off a new download
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async {
                
                if data == nil {
                    print("imageData is nil")
                    return
                }
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
            
        }).resume()
    }
}
