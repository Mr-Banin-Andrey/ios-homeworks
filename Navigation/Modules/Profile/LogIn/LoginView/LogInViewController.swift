

import UIKit

@available(iOS 15.0, *)
protocol LoginViewControllerDelegate {
    func isCheck(_ sender: LogInViewController, login: String, password: String) -> Bool
}

@available(iOS 15.0, *)
struct LoginInspector: LoginViewControllerDelegate {
    func isCheck(_ sender: LogInViewController, login: String, password: String) -> Bool {
        return Checker.shared.isCheck(sender, login: login, password: password)
    }
}

@available(iOS 15.0, *)
class LogInViewController: UIViewController {
    
    var coordinator: ProfileCoordinator?
    
    var loginDelegate: LoginViewControllerDelegate?
    
    private let checkerService = CheckerService()
    
    private let dataBaseRealmService: RealmServiceProtocol = RealmService()
    
//MARK: - 1. Properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .secondarySystemBackground
        return scrollView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    private lazy var loginPasswordView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.opaqueSeparator.cgColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loginPasswordStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var loginTextField: UITextField = {
        let login = UITextField()
        login.placeholder = "E-mail"
        login.font = UIFont.systemFont(ofSize: 16)
        login.autocapitalizationType = .none
        login.translatesAutoresizingMaskIntoConstraints = false
        login.keyboardType = .emailAddress
        login.backgroundColor = .tertiarySystemBackground
        return login
    }()
    
    
    private lazy var passwordTextField: UITextField = {
        let password = UITextField()
        password.placeholder = "loginVC.passwordTextField.placeholder".localized
        password.font = UIFont.systemFont(ofSize: 16)
        password.autocapitalizationType = .none
        password.isSecureTextEntry = true
        password.translatesAutoresizingMaskIntoConstraints = false
        password.backgroundColor = .tertiarySystemBackground
        return password
    }()
    
    lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("loginVC.logInButton.setTitle".localized,
                        for: .normal)
        button.setTitleColor(UIColor.createColor(lightMode: .white, darkMode: .black)
                             , for: .normal)
        button.backgroundColor = UIColor(named: "blueColor")
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showProfileViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var lineView: UIView = {
        let line = UIView()
        line.layer.borderWidth = 0.5
        line.layer.borderColor = UIColor.opaqueSeparator.cgColor
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
        
    private lazy var alertController: UIAlertController = {
        let alert = UIAlertController(
            title: "",
            message: "loginVC.alert.message".localized,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "loginVC.logInButton.setTitle".localized,
            style: .default,
            handler: { _ in
                self.dismiss(animated: true)
                self.coordinator?.showProfileVC()
                print("alert Пользователь сохранен")
            })
        )
        return alert
    }()
    
    
    lazy var singUpButton: CustomButton = {
        let button = CustomButton(
            title: "loginVC.singUpButton.title".localized,
            titleColor: UIColor.createColor(lightMode: .white, darkMode: .black),
            bgColor: UIColor(named: "blueColor") ?? UIColor.red
        ) { [unowned self] in
            self.coordinator?.showRegistration()
//            self.passwordGuessQueue()
        }
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var nameQueue = DispatchQueue(label: "ru.navigation", qos: .userInteractive, attributes: [.concurrent])
        
//MARK: - 2.Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isModal {
            self.viewPresent()
        }
                
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.isHidden = true
        
        self.setupGestures()
        self.setupConstraints()
        
        self.autoAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didShowKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
//MARK: - 3.Methods
    private func setupConstraints() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.logoImageView)
        self.scrollView.addSubview(self.loginPasswordView)
        self.scrollView.addSubview(self.lineView)
        self.scrollView.addSubview(self.loginPasswordStack)
        self.loginPasswordStack.addArrangedSubview(self.loginTextField)
        self.loginPasswordStack.addArrangedSubview(self.passwordTextField)
        self.scrollView.addSubview(self.logInButton)
        self.scrollView.addSubview(self.singUpButton)
        self.scrollView.addSubview(self.activityIndicator)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.logoImageView.heightAnchor.constraint(equalToConstant: 100),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 100),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.logoImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 120),
            
            self.loginPasswordView.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 100),
            self.loginPasswordView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.loginPasswordView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.loginPasswordView.heightAnchor.constraint(equalToConstant: 100),
            
            self.lineView.heightAnchor.constraint(equalToConstant: 0.5),
            self.lineView.topAnchor.constraint(equalTo: self.loginPasswordView.topAnchor, constant: 50),
            self.lineView.leadingAnchor.constraint(equalTo: self.loginPasswordView.leadingAnchor),
            self.lineView.trailingAnchor.constraint(equalTo: self.loginPasswordView.trailingAnchor),
            
            self.loginPasswordStack.leadingAnchor.constraint(equalTo: self.loginPasswordView.leadingAnchor, constant: 10),
            self.loginPasswordStack.trailingAnchor.constraint(equalTo: self.loginPasswordView.trailingAnchor, constant: -10),
            self.loginPasswordStack.topAnchor.constraint(equalTo: self.loginPasswordView.topAnchor, constant: 5),
            self.loginPasswordStack.bottomAnchor.constraint(equalTo: self.loginPasswordView.bottomAnchor, constant: -5),
            
            self.logInButton.heightAnchor.constraint(equalToConstant: 50),
            self.logInButton.topAnchor.constraint(equalTo: self.loginPasswordView.bottomAnchor, constant: 16),
            self.logInButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.logInButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.singUpButton.heightAnchor.constraint(equalToConstant: 30),
            self.singUpButton.topAnchor.constraint(equalTo: self.logInButton.bottomAnchor, constant: 16),
            self.singUpButton.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            
            self.activityIndicator.bottomAnchor.constraint(equalTo: self.loginPasswordStack.bottomAnchor, constant: -8),
            self.activityIndicator.leadingAnchor.constraint(equalTo: self.loginPasswordStack.leadingAnchor)
        ])
    }
    
    private func setupGestures() {
        let tapGestures = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGestures)
    }
    
    func passwordGuessQueue() {
        let useBruteForce = UseBruteForce()
        let randomPassword = useBruteForce.randomPassword()
        var bruteForceWord = ""
        passwordTextField.placeholder = nil
        passwordTextField.text = nil
        activityIndicator.startAnimating()
        passwordTextField.isEnabled = false
        singUpButton.isEnabled = false
        nameQueue.async { [weak self] in
            bruteForceWord = useBruteForce.bruteForce(passwordToUnlock: randomPassword)
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                self?.passwordTextField.isSecureTextEntry = false
                self?.passwordTextField.text = bruteForceWord
                self?.passwordTextField.isEnabled = true
                self?.singUpButton.isEnabled = true
            }
        }
    }
    
    private func viewPresent() {
        self.singUpButton.isHidden = true
        self.logInButton.setTitle("loginVC.modalPresent.logInButton.title".localized,
                                  for: .normal)
        self.passwordTextField.placeholder = "loginVC.modalPresent.passwordTextField.placeholder".localized
        self.loginTextField.placeholder = "loginVC.modalPresent.loginTextField.placeholder".localized
    }
    
    private func createUserRealm(user: LogInUser) {
        let success = dataBaseRealmService.createUser(user: user)
        if success {
            print("пользователь добавлен в базу Realm")
        } else {
            print("пользователь уже есть в базе Realm")
        }
    }
    
    private func autoAuth() {
        let arrayUsers = RealmService().fetch()
        print( arrayUsers )
        guard arrayUsers.isEmpty == false else { return }

        loginTextField.text = arrayUsers[0].login
        passwordTextField.text = arrayUsers[0].password

        showProfileViewController()
    }
    
    @objc func showAlert() {
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let loginButtonBottom = self.loginPasswordView.frame.origin.y + self.loginPasswordView.frame.height + 16 + self.logInButton.frame.height + 16 + self.singUpButton.frame.height
            
            let keyboardOriginY = self.view.frame.height - keyboardHeight
            let yOffset = keyboardOriginY < loginButtonBottom
            ? loginButtonBottom - keyboardOriginY + 16
            : 0
            
            self.scrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }
    
    @objc private func didHideKeyboard(_ notification: Notification) {
        self.forcedHidingKeyboard()
    }
    
    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc func showProfileViewController() {
       
        let user = LogInUser(
            login: loginTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
        
       if isModal {
           checkerService.singUp(
                withEmail: user.login,
                password: user.password,
                vc: self
           ) { result in
               switch result {
               case .success:
                   print("пользователь добавлен в firebase")
                   self.createUserRealm(user: user)
                   self.showAlert()
               case .failure(let error):
                   print("ошибка в firebase: ", error)
               }
           }
       } else {
           checkerService.checkCredentials(
                withEmail: user.login,
                password: user.password,
                vc: self
           ) { result in
                   switch result {
                   case .success:
                       print("логин и пароль верные -> открытие профиля")
                       self.createUserRealm(user: user)
                       self.coordinator?.showProfileVC()
                   case .failure(let error):
                       print("ошибка в логине или пароле", error)
                   }
           }
       }
    }
}
