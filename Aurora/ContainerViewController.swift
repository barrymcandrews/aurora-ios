//
//  ContainerViewController.swift
//  Aurora
//
//  Created by Barry McAndrews on 5/2/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import AuroraCore
import Hero
import ColorPicker

enum ContainerPage: Int {
    case huePage = 0
    case rgbPage = 1
    case sequencePage = 2
    
    init?(page: UIViewController) {
        if (page is HuePageViewController) { self = .huePage }
        else if (page is RGBPageViewController) { self = .rgbPage }
        else if (page is SequencePageViewController) { self = .sequencePage }
        else { fatalError("The given view controller is not a ContainerPage") }
    }
}

class ContainerViewController: UIViewController, RequestMaker {
    var currentPage = ContainerPage.huePage
    var child: UIViewController!
    var initialRequest: Request?
    var pages: [UIViewController?] = [UIViewController?](repeating: nil, count:3) //Should match enum size
    var animationSender: UIControl?


    override func viewDidLoad() {
        super.viewDidLoad()
        //pages[ContainerPage.ColorPage.rawValue] = storyboard?.instantiateViewController(withIdentifier: "ColorPage") as! ColorPageViewController
        
        pages[ContainerPage.huePage.rawValue] = HuePageViewController.preloaded
        pages[ContainerPage.rgbPage.rawValue] = (storyboard?.instantiateViewController(withIdentifier: "RGBPage"))!
        pages[ContainerPage.sequencePage.rawValue] = (storyboard?.instantiateViewController(withIdentifier: "SequencePage"))!
        

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var firstPage = ContainerPage.huePage
        
        for page in pages {
            var page = page as! RequestMaker
            page.initialRequest = initialRequest
        }
        
        if (initialRequest is SequenceRequest) {
            firstPage = .sequencePage
        }
        
        setPage(firstPage, animated: false)
    }
    
    func setPage(_ page: ContainerPage, animated: Bool = true) {
        currentPage = page
        if (animated) {
            change(toViewController: pages[page.rawValue]!)
        } else {
            self.addChildViewController(pages[page.rawValue]!)
            self.view.embedView((pages[page.rawValue]?.view)!)
            pages[page.rawValue]?.didMove(toParentViewController: self)
            child = pages[page.rawValue]
        }
    }
    
    func buildRequest() -> Request {
        let maker = pages[currentPage.rawValue] as! RequestMaker
        return maker.buildRequest()
    }

    
    func change(toViewController: UIViewController) {
        let oldVC = child!
        let newVC = toViewController
        
        let oldPage = ContainerPage(page: oldVC)?.rawValue
        let newPage = ContainerPage(page: newVC)?.rawValue
        let rightDirection = ((newPage! - oldPage!) < 0)
        
        let oldRM = child as! RequestMaker
        var newRM = newVC as! RequestMaker
        if (!(newRM is SequenceRequest)) {
            newRM.initialRequest = oldRM.buildRequest()
        }
        
        oldVC.willMove(toParentViewController: nil)
        self.addChildViewController(newVC)
        newVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(newVC.view)
        
        // For regular, non-Hero, transition:
        // self.transition(from: oldVC, to: newVC, duration: 0.25, options: .transitionCrossDissolve, animations: {}, completion: { finished in
        //     oldVC.view.removeFromSuperview()
        //     oldVC.removeFromParentViewController()
        //     newVC.didMove(toParentViewController: self)
        //     self.child = newVC
        // })
        
        Hero.shared.setDefaultAnimationForNextTransition(.slide(direction: (rightDirection ? .right : .left)))
        Hero.shared.transition(from: oldVC, to: newVC, in: self.view) { finished in
            if finished {
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
                newVC.didMove(toParentViewController: self)
                self.child = newVC
                
                if let sender = self.animationSender {
                    sender.isUserInteractionEnabled = true
                }
            }
        }
    }
}
