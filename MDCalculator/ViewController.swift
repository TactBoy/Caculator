//
//  ViewController.swift
//  MDCalculator
//
//  Created by Gavin on 2020/4/16.
//  Copyright © 2020 LRanger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var items = [MDItem]()
    
    let resultLabel = UILabel()
    
    let expLabel = UILabel()
    
    let contentView = UIView()
    
    var layoutCount = 0
    
    var exps = [String]()
    
    var currentValue = ""
    
    var symbol = ""
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
    
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if layoutCount == 0 {
            
            generateItems()
            
            resultLabel.textColor = UIColor.white
            resultLabel.font = UIFont.systemFont(ofSize: 90, weight: .thin)
            resultLabel.textAlignment = .right
            resultLabel.adjustsFontSizeToFitWidth = true
            resultLabel.text = "0"
            
            expLabel.textColor = UIColor.white
            expLabel.font = UIFont.systemFont(ofSize: 30, weight: .thin)
            expLabel.textAlignment = .right
            expLabel.adjustsFontSizeToFitWidth = true
            expLabel.text = ""
            
            layoutItems()
            
            layoutCount += 1
            
        } else {
            
            layoutItems()
            
        }
    }
    
    
    @objc func touinInside(item: MDItem) {
        print("touch \(item.type)")
        
        var text = self.currentValue;
        
        switch item.type {
        case .zero:
            text = touchNumber(number: 0)
        case .one:
            text = touchNumber(number: 1)
        case .two:
            text = touchNumber(number: 2)
        case .three:
            text = touchNumber(number: 3)
        case .four:
            text = touchNumber(number: 4)
        case .five:
            text = touchNumber(number: 5)
        case .six:
            text = touchNumber(number: 6)
        case .seven:
            text = touchNumber(number: 7)
        case .eight:
            text = touchNumber(number: 8)
        case .nine:
            text = touchNumber(number: 9)
        case .symbol:
            if text.isEmpty {
                text = "0"
            }
            if text.hasPrefix("-") {
                text = text.replacingOccurrences(of: "-", with: "")
            } else {
                text = "-" + text
            }
        case .percent:
            if let v = Double(text), v != 0 {
                var value = Double(text) ?? 0
                value /= 100
                text = String.init(format: "%g", value)
            }
        case .dot:
            if text.contains(".") == false {
                if text.isEmpty {
                    text = "0"
                }
                text = text + "."
            }
        case .minus:
            self.symbol = "-"
        case .plus:
            self.symbol = "+"
        case .division:
            self.symbol = "/"
        case .multiple:
            self.symbol = "*"
        case .equal:
            if self.currentValue.isEmpty == false {
                self.exps.append(self.currentValue)
                print("exps == \(self.exps)")
            }
            let value = self.getResult()
            text = String.init(format: "%g", value)
            self.symbol = ""
            self.exps.removeAll()
        case .ac:
            text = ""
            self.symbol = ""
            self.exps.removeAll()


            //        default:

        }
        
        self.currentValue = text
        
        if text.isEmpty {
            self.resultLabel.text = "0"
        } else {
            self.resultLabel.text = text
        }
        
        if item.type != .equal {
            var exp = ""
            for ex in exps {
                exp += ex
            }
            exp += self.currentValue
            exp += self.symbol
            self.expLabel.text = exp
        }
                
        print("exps == \(self.exps)")
    }
    
    func touchNumber(number: Int) -> String {
        
        var text = self.currentValue
        
        if let v = Double(text), v == 0 {
            text = ""
        }
        
        if self.symbol.isEmpty == false {
            text = ""
            self.exps.append(self.currentValue)
            self.exps.append(self.symbol)
            self.symbol = ""
        }
        
        if number == 0 {
            if let v = Double(text), v != 0 {
                text += "0"
            }
        } else {
            text += String.init(format: "%d", number)
        }
        
        return text
        
    }
    
    func getResult() -> Double {

        var res: Double = 0
        
        let symbols: [String] = ["+", "-", "*", "/"]
        var currntSym: String = "+"
        var num = ""
        
        while exps.count > 0 {
            
            let exp = exps.first ?? ""
            
            if symbols.contains(exp) {
                
                if exp == "*" || exp == "/" {
                    
                    exps.removeFirst()
                    
                    if let nextNum = exps.first {
                        
                        exps.removeFirst()

                        var value = Double(num) ?? 0
                        let nextValue = Double(nextNum) ?? 0

                        if exp == "*" {
                            value *= nextValue
                        } else {
                            value /= nextValue
                        }
                        
                        num = String.init(format: "%g", value)
                        
                        if exps.count == 0 {
                            let value = Double(num) ?? 0
                            if currntSym == "+" {
                                res += value
                            } else {
                                res -= value
                            }
                        }
                        
                    }
                    
                } else {
                    let value = Double(num) ?? 0
                    if currntSym == "+" {
                        res += value
                    } else {
                        res -= value
                    }
                    exps.removeFirst()
                    
                    currntSym = exp
                    
                }
                
                
            } else {
                num = exp
                exps.removeFirst()
                
                if exps.count == 0 {
                    let value = Double(num) ?? 0
                    if currntSym == "+" {
                        res += value
                    } else {
                        res -= value
                    }
                }
                
            }
            
        }
        
        return res
    }
    
    func layoutItems() {
        
        let leading: CGFloat = 20
        let space: CGFloat = 15
        let viewWidth = CGFloat(self.view.frame.size.width);
        
        var left: CGFloat = leading
        var top: CGFloat = 0;
        
        contentView.frame = CGRect.init(x: 0, y: 0, width: viewWidth, height: viewWidth)
        self.view.addSubview(contentView)
        
        for item in items {
            let view = item.view
            view.frame = CGRect.init(x: left, y: top, width: item.size.width, height: item.size.height)
            left += space + view.frame.size.width
            if (left >= (viewWidth - leading)) {
                left = leading
                top += space + view.frame.size.height
            }
            contentView.addSubview(view)
            if let last = items.last, item === last {
                var frame = contentView.frame
                frame.size.height = view.frame.maxY
                frame.origin.y = self.view.frame.size.height - frame.size.height - bottomSafeInset()
                contentView.frame = frame
            }
        }
        
        resultLabel.sizeToFit()
        let frame = CGRect.init(x: leading, y: self.contentView.frame.origin.y - resultLabel.frame.size.height - 10, width: self.view.frame.size.width - leading * 2, height: resultLabel.frame.size.height)
        resultLabel.frame = frame;
        self.view.addSubview(resultLabel)
        
        if let empty = expLabel.text?.isEmpty, empty == true {
            expLabel.text = " "
        }
        expLabel.sizeToFit()
        expLabel.frame = CGRect.init(x: leading, y: self.topLayoutGuide.length + 20, width: self.view.frame.size.width - leading * 2, height: expLabel.frame.size.height)
        self.view.addSubview(expLabel)

    }
    
    func bottomSafeInset() -> (CGFloat) {
        if #available(iOS 11.0, *) {
            let inset = self.view.safeAreaInsets.bottom
            return inset > 0 ? inset + 20 : 30
        } else {
            return 30
        }
    }
    
        
    func generateItems()  {
        
        items.removeAll()
        
        let leading: CGFloat = 20
        let space: CGFloat = 15
        let count: CGFloat = 4
        let viewWidth = CGFloat(self.view.frame.size.width);
        let allSpace = (count - 1) * space + leading * 2
        let width = (viewWidth - allSpace) / count
        let zeroWidth = width * 2 + space;
        
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .ac)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .symbol)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .percent)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .division)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .seven)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .eight)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .nine)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .multiple)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .four)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .five)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .six)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .minus)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .one)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .two)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .three)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .plus)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: zeroWidth, height: width), type: .zero)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .dot)
            items.append(item)
        }
        if (true) {
            let item = MDItem(size: CGSize.init(width: width, height: width), type: .equal)
            items.append(item)
        }
        
        for item in items {
            item.addTarget(target: self, action: #selector(touinInside(item:)));
        }
        
    }
    
    

}



class MDCalcautor {
    
    var symbols: [Character] = ["+", "-", "*", "/"]
    var numbers: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var currntSym: Character = "+"
    var stack = [String]()
    
    func calculate(_ s: String) -> Int {
        var num = [Character]();
        var index = 0
        for c in s {
            if numbers.contains(c) {
                num.append(c)
            }
            
            if !numbers.contains(c) || index == s.count - 1 {
                var value = ""
                switch currntSym {
                case "+":
                    value = String.init(num)
                    num.removeAll()
                    stack.append(value)
                case "-":
                    num.insert(currntSym, at: 0)
                    value = String.init(num)
                    num.removeAll()
                    stack.append(value)
                case "*":
                    let last = stack.last ?? ""
                    stack.removeLast()
                    let cur = String.init(num)
                    let value = String.init(format: "%ld", (Int(last) ?? 0) * (Int(cur) ?? 0))
                    stack.append(value)
                    num.removeAll()
                case "/":
                    let last = stack.last ?? ""
                    stack.removeLast()
                    let cur = String.init(num)
                    let value = String.init(format: "%ld", (Int(last) ?? 0) / (Int(cur) ?? 0))
                    stack.append(value)
                    num.removeAll()
                    //                case "(":
                    //                case ")":
                    
                default:
                    break
                }
                currntSym = c
//                print(stack)
            }
            index += 1
        }

        var res = 0;
        for value in stack {
            res += Int(value) ?? 0
        }
        
        return res
    }
}
