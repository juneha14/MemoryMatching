//
//  AppDelegate.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-18.
//  Copyright © 2019 June Ha. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()

        // Custom flow layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 30, height: 30)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)

        let vc = CardsCollectionViewController(collectionViewLayout: flowLayout)
        window?.rootViewController = vc

        return true
    }
}

