//
//  MDItem.swift
//  MDCalculator
//
//  Created by Gavin on 2020/5/15.
//  Copyright © 2020 LRanger. All rights reserved.
//

import UIKit

enum MDItemType {
    case zero;
    case one;
    case two;
    case three;
    case four;
    case five;
    case six;
    case seven;
    case eight;
    case nine;
    case symbol;
    case plus;
    case minus;
    case division;
    case multiple;
    case percent;
    case equal;
    case ac;
    case dot;
}


class MDItem: NSObject {

    public var size = CGSize.zero
    private var imageName = ""
    private var highlightImageName = ""
    let type: MDItemType;
    var target: Any?
    var action: Selector?
    
    public lazy var view: MDButton = {
        let button = MDButton(image: UIImage.init(named: imageName), hightlightImage: UIImage.init(named: highlightImageName))
        return button
    }()
    
    public init(size: CGSize, type: MDItemType) {
        self.size = size
        self.type = type
        
        switch type {
        case .zero:
            imageName = "0"
            highlightImageName = "0_"
        case .one:
            imageName = "1"
            highlightImageName = "1_"
        case .two:
            imageName = "2"
            highlightImageName = "2_"
        case .three:
            imageName = "3"
            highlightImageName = "3_"
        case .four:
            imageName = "4"
            highlightImageName = "4_"
        case .five:
            imageName = "5"
            highlightImageName = "5_"
        case .six:
            imageName = "6"
            highlightImageName = "6_"
        case .seven:
            imageName = "7"
            highlightImageName = "7_"
        case .eight:
            imageName = "8"
            highlightImageName = "8_"
        case .nine:
            imageName = "9"
            highlightImageName = "9_"
        case .symbol:
            imageName = "add"
            highlightImageName = "add_"
        case .division:
            imageName = "div"
            highlightImageName = "div_"
        case .multiple:
            imageName = "x"
            highlightImageName = "x_"
        case .percent:
            imageName = "per"
            highlightImageName = "per_"
        case .equal:
            imageName = "="
            highlightImageName = "=_"
        case .ac:
            imageName = "ac"
            highlightImageName = "ac_"
        case .dot:
            imageName = "dot"
            highlightImageName = "dot_"
        case .minus:
            imageName = "-"
            highlightImageName = "-_"
        case .plus:
            imageName = "+"
            highlightImageName = "+_"
//        default:
            
        }
    }
    
    func addTarget(target: Any?, action: Selector) {
        
        self.view.addTarget(self, action: #selector(touchInSide), for: .touchUpInside)
        
        self.target = target
        self.action = action
        
    }
    
    @objc func touchInSide() {
        
        if let t = self.target as? NSObject, let a = self.action {
            t.perform(a, with: self)
        }
        
    }
    
    
}
