//
//  RegistrationController.swift
//  TinderClone
//
//  Created by Vincent Angelo on 18/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit
import JGProgressHUD

class RegistrationController: UIViewController {
    
    
    // MARK: - Properties
    
    weak var delegate: AuthenticationDelegate?
    
    private var viewModel = RegistrationViewModel()
    
    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let fullnameTextField = CustomTextField(placeholder: "Full Name")
    
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureField: true)
    
    var profileImage : UIImage? = UIImage(named: "")
    
    private lazy var emailContainerView: CustomContainerView = {
        return CustomContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
    }()
    
    private lazy var fullnameContainerView: CustomContainerView = {
        return CustomContainerView(image: #imageLiteral(resourceName: "top_left_profile"), textField: fullnameTextField)
    }()
    
    private lazy var passwordContainerView: CustomContainerView = {
        return CustomContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
    }()
    
    private let registerButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    private let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
 
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTextFieldObservers()
    }
    
    // MARK: - Selectors
    
    @objc func handleSelectPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func handleRegister(){
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile image")
            return
        }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, profileImage: profileImage)
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        
        AuthService.shared.registerUser(credentials: credentials, completion: { error in
            //self.navigationController?.popViewController(animated: true)
            if let error = error {
                print("DEBUG: ERROR is \(error.localizedDescription)")
                hud.dismiss()
                return
            }
            
            hud.dismiss()
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow})  else { return}
            guard let tab = window.rootViewController as? HomeController else {return}
            
            tab.authenticateUserAndConfigureUI()
            tab.fetchCurrentUserAndCards()
            
            let navToMain = HomeController()
            //navToMain.modalPresentationStyle = .fullScreen
            //self.present(navToMain, animated: true, completion: nil)
            
            self.navigationController?.pushViewController(navToMain, animated: true)
            print("DEBUG: Sign Up Successful")
            print("DEBUG: Handle Update User Interface Here")
            self.dismiss(animated: true, completion: nil)
            
        })
        
        
        
    }
    
    @objc func handleLogin(){
        navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - API
    
    
    // MARK: - Helpers
    
    func checkFormStatus(){
        if viewModel.formIsValid {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .systemPink
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .lightGray
        }
    }
    
    func configureUI(){
        configureGradientLayer()
        
        view.addSubview(selectPhotoButton)
        selectPhotoButton.setDimensions(height: 275, width: 275)
        selectPhotoButton.layer.cornerRadius = 275 / 2
        selectPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        selectPhotoButton.centerX(inView: view)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, fullnameContainerView, passwordContainerView])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: selectPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(registerButton)
        registerButton.centerX(inView: view)
        registerButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(goToLoginButton)
        goToLoginButton.centerX(inView: view)
        goToLoginButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    }
    
    func configureTextFieldObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImage = info[.originalImage] as? UIImage
        selectPhotoButton.setImage(profileImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
}
