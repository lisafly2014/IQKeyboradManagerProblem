//
//  ViewController.swift
//  IQKeyboradManagerProblem
//
//  Created by Ximei Liu on 4/04/19.
//  Copyright © 2019 WHSoftware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var serverAddressLabel: UILabel!
    
    @IBOutlet weak var serverAddressTextField: UITextField!
    
    
    @IBOutlet weak var iconView: UIView!
    
    @IBOutlet weak var sslLabel: UILabel!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var iconViewHeightRatioConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var iconViewBottomConstraint: NSLayoutConstraint!
    
    var savedUrl: URL!
    
    var selectedSSL: String = ""
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    let smallFont = UIFont.systemFont(ofSize: 15.0)
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.backBarButtonItem = backItem
        
        configViews()
        
        disableButton(loginButton)
    }
    private func setFont(_ label: UILabel, _ font: UIFont){
        label.font = font
    }
    private func setFont(_ textField: UITextField, _ font: UIFont){
        textField.font = font
    }
    
    private func disableButton(_ button: UIButton){
        button.isEnabled = false
        button.alpha = 0.3
    }
    
    private func enableButton(_ button: UIButton){
        button.isEnabled = true
        button.alpha = 1.0
    }
    
    private func setButton(_ button: UIButton, backgroundColor: UIColor = UIColor.blue){
        button.backgroundColor = backgroundColor
        button.tintColor = UIColor.white
        setFont(button.titleLabel!,smallFont)
    }
    
    private func configViews(){
        setFont(serverAddressLabel,smallFont)
        serverAddressLabel.textColor = UIColor.darkGray
        setFont(serverAddressTextField,smallFont)
        serverAddressTextField.keyboardType = .numbersAndPunctuation
        serverAddressTextField.delegate = self
        
        if let serverAddress = UserDefaults.standard.string(forKey: "ServerAddress"){
            serverAddressTextField.text = serverAddress
        }
        
        setFont(sslLabel,smallFont)
        
        segment.setTitleTextAttributes([NSAttributedString.Key.font: smallFont], for: .normal)
        
        sslLabel.textColor = UIColor.darkGray
        
        setFont(userNameLabel,smallFont)
        
        userNameLabel.textColor = UIColor.darkGray
        
        setFont(userNameTextField,smallFont)
        
        userNameTextField.keyboardType = .asciiCapable
        
        userNameTextField.autocorrectionType = .no
        
        userNameTextField.autocapitalizationType = .none
        
        userNameTextField.delegate = self
        
        if let userName = UserDefaults.standard.string(forKey: "UserName"){
            userNameTextField.text = userName
        }
        
        setFont(passwordLabel,smallFont)
        
        passwordLabel.textColor = UIColor.darkGray
        
        setFont(passwordTextField,smallFont)
        
        passwordTextField.text = ""
        
        passwordTextField.isSecureTextEntry = true
        
        passwordTextField.keyboardType = .asciiCapable
        
        passwordTextField.autocorrectionType = .no
        
        passwordTextField.autocapitalizationType = .none
        
        passwordTextField.delegate = self
        
        setButton(loginButton)
        
        navigationItem.title = "Sign In"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let ssl = UserDefaults.standard.string(forKey: "SSL"){
            
            selectedSSL = ssl
            
            if selectedSSL == "HTTP"{
                
                segment.selectedSegmentIndex = 0
                
            }else{
                
                segment.selectedSegmentIndex = 1
                
            }
            
        }else{
            
            selectedSSL = segment.titleForSegment(at: segment.selectedSegmentIndex)!
            
            UserDefaults.standard.setValue(selectedSSL, forKey: "SSL")
            
        }
        
        satisfyLoginCondition()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: UITextField.textDidChangeNotification, object: nil)
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textFieldDidChange(){        
        satisfyLoginCondition()
    }
    
    private func satisfyLoginCondition(){
        
        var activate = false
        
        if ((serverAddressLabel.text != nil && serverAddressLabel.text!.count > 0) && selectedSSL != "" && (userNameTextField.text != nil && userNameTextField.text!.count > 0) && passwordTextField.text != nil && passwordTextField.text!.count > 0 ){
            
            activate = true
            
        }
        
        
        
        if activate {
            
            enableButton(loginButton)
            
        }else{
            
            disableButton(loginButton)
            
        }
        
    }
    
    
    
    private func clearUI(){
        
        passwordTextField.text = ""
        
    }
    
    
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        
        selectedSSL = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        
        UserDefaults.standard.setValue(selectedSSL, forKey: "SSL")
        
        satisfyLoginCondition()
        
    }
    


}

extension ViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == serverAddressTextField {
            
            if serverAddressTextField.text != nil && serverAddressTextField.text!.count > 0 {
                
                UserDefaults.standard.setValue(textField.text!, forKey: "ServerAddress")
                
            }
            
            
            
        }else if textField == userNameTextField {
            
            if userNameTextField.text != nil && userNameTextField.text!.count > 0 {
                
                UserDefaults.standard.setValue(textField.text!, forKey: "UserName")
                
            }
            
        }
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }


}
