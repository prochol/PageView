//
//  ViewPage.swift
//  PageView-Example
//
//  Created by Pavel Kuzmin on 17.07.2020.
//  Copyright © 2020 Prochol. All rights reserved.
//

import PageView

class ViewPage: UIView, IPageView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    var index: Int = 0 {
        didSet {
            titleLabel.text = String(index)
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
    
    private func setup() {
        let nameOfClass = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        Bundle.main.loadNibNamed(nameOfClass, owner: self, options: nil)
        addSubview(titleLabel)
        titleLabel.frame = self.bounds
    }
}
