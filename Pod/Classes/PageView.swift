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
    private let kMaxPageInMemory = 5
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet public var dataSource: PageViewDataSource?
    @IBOutlet public weak var delegate: PageViewDelegate?
    
    public var isInfiniteScroll: Bool = false
    
    private var pageViews = [Int: IPageView]()// Текущие "видимые" вьюхи
    // [reuseIdentifier: [index: View]]
    private var cacheReusableViews = [String: [Int: IReusablePageView]]()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let numberOfPages = dataSource?.numberOfPages(in: self) ?? 0
        if isInfiniteScroll && numberOfPages > 1 {
            scrollView.contentSize = contentSize(for: numberOfPages + 2)
        }
        else {
            scrollView.contentSize = contentSize(for: numberOfPages)
        }
        
        pageViews.forEach {
            if bounds != $0.value.bounds {
                var needUpdateContentOffset = false
                if scrollView.contentOffset.x == $0.value.frame.minX {
                    needUpdateContentOffset = true
                }
                
                let x: CGFloat
                if isInfiniteScroll && numberOfPages > 1 {
                    x = CGFloat($0.key) * frame.width + frame.width
                }
                else {
                    x = CGFloat($0.key) * frame.width
                }
                $0.value.frame = CGRect.init(origin: CGPoint.init(x: x, y: 0.0),
                                             size: bounds.size)
                
                if needUpdateContentOffset {
                    scrollView.setContentOffset($0.value.frame.origin, animated: false)
                }
            }
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
    
    public func scrollToPage(at index: Int, animated: Bool) {
        var contentOffset = index > 0 ? CGFloat(index) * frame.width : 0.0
        if isInfiniteScroll && scrollView.contentSize.width > frame.width {
            contentOffset += frame.width
        }
        
        if contentOffset > scrollView.contentSize.width - frame.width {
            contentOffset = scrollView.contentSize.width - frame.width
        }
        
        let contentPoint = CGPoint.init(x: contentOffset, y: 0.0)
        
        if pageViews[index] == nil {
            if let pageView = dataSource?.pageView(self, pageAt: index) {
                pageView.frame.origin = contentPoint
                addPageView(pageView, for: index)
            }
        }
        scrollView.setContentOffset(contentPoint, animated: animated)
    }
    // MARK: - Reusable
    public func dequeueReusableView<T: IReusablePageView>(at index: Int) -> T {
        if let cacheViews = cacheReusableViews[T.reuseIdentifier],
           let cacheView = cacheViews[index] as? T {
            
            cacheView.prepareForReuse()
            
            return cacheView
        }
        
        let newView = T.init(frame: frame)
        return newView
    }
}
// MARK: - DataSource
extension PageView {
    func reloadData() {
        guard let dataSource = dataSource else { return }
        let numberOfPages = dataSource.numberOfPages(in: self)
        
        if isInfiniteScroll && numberOfPages > 1 {
            scrollView.contentSize = contentSize(for: numberOfPages + 2)
            removeAllPages()
            
            let pageView = dataSource.pageView(self, pageAt: 0)
            pageView.frame.origin.x = frame.width
            addPageView(pageView, for: 0)
            scrollView.setContentOffset(pageView.frame.origin, animated: false)
        }
        else {
            scrollView.contentSize = contentSize(for: numberOfPages)
            removeAllPages()
            
            let pageView = dataSource.pageView(self, pageAt: 0)
            pageView.frame.origin.x = 0
            addPageView(pageView, for: 0)
            scrollView.setContentOffset(pageView.frame.origin, animated: false)
        }
    }
}

extension PageView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let numberOfPages = dataSource?.numberOfPages(in: self) ?? 0
        
        let currentIndex: Int
        if isInfiniteScroll && numberOfPages > 1 {
            currentIndex = Int(offset.x / frame.width) - 1
        }
        else {
            currentIndex = Int(offset.x / frame.width)
        }
        
        let prevIndex = currentIndex - 1
        if pageViews[prevIndex] == nil {
            if let prevView = dataSource?.pageView(self, pageAt: prevIndex) {
                prevView.frame.origin.x = offset.x - frame.width
                addPageView(prevView, for: prevIndex)
            }
        }
        
        let nextIndex = currentIndex + 1
        if pageViews[nextIndex] == nil {
            if let nextView = dataSource?.pageView(self, pageAt: nextIndex) {
                nextView.frame.origin.x = offset.x + frame.width
                addPageView(nextView, for: nextIndex)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrolling(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndScrolling(scrollView)
    }
    
    private func scrollViewDidEndScrolling(_ scrollView: UIScrollView) {
        guard let delegate = delegate else { return }
        
        let offset = scrollView.contentOffset
        let numberOfPages = Int(scrollView.contentSize.width / frame.width)
        
        if isInfiniteScroll && numberOfPages > 1 {
            let index = Int(offset.x / frame.size.width)

            var indexPage = index
            indexPage = index == 0 ? numberOfPages-3 : index-1
            indexPage = index == numberOfPages-1 ? 0 : indexPage

            scrollToPage(at: indexPage, animated: false)
            delegate.pageView?(self, didChangePageIndex: indexPage)
        }
        else {
            let index = Int(offset.x / frame.size.width)
            delegate.pageView?(self, didChangePageIndex: index)
        }
    }
    
}
// MARK: - Utils
extension PageView {
    private func contentSize(for numberOfPages: Int) -> CGSize {
        let width = bounds.size.width * CGFloat(numberOfPages)
        return CGSize.init(width: width, height: bounds.size.height)
    }
    
    private func addPageView(_ pageView: IPageView, for index: Int) {
        pageViews[index] = pageView
        
        if let reusableView = pageView as? IReusablePageView {
            let reuseIdentifier = type(of: reusableView).reuseIdentifier
            var cacheViews: [Int: IReusablePageView]! = cacheReusableViews[reuseIdentifier]
            if cacheViews == nil {
                cacheViews = [Int: IReusablePageView]()
            }
            cacheViews[index] = reusableView
            
            cacheReusableViews[reuseIdentifier] = cacheViews
            
            pageView.isHidden = false
        }
        
        scrollView.addSubview(pageView)
    }
    
    private func removeAllPages() {
        pageViews.values.forEach {
            if $0 is IReusablePageView {
                $0.isHidden = true
            }
            else {
                $0.removeFromSuperview()
            }
        }
        pageViews.removeAll()
    }
}
