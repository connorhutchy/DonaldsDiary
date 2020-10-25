//
//  ViewController.swift
//  DonaldsDiary
//
//  Created by Connor Hutchinson on 24/10/20.
//

import UIKit

class DiaryViewController: UIPageViewController, Refresh {
    
    
    
    override func viewDidLayoutSubviews() {
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            } else if subView is UIPageControl {
                self.view.bringSubviewToFront(subView)
            }
        }
        super.viewDidLayoutSubviews()
    }
    
    func updateUI() {
        
        for i in 0...model.tweets.count-1
        {
            let newPage = storyboard?.instantiateViewController(identifier: "SinglePage") as! PageViewController
            newPage.tweetText = model.tweets[i]
            newPage.dateText = String(model.dates[i].prefix(20))
            pages.append(newPage)
        }
        
        self.view.layoutIfNeeded()
    }
    

    let model = TwitterAPI_Access.sharedInstance

    var pages = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.dataSource = self
        model.delegate = self
        
        model.getTweets()
        print(model.tweets.count)
        
        let singlePage = storyboard?.instantiateViewController(identifier: "FrontPage")
        pages.append(singlePage!)
        
        if let firstVC = pages.first
            {
                setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            }
        
    }

}

extension DiaryViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return pages.last }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    

}

extension DiaryViewController: UIPageViewControllerDelegate { }

