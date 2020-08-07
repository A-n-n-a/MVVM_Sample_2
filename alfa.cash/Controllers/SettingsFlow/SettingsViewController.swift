//
//  SettingsViewController.swift
//  AlfaCash
//
//  Created by Anna Alimanova on 27.01.2020.
//  Copyright © 2020 Anna Alimanova. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController, UsernameViewDelegate {
    
    @IBOutlet weak var tableView: SettingsTableView!
    
    var viewModel = SettingsViewModel()
    var usernameView: UsernameView!
    let usernameViewHeignt: CGFloat = 300
    var bottomConstraint: NSLayoutConstraint?
    var bottomConnectViewConstraint: NSLayoutConstraint?
    
    let connectView = ConnectView(frame: CGRect(x: 12, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 24, height: 284))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavBar(title: "SETTINGS")
        registerCell()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.reloadData()
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func registerCell() {
        tableView.register(cellClass: UsernameTableViewCell.self)
        tableView.register(cellClass: SettingsBaseTableViewCell.self)
        tableView.register(cellClass: SettingsIconTableViewCell.self)
    }
    
    func setupUI() {
        let frame = view.frame
        usernameView = UsernameView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: usernameViewHeignt + 30))
        usernameView.delegate = self
        connectView.delegate = self
    }
    
    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func showUsernameView() {
        guard let window = window else { return }
        updateBlackView()
        window.addSubview(blackView)
        blackView.addSubview(usernameView)
        usernameView.translatesAutoresizingMaskIntoConstraints = false
        usernameView.leadingAnchor.constraint(equalTo: blackView.leadingAnchor).isActive = true
        usernameView.trailingAnchor.constraint(equalTo: blackView.trailingAnchor).isActive = true
        bottomConstraint = usernameView.bottomAnchor.constraint(equalTo: blackView.bottomAnchor, constant: 30)
        bottomConstraint?.isActive = true
        usernameView.heightAnchor.constraint(equalToConstant: 330).isActive = true
        blackView.frame = window.frame
        
        usernameView.checkingLabel.isHidden = true
        usernameView.checkmark.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 1
            self.blackView.layoutIfNeeded()
        }
    }
    
    func hideUsernameView() {
        tableView.reloadData()
        usernameView.usernameTextField.resignFirstResponder()
        bottomConstraint?.constant = 330
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
            self.blackView.layoutIfNeeded()
        }) { (_) in
            self.usernameView.removeFromSuperview()
        }
    }
    
    fileprivate func showConnectView() {
        guard let window = window else { return }
        updateBlackView()
        window.addSubview(blackView)
        blackView.addSubview(connectView)
        connectView.translatesAutoresizingMaskIntoConstraints = false
        connectView.leadingAnchor.constraint(equalTo: blackView.leadingAnchor, constant: 12).isActive = true
        blackView.trailingAnchor.constraint(equalTo: connectView.trailingAnchor, constant: 12).isActive = true
        bottomConnectViewConstraint = blackView.bottomAnchor.constraint(equalTo: connectView.bottomAnchor, constant: 30)
        bottomConnectViewConstraint?.isActive = true
        connectView.heightAnchor.constraint(equalToConstant: 284).isActive = true
        blackView.frame = window.frame
        
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 1
            self.blackView.layoutIfNeeded()
        }
    }
    
    fileprivate func hideConnectView() {
        bottomConnectViewConstraint?.constant = -400
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
            self.blackView.layoutIfNeeded()
        }) { (_) in
            self.connectView.removeFromSuperview()
        }
    }
    
    override func handleDismiss() {
        hideUsernameView()
        hideConnectView()
    }
    
    @objc func logout() {
        viewModel.logoutAction()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint?.constant = -(keyboardSize.height - 30)
            UIView.animate(withDuration: 0.4) {
                self.blackView.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint?.constant = 30
        UIView.animate(withDuration: 0.4) {
            self.blackView.layoutIfNeeded()
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
        switch section {
        case .profile, .referrals, .alfaCashAccount, .theme: return 1
        case .security: return viewModel.securitySection.count
        case .localSettings: return viewModel.settingsSection.count
        case .about: return viewModel.aboutSection.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: cellId(SettingsBaseTableViewCell.self)) as! SettingsBaseTableViewCell
        var item: SettingsViewModel.SettingsItem?
        switch section {
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId(UsernameTableViewCell.self)) as! UsernameTableViewCell
            if let username = ApplicationManager.profile?.login, !username.isEmpty {
                cell.username = "@\(username)"
            } else {
                cell.username = nil
            }
            return cell
        case .security:
            item = viewModel.securitySection[indexPath.row]
        case .localSettings:
            item = viewModel.settingsSection[indexPath.row]
        case .about:
            item = viewModel.aboutSection[indexPath.row]
        case .theme:
            item = .theme
        case .alfaCashAccount, .referrals:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId(SettingsIconTableViewCell.self)) as! SettingsIconTableViewCell
            let item: SettingsViewModel.SettingsItem = section == .alfaCashAccount ? .account : .referal
            cell.model = viewModel.settingsModel(item: item)
            return cell
        }
        if let item = item {
            let model = viewModel.settingsModel(item: item)
            settingsCell.model = model
        }
        return settingsCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.sections[indexPath.section]
        
        switch section {
        case .referrals: return 80
        case .profile, .alfaCashAccount, .localSettings: return 75
        case .security, .theme, .about: return 56
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var text = ""
        let section = viewModel.sections[section]
        
        switch section {
        case .referrals:
            text = "REFERRALS"
        case .profile:
            text = "PROFILE"
        case .security:
            text = "SECURITY"
        case .alfaCashAccount:
            text = "ALFACASH_ACCOUNT"
        case .localSettings:
            text = "LOCAL_SETTINGS"
        case .theme:
            text = "SKINS"
        case .about:
            text = "ABOUT_ALFACASH_WALLET"
        }

        return text.headerThemedViewWithTitle()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setHighlighted(false, animated: false)
        
        let item = viewModel.itemForIndexPath(indexPath)
        viewModel.handleLocalSettingsSelection(item: item) {
            switch item {
            case .username:
                if let username = ApplicationManager.profile?.login, !username.isEmpty, let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as? UsernameTableViewCell {
                    cell.copyName()
                } else {
                    self.showUsernameView()
                }
            case .referal:
                self.showConnectView()
            case .account:
                self.connectToAlfacash()
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == viewModel.sections.count - 1 {
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 52))
            let button = NoBorderThemedButton(frame: footer.frame)
            button.localizedKey = "SIGN_OUT_OF_CURRENT_SEEDPHRASE"
            button.addTarget(self, action: #selector(logout), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.setTitleColor(UIColor.kErrorColor, for: .normal)
            footer.addSubview(button)
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == viewModel.sections.count - 1 {
            return 52
        }
        return 0
    }
}

extension SettingsViewController: ConnectViewDelegate {
    func connectToAlfa() {
        connectToAlfacash()
    }
}
