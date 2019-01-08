//
//  ViewController.swift
//  JYPageViewSwift
//
//  Created by hb on 2019/1/7.
//  Copyright © 2019 hb. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    fileprivate var pageView: JYPageView! = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "reload", style: .plain, target: self, action: #selector(self.reloadJYPageView))
        
        if #available(iOS 11, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let titles = [
            "测试分类01",
            "测试分类02",
            "测试分类03",
            "测试分类04",
            "测试分类05",
            "测试分类06",
            "测试分类07",
            "测试分类0000000000000000000000000000008"
        ]
        
        var childs = [UIViewController]()
        for _ in 0..<titles.count {
            let child = UIViewController()
            child.view.backgroundColor = UIColor.randomColor()
            childs.append(child)
        }
        
        let top_height = navigationController!.navigationBar.bounds.size.height + UIApplication.shared.statusBarFrame.size.height
        let rect = CGRect(x: view.frame.origin.x,
                          y: top_height,
                          width: UIScreen.main.bounds.size.width,
                          height: UIScreen.main.bounds.size.height - top_height)
        let style = JYPageTitleViewStyle()
        style.is_hidden_when_only_one_item = true
        
        pageView = JYPageView(rect, style: style, titles: titles, parent: self, childs: childs)
        pageView.delegate = self
        view.addSubview(pageView)
    }
    
    
    /// 刷新
    @objc func reloadJYPageView() {
        
        let titles = [
            "测试分类01",
            "测试分类01",
            "测试分类01",
            "测试分类01"
        ]
        var childs = [UIViewController]()
        
        for _ in 0..<titles.count {
            let child = UIViewController()
            child.view.backgroundColor = UIColor.randomColor()
            childs.append(child)
        }
        
        pageView.reload(with: titles, childs: childs)
    }
}

extension ViewController: JYPageViewDelegate {
    func pageView(_ pageMenu: JYPageView, didSelectedItemAt index: Int) {
        print(index)
    }
}

extension UIColor {
    public static func randomColor() -> UIColor {
        let r = CGFloat(arc4random()%255)
        let g = CGFloat(arc4random()%255)
        let b = CGFloat(arc4random()%255)
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}



