//
//  CustomUITextField.swift
//  VotingApp
//
//  Created by iGuest on 12/13/15.
//  Copyright © 2015 Jill Lopez. All rights reserved.
//

import UIKit

@IBDesignable
class CustomUITextField: UITextField {

    @IBInspectable var inset: CGFloat = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
}
