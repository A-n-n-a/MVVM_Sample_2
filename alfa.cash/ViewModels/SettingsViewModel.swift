//
//  SettingsViewModel.swift
//  AlfaCash
//
//  Created by Anna Alimanova on 28.01.2020.
//  Copyright © 2020 Anna Alimanova. All rights reserved.
//

import UIKit

class SettingsViewModel {
    
    var sections: [Sections] = [.referrals, .profile, .security, .alfaCashAccount, .localSettings, .theme, .about]
    let securitySection: [SettingsItem] = [.recoveryPhrase, .appLock]
    let settingsSection: [SettingsItem] = [.currency, .language]
    let aboutSection: [SettingsItem] = [.version, .legal, .faq, .report]
    
    func settingsModel(item: SettingsItem) -> SettingsItemModel? {
        switch item {
        case .recoveryPhrase:
            return SettingsItemModel(title: "RECOVERY_PHRASE")
        case .appLock:
            return SettingsItemModel(title: "APP_LOCK")
        case .currency:
            //TODO: currencies support
            return SettingsItemModel(title: "LOCAL_CURRENCY", subtitle: "SET_UP_THE_BASE_CURRENCY", value: FiatManager.currentFiat.rawValue.uppercased())
        case .language:
            let lang = LanguageManager.currentLanguage.localizedName
            return SettingsItemModel(title: "LANGUAGE", value: lang)
        case .notifications:
            return SettingsItemModel(title: "NOTIFICATIONS", subtitle: "CONTROL_YOUR_NOTIFICATIONS")
        case .theme:
            let theme = ThemeManager.currentTheme
            return SettingsItemModel(title: theme.name)
        case .version:
            if let version = Bundle.main.version, let build = Bundle.main.build {
                let version = "\(version).\(build)"
                return SettingsItemModel(title: "VERSION", value: version, valueBlack: false)
            }
            return SettingsItemModel(title: "VERSION")
        case .legal:
            return SettingsItemModel(title: "LEGAL")
        case .faq:
            return SettingsItemModel(title: "SETTINGS_FAQ")
        case .report:
            return SettingsItemModel(title: "REPORT_A_PROBLEM")
        case .referal:
            return SettingsItemModel(title: "REFER_EARN", subtitle: "RECEIVE_20", image: #imageLiteral(resourceName: "giftWithWhiteContainer"))
        case .account:
            return SettingsItemModel(title: "CONNECT_TO_ALFACASH", subtitle: "ACCESS_DISCOUNT_AFFILIATE_PROGRAMS", image: #imageLiteral(resourceName: "alfacashLogo"))
        default:
            return nil
        }
    }
    
    func settingsModel(title: String) -> SettingsItemModel {
        return SettingsItemModel(title: title)
    }
    
    func handleLocalSettingsSelection(item: SettingsViewModel.SettingsItem, completion: (() -> Void)? = nil) {
        switch item {
        case .username:
            completion?()
        case .language:
            if let vc = UIStoryboard.get(flow: .settings).get(controller: .languages) as? LanguagesViewController {
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        case .currency:
            if let vc = UIStoryboard.get(flow: .settings).get(controller: .currencyVC) as? CurrencyViewController {
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        case .theme:
            if let vc = UIStoryboard.get(flow: .settings).get(controller: .themeVC) as? ThemeViewController {
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        case .legal:
            if let vc = UIStoryboard.get(flow: .settings).get(controller: .legalSettings) as? LegalSettingsViewController {
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        case .recoveryPhrase:
            if let vc = UIStoryboard.get(flow: .settings).get(controller: .recoveryPhrase) as? RecoveryPhraseViewController {
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        case .appLock:
            if let vc = UIStoryboard.get(flow: .settings).get(controller: .securitySettingsVC) as? SecuritySettingsViewController {
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        case .faq:
            if let vc = UIStoryboard.get(flow: .settings).get(controller: .faqVC) as? FaqViewController {
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        case .report:
            let email = Constants.Email.appAlfa
            if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url)
            }
        case .referal:
            if ApplicationManager.profile?.connectedToAlfacash ?? false, let referralVC = UIStoryboard.get(flow: .referral).instantiateInitialViewController() as? ReferralViewController {
                UIApplication.topViewController()?.navigationController?.pushViewController(referralVC, animated: true)
            } else {
                completion?()
            }
        case .account:
            completion?()
        default:
            break
        }
    }
    
    @objc func logoutAction() {
        if let vc = UIStoryboard.get(flow: .loginFlow).get(controller: .logout) as? LogoutViewController {
            vc.modalPresentationStyle = .fullScreen
            
            let transition:CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromTop
            UIApplication.topViewController()?.navigationController!.view.layer.add(transition, forKey: kCATransition)
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: false)
            
        }
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> SettingsItem {
        
        let section = sections[indexPath.section]
        
        var item: SettingsViewModel.SettingsItem
        switch section {
            case .referrals:
                item = .referal
            case .profile:
                item = .username
            case .security:
                item = securitySection[indexPath.row]
            case .alfaCashAccount:
                item = .account
            case .localSettings:
                item = settingsSection[indexPath.row]
            case .theme:
                item = .theme
            case .about:
                item = aboutSection[indexPath.row]
        }
        return item
    }
    
    enum Sections {
        case referrals
        case profile
        case security
        case alfaCashAccount
        case localSettings
        case theme
        case about
    }

    enum SettingsItem {
        case username
        case recoveryPhrase
        case appLock
        case currency
        case language
        case emptyWallets
        case notifications
        case theme
        case version
        case legal
        case faq
        case report
        case account
        case referal
    }

}
