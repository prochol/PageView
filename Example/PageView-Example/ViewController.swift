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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageView.currentIndex = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageView.currentIndex = 0
    }
}

extension ViewController: PageViewDataSource {
    func numberOfPages(in pageView: PageView) -> Int {
        return 6
    }
    
    func pageView(_ pageView: PageView, pageAt index: Int) -> IPageView {
        let viewPage = ViewPage()
        
        viewPage.backgroundColor = UIColor.white
        viewPage.index = index
        
        return viewPage
    }
}
