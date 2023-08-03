//
//  StarRating.swift
//  StarRating_DKTech
//
//  Created by tran nghia pro on 03/08/2023.
//
import Foundation
import UIKit
import Cosmos
import StoreKit
import MessageUI

public final class StarRating: NSObject, UITextViewDelegate, MFMailComposeViewControllerDelegate {
    
    public static let shared = StarRating()
    
    private var darkBackground: UIView!
    private var alertView: UIView!
    private var starRating: CosmosView!
    private var title: UILabel!
    private var content: UILabel!
    private var remind: UIButton!
    private var submit: UIButton!
    private var submitView: UIView?
    private var icon: UIImageView?
    private var nameAppLabel: UILabel?
    private var messageView: UITextView?
    private var countText: UILabel?
    private var cancelButton: UIButton?
    private var sendButton: UIButton?
    private var star: Double = 5.0
    private var nameApp: String?
    private var cancelText: String?
    private var sendText: String?
    private var placeHolderTextView: String?
    private var vc: UIViewController?
    private var emailAddress: String?
    private var dismissKeyboardClosure: (() -> Void)?
    
    private override init(){}
    
    public func addRating(vc: UIViewController?, title: String?, contentLow: String?, contentMedium: String?, contentHigh: String?, remind: String?, submit: String?, icon: UIImageView?, nameApp: String?, cancelText: String?, sendText: String?, placeHolderTextView: String?, emailAddress: String?) {
        guard let vc = vc else {
            print("View Controller doesn't exist")
            return
        }
        guard let title = title, let remind = remind, let submit = submit, let contentLow = contentLow, let contentMedium = contentMedium, let contentHigh = contentHigh, let icon = icon, let nameApp = nameApp, let cancelText = cancelText, let sendText = sendText, let placeHolderTextView = placeHolderTextView, let emailAddress = emailAddress else {
            print("Please fill all fields")
            return
            }
        self.sendText = sendText
        self.cancelText = cancelText
        self.placeHolderTextView = placeHolderTextView
        self.emailAddress = emailAddress
        darkBackground = UIView(frame: CGRect(x: 0, y: 0, width: vc.view.frame.width, height: vc.view.frame.height))
        darkBackground.backgroundColor = .black
        darkBackground.alpha = 0.9
        self.vc = vc
        vc.view.addSubview(darkBackground)
        darkBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            darkBackground.widthAnchor.constraint(equalTo: vc.view.widthAnchor),
            darkBackground.heightAnchor.constraint(equalTo: vc.view.heightAnchor)
        ])
        alertView = UIView(frame: CGRect(x: 0, y: 0, width: 291, height: 288))
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 11
        darkBackground.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        alertView.heightAnchor.constraint(equalToConstant: 288).isActive = true
        //alertView.heightAnchor.constraint(equalToConstant: 288).isActive = true
        alertView.centerXAnchor.constraint(equalTo: darkBackground.centerXAnchor).isActive = true
        alertView.centerYAnchor.constraint(equalTo: darkBackground.centerYAnchor).isActive = true
        self.title = UILabel()
        self.title.textColor = UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1)
        self.title.font = UIFont.boldSystemFont(ofSize: 20) // Sử dụng boldSystemFont với size là 20
        self.title.textAlignment = .center // Căn giữa chữ
        self.title.numberOfLines = 0 // Cho phép hiển thị nhiều dòng nếu cần
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.16
        self.title.attributedText = NSMutableAttributedString(string: "Do you like our app?", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        alertView.addSubview(self.title)
        self.title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.title.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 16),
            self.title.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 48),
            self.title.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -48),
        ])
        self.title.textAlignment = .center
        self.content = UILabel()
        self.content.textColor = UIColor(red: 0.31, green: 0.392, blue: 0.435, alpha: 1)
        self.content.font = UIFont.systemFont(ofSize: 16)
        self.content.numberOfLines = 0
        self.content.lineBreakMode = .byWordWrapping
        var paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.lineHeightMultiple = 1.24
        // Line height: 24 pt
        self.content.attributedText = NSMutableAttributedString(string: contentHigh, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle2])
        alertView.addSubview(self.content)
        self.content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.content.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 8),
            self.content.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor, constant: 16),
            self.content.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),
        ])
        self.content.textAlignment = .center
        self.starRating = CosmosView()
        self.starRating.settings.fillMode = .half
        self.starRating.rating = 5.0
        self.starRating.settings.filledImage = UIImage(named: "FillStar")
        self.starRating.settings.emptyImage = UIImage(named: "EmptyStar")
        self.starRating.settings.starSize = 28
        self.starRating.settings.minTouchRating = 0.0
        alertView.addSubview(self.starRating)
        self.starRating.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starRating.topAnchor.constraint(equalTo: self.content.bottomAnchor, constant: 32),
            starRating.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 36),
            starRating.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -36),
        ])
        self.starRating.settings.starMargin = 20
        print("star rating: \(starRating.settings.starMargin)")
        self.submit = UIButton()
        self.submit.setTitle(submit, for: .normal)
        self.submit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        self.submit.titleLabel?.textAlignment = .center
        self.submit.titleLabel?.attributedText = NSMutableAttributedString(string: submit, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle2])
        self.submit.setTitleColor(UIColor(red: 0.031, green: 0.494, blue: 0.937, alpha: 1), for: .normal)
        alertView.addSubview(self.submit)
        self.submit.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.submit.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 32),
            self.submit.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            self.submit.trailingAnchor.constraint(equalTo: alertView.trailingAnchor)
        ])
        
        self.remind = UIButton()
        self.remind.setTitle(remind, for: .normal)
        self.remind.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.remind.titleLabel?.textAlignment = .center
        self.remind.setTitleColor(UIColor(red: 0.31, green: 0.392, blue: 0.435, alpha: 1), for: .normal)
        self.remind.layer.borderWidth = 0.5
        self.remind.layer.cornerRadius = 8
        let maskedCorners: CACornerMask = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.remind.layer.maskedCorners = maskedCorners
        alertView.addSubview(self.remind)
        self.remind.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.remind.topAnchor.constraint(equalTo: self.submit.bottomAnchor, constant: 0),
            self.remind.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            self.remind.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            self.remind.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 0)
        ])
        //self.remind.backgroundColor = .red
        
        starRating.didTouchCosmos = { [weak self] rating in
            print(rating)
            if rating  == 0 {
                self?.content.text = contentLow
            } else if rating > 0 && rating < 4 {
                self?.content.text = contentMedium
            } else {
                self?.content.text = contentHigh
            }
            self?.star = rating
        }
        self.icon = icon
        self.nameApp = nameApp
        self.remind.addTarget(self, action: #selector(remindLater), for: .touchUpInside)
        self.submit.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        
    }
    @objc private func remindLater() {
        if darkBackground != nil {
                darkBackground.removeFromSuperview()
        }
    }
    
    @objc private func submitAction() {
        if darkBackground != nil {
            if alertView != nil && star <= 3 {
                alertView.removeFromSuperview()
                submitView = UIView(frame: CGRect(x: 0, y: 0, width: 291, height: 288))
                guard let submitView = self.submitView else { return }
                submitView.backgroundColor = .white
                submitView.layer.cornerRadius = 11
                darkBackground.addSubview(submitView)
                submitView.translatesAutoresizingMaskIntoConstraints = false
                submitView.widthAnchor.constraint(equalToConstant: 300).isActive = true
                //submitView.heightAnchor.constraint(equalToConstant: 300).isActive = true
                //        alertView.heightAnchor.constraint(equalToConstant: 288).isActive = true
                //alertView.heightAnchor.constraint(equalToConstant: 288).isActive = true
                submitView.centerXAnchor.constraint(equalTo: darkBackground.centerXAnchor).isActive = true
                submitView.centerYAnchor.constraint(equalTo: darkBackground.centerYAnchor).isActive = true
                guard let icon = self.icon else { return }
                icon.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
                icon.layer.cornerRadius = 10
                icon.layer.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1).cgColor
                icon.contentMode = .scaleAspectFit
                submitView.addSubview(icon)
                icon.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    icon.widthAnchor.constraint(equalToConstant: 48),
                    icon.heightAnchor.constraint(equalToConstant: 48),
                    icon.topAnchor.constraint(equalTo: submitView.topAnchor, constant: 16),
                    icon.centerXAnchor.constraint(equalTo: submitView.centerXAnchor),
                ])
                self.nameAppLabel = UILabel()
                guard let nameAppLabel = self.nameAppLabel else { return }
                nameAppLabel.textColor = UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1)
                nameAppLabel.font = UIFont.boldSystemFont(ofSize: 20)
                nameAppLabel.numberOfLines = 0
                nameAppLabel.textAlignment = .center
                nameAppLabel.text = self.nameApp
                submitView.addSubview(nameAppLabel)
                nameAppLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    nameAppLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 8),
                    nameAppLabel.leadingAnchor.constraint(equalTo: submitView.leadingAnchor, constant: 20),
                    nameAppLabel.trailingAnchor.constraint(equalTo: submitView.trailingAnchor, constant: -20),
                ])
                
                messageView = UITextView()
                guard let messageView = self.messageView else { return }
                messageView.layer.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1).cgColor
                messageView.layer.cornerRadius = 10
                messageView.textColor = UIColor(red: 0.31, green: 0.392, blue: 0.435, alpha: 1)
                messageView.text = "Tell others what you think"
                messageView.font = UIFont(name: "Inter-Regular", size: 16)
                messageView.textColor = UIColor.lightGray
                messageView.delegate = self
                submitView.addSubview(messageView)
                messageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    messageView.topAnchor.constraint(equalTo: nameAppLabel.bottomAnchor, constant: 20),
                    messageView.leadingAnchor.constraint(equalTo: submitView.leadingAnchor, constant: 16),
                    messageView.trailingAnchor.constraint(equalTo: submitView.trailingAnchor, constant: -16),
                    messageView.heightAnchor.constraint(equalToConstant: 118)
                ])
                countText = UILabel()
                guard let countText = self.countText else { return }
                countText.text = "0/500"
                countText.textColor = .systemBlue
                countText.font = UIFont.systemFont(ofSize: 12)
                countText.textAlignment = .right
                submitView.addSubview(countText)
                countText.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    countText.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -16),
                    countText.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -16)
                ])
                self.cancelButton = UIButton()
                guard let cancelButton = self.cancelButton, let cancelText = self.cancelText else { return }
                cancelButton.setTitle(cancelText, for: .normal)
                cancelButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 20)
                cancelButton.titleLabel?.textAlignment = .center
                cancelButton.setTitleColor(UIColor(red: 0.031, green: 0.494, blue: 0.937, alpha: 1), for: .normal)
                cancelButton.layer.cornerRadius = 8
                cancelButton.layer.backgroundColor = UIColor(red: 0.902, green: 0.965, blue: 1, alpha: 1).cgColor
                submitView.addSubview(cancelButton)
                cancelButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    cancelButton.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 25),
                    cancelButton.leadingAnchor.constraint(equalTo: submitView.leadingAnchor, constant: 16),
                    cancelButton.widthAnchor.constraint(equalToConstant: (submitView.frame.width-43)/2),
                    cancelButton.bottomAnchor.constraint(equalTo: submitView.bottomAnchor, constant: -16),
                ])
                self.sendButton = UIButton()
                guard let sendButton = self.sendButton, let sendText = self.sendText else { return }
                sendButton.setTitle(sendText, for: .normal)
                sendButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 20)
                sendButton.titleLabel?.textAlignment = .center
                sendButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                sendButton.layer.cornerRadius = 8
                sendButton.layer.backgroundColor = UIColor(red: 0, green: 0.64, blue: 1, alpha: 1).cgColor
                submitView.addSubview(sendButton)
                sendButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                   sendButton.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 25),
                    sendButton.trailingAnchor.constraint(equalTo: submitView.trailingAnchor, constant: -16),
                    sendButton.widthAnchor.constraint(equalToConstant: (submitView.frame.width-43)/2),
                    sendButton.bottomAnchor.constraint(equalTo: submitView.bottomAnchor, constant: -16),
                ])
                cancelButton.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
                sendButton.addTarget(self, action: #selector(sendReviewByEmail), for: .touchUpInside)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                vc?.view.addGestureRecognizer(tapGesture)
                
            } else if alertView != nil && star > 3 {
                self.darkBackground.removeFromSuperview()
                if #available(iOS 10.3, *) {
                            SKStoreReviewController.requestReview()
                        } else {
                            // Xử lý logic khi không hỗ trợ trên phiên bản cũ hơn của iOS (thường mở trang App Store để người dùng tự đánh giá)
                            if let url = URL(string: "itms-apps://itunes.apple.com/app/your_app_id?action=write-review") {
                                UIApplication.shared.openURL(url)
                            }
                }
            }
        }
    }
    @objc private func dismissKeyboard() {
        self.messageView?.resignFirstResponder()
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        updateCharCount()
    }
    func updateCharCount() {
        let text = messageView?.text ?? ""
        let charCount = text.count
        countText?.text = "\(charCount)/500"

        // Kiểm tra giới hạn số chữ tối đa
        if charCount > 500 {
            // Nếu vượt quá giới hạn, cắt văn bản để chỉ hiển thị 500 chữ
            let index = text.index(text.startIndex, offsetBy: 500)
            let limitedText = String(text[..<index])
            messageView?.text = limitedText
        }
    }
    
    @objc private func cancelClicked() {
        if darkBackground != nil {
                darkBackground.removeFromSuperview()
        }
    }
    
    @objc private func sendReviewByEmail() {
//        let emailAddress = "trannghia1004@gmail.com"
//        if let mailURL = URL(string: "mailto:\(emailAddress)") {
//            // Sử dụng mailURL theo nhu cầu của bạn, ví dụ: mở ứng dụng Mail
//            UIApplication.shared.open(mailURL)
//        } else {
//            print("Invalid URL for Mail app.")
//        }
        sendEmail()
        
    }
    func sendEmail() {
            if MFMailComposeViewController.canSendMail() {
                let mailComposeVC = MFMailComposeViewController()
                mailComposeVC.mailComposeDelegate = self
                mailComposeVC.setToRecipients([emailAddress ?? "trannghia1004@gmail.com"])
                mailComposeVC.setSubject("review " + (self.nameApp ?? "our app"))
                mailComposeVC.setMessageBody(self.messageView?.text ?? "", isHTML: false)

                vc?.present(mailComposeVC, animated: true, completion: nil)
            } else {
                print("Mail không được cấu hình trên thiết bị này.")
            }
    }
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
            // Xử lý kết quả của việc gửi email (nếu cần)
            switch result {
            case .cancelled:
                print("Email bị hủy.")
            case .saved:
                print("Email đã được lưu nháp.")
            case .sent:
                print("Email đã được gửi thành công.")
                self.darkBackground.removeFromSuperview()
            case .failed:
                print("Gửi email thất bại.")
            default:
                break
            }
        }

}
