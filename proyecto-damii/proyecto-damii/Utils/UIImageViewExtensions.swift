//
//  UIImageViewExtensions.swift
//  proyecto-damii
//
//  Created by Elsa on 14/12/24.
//
import UIKit

extension UIImageView {
    func load(urlString: String, size: CGSize? = nil, cornerRadius: CGFloat = 0) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        var finalImage = image
                        if let size = size {
                            finalImage = image.resize(to: size)
                        }
                        
                        if cornerRadius > 0 {
                            finalImage = finalImage.roundedCornerImage(with: cornerRadius)
                        }
                        
                        self?.image = finalImage
                    }
                }
            }
        }
    }
    
    func resizeImage(to size: CGSize) {
        guard let currentImage = self.image else { return }
        
        let resizedImage = currentImage.resize(to: size)
        self.image = resizedImage
    }
}

extension UIImage {
    func roundedCornerImage(with radius: CGFloat) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        
        return renderer.image { rendererContext in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            path.close()

            let cgContext = rendererContext.cgContext
            cgContext.saveGState()
            path.addClip()
            draw(in: rect)
            cgContext.restoreGState()
        }
    }
    
    func resize(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
