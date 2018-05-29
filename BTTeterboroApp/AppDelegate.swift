//
//  AppDelegate.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/19/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import UserNotifications
import OneSignal
import FCAlertView


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, FCAlertViewDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        /* check for user's token */
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {

            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "signInWaitVC")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            
            let db = Firestore.firestore()
            let accessDoc = db.collection("AccessControl")
            
            
            accessDoc.getDocuments { (document, error) in
                if error != nil{
                    
                    self.makeFCAlertView(title: "An unexpected error occured", message: "Please close the app and try again.", buttons: [])
                    
                }else if let item = document?.documents[0]{
                        
                    if(item.data()["Enabled"] as! Bool == false){
                        
                        var message = String(describing: item.data()["message"]!)
                        if (message == "" || message == "None"){
                            message = "No further information. The application will be available again shortly."
                        }
                        
                        self.makeFCAlertView(title: "Connection Refused", message: message, buttons: [])
                        
                        
                        
                    }else{
                        
                        GIDSignIn.sharedInstance().signInSilently()
                        
                        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
                        
                        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
                        OneSignal.initWithLaunchOptions(launchOptions,
                                                        appId: "46dc21e4-34f4-42b2-9e4f-b465a8fb6dba",
                                                        handleNotificationAction: nil,
                                                        settings: onesignalInitSettings)
                        
                        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
                        
                    }
                    
                }else{
                    
                    self.makeFCAlertView(title: "An unexpected error occured", message: "Please close the app and try again.", buttons: [])
                    
                }
            }

        } else {
            /* code to show your login VC */
            print("User not logged in")
        }
        return true
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?){
        // ...
        print("Attempting sign in")
        if let error = error {
            // ...
            print("APPDELEGATE GIDSIGN IN: ", error.localizedDescription)
            
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                print("ERROR: ", error)
                return
            }
            // User is signed in
            // ...
            
            print(GIDSignIn.sharedInstance().currentUser.profile.email)
            print("User successfully signed in")
            
            let userEmailDomain = self.getMainPart(s: (user?.email)!)
            
            
            
            print("THIS IS BEING CALLED BECAUSE ENABLED IS TRUE")
            if userEmailDomain == "bergen"{
            
                let pushStatus: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
                
                if (pushStatus.permissionStatus.hasPrompted == false){
                    
                    self.makeFCAlertView(title: "Allow Notifications?", message: "Stay up to date with information about important school events, school closings, or other important announcements.", buttons: ["Continue"])
                    
                }
                
                
                if self.window?.rootViewController is SignInVC {
                    //do something if it's an instance of that class
                    //                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                    //                let viewController: SignInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC;
                    //
                    //                // Then push that view controller onto the navigation stack
                    //                let rootViewController = self.window!.rootViewController as! UIViewController;
                    
                    self.window?.rootViewController!.performSegue(withIdentifier: "loginToHomeVC", sender: nil)
                    
                }else if self.window?.rootViewController is SignInWaitVC{
                    
                    // Then push that view controller onto the navigation stack
                    
                    self.window?.rootViewController!.performSegue(withIdentifier: "signInWaitToHome", sender: nil)
                    
                    //signInWaitToHome
                }
            }else{
                print("User must sign in with their bergen account")
                GIDSignIn.sharedInstance().signOut()

                self.window = UIWindow(frame: UIScreen.main.bounds)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "SignInVC")
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()

                let alertController = UIAlertController(title: "Login Failed", message: "Users can only login with a bergen.org gmail. Please sign in with your bergen.org gmail.", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
            }
            
            
            
            

        }
        // ...
    }
    
    func makeFCAlertView(title: String, message: String, buttons: [String]){
        let alert = FCAlertView()
        alert.colorScheme = UIColor(red: 198/255, green: 180/255, blue: 69/255, alpha: 1.0)
        alert.hideDoneButton = true
        alert.delegate = self
        alert.secondButtonBackgroundColor = UIColor(red: 198/255, green: 180/255, blue: 69/255, alpha: 1.0)
        alert.secondButtonTitleColor = UIColor.white
        alert.dismissOnOutsideTouch = false
        alert.overrideForcedDismiss = true
        alert.showAlert(inView: UIApplication.topViewController(),
                        withTitle: title,
                        withSubtitle: message,
                        withCustomImage: UIImage(named: "ExclamationMarkYellow"),
                        withDoneButtonTitle: nil,
                        andButtons: buttons)
    }
    
    func fcAlertView(_ alertView: FCAlertView, clickedButtonIndex index: Int, buttonTitle title: String) {
        print("TITLE CHECK CALLED")
        if title == "Continue" {
            // Perform Action for Button 1
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                print("User accepted notifications: \(accepted)")
            })
            
        }
    }
    
    
    func getMainPart(s: String) -> String {
        let charSet = CharacterSet(charactersIn: ".@")
        let v = s.components(separatedBy: charSet)
        let pos = v.count - 2
        return v[pos]
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            if granted == true{
                
            }
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BTTeterboroApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

