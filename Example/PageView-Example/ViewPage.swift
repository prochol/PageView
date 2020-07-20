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
        let bundle = Bundle.init(for: Self.self)
        bundle.loadNibNamed(nameOfClass, owner: self, options: nil)
        addSubview(titleLabel)
        
        addConstraints(forView: titleLabel)
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
