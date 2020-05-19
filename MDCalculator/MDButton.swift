//
//  MDButton.swift
//  MDCalculator
//
//  Created by Gavin on 2020/5/15.
//  Copyright © 2020 LRanger. All rights reserved.
//

import UIKit

class MDButton: UIButton {

    open class func buttonWith(image: UIImage?, hightlightImage: UIImage?) -> MDButton {
        return MDButton.init(image: image, hightlightImage: hightlightImage)
    }
    
    public convenience init(image: UIImage?, hightlightImage: UIImage?) {
        self.init(frame: CGRect.zero)
        self.setImage(image, for: .normal)
        self.setImage(hightlightImage, for: .highlighted)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

