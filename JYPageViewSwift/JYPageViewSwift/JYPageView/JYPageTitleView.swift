//
//  JYPageTitleView.swift
//  JYPageController
//
//  Created by hb on 2017/10/24.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

import UIKit

/// Delegate
protocol JYPageTitleViewDelegate: class {
    func titleView(_ titleView: JYPageTitleView, didSelectedItemAt index: Int)
}

/// View
class JYPageTitleView: UIView {
    
    //MARK: - Public Models
    
    public weak var delegate: JYPageTitleViewDelegate? = nil
    
    //MARK: - Private Models
    
    fileprivate var titles = [String]()
    fileprivate var title_views = [UIView]()
    fileprivate var style: JYPageTitleViewStyle!
    fileprivate var current_index: Int = 0
    fileprivate var current_title_view: UILabel {
        get {
            return title_views[current_index] as! UILabel
        }
    }
    fileprivate var content_view = UIScrollView()
    fileprivate var flag_view = UIView()
    fileprivate var line_view = UIView()
    
    //MARK: - init
    /// 便捷构造器
    ///
    /// - Parameters:
    ///   - titles: 标题数组
    ///   - style: 标题样式
    convenience init(_ titles: [String], style: JYPageTitleViewStyle?) {
        self.init(frame: .zero)
        
        if style == nil  {
            self.style = JYPageTitleViewStyle()
        } else {
            self.style = style
        }
        
        self.titles = titles
        if self.titles.count == 1, self.style.is_hidden_when_only_one_item {
            self.style.title_view_height = 0.0
            self.style.bottom_line_height = 0.0
        } else {
            if self.style.title_view_height == 0.0 {
                self.style.title_view_height = JYPageTitleViewStyle().title_view_height
            }
            if self.style.bottom_line_height == 0.0 {
                self.style.bottom_line_height = JYPageTitleViewStyle().bottom_line_height
            }
        }
        self.frame = CGRect(x: 0.0,
                            y: 0.0,
                            width: self.style!.title_view_width,
                            height: self.style.title_view_height)
        
        /// contentView
        content_view.frame = CGRect(x: 0.0,
                                    y: 0.0,
                                    width: self.style!.title_view_width,
                                    height: self.style.title_view_height - self.style.bottom_line_height)
        content_view.showsVerticalScrollIndicator = false
        content_view.showsHorizontalScrollIndicator = false
        content_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(content_view)
        
        /// 根据titles计算scrollView的contentSize
        
        for i in 0..<self.titles.count {
            
            var offset_x: CGFloat = 0.0
            var title_width: CGFloat = 0.0
            
            let label = UILabel()
            label.isUserInteractionEnabled = true
            label.tag = i
            label.textAlignment = .center
            if self.style.is_font_bold {
                label.font = UIFont.boldSystemFont(ofSize: self.style.font_size)
            } else {
                label.font = UIFont.systemFont(ofSize: self.style.font_size)
            }
            label.text = self.titles[i]
            if i == self.current_index {
                label.textColor = self.style.selected_color
            } else {
                label.textColor = self.style.default_color
            }
            if i == 0 {
                offset_x = self.style.item_margin / 2
            } else {
                offset_x = (self.title_views.last?.frame ?? CGRect.zero).maxX + self.style.item_margin
            }
            let title_rect = (label.text! as NSString).boundingRect(with: CGSize(width: Double(MAXFLOAT), height: 0.0),
                                                                    options: NSStringDrawingOptions.usesFontLeading,
                                                                    attributes: [NSAttributedString.Key.font: label.font ?? UIFont.systemFont(ofSize: 15)],
                                                                    context: nil)
            title_width = title_rect.size.width
            /// 最终的frame
            label.frame = CGRect(x: offset_x, y: 0, width: title_width, height: self.style.title_view_height)
            /// 添加手势
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.titleTaped(_:))))
            title_views.append(label)
            content_view.addSubview(label)
        }
        
        /// 最后一个 -> + 右边距/2
        let maxX = (title_views.last?.frame ?? CGRect.zero).maxX + self.style.item_margin / 2
        
        if maxX < self.style.title_view_width {
            /// 说明没有到一屏幕宽, 则按照屏幕等分
            var offset_x: CGFloat = 0.0
            let title_width: CGFloat = (self.style.title_view_width - CGFloat(self.titles.count) * self.style.item_margin ) / CGFloat(self.titles.count)
            /// 重新计算,X 和 宽度
            for i in 0..<self.titles.count {
                if i == 0 {
                    offset_x = self.style.item_margin / 2
                } else {
                    offset_x = self.style.item_margin / 2 + (title_width + self.style.item_margin) * CGFloat(i)
                }
                let frame = CGRect(x: offset_x, y: 0, width: title_width, height: self.style.title_view_height)
                self.title_views[i].frame = frame
                self.content_view.subviews[i].frame = frame
            }
        }
        
        /// flagView Default
        flag_view.backgroundColor = self.style.selected_color
        flag_view.frame = CGRect(x: current_title_view.frame.origin.x,
                                 y: self.style.title_view_height - self.style.flag_view_height - self.style.bottom_line_height,
                                 width: current_title_view.frame.size.width,
                                 height: self.style.flag_view_height)
        content_view.addSubview(flag_view)
        
        /// 最后一个titleLabel的最大 X + 0.5倍边距
        content_view.contentSize = CGSize(width: (self.title_views.last?.frame.maxX ?? 0) + self.style.item_margin / 2, height: 0)
        
        /// lineView
        line_view.frame = CGRect(x: 0,
                                 y: self.style.title_view_height - self.style.bottom_line_height,
                                 width: self.style.title_view_width,
                                 height: self.style.bottom_line_height)
        line_view.backgroundColor = self.style.bottom_line_color
        addSubview(line_view)
    }
    
    //MARK: - public functions
    
    /// 标题被点击时触发的事件
    ///
    /// - Parameter gesture: 单击手势
    @objc public func titleTaped(_ gesture: UITapGestureRecognizer) {
        let destination_index = gesture.view!.tag
        updateTitleLabel(with: destination_index)
        if let my_delegate = self.delegate {
            my_delegate.titleView(self, didSelectedItemAt: destination_index)
        }
    }
    
    /// 更新标题选中和未选中的样式
    ///
    /// - Parameter targetIndex: 被点击label的tag
    public func updateTitleLabel(with targetIndex: Int) {
        if targetIndex == current_index {
            return
        }
        let source_lable = title_views[current_index] as! UILabel
        let target_label = title_views[targetIndex] as! UILabel
        source_lable.textColor = style.default_color
        target_label.textColor = style.selected_color
        current_index = targetIndex
        
        // 让选中的标题位于中间
        updateSelectedTitleContentOffset()
        /// 更新标志视图的位置
        updateFlagViewFrame()
    }
    
    //MARK: - private functions
    
    /// 让选中的标题位于中间
    private func updateSelectedTitleContentOffset() {
        
        let frame = current_title_view.frame
        let title_x = frame.origin.x
        let width = content_view.frame.size.width
        let content_size = content_view.contentSize
        
        if title_x > width / 2.0 {
            var target_x: CGFloat
            if content_size.width - title_x <= width / 2.0 {
                target_x = content_size.width - width
            } else {
                target_x = frame.origin.x - width / 2.0 + frame.size.width / 2.0
            }
            // 应该有更好的解决方法
            if target_x + width > content_size.width {
                target_x = content_size.width - width
            }
            content_view.setContentOffset(CGPoint(x: target_x, y: 0), animated: true)
        } else {
            content_view.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    /// 更新flagView的位置
    private func updateFlagViewFrame() {
        UIView.animate(withDuration: 0.25) {
            self.flag_view.frame = CGRect(x: self.current_title_view.frame.origin.x,
                                          y: self.style.title_view_height - self.style.flag_view_height - self.style.bottom_line_height,
                                          width: self.current_title_view.frame.size.width,
                                          height: self.style.flag_view_height)
        }
    }
}

//MARK: - 标题样式
/// 标题样式
class JYPageTitleViewStyle {
    public var title_view_height: CGFloat = 44.0 //
    public var title_view_width: CGFloat = UIScreen.main.bounds.size.width
    public var item_margin: CGFloat = 10.0
    public var font_size: CGFloat = 14.0
    public var is_font_bold: Bool = false
    public var bottom_line_color = UIColor.groupTableViewBackground
    public var bottom_line_height: CGFloat = 0.5
    public var default_color = UIColor.darkGray
    public var selected_color = UIColor(red: 198.0/255.0, green: 1/255.0, blue: 31/255.0, alpha: 1)
    public var background_color = UIColor.groupTableViewBackground
    public var is_hidden_when_only_one_item = false
    public var flag_view_height: CGFloat = 2.0 // 标识View的高度
}
