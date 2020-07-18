//
//  PageView.swift
//  PageView
//
//  Created by Pavel Kuzmin on 17.07.2020.
//  Copyright © 2020 Prochol. All rights reserved.
//

import UIKit
import Foundation

@objc
public class PageView: UIView {
    
    @IBOutlet private var scrollView: UIScrollView!
        
    open var dataSource: PageViewDataSource?
    
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
        let bundle = Bundle.init(for: Self.self)
        bundle.loadNibNamed(nameOfClass, owner: self, options: nil)
        addSubview(scrollView)
        scrollView.frame = self.bounds
    }
    
    
}

extension Bundle {
    static let frameworkBundle = Bundle.init(identifier: "com.prochol.PageView")
}
