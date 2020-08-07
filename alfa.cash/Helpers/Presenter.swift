//
//  Presenter.swift
//  AlfaCash
//
//  Created by Anna Alimanova on 30.01.2020.
//  Copyright © 2020 Anna Alimanova. All rights reserved.
//

import UIKit

class Presenter {
    
    static func showCustomScreen() {
        
        showSettings()
    }
    
    private static func showSettings() {
        if let settingsVC = UIStoryboard.get(flow: .settings).instantiateInitialViewController() as? SettingsViewController {
            let navVC = UINavigationController(rootViewController: settingsVC)
            Presenter.setRootVC(navVC)
        }
    }
    
    private static func setRootVC(_ vc: UIViewController) {
        if #available(iOS 13.0, *) {
            let sharedSceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            let window = sharedSceneDelegate?.window
            window?.rootViewController = vc
        } else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = vc
            }
        }
    }
}
