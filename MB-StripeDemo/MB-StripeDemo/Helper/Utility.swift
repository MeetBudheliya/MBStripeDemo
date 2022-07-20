//
//  Extensions.swift
//  MB-StripeDemo
//
//  Created by Meet's MAC on 19/07/22.
//

import UIKit

extension UIViewController{

    func alert(msg:String){
        let alert = UIAlertController(title: Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Alert", message: msg, preferredStyle: .alert)
        let ohkAction = UIAlertAction(title: "OK", style: .default) { _Arg in
            //
        }
        alert.addAction(ohkAction)
        present(alert, animated: true, completion: nil)
    }
}

extension Data{
    // Convert from NSData to json object
    func convertToDictionary() -> NSDictionary{
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? NSDictionary ?? [:]
        } catch let myJSONError {
            return ["error": myJSONError]
        }
    }
}


extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadowOffset : CGSize{
        get{
            return layer.shadowOffset
        }set{
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable
    var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable
    var shadowOpacity : Float {

        get{
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
}

