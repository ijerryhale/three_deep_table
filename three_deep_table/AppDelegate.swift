//
//  AppDelegate.swift
//
//  Created by Jerry Hale on 4/11/17.
//  Copyright © 2017 jhale. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var movie = [[String: AnyObject]]()
	var theater = [[String: AnyObject]]()


	private func readjson() -> [Any]
	{
		do {
			if let file = Bundle.main.url(forResource: "theater", withExtension: "json")
			{
				let data = try Data(contentsOf: file)
				let json = try JSONSerialization.jsonObject(with: data, options: [])
				
				return json as! [Any]
				
			} else { print("no file") }
		} catch {
			print(error.localizedDescription)
		}
		
		return []
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
	{
		//	read the theater.json file
		theater = readjson() as! [[String : AnyObject]]

		//	sort the Theaters by Theater name
		theater.sort { ($0[KEY_NAME]! as! String) < ($1[KEY_NAME]! as! String) }

		//	create a set to hold Movie tms_id's
		let tms_id: NSMutableSet = NSMutableSet()

		//	loop thru the Theaters and create a unique set of Movies
		for t in theater
		{
			for ns in t[KEY_NOW_SHOWING] as! [[String:AnyObject]]
			{
				let tmsid = (ns as AnyObject)[KEY_TMS_ID] as! String

				if tms_id.contains(tmsid) { continue }

				tms_id.add(tmsid)
				movie.append(ns);
			}
		}

		//	sort the Movies by Movie title
		movie.sort { ($0[KEY_TITLE]! as! String) < ($1[KEY_TITLE]! as! String) }

		//	have a go at it
		let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		
		self.window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
		self.window?.makeKeyAndVisible()

		return true
	}

	func applicationWillResignActive(_ application: UIApplication)
	{
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication)
	{
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication)
	{
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication)
	{
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication)
	{
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

