//
//  LoginController.swift
//  DragonBallHeroes
//
//  Created by Salva Moreno.
//

import Foundation
import UIKit

final class LoginController: UIViewController {
    
    let backgroundImageView = UIImageView()
    private let apiClient = APIClient()
    
    override func loadView() {
        super.loadView()
        self.view = LoginView()
        
        // Configuración del delegado del UITextField
        if let loginView = self.view as? LoginView {
            loginView.getEmailTextField.delegate = self
            loginView.getPasswordTextField.delegate = self
        }
        
        // Captación de la pulsación del botón en condiciones adecuadas para realizar navegación
        if let loginView = self.view as? LoginView {
            loginView.buttonTapHandler = { [weak self] loginData in
                self?.goToHeroesListController(email: loginData.email, password: loginData.password)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
    }
    
    func setBackground() {
        backgroundImageView.image = UIImage(named: "loginBackground")
        backgroundImageView.contentMode = .scaleAspectFill
        [backgroundImageView].forEach(view.addSubview)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.sendSubviewToBack(backgroundImageView)
    }
    
    func goToHeroesListController(email: String, password: String) {
        let rootVC = HeroesListController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        
        apiClient.login(
            user: email,
            password: password) { [weak self] result in
                switch result {
                    case .success(_):
                        self?.apiClient.getHeroes { result in
                            switch result {
                                case let .success(heroes):
                                    // Limpieza de variable heroes debido a que viene de la API un héroe sin info
                                    var heroesCleaned: [Hero] = []
                                    heroes.enumerated().forEach { index, hero in
                                        if index != heroes.count - 1 {
                                            heroesCleaned.append(hero)
                                        }
                                    }
                                    rootVC.heroData = heroesCleaned
                                    // Notificación para informar que los datos se han actualizado
                                    NotificationCenter.default.post(name: NSNotification.Name("HeroesDataUpdated"), object: nil)
                                case let .failure(error):
                                    print("Error: \(error)")
                            }
                        }
                        DispatchQueue.main.async {
                            self?.present(navVC, animated: true)
                        }
                    case let .failure(error):
                        print("Error: \(error)")
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(
                                title: "Autenticación fallida",
                                message: "Las credenciales proporcionadas son incorrectas. Por favor, verifica tu correo electrónico y contraseña e inténtalo nuevamente",
                                preferredStyle: .alert
                            )
                            alertController.addAction(UIAlertAction(title: "OK", style: .default))
                            self?.present(alertController, animated: true)
                        }
                }
            }
        
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: [.allowUserInteraction],
            animations: {
                textField.backgroundColor = .systemGray4
                textField.layer.borderWidth = 2
                textField.layer.borderColor = UIColor.systemBlue.cgColor
            },
            completion: nil
        )
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: [.allowUserInteraction],
            animations: {
                textField.backgroundColor = .systemGray6
                textField.layer.borderWidth = 0
                textField.layer.borderColor = .none
            },
            completion: nil
        )
    }
}
