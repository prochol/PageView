//
//  PageViewDataSourse.swift
//  PageView
//
//  Created by prochol on 17.07.2020.
//

import Foundation

public protocol IPageView {
}
    
public protocol PageViewDataSource {
    func numberOfPages(in pageView: PageView) -> Int
    func pageView(_ pageView: PageView, pageAt index: Int) -> IPageView
}
