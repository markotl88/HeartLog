//
//  HistoryResultVC.swift
//  FTN
//
//  Created by Marko Stajic on 12/23/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

protocol SingleResultDelegate: class {
    func resultClosed()
    func deletedResult()
    func resultEdited(result: BloodPressureReading)
}

class HistoryResultVC: UIViewController {
    
    weak var delegate : SingleResultDelegate?
    var isPresenting: Bool = true
    
    @IBOutlet weak var timeLabel: TimeLabel!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var moodLabel: UserAttributeLabel!
    @IBOutlet weak var activityLabel: UserAttributeLabel!
    @IBOutlet weak var noteLabel: SubtitleLabel!
    
    @IBOutlet weak var sysLabel: CellTitle!
    @IBOutlet weak var diaLabel: CellTitle!
    @IBOutlet weak var heartbeatLabel: CellTitle!
    
    @IBOutlet weak var systolicUnitLabel: CellTitle!
    @IBOutlet weak var diastolicUnitLabel: CellTitle!
    @IBOutlet weak var heartbeatUnitLabel: CellTitle!
    
    @IBOutlet weak var systolicResultLabel: CellResultLabel!
    @IBOutlet weak var diastolicResultLabel: CellResultLabel!
    @IBOutlet weak var heartbeatResultLabel: CellResultLabel!
    
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var editEntryButton: CustomButton!
    
    @IBOutlet var borderLines: [UIView]!
    @IBOutlet weak var resultView: UIView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    var bloodPressureReading : BloodPressureReading? {
        didSet {
            updateData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateViews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(){
        super.init(nibName: String(describing: HistoryResultVC.self), bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = UIModalPresentationStyle.custom
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews(){
        self.view.backgroundColor = UIColor.clear
        resultView.backgroundColor = UIColor.white
        resultView.layer.cornerRadius = 4.0
        resultView.clipsToBounds = true
        for border in borderLines {
            border.backgroundColor = UIColor.dmsCloudyBlue
        }
        editEntryButton.updateEnabledButtonColors(backgroundColor: UIColor.dmsOffBlue, titleColor: UIColor.white)
        editEntryButton.setEnabled = true
        moodLabel.updateTextColor(color: UIColor.dmsOffBlue)
        activityLabel.updateTextColor(color: UIColor.dmsOffBlue)
        noteLabel.updateFont(size: 14)
        
        sysLabel.updateFont(size: 14)
        diaLabel.updateFont(size: 14)
        heartbeatLabel.updateFont(size: 14)
        
        systolicUnitLabel.updateFont(size: 14)
        diastolicUnitLabel.updateFont(size: 14)
        heartbeatUnitLabel.updateFont(size: 14)
        
        systolicResultLabel.updateFont(size: 30)
        diastolicResultLabel.updateFont(size: 30)
        heartbeatResultLabel.updateFont(size: 30)
        
    }
    func updateData(){
        if let bloodPressureReading = bloodPressureReading {
            
            self.timeLabel.text = (bloodPressureReading.dateCreated.getLocalShortDate() ?? "") + " • " + (bloodPressureReading.dateCreated.getLocalShortTime() ?? "")
            self.moodLabel.text = Mood(rawValue: bloodPressureReading.mood?.capitalized ?? "").map { $0.rawValue }
            self.moodImage.image = Mood(rawValue: bloodPressureReading.mood?.capitalized ?? "")?.image
            self.activityLabel.text = bloodPressureReading.activity?.capitalized
            self.activityImage.image = ActivityBP(rawValue: bloodPressureReading.activity?.capitalized ?? "")?.image
            
            self.systolicResultLabel.text = String(bloodPressureReading.systolic)
            self.diastolicResultLabel.text = String(bloodPressureReading.diastolic)
            self.heartbeatResultLabel.text = String(bloodPressureReading.heartRate)
            
            self.noteLabel.text = bloodPressureReading.note
        }
    }
    
    @IBAction func closeResult(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate?.resultClosed()
    }
    @IBAction func editResult(_ sender: UIButton) {
        if let bloodPressureReading = bloodPressureReading {
            
            AppCoordinator.shared.showEditBPViewController(viewController: self, reading: bloodPressureReading)
            
//            let storyboard = UIStoryboard(name: "BloodPressure", bundle: nil)
//            if let navController = storyboard.instantiateViewController(withIdentifier: "editNavigationController") as? UINavigationController {
//                self.present(navController, animated: true, completion: nil)
//                (navController.topViewController as? EditBPEntryVC)?.bloodPressureReadingOriginal = bloodPressureReading
//                (navController.topViewController as? EditBPEntryVC)?.delegate = self
//            }
        }
    }
}

extension HistoryResultVC : EditResultDelegate {
    func returnBpResult(result: BloodPressureReading) {
        print("Edited")
        self.bloodPressureReading = result
        delegate?.resultEdited(result: result)
    }
    func resultDeleted() {
        self.dismiss(animated: true) { 
            self.delegate?.deletedResult()
        }
    }
}

extension HistoryResultVC : UIViewControllerAnimatedTransitioning {
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

extension HistoryResultVC : UIViewControllerTransitioningDelegate {
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

