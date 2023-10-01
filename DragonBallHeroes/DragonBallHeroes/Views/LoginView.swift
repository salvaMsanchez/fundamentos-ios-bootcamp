//
//  LoginView.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation
import UIKit

typealias LoginData = (email: String, password: String)

final class LoginView: UIView {
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "title")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let textFieldsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5.0
        textField.backgroundColor = .systemGray6
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        textField.clearButtonMode = .whileEditing
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 12
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Agrega un espacio en la parte izquierda del campo de texto
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
    
        return textField
    }()
    
    var getEmailTextField: UITextField {
        return emailTextField
    }
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5.0
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.backgroundColor = .systemGray6
        textField.attributedPlaceholder = NSAttributedString(string: "Contraseña", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        textField.clearButtonMode = .whileEditing
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 12
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Agrega un espacio en la parte izquierda del campo de texto
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    var getPasswordTextField: UITextField {
        return passwordTextField
    }
    
    var buttonTapHandler: ((LoginData) -> Void)?
    
    private lazy var loginContinueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continuar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18.0)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubviews()
        configureConstraints()
    }
    
    private func addSubviews() {
        [loginStackView, titleImageView].forEach(addSubview)
        [textFieldsStackView, loginContinueButton].forEach(loginStackView.addArrangedSubview)
        [emailTextField, passwordTextField].forEach(textFieldsStackView.addArrangedSubview)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleImageView.bottomAnchor.constraint(equalTo: loginStackView.topAnchor, constant: -80),
            titleImageView.heightAnchor.constraint(equalToConstant: 60),
            
            loginStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loginStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            loginStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 56),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56),
            loginContinueButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc
    func buttonTouchDown() {
        zoomIn()
    }
    
    @objc
    func buttonTapped() {
        zoomOut()
        if let emailInput = emailTextField.text,
        let passwordInput = passwordTextField.text {
            buttonTapHandler?((emailInput, passwordInput))
        }
    }
}

// MARK: - Animations

extension LoginView {
    func zoomIn() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.5
        ) { [weak self] in
            self?.loginContinueButton.transform = .identity.scaledBy(x: 0.94, y: 0.94)
        }
    }

    func zoomOut() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 2
        ) { [weak self] in
            self?.loginContinueButton.transform = .identity
        }
    }

}
