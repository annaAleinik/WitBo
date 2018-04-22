//
//  СhatInputTextPanel.swift
//  Proj
//
//  Created by  Anita on 4/22/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import NoChat

class СhatInputTextPanel: NOCChatInputPanel, UITextFieldDelegate {
    
    var keyboardHeight : CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func adjust(for size: CGSize, keyboardHeight: CGFloat, duration: TimeInterval, animationCurve: Int32) {
        if keyboardHeight > self.keyboardHeight {
            self.keyboardHeight = keyboardHeight
            adjustToKeyboardHeight(self.keyboardHeight)
        } else {
            adjustToKeyboardHeight(-self.keyboardHeight)
            self.keyboardHeight = 0
        }
    }
    
    func adjustToKeyboardHeight(_ keyboardHeight : CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.y -= keyboardHeight
        }
    }
    
    override func endInputting(_ animated: Bool) {
        
    }
    
    override func change(to size: CGSize, keyboardHeight: CGFloat, duration: TimeInterval) {
        
    }
}
