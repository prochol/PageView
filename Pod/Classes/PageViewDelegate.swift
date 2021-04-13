//
//  PageViewDelegate.swift
//  PageView
//
//  Created by Pavel Kuzmin on 13.04.2021.
//

import Foundation

@objc
public protocol PageViewDelegate
{
    @objc optional func pageView(_ view: PageView, didChangePageIndex index: Int)
}
