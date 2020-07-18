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
        // Do any additional setup after loading the view.
        
        
    }


}

extension ViewController: PageViewDataSource {
    func numberOfPages(in pageView: PageView) -> Int {
        return 6
    }
    
    func pageView(_ pageView: PageView, pageAt index: Int) -> IPageView {
        var pageView = ViewPage()
        
        Bundle.main.loadNibNamed("ViewPage", owner: pageView)
        pageView.index = index
        
        return pageView
    }
}
