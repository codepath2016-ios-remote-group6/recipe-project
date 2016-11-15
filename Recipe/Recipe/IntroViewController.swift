//
//  IntroViewController.swift
//  Recipe
//
//  Created by Craig Vargas on 11/14/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    public static let finishedIntroNotification = Notification.Name("finishedIntro")
    
    @IBOutlet weak var pageOneView: UIView!
    @IBOutlet weak var pageTwoView: UIView!
    @IBOutlet weak var pageThreeView: UIView!
    @IBOutlet var parentView: UIView!
    
    @IBOutlet weak var introPageControl: UIPageControl!
    
    var views = [UIView]()
    var pagerDicts = [Dictionary<String,Any>]()
    var pager = Pager(numPages: 3)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGestureRecognizers()
        setupViewsArray()
        setupInitialView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Wire up exit button
    @IBAction func didTapExitButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: IntroViewController.finishedIntroNotification, object: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //*
    //*
    //Low level detail
    //*
    //*
    private func setupGestureRecognizers(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanParent))
        self.parentView.addGestureRecognizer(panGesture)
    }
    
    internal func didPanParent(panGesture: UIPanGestureRecognizer){
        switch panGesture.state {
        case UIGestureRecognizerState.began:
//            print("Page panning began")
            break
        case UIGestureRecognizerState.changed:
//            let velocity = panGesture.velocity(in: parentView)
//            print("Velocity -> X: \(velocity.x), Y: \(velocity.y)")
            break
        case UIGestureRecognizerState.ended:
//            print("Page panning ended")
            let velocity = panGesture.velocity(in: parentView)
//            print("Velocity -> X: \(velocity.x), Y: \(velocity.y)")
            if(velocity.x < -50.0){
                pageRight()
            }else if(velocity.x > 50.0){
                pageLeft()
            }
            break
        default:
            break
        }
    }
    
    private func setupViewsArray(){
        self.views.append(self.pageOneView)
        self.views.append(self.pageTwoView)
        self.views.append(self.pageThreeView)
    }
    
    private func setupInitialView(){
        //Setup initial paging
        self.pageTwoView.alpha=0.0
        self.pageThreeView.alpha=0.0
        self.pager.current = 0
        self.introPageControl.currentPage = 0
        //Modify page control bar
        self.introPageControl.layer.cornerRadius = 4
        self.introPageControl.clipsToBounds = true
    }
    
    private func pageLeft(){
        
        if(self.pager.current != self.pager.minIndex){
            UIView.animate(withDuration: 1.0, animations: {
                self.views[self.pager.prev].alpha = 1.0
                self.views[self.pager.current].alpha = 0.0
                self.pager.decrement()
                self.introPageControl.currentPage = self.pager.current
            })
        }
    }
    
    private func pageRight(){
        if(self.pager.current != self.pager.maxIndex){
            UIView.animate(withDuration: 1.0, animations: {
                self.views[self.pager.next].alpha = 1.0
                self.views[self.pager.current].alpha = 0.0
                self.pager.increment()
                self.introPageControl.currentPage = self.pager.current
            })
        }
    }
    
    class Pager{
        var current: Int
        var numPages: Int
        var maxIndex: Int
        let minIndex: Int = 0
        
        init(numPages: Int){
            self.current = 0
            self.numPages = numPages
            self.maxIndex = numPages - 1
        }
        
        var next: Int{
            get{
                switch current {
                case maxIndex:
                    return current
                default:
                    return current + 1
                }
            }
        }
        
        var prev: Int{
            get{
                switch current {
                case minIndex:
                    return current
                default:
                    return current - 1
                }
            }
        }
        
        func increment(){
            self.current = self.next
        }
        
        func decrement(){
            self.current = self.prev
        }

    }

}
