//
//  SeparatorView.swift
//  alfa.cash
//
//  Created by Anna Alimanova on 16.04.2020.
//  Copyright © 2020 Anna Alimanova. All rights reserved.
//

import UIKit

@IBDesignable class SeparatorView: ACBorderedView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func setup() {
        self.theme.backgroundColor = ThemeManager.shared.themed( { $0.textFieldBorderColor })
        
    }
}


