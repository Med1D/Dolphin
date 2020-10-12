//
//  ForgotPasswordViewController.swift
//  Dolphin
//
//  Created by Иван Медведев on 12.10.2020.
//

import UIKit

final class ForgotPasswordViewController: UIViewController
{
// MARK: - Properties
	private let presenter: IForgotPasswordPresenter

// MARK: - UI properties
	private let vStackView = UIStackView()
	private let forgotPasswordLabel = UILabel()
	private let loginTextField = AuthTextField(type: .email,
											   placeholder: "Email",
											   title: "Email address",
											   imageName: AuthConstants.loginTextFieldImageName)
	private let sendToEmailButton = UIButton(type: .system)

// MARK: - Init
	init(presenter: IForgotPasswordPresenter) {
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
		self.title = "Forgot password"
		self.setupForgotPasswordLabel()
		self.setupLoginTextField()
		self.setupSendToEmailButton()
		self.setupVStackView()
		self.setupConstraints()
	}

// MARK: - touchesBegan
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}

// MARK: - Private methods (Setup UI)
private extension ForgotPasswordViewController
{

	func setupForgotPasswordLabel() {
		self.forgotPasswordLabel.text =
			"""
			Enter your email address that you used to register. We'll send you an email with your password.
			"""
		self.forgotPasswordLabel.numberOfLines = 0
		self.forgotPasswordLabel.textColor = AuthConstants.textColor
		self.forgotPasswordLabel.textAlignment = .center
		if let font = AuthConstants.helvetica16 {
			self.forgotPasswordLabel.font = font
		}
	}

	func setupLoginTextField() {
		self.loginTextField.delegate = self
		self.loginTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
	}

	func setupSendToEmailButton() {
		self.sendToEmailButton.isEnabled = false
		self.sendToEmailButton.backgroundColor = AuthConstants.buttonColor
		self.sendToEmailButton.setTitle("SEND TO EMAIL", for: .normal)
		self.sendToEmailButton.tintColor = AuthConstants.backgroundColor
		if let font = AuthConstants.helveticaBold16 {
			self.sendToEmailButton.titleLabel?.font = font
		}
		self.sendToEmailButton.addTarget(self, action: #selector(touchSendToEmailButton), for: .touchUpInside)
	}

	func setupVStackView() {
		self.view.addSubview(self.vStackView)
		self.vStackView.axis = .vertical
		self.vStackView.alignment = .center
		self.vStackView.distribution = .equalCentering
		self.vStackView.addArrangedSubview(self.forgotPasswordLabel)
		self.vStackView.addArrangedSubview(self.loginTextField)
		self.vStackView.addArrangedSubview(self.sendToEmailButton)
	}

	func setupConstraints() {
		self.vStackView.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.leading.equalToSuperview().offset(64)
			make.trailing.equalToSuperview().offset(-64)
		}

		self.forgotPasswordLabel.snp.makeConstraints { make in
			make.leading.top.trailing.equalToSuperview()
			make.bottom.equalTo(self.loginTextField.snp.top).offset(-32)
		}

		self.loginTextField.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(self.sendToEmailButton.snp.top).offset(-32)
		}

		self.sendToEmailButton.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.leading.bottom.trailing.equalToSuperview()
		}
	}
}

// MARK: - Private methods
private extension ForgotPasswordViewController
{
	@objc func textFieldDidChange(_ textField: AuthTextField) {
		guard self.loginTextField.text?.isEmpty == false else {
			self.sendToEmailButton.isEnabled = false
			return
		}
		self.sendToEmailButton.isEnabled = true
	}

	@objc func touchSendToEmailButton() {
		presenter.touchSendToEmailButton()
	}
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

// MARK: - IForgotPasswordViewController
extension ForgotPasswordViewController: IForgotPasswordViewController
{
}
