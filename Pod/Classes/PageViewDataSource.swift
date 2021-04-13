//
//  PageViewDataSourse.swift
//  PageView
//
//  Created by prochol on 17.07.2020.
//

import UIKit
import Foundation

@objc
public protocol IPageView where Self: UIView
{
}
    
@objc
public protocol PageViewDataSource
{
    func numberOfPages(in pageView: PageView) -> Int
    @objc func pageView(_ pageView: PageView, pageAt index: Int) -> IPageView
}


public protocol IReusablePageView: IPageView
{
    static var reuseIdentifier: String { get }
    
    func prepareForReuse()
}

extension IReusablePageView
{
    public static var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    func prepareForReuse() {}
}
