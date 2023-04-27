//
//  UITextView+.swift
//  MKTFU
//
//  Created by mac on 2023-02-05.
//

import Foundation
import UIKit

extension UITextView {
    
    func addHyperLinksToText(text: String, textView: UITextView) {
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttribute(.link,
                                      value: "terms://termsofCondition",
                                      range: (attributedString.string as NSString).range(of: "Terms of Service"))
        
        attributedString.addAttribute(.link,
                                      value: "privacy://privacypolicy",
                                      range: (attributedString.string as NSString).range(of: "Privacy Policy"))
        
        
        textView.linkTextAttributes = [ NSAttributedString.Key.foregroundColor:
                                            UIColor.appColor(LPColor.OccasionalPurple) ?? UIColor(.black),
                                        .underlineStyle: NSUnderlineStyle.single.rawValue]
        textView.font = UIFont(name: "OpenSans-Regular", size: 14)
        textView.attributedText = attributedString
        textView.isSelectable = true
        textView.isEditable = false
        textView.delaysContentTouches = false
        textView.isScrollEnabled = false
    }
}
