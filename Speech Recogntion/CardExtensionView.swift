//
//  CardExtensionView.swift
//  Speech Recogntion
//
//  Created by Niks on 06/10/18.
//  Copyright © 2018 SwarajyaIT India All rights reserved.
//

import UIKit

class CardExtensionView: UIView {

    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    
    func addShadow(shadowColor: CGColor = UIColor.darkGray.cgColor,
                   shadowOffset: CGSize = CGSize(width: 3.0, height: 3.0),
                   shadowOpacity: Float = 0.5,
                   shadowRadius: CGFloat = 5.0)
    {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        
    }
    
    

}
