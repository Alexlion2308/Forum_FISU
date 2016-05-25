//
//  PageIntroViewController.swift
//  FISU
//
//  Created by Reda Maachi on 08/04/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    
    var pageHeaders = ["Welcome to 13th FISU Forum", "Events screen", "Speakers screen", "Places of interest", "Have a good trip in Montpellier"]
    var pageImages = ["app1", "app2", "app3", "app4", "app5"]
    var pageDescriptions = ["This event takes place in the beautifull city of Montpellier. This application will help you enjoy the FISU Forum. Register once and enjoy the app", "Allows you to see past & upcoming events. You can also add an event to your own calendar to book a place ", "Allows you to see all the speakers. Access their details by clicking them. Receive a notification when someone or something has changed.", "Find all the interisting places, to see & to visit, near you. Get the phone number & some other informations simply by clicking the place.", ""]
    // make the status bar white (light content)
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this class is the page view controller's data source itself
        self.dataSource = self
        
        // create the first walkthrough vc
        if let startWalkthroughVC = self.viewControllerAtIndex(0) {
            setViewControllers([startWalkthroughVC], direction: .Forward, animated: true, completion: nil)
        }
        
    }
    
    
    
    func nextPageWithIndex(index: Int)
    {
        if let nextWalkthroughVC = self.viewControllerAtIndex(index+1) {
            setViewControllers([nextWalkthroughVC], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    func viewControllerAtIndex(index: Int) -> WalkthroughViewController?
    {
        if index == NSNotFound || index < 0 || index >= self.pageDescriptions.count {
            return nil
        }
        
        // create a new walkthrough view controller and assing appropriate date
        if let walkthroughViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughViewController") as? WalkthroughViewController {
            walkthroughViewController.imageName = pageImages[index]
            walkthroughViewController.headerText = pageHeaders[index]
            walkthroughViewController.descriptionText = pageDescriptions[index]
            walkthroughViewController.index = index
            
            return walkthroughViewController
        }
        
        return nil
    }
}

extension PageViewController : UIPageViewControllerDataSource
{
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! WalkthroughViewController).index
        index += 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughViewController).index
        index -= 1
        return self.viewControllerAtIndex(index)
    }
}