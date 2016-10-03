//
//  ViewController.swift
//  Copyright (c) 2016 Takuyaaan
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.shadowImage = UIImage()

        let menuBtn = UIButton(frame: CGRectMake(0, 0, 32, 32))
        menuBtn.setImage(UIImage(named: "menu"), forState: .Normal)
        let menuBarButtonItem = DropdownMenu(customView: menuBtn)
        menuBarButtonItem.setDropMenus(["Menu1", "Menu2", "Menu3", "Menu4"])
        menuBarButtonItem.superView = navigationBar
        navigationBar.topItem?.rightBarButtonItem = menuBarButtonItem
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

