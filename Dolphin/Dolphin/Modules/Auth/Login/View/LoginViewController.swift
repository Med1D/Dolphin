//
//  LoginViewController.swift
//  Dolphin
//
//  Created by Иван Медведев on 09.10.2020.
//

import UIKit
import SkyFloatingLabelTextField
import SnapKit

final class LoginViewController: UIViewController
{
// MARK: - Properties
	private let presenter: ILoginPresenter

// MARK: - UI properties
	private let imageView = UIImageView()
	private let vStackView = UIStackView()
	private let hStackView = UIStackView()
	private let loginTextField = AuthTextField(type: .email,
											   placeholder: "Email",
											   title: "Email address",
											   imageName: AuthConstants.loginTextFieldImageName)
	private let passwordTextField = AuthTextField(type: .password,
												  placeholder: "Password",
												  title: "Password",
												  imageName: AuthConstants.passwordTextFieldImageName)
	private let loginButton = UIButton(type: .system)
	private let forgotPasswordButton = UIButton(type: .system)
	private let signUpLabel = UILabel()
	private let signUpButton = UIButton(type: .system)
	private let activityIndicator = UIActivityIndicatorView(style: .medium)
	private let activityView = UIView()

// MARK: - Init
	init(presenter: ILoginPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

// MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = AuthConstants.backgroundColor
		self.setupNavigationController()
		self.setupImageView()
		self.setupLoginTextField()
		self.setupPasswordTextField()
		self.setupLoginButton()
		self.setupForgotPasswordButton()
		self.setupSignUpLabel()
		self.setupSignUpButton()
		self.setupVStackView()
		self.setupHStackView()
		self.setupActivityIndicatorAndActivityView()
		self.setupConstraints()
	}

// MARK: - viewWillAppear
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.loginTextField.text = ""
		self.passwordTextField.text = ""
		self.loginButton.isEnabled = false
	}

// MARK: - touchesBegan
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}

// MARK: - Private methods (Setup UI)
private extension LoginViewController
{
	func setupNavigationController() {
		if let navController = self.navigationController {
			navController.navigationBar.barStyle = .black
			navController.navigationBar.barTintColor = AuthConstants.backgroundColor
			navController.navigationBar.isTranslucent = true
			navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
			navController.navigationBar.shadowImage = UIImage()
			navController.navigationBar.tintColor = .white
			navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AuthConstants.textColor]
			navController.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "",
																					 style: .plain,
																					 target: nil,
																					 action: nil)
		}
	}

	func setupImageView() {
		self.view.addSubview(self.imageView)
		self.imageView.contentMode = .scaleAspectFit
		self.imageView.image = UIImage(named: "Dolphin")
	}

	func setupLoginTextField() {
		self.loginTextField.delegate = self
		self.loginTextField.returnKeyType = .next
		self.loginTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
	}

	func setupPasswordTextField() {
		self.passwordTextField.delegate = self
		self.passwordTextField.isSecureTextEntry = true
		self.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
	}

	func setupLoginButton() {
		self.loginButton.isEnabled = false
		self.loginButton.backgroundColor = AuthConstants.buttonColor
		self.loginButton.setTitle("LOGIN", for: .normal)
		self.loginButton.tintColor = AuthConstants.backgroundColor
		if let font = AuthConstants.helveticaBold16 {
			self.loginButton.titleLabel?.font = font
		}
		self.loginButton.addTarget(self, action: #selector(touchLoginButton), for: .touchUpInside)
	}

	func setupForgotPasswordButton() {
		self.forgotPasswordButton.backgroundColor = .clear
		self.forgotPasswordButton.setTitle("Forgot your password?", for: .normal)
		self.forgotPasswordButton.tintColor = AuthConstants.textColor
		if let font = AuthConstants.helvetica14 {
			self.forgotPasswordButton.titleLabel?.font = font
		}
		self.forgotPasswordButton.addTarget(self, action: #selector(touchForgotPasswordButton), for: .touchUpInside)
	}

	func setupSignUpLabel() {
		self.signUpLabel.textColor = AuthConstants.placeholderColor
		self.signUpLabel.text = "Don't have an Account?"
		if let font = AuthConstants.helvetica16 {
			self.signUpLabel.font = font
		}
	}

	func setupSignUpButton() {
		self.signUpButton.backgroundColor = .clear
		self.signUpButton.setTitle("Sign Up", for: .normal)
		self.signUpButton.tintColor = AuthConstants.textColor
		if let font = AuthConstants.helvetica16 {
			self.signUpButton.titleLabel?.font = font
		}
		self.signUpButton.addTarget(self, action: #selector(touchSignUpButton), for: .touchUpInside)
	}

	func setupVStackView() {
		self.view.addSubview(self.vStackView)
		self.vStackView.axis = .vertical
		self.vStackView.alignment = .center
		self.vStackView.distribution = .equalCentering
		self.vStackView.addArrangedSubview(self.loginTextField)
		self.vStackView.addArrangedSubview(self.passwordTextField)
		self.vStackView.addArrangedSubview(self.loginButton)
		self.vStackView.addArrangedSubview(self.forgotPasswordButton)
	}

	func setupHStackView() {
		self.view.addSubview(self.hStackView)
		self.hStackView.axis = .horizontal
		self.hStackView.distribution = .equalCentering
		self.hStackView.addArrangedSubview(self.signUpLabel)
		self.hStackView.addArrangedSubview(self.signUpButton)
	}

	func setupActivityIndicatorAndActivityView() {
		self.view.addSubview(self.activityView)
		self.activityView.addSubview(self.activityIndicator)
		self.activityView.frame = self.view.bounds
		self.activityView.backgroundColor = AuthConstants.activityViewColor
		self.activityView.isHidden = true
		self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
		self.activityIndicator.color = .white
		self.activityIndicator.isHidden = true
	}

	func setupConstraints() {
		self.vStackView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview().multipliedBy(1.1)
			make.leading.equalToSuperview().offset(64)
			make.trailing.equalToSuperview().offset(-64)
		}

		self.imageView.snp.makeConstraints { make in
			make.width.height.equalTo(AuthConstants.imageSize)
			make.centerX.equalToSuperview()
			make.bottom.equalTo(self.vStackView.snp.top).offset(-32)
		}

		self.loginTextField.snp.makeConstraints { make in
			make.leading.top.trailing.equalToSuperview()
			make.bottom.equalTo(self.passwordTextField.snp.top).offset(-16)
		}

		self.passwordTextField.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(self.loginButton.snp.top).offset(-32)
		}

		self.loginButton.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(self.forgotPasswordButton.snp.top).offset(-8)
		}

		self.forgotPasswordButton.snp.makeConstraints { make in
			make.bottom.equalToSuperview()
		}

		self.hStackView.snp.makeConstraints { make in
			make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-24)
			make.centerX.equalTo(self.view)
		}

		self.signUpLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview()
			make.trailing.equalTo(self.signUpButton.snp.leading).offset(-8)
		}

		self.signUpButton.snp.makeConstraints { make in
			make.trailing.equalToSuperview()
		}

		self.activityIndicator.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}

	func createAlertController(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			let action = UIAlertAction(title: "OK", style: .default, handler: handler)
			alert.addAction(action)
			self.present(alert, animated: true)
		}
	}

	func startActivityIndicator() {
		self.navigationController?.view.isUserInteractionEnabled = false
		self.activityView.isHidden = false
		self.activityIndicator.startAnimating()
		self.activityIndicator.isHidden = false
	}

	func stopActivityIndicator() {
		DispatchQueue.main.async {
			self.navigationController?.view.isUserInteractionEnabled = true
			self.activityView.isHidden = true
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
		}
	}
}

// MARK: - Private methods
private extension LoginViewController
{
	@objc func textFieldDidChange(_ textField: AuthTextField) {
		guard self.loginTextField.text?.isEmpty == false,
			  self.passwordTextField.text?.isEmpty == false else {
			self.loginButton.isEnabled = false
			return
		}
		self.loginButton.isEnabled = true
	}

	@objc func touchLoginButton() {
		self.startActivityIndicator()
		guard let email = self.loginTextField.text,
			  let password = self.passwordTextField.text else {
			return
		}
		let user = User(username: nil, email: email, password: password)
		presenter.touchLoginButton(user: user) { result in
			switch result {
			case .success:
				self.stopActivityIndicator()
			case .failure(let error):
				self.stopActivityIndicator()
				guard let error = error as? AuthNetworkErrors else {
					return
				}
				switch error {
				case .dataTaskError, .noConnection:
					self.createAlertController(title: "No Connection",
											   message: "Failed to access the service.",
											   handler: nil)
				case .badResponse:
					self.createAlertController(title: "Sign In Failed",
											   message: "Incorrect email or password.",
											   handler: nil)
				default:
					self.createAlertController(title: "Sign In Failed",
											   message: "Failed to access the service.",
											   handler: nil)
				}
			}
		}
	}

	@objc func touchForgotPasswordButton() {
		presenter.touchForgotPasswordButton { viewController in
			self.navigationController?.pushViewController(viewController, animated: true)
		}
	}

	@objc func touchSignUpButton() {
		presenter.touchSignUpButton { viewController in
			self.navigationController?.pushViewController(viewController, animated: true)
		}
	}
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == self.loginTextField {
			self.passwordTextField.becomeFirstResponder()
		}
		else {
			textField.resignFirstResponder()
		}
		return true
	}
}

// MARK: - ILoginViewController
extension LoginViewController: ILoginViewController
{
}
