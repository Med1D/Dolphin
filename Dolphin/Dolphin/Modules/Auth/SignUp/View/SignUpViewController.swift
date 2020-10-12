//
//  SignUpViewController.swift
//  Dolphin
//
//  Created by Иван Медведев on 11.10.2020.
//

import UIKit
import SkyFloatingLabelTextField
import SnapKit

final class SignUpViewController: UIViewController
{
// MARK: - Properties
	private let presenter: ISignUpPresenter

// MARK: - UI properties
	private let vStackView = UIStackView()
	private let nameTextField = AuthTextField(type: .name,
											  placeholder: "Name",
											  title: "Name",
											  imageName: AuthConstants.nameTextFieldImageName)
	private let loginTextField = AuthTextField(type: .email,
											   placeholder: "Email",
											   title: "Email address",
											   imageName: AuthConstants.loginTextFieldImageName)
	private let passwordTextField = AuthTextField(type: .password,
												  placeholder: "Password",
												  title: "Password",
												  imageName: AuthConstants.passwordTextFieldImageName)
	private let confirmPasswordTextField = AuthTextField(type: .password,
														 placeholder: "Confirm password",
														 title: "Confirm password",
														 imageName: AuthConstants.passwordTextFieldImageName)
	private let signUpButton = UIButton(type: .system)

// MARK: - Init
	init(presenter: ISignUpPresenter) {
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
		self.title = "Sign Up"
		self.setupNameTextField()
		self.setupLoginTextField()
		self.setupPasswordTextField()
		self.setupConfirmPasswordTextField()
		self.setupSignUpButton()
		self.setupVStackView()
		self.setupConstraints()
	}

// MARK: - touchesBegan
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}

// MARK: - Private methods (Setup UI)
private extension SignUpViewController
{
	func setupNameTextField() {
		self.nameTextField.delegate = self
		self.nameTextField.returnKeyType = .next
		self.nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
	}

	func setupLoginTextField() {
		self.loginTextField.delegate = self
		self.loginTextField.errorColor = AuthConstants.errorColor
		self.loginTextField.returnKeyType = .next
		self.loginTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
	}

	func setupPasswordTextField() {
		self.passwordTextField.delegate = self
		self.passwordTextField.returnKeyType = .next
		self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
	}

	func setupConfirmPasswordTextField() {
		self.confirmPasswordTextField.delegate = self
		self.confirmPasswordTextField.errorColor = AuthConstants.errorColor
		self.confirmPasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
	}

	func setupSignUpButton() {
		self.signUpButton.isEnabled = false
		self.signUpButton.backgroundColor = AuthConstants.buttonColor
		self.signUpButton.setTitle("SIGN UP", for: .normal)
		self.signUpButton.tintColor = AuthConstants.backgroundColor
		if let font = AuthConstants.helveticaBold16 {
			self.signUpButton.titleLabel?.font = font
		}
		self.signUpButton.addTarget(self, action: #selector(touchSignUpButton), for: .touchUpInside)
	}

	func setupVStackView() {
		self.view.addSubview(self.vStackView)
		self.vStackView.axis = .vertical
		self.vStackView.alignment = .center
		self.vStackView.distribution = .equalCentering
		self.vStackView.addArrangedSubview(self.nameTextField)
		self.vStackView.addArrangedSubview(self.loginTextField)
		self.vStackView.addArrangedSubview(self.passwordTextField)
		self.vStackView.addArrangedSubview(self.confirmPasswordTextField)
		self.vStackView.addArrangedSubview(self.signUpButton)
	}

	func setupConstraints() {
		self.vStackView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview().multipliedBy(1)
			make.leading.equalToSuperview().offset(64)
			make.trailing.equalToSuperview().offset(-64)
		}

		self.nameTextField.snp.makeConstraints { make in
			make.leading.top.trailing.equalToSuperview()
			make.bottom.equalTo(self.loginTextField.snp.top).offset(-16)
		}

		self.loginTextField.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(self.passwordTextField.snp.top).offset(-16)
		}

		self.passwordTextField.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(self.confirmPasswordTextField.snp.top).offset(-16)
		}

		self.confirmPasswordTextField.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(self.signUpButton.snp.top).offset(-32)
		}

		self.signUpButton.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.leading.bottom.trailing.equalToSuperview()
		}
	}
}

// MARK: - Private methods
private extension SignUpViewController
{
	@objc func touchSignUpButton() {
		presenter.touchSignUpButton()
	}

	@objc func textFieldDidChange(_ textField: AuthTextField) {
		if textField == self.loginTextField, let text = textField.text {
			if self.validateEmail(candidate: text) || text.isEmpty {
				textField.errorMessage = ""
			}
			else {
				textField.errorMessage = "Invalid email"
			}
		}
		if textField == self.confirmPasswordTextField, let text = textField.text {
			if self.passwordTextField.text == text || text.isEmpty {
				textField.errorMessage = ""
			}
			else {
				textField.errorMessage = "Passwords don't match"
			}
		}

		guard self.nameTextField.text?.isEmpty == false,
			  self.loginTextField.text?.isEmpty == false,
			  let errorMessage = self.loginTextField.errorMessage,
			  errorMessage.isEmpty,
			  self.passwordTextField.text?.isEmpty == false,
			  self.passwordTextField.text == self.confirmPasswordTextField.text else {
			self.signUpButton.isEnabled = false
			return
		}
		self.signUpButton.isEnabled = true
	}

	func validateEmail(candidate: String) -> Bool {
		let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
	}
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == self.nameTextField {
			self.loginTextField.becomeFirstResponder()
		}
		else if textField == self.loginTextField {
			self.passwordTextField.becomeFirstResponder()
		}
		else if textField == self.passwordTextField {
			self.confirmPasswordTextField.becomeFirstResponder()
		}
		else {
			textField.resignFirstResponder()
		}
		return true
	}
}

// MARK: - ISignUpViewController
extension SignUpViewController: ISignUpViewController
{
}
