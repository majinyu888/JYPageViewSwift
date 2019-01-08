//
//  JYPageView.swift
//  JYPageController
//
//  Created by hb on 2017/10/24.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

import UIKit

/// Deleagte
protocol JYPageViewDelegate: class {
    func pageView(_ pageView: JYPageView, didSelectedItemAt index: Int)
}

/// View
class JYPageView: UIView {
    
    //MARK: - public models
    public weak var delegate: JYPageViewDelegate? = nil
    public var current_index = 0 {
        didSet {
            self.title_view?.updateTitleLabel(with: current_index)
            self.content_view?.updateScrollToIndex(current_index, animate: false)
        }
    }
    
    
    //MARK: - private models
    fileprivate var titles = [String]()
    fileprivate weak var parent: UIViewController!
    fileprivate var childs = [UIViewController]()
    
    fileprivate var style: JYPageTitleViewStyle!
    fileprivate var title_view: JYPageTitleView! = nil
    
    //MARK: - public models
    public var content_view: JYPageContentView! = nil
    
    //MARK: - init
    
    convenience init(_ frame: CGRect, style: JYPageTitleViewStyle?, titles: [String], parent: UIViewController, childs: [UIViewController]) {
        self.init(frame: frame)
        backgroundColor = UIColor.white
        self.titles = titles
        self.childs = childs
        self.parent = parent
        self.style = style == nil ? JYPageTitleViewStyle() : style!
        self.title_view = JYPageTitleView(self.titles, style: self.style)
        let rect = CGRect(x: 0,
                          y: self.style.title_view_height,
                          width: self.style.title_view_width,
                          height: self.bounds.size.height - self.style.title_view_height)
        content_view = JYPageContentView(rect, parent: self.parent, childs: self.childs)
        title_view.delegate = self
        content_view.delegate = self
        addSubview(title_view)
        addSubview(content_view)
    }
    //MARK: - private functions
    
    //MARK: - public functions
    public func reload(with titles: [String], childs: [UIViewController]) {
        /// 1.清空
        /// 2.恢复默认值
        /// 3.重新添加
        
        UIView.animate(withDuration: 0.25, animations: {
            self.title_view.alpha = 0
        }) { (isFinish) in
            if isFinish {
                
                self.title_view.delegate = nil
                self.content_view.delegate = nil
                self.title_view.removeFromSuperview()
                self.content_view.removeFromSuperview()
                self.title_view = nil
                self.content_view = nil
                self.current_index = 0
                
                self.titles = titles
                self.childs = childs
                self.title_view = JYPageTitleView.init(titles, style: self.style)
                let rect = CGRect(x: 0,
                                  y: self.style.title_view_height,
                                  width: self.style.title_view_width,
                                  height: self.bounds.size.height - self.style.title_view_height)
                self.content_view = JYPageContentView(rect, parent: self.parent, childs: self.childs)
                
                self.addSubview(self.title_view)
                self.addSubview(self.content_view)
                
                self.title_view.delegate = self
                self.content_view.delegate = self
            }
        }
    }
}

// MARK: - JYPageTitleViewDelegate
extension JYPageView: JYPageTitleViewDelegate {
    func titleView(_ titleView: JYPageTitleView, didSelectedItemAt index: Int) {
        if index == current_index {
            return
        }
        current_index = index
        self.content_view.updateScrollToIndex(index, animate: false)
        if let my_delegate = self.delegate {
            my_delegate.pageView(self, didSelectedItemAt: index)
        }
    }
}

// MARK: - JYPageContentViewDelegate
extension JYPageView: JYPageContentViewDelegate {
    func contentView(_ contentView: JYPageContentView, didselectedItemAt index: Int) {
        if index == current_index {
            return
        }
        current_index = index
        self.title_view.updateTitleLabel(with: index)
        if let my_delegate = self.delegate {
            my_delegate.pageView(self, didSelectedItemAt: index)
        }
    }
}

