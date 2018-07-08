//
//  AppDelegate.swift
//  FTN
//
//  Created by Marko Stajic on 11/7/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit
import CoreData
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var unitType = UnitType.imperial
    var defaults = UserDefaults.standard
    var reach: Reachability?
    var syncingStarted = false
    var deviceToken : String! {
        didSet{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationNames.sendAPNSToken), object: nil, userInfo: nil)
        }
    }
    var temporaryAuthToken : String = "" //Put token when registration starts - save it in UserDefaults when registration is finished
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if let authToken = defaults.value(forKey: UserDefaultsStrings.authToken) as? String {
            
            print("• Saved authorization token: \(authToken)")
            RestManager.sharedInstance.updateAuthToken(token: authToken)
                        
            let homeStoryboard = UIStoryboard(name: "BloodPressure", bundle: nil)
            let homeController = homeStoryboard.instantiateViewController(withIdentifier: "BloodPressureStartVC") as! BloodPressureStartVC
            
            window!.rootViewController = homeController
            window!.makeKeyAndVisible()
            
            //Heap
            setHeap()

        }else{
            let onboarding = UIStoryboard(name: "Onboarding", bundle: nil)
            let rootController = onboarding.instantiateViewController(withIdentifier: "OnboardingNavigationController") as! UINavigationController
            
            window!.rootViewController = rootController
            window!.makeKeyAndVisible()
        }

        if let unitRawValue = defaults.value(forKey: UserDefaultsStrings.unitForApp) as? Int {
            self.unitType = UnitType(rawValue: unitRawValue)!
        }
        
        setStatusBarColor(light: true)
        
        // Allocate a reachability object
        self.reach = Reachability.forInternetConnection()
        
        // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
        self.reach!.reachableOnWWAN = true
        
        // Here we set up a NSNotification observer. The Reachability that caused the notification
        // is passed in the object parameter
        NotificationCenter.default.addObserver(self, selector: #selector(reachabiltyChanged(notification:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        
//        registerForPushNotification(application: application)
        
        self.reach!.startNotifier()
        // Override point for customization after application launch.
        
        return true
    }
    
    func setHeap(){
        print("• Heap set! •")
        Heap.setAppId(HeapCredentials.appId)
        #if DEBUG
            Heap.enableVisualizer()
        #endif
        
    }
    
    func setHeapIdentity(email: String){
        Heap.identify(email)
        print("• Heap set for user: \(email) •")
    }
    
    func setStatusBarColor(light: Bool) {
        if light {
            UIApplication.shared.statusBarStyle = .lightContent
        }else{
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
    func reachabiltyChanged(notification: Notification) {
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            print("Service avalaible!!!")
            if !syncingStarted {
                syncCoreDataAndServer()
            }
        } else {
            print("No service avalaible!!!")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveContext()
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "uk.co.plymouthsoftware.core_data" in the application's documents Application Support directory.
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "HeartLogModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator : NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let url = self.applicationDocumentsDirectory.appendingPathComponent("HeartLogModel 4.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func registerForPushNotification(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("Register notifications settings")
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceString = deviceToken.hexEncodedString()
        
        print("Device string: \(deviceString)")
        self.deviceToken = deviceString
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register push notifications")
        print("Error: \(error.localizedDescription)")
    }
}

extension AppDelegate {
    func fillCoreData(){
        
        print("• CORE DATA ALREADY FILLED: \(defaults.bool(forKey: UserDefaultsStrings.coreDataFilled))")
        if !defaults.bool(forKey: UserDefaultsStrings.coreDataFilled) {
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationNames.fetchStarted), object: nil)
            }
            
            let queue:DispatchQueue	= DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
            let group:DispatchGroup	= DispatchGroup()
            
            group.enter()
            DataManager.sharedInstance.getAllBloodPressureFromServer(url: nil, readings: nil, completionHandler: { (result) in
                group.leave()
                if result {
                    print("SKINUO SVE SA SERVERA - PRITISAK")
                }else{
                    print("NIJE SKINUO NISTA SA SERVERA - PRITISAK")
                }
            })
            group.notify(queue: queue) {
                // This closure will be executed when all tasks are complete
                DispatchQueue.main.async {
                    self.syncCoreDataAndServer()
                }
            }
            defaults.set(true, forKey: UserDefaultsStrings.coreDataFilled)
        }else{
            print("Core Data already filled with data - Sync starting")
            self.syncCoreDataAndServer()
        }
    }
    func syncCoreDataAndServer(){
        
        syncingStarted = true
        
        let queue:DispatchQueue	= DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        let group:DispatchGroup	= DispatchGroup()
        
        print("Sync started... ")
        let bpList = DataManager.sharedInstance.getBloodPressureReadingsFromCoreData()
        for b in bpList {
            
            group.enter()
            print("BP Reading ID: \(b.id) Synced: \(b.syncedWithServer) Object ID: \(b.objectId)")
            if b.id == "" && b.syncedWithServer == false {
                DataManager.sharedInstance.postBloodPressureReading(bloodPressureReading: b, update: true, completion: { (SingleBloodPressureReadingResponse) in
                    
                    group.leave()
                    
                    if SingleBloodPressureReadingResponse.success {
                        print("Core data and Server synced in background - SAVED BP READING")
                    }
                })
            }else if b.syncedWithServer == false {
                DataManager.sharedInstance.editBloodPressureReading(bloodPressureReading: b, completion: { (SingleBloodPressureReadingResponse) in
                    
                    group.leave()

                    if SingleBloodPressureReadingResponse.success {
                        print("Core data and Server synced in background - UPDATED BP READING")
                    }
                })
            }else{
                group.leave()
            }
        }

        group.notify(queue: queue) {
            // This closure will be executed when all tasks are complete
            print("All tasks complete - Core data synced with server")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationNames.fetchFinished), object: nil)
            self.syncingStarted = false
        }
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
