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
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet public var dataSource: PageViewDataSource?
    
    public var currentIndex: UInt = 0 {
        didSet {
            setCurrentIndex(currentIndex)
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
        let bundle = Bundle.init(for: Self.self)
        bundle.loadNibNamed(nameOfClass, owner: self, options: nil)
        addSubview(scrollView)
        
        addConstraints(forView: scrollView)        
    }
    
    private func addConstraints(forView view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension PageView {
    private func setCurrentIndex(_ currentIndex: UInt) {
        scrollView.subviews.forEach{ $0.removeFromSuperview() }
        
        if let pageView = dataSource?.pageView(self, pageAt: Int(currentIndex)) {
            let origin = CGPoint.init(x: CGFloat(currentIndex) * self.frame.width + 1, y: 0.0)
            
            let width = self.frame.width - 2
            let height = self.frame.height
            let size = CGSize.init(width: width, height: height)
            
            pageView.frame = CGRect.init(origin: origin, size: size)
            scrollView.addSubview(pageView)
        }
        
        if let pageView = dataSource?.pageView(self, pageAt: Int(currentIndex + 1)) {
            let origin = CGPoint.init(x: CGFloat(currentIndex + 1) * self.frame.width + 1, y: 0.0)
            
            let width = self.frame.width - 2
            let height = self.frame.height
            let size = CGSize.init(width: width, height: height)
            
            pageView.frame = CGRect.init(origin: origin, size: size)
            scrollView.addSubview(pageView)
        }
        
        let width = self.frame.width * 2
        let height = self.frame.height
        let contentSize = CGSize.init(width: width, height: height)
        scrollView.contentSize = contentSize
    }
}

extension PageView: UIScrollViewDelegate {
}
