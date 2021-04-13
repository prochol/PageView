//
//  ViewController.swift
//  PageView-Example
//
//  Created by prochol on 17.07.2020.
//  Copyright © 2020 Prochol. All rights reserved.
//

import UIKit
import PageView

class ViewController: UIViewController {

    @IBOutlet private weak var pageView: PageView!
    
    private var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageView.scrollToPage(at: currentPage, animated: false)
    }
}
// MARK: - Actions
extension ViewController {
    @IBAction func nextButtonPressed(_ sender: Any) {
        pageView.scrollToPage(at: currentPage + 1, animated: true)
    }
}

extension ViewController: PageViewDataSource {
    func numberOfPages(in pageView: PageView) -> Int {
        return 6
    }
    
    func pageView(_ pageView: PageView, pageAt index: Int) -> IPageView {
        let frame = CGRect.init(origin: .zero, size: pageView.frame.size)
        let viewPage = ViewPage(frame: frame)
        
        viewPage.backgroundColor = UIColor.white
        viewPage.index = index
        
        return viewPage
    }
}

extension ViewController: PageViewDelegate {
    func pageView(_ view: PageView, didChangePageIndex index: Int) {
        currentPage = index
    }
}

