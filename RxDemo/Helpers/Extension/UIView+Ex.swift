//
//  UIView+Ex.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/9.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation

extension UIView {
    //将当前视图转为UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
