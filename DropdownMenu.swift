/*
 MIT License
 
 Copyright (c) 2016 Takuyaaan
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import QuartzCore

@objc protocol DropdownListMenuDelegate : NSObjectProtocol {
    
    optional func dropdownListMenuWillDisplay()
    optional func dropdownListMenuWillDismiss()
    optional func dropdownListMenuDidSelected(selectedIndex: Int)
}

class DropdownMenu: UIBarButtonItem {
    
    final let kvListRowHeight = 50

    var superView: UIView!                        // parentView
    var menuDelegate: DropdownListMenuDelegate!
    
    var isShowDisplay: Bool = false

    var tableSelectedColor = UIColor.grayColor()
    var menuSeparatorColor = UIColor.darkGrayColor()
    var menuTableBackgroundColor = UIColor.whiteColor()
    var menuBackgroundColor = UIColor.lightGrayColor()
    var menuLabelColor = UIColor.darkTextColor()

    private var dropList: [AnyObject]!            // drop menu list
    private var displayNumOfRows = 0              // display count
    private var heightOfListItem = 0              // list item height
    private var borderColorForList: UIColor!      // list item border color
    private var borderWidth = 0.0                 // list item border width
    private var fontOfListItem: UIFont!           // list item font size
    private var baseView: UIView!
    private var tableView: UITableView!
    
    override init() {
        super.init()
    }

    convenience init(customView: UIView) {
        self.init()

        addTarget(customView)
        borderWidth = 0.5
        borderColorForList = UIColor.lightGrayColor()
        displayNumOfRows = self.numberOfRows()
        if heightOfListItem <= 0 {
            heightOfListItem = kvListRowHeight
        }
        
        baseView = UIView(frame: CGRectZero)
        baseView.backgroundColor = menuBackgroundColor.colorWithAlphaComponent(0.6)
        let singleTapGesture = UITapGestureRecognizer(target:self, action: #selector(DropdownMenu.handleSingleTap))
        baseView.addGestureRecognizer(singleTapGesture)
        
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = true
        let backgroundColorView = UIView()
        backgroundColorView.backgroundColor = tableSelectedColor.colorWithAlphaComponent(0.1)
        UITableViewCell.appearance().selectedBackgroundView = backgroundColorView
        tableView.layer.borderWidth = CGFloat(borderWidth)
        tableView.layer.borderColor = borderColorForList.CGColor
        tableView.backgroundColor = menuTableBackgroundColor
        self.customView = customView
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDropMenus(menus: [String]) {
        dropList = menus
    }

    func toggleMenu(button: UIButton) {
        if self.isShowDisplay {
            self.hideDropDownList()
        }
        else {
            self.showDropDownList()
        }
    }
    
    func handleSingleTap(gestureRecognizer: UITapGestureRecognizer) {
        let touchPoint: CGPoint = gestureRecognizer.locationInView(baseView)
        if touchPoint.y <= tableView.frame.size.height {
            return
        }
        self.hideDropDownList()
    }

    //MARK: private

    private func addTarget(customview: UIView) {
        guard let button = customview as? UIButton else {
            let tapGesture = UITapGestureRecognizer(target:self, action: #selector(DropdownMenu.toggleMenu))
            customview.addGestureRecognizer(tapGesture)
            return
        }
        button.addTarget(self, action: #selector(DropdownMenu.toggleMenu), forControlEvents: .TouchUpInside)
    }

    func prepare() {
        
        if dropList != nil && dropList?.count <= Int(displayNumOfRows) {
            displayNumOfRows = (dropList?.count)!
            tableView.scrollEnabled = false
        }
        
        let navFrame: CGRect = self.navigationBar().frame
        var height = displayNumOfRows*heightOfListItem
        if tableView.scrollEnabled {
            height += heightOfListItem/2
        }
        tableView.frame = CGRectMake(CGRectGetMinX(navFrame), CGRectGetMinY(navFrame)+CGRectGetHeight(navFrame), CGRectGetWidth(navFrame), CGFloat(height))
        tableView.alpha = 0
        var frame = tableView.frame
        frame.size.height = navigationBar().superview!.frame.size.height
        baseView.frame = frame
        baseView.alpha = 0
        
        UIApplication.sharedApplication().keyWindow?.addSubview(baseView)
        UIApplication.sharedApplication().keyWindow?.addSubview(tableView)
    }
    
    private func navigationBar() -> UINavigationBar {
        return (self.superView as! UINavigationBar)
    }

    private func showDropDownList() {
        
        self.menuDelegate?.dropdownListMenuWillDisplay!()
        self.prepare()
        
        var frame = tableView.frame
        frame.size.height = 0
        tableView.frame = frame
        
        UIView.animateWithDuration(0.2,
                                   animations: {
                                    if let baseView = self.baseView {
                                        baseView.alpha = 1.0
                                    }
            },
                                   completion: {(finished: Bool) in
            }
        )
        UIView.animateWithDuration(0.3,
                                   delay: 0.1,
                                   options: .CurveEaseInOut,
                                   animations: {
                                    if let tableView = self.tableView {
                                        tableView.alpha = 1.0
                                        var frame = tableView.frame
                                        frame.size.height = CGFloat(self.displayNumOfRows*self.heightOfListItem)
                                        if tableView.scrollEnabled {
                                            frame.size.height += CGFloat(self.heightOfListItem/2)
                                        }
                                        tableView.frame = frame
                                    }
                                   },
                                   completion: { (finished: Bool) in
                                    self.isShowDisplay = true
                                    }
        )
    }
    
    private func hideDropDownList() {
        
        self.menuDelegate?.dropdownListMenuWillDismiss!()

        UIView.animateWithDuration(0.3,
                                   animations: {
                                    if let tableView = self.tableView {
                                        var frame = tableView.frame
                                        frame.size.height = 0
                                        tableView.frame = frame
                                    }
            },
                                   completion: {(finished: Bool) in
                                    if let tableView = self.tableView {
                                        tableView.alpha = 0
                                        tableView.removeFromSuperview()
                                    }
            }
        )
        UIView.animateWithDuration(0.3,
                                   delay: 0.2,
                                   options: .CurveEaseInOut,
                                   animations: {
                                    if let baseView = self.baseView {
                                        baseView.alpha = 0
                                    }
            },
                                   completion: {(finished: Bool) in
                                    if let baseView = self.baseView {
                                        baseView.removeFromSuperview()
                                    }
                                    self.isShowDisplay = false
            }
        )
    }
    
    private func numberOfRows() -> Int {
        let height =  UIScreen.mainScreen().bounds.size.height
        // iPhone4/4S
        if height <= 480 {
            return 6
        }
        // iPhone5/5S
        if height > 480 && height <= 568 {
            return 7
        }
        // iPhone6/6S
        if height > 568 && height <= 667 {
            return 9
        }
        // iPhone6/6S plus
        return 10
    }

    private func heightOfRows() -> CGFloat {
        let height =  UIScreen.mainScreen().bounds.size.height
        // iPhone4/4S
        if height <= 480 {
            return 44
        }
        // iPhone5/5S
        if height > 480 && height <= 568 {
            return 44
        }
        // iPhone6/6S
        if height > 568 && height <= 667 {
            return 50
        }
        // iPhone6/6S plus
        return 50
    }

}

// MARK: - TableViewController datasource & delegate

extension DropdownMenu: UITableViewDelegate, UITableViewDataSource {
    
    private func setCell(cell: UITableViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) {
        
        if ((fontOfListItem) != nil) {
            cell.textLabel!.font = fontOfListItem
        }
        if let dropMenus = dropList[indexPath.item] as? String {
            cell.textLabel!.text = dropMenus
        }
    }
    
    // data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") {
            self.setCell(cell, cellForRowAtIndexPath: indexPath)
            return cell
        }
        else {
            let cell = UITableViewCell(style: .Default, reuseIdentifier:"cell")
            
            var boarderImage = UIImage(named: "bg_table_border_bottom")
            if indexPath.row == 0 {
                boarderImage = UIImage(named: "bg_table_border")
            }
            boarderImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(1, 0, 1, 0), resizingMode: .Stretch)
            let boarderImageView = UIImageView()
            boarderImageView.image = boarderImage
            boarderImageView.frame = cell.frame
            boarderImageView.backgroundColor = UIColor.clearColor()
            cell.addSubview(boarderImageView)
            
            cell.contentView.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = UIColor.clearColor()
            cell.textLabel!.textAlignment = .Left
            cell.textLabel!.textColor = menuLabelColor
            self.setCell(cell, cellForRowAtIndexPath: indexPath)
            return cell
        }
    }
    
    // delegate
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(heightOfListItem)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.hideDropDownList()
        self.menuDelegate?.dropdownListMenuDidSelected!(indexPath.item)
    }
}
