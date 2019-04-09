//
//  Extensions.swift
//  Swift4-Examples
//
//  Created by Terranz on 9/4/19.
//  Copyright © 2019 Terra Dev. All rights reserved.
//

import UIKit

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
