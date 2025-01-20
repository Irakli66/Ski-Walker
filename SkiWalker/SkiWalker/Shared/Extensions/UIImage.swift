//
//  UIImage.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 20.01.25.
//
import UIKit

extension UIImageView{
    func imageFrom(url:URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data:data){
                    DispatchQueue.main.async{
                        self?.image = image
                    }
                }
            }
        }
    }
}
