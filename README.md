# Swift-DropdownMenu
DropdownMenu Swift Programing code

This `Dropdown-Menu` can added as UIBarButtonItem.

![Screenshot](https://github.com/takuyaaan/Swift-DropdownMenu/blob/master/example.gif)

## Installation
- Just drag `DropdownMenu.swift` into your project.
- `CocoaPods` and `Carthage` support is on To-do list.

## Sample Code
Below you can see code that creates and sets up a `DropdownMenu` instance. Which gives you a configuration that looks similar to the progress in the example images.

```swift
let menuBtn = UIButton(frame: CGRectMake(0, 0, 32, 32))
menuBtn.setImage(UIImage(named: "menu"), forState: .Normal)
let menuBarButtonItem = DropdownMenu(customView: menuBtn)
menuBarButtonItem.setDropMenus(["Menu1", "Menu2", "Menu3", "Menu4"])
menuBarButtonItem.superView = navigationBar
navigationBar.topItem?.rightBarButtonItem = menuBarButtonItem
```

### protocol
```swift
optional func dropdownListMenuWillDisplay()
```
when the menu is open, before animation.
```swift
optional func dropdownListMenuWillDismiss()
```
when the menu is close, before animation.
```swift
optional func dropdownListMenuDidSelected(selectedIndex: Int)
```
when the menu is selected, after `dropdownListMenuWillDismiss()`.

### property


## To-Do
- [x]Add example project
- [] Carthage Support
- [] CocoaPods Support
- [] postscript of property

## License

 The MIT License
 
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
