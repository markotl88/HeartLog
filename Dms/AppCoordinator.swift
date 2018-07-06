//
//  AppCoordinator.swift
//  DPS
//
//  Created by Marko Stajic on 12/25/17.
//  Copyright © 2017 Marko Stajic. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    static let shared = AppCoordinator()
    
    init() {
        
    }
    
    fileprivate var navigationController: UINavigationController?

    // MARK: - Root
    
    func setBloodPressureListAsRoot() {
        
        let bpListViewController = BPHistoryVC.makeFromHomeStoryboard()
        navigationController = bpListViewController.embedInNavigationController()
        setWindowRootViewController(navigationController!)
    }
    
    // MARK: - Show controller from side menu
    func showHomeViewController() {
        let homeViewController = HomeViewController.makeFromLoginStoryboard()
        setNavigationRootViewController(homeViewController)
    }
    
    func showBPMeasuringViewController(bpDeviceInstance: BP7?) {
        let bpMeasuringViewController = BPMeasuringVC.makeFromHomeStoryboard()
        bpMeasuringViewController.bpDeviceInstance = bpDeviceInstance
        navigationController?.pushViewController(bpMeasuringViewController, animated: true)
    }
    
    func showEditBPViewController(viewController: UIViewController, reading: BloodPressureReading) {
        let editBPViewController = EditBPEntryVC.makeFromHomeStoryboard()
        editBPViewController.bloodPressureReadingOriginal = reading
        editBPViewController.delegate = viewController as? EditResultDelegate
        navigationController = editBPViewController.embedInNavigationController()
        viewController.present(navigationController!, animated: true, completion: nil)
    }
    
    func showBPMStartMeasureViewController(viewController: UIViewController) {
        let bpMeasureViewController = BloodPressureStartVC.makeFromHomeStoryboard()
        viewController.present(bpMeasureViewController, animated: true, completion: nil)
    }
    
    func showAutomaticBPMeasureViewController(viewController: UIViewController) {
        let bpAngleViewController = BPAngleVC.makeFromHomeStoryboard()
        navigationController = bpAngleViewController.embedInNavigationController()
        viewController.present(navigationController!, animated: true, completion: nil)
        hideNavigationBar()
    }
    
    func showAutomaticBPMeasureAfterTipsViewController() {
        let bpAngleViewController = BPAngleVC.makeFromHomeStoryboard()
        navigationController?.pushViewController(bpAngleViewController, animated: true)
        hideNavigationBar()
    }

    func showBPResultViewController(bloodPressureReading: BloodPressureReading) {
        let bpResultViewController = BPResultVC.makeFromHomeStoryboard()
        bpResultViewController.bloodPressureReading = bloodPressureReading
        navigationController?.pushViewController(bpResultViewController, animated: true)
        showNavigationBar()
    }
    
    func showTipsForBPMeasuring(viewController: UIViewController) {
        let bpIntroViewController = BPSetupOneVC.makeFromHomeStoryboard()
        navigationController = bpIntroViewController.embedInNavigationController()
        viewController.present(navigationController!, animated: true, completion: nil)
    }
    
    func backToWelcomeScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Style
    
    fileprivate func setNavigationBarStyle(_ navigationController: UINavigationController) {
        
        let backgroundImage = #imageLiteral(resourceName: "navbar_red").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.stretch)
        navigationController.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationController.navigationBar.tintColor = UIColor.white
    }
    
    fileprivate func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    fileprivate func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Private
    fileprivate func setWindowRootViewController(_ rootViewController: UIViewController) {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.rootViewController = rootViewController
        }
    }
    
    fileprivate func setNavigationRootViewController(_ rootViewController: UIViewController) {
        navigationController!.viewControllers = [rootViewController]
    }
    
    fileprivate func setNavigationRootViewControllerWithoutToggle(_ rootViewController: UIViewController) {
        navigationController!.viewControllers = [rootViewController]
    }
    
    // MARK: - Side Menu
}

