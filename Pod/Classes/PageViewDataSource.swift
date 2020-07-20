//
//  PageViewDataSourse.swift
//  PageView
//
//  Created by prochol on 17.07.2020.
//

import Foundation

@objc
public protocol IPageView where Self : UIView {
}
    
@objc
public protocol PageViewDataSource {
    func numberOfPages(in pageView: PageView) -> Int
    @objc func pageView(_ pageView: PageView, pageAt index: Int) -> IPageView
}
