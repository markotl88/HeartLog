//
//  ErrorVC.swift
//  FTN
//
//  Created by Marko Stajic on 4/5/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import UIKit

import UIKit

protocol ErrorDelegate: class {
    func cancelError()
    func restartMeasuring()
}

class ErrorVC: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    var isPresenting: Bool = true
    weak var delegate : ErrorDelegate?
    
    @IBOutlet weak var stopButton: CustomButton!
    @IBOutlet weak var continueButton: CustomButton!
    @IBOutlet weak var buttonBorder: UIView!
    @IBOutlet weak var borderLine: UIView!
    @IBOutlet weak var stopProcessTitleLabel: TitleLabel!
    @IBOutlet weak var stopProcessInfoLabel: CheckBoxLabel!
    
    var error : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        
    }
    @IBAction func noAction(_ sender: AnyObject) {
        delegate?.cancelError()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func yesAction(_ sender: AnyObject) {
        
        delegate?.restartMeasuring()
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateViews(){
        self.view.backgroundColor = UIColor.clear
        alertView.layer.cornerRadius = 4.0
        alertView.backgroundColor = UIColor.white
        buttonBorder.backgroundColor = UIColor.dmsCloudyBlue
        borderLine.backgroundColor = UIColor.dmsCloudyBlue
        
        stopButton.updateEnabledButtonColors(backgroundColor: UIColor.white, titleColor: UIColor.dmsTomato, highlightedColor: UIColor.dmsHighlightedWhite)
        stopButton.setEnabled = true
        continueButton.updateEnabledButtonColors(backgroundColor: UIColor.white, titleColor: UIColor.dmsOffBlue, highlightedColor: UIColor.dmsHighlightedWhite)
        continueButton.setEnabled = true
        
        stopProcessTitleLabel.updateFontSize(size: 24.0)
        stopProcessTitleLabel.updateTextColor(color: UIColor.dmsLightNavy)
        stopProcessInfoLabel.updateFontSize(size: 17.0)
        if let error = error {
            stopProcessInfoLabel.text = error + "\nPlease retake your reading."
        }else{
            stopProcessInfoLabel.text = "Please retake your reading."

        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    init(){
        super.init(nibName: String(describing: ErrorVC.self), bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = UIModalPresentationStyle.custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ErrorVC : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5 //Add your own duration here
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //Add presentation and dismiss animation transition here.
        if isPresenting == true{
            isPresenting = false
            let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
            let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
            let containerView = transitionContext.containerView
            
            presentedControllerView.frame = transitionContext.finalFrame(for: presentedController)
            //                    presentedControllerView.center.y -= self.point!.y
            presentedControllerView.alpha = 0
            presentedControllerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            containerView.addSubview(presentedControllerView)
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
                //            presentedControllerView.center.y += containerView.bounds.size.height
                //                presentedControllerView.center.y += self.point!.y
                presentedControllerView.alpha = 1
                presentedControllerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
            })
        }else{
            let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
            _ = transitionContext.containerView
            
            // Animate the presented view off the bottom of the view
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
                //                presentedControllerView.center.y += containerView.bounds.size.height
                presentedControllerView.alpha = 0
                presentedControllerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
            })
        }
        
    }
}

extension ErrorVC : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed == self {
            return self
        }
        else {
            return nil
        }
    }
    
}
