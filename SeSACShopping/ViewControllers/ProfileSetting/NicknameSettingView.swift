//
//  NicknameSettingView.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/27/24.
//

import UIKit

class NicknameSettingView: BaseView {
    let profileImageView = ProfileImageView(frame: .zero)
    let cameraImageView = UIImageView()
    let nicknameTextField = UITextField()
    let textFieldUnderLine = UIView()
    let statusLabel = UILabel()
    let finishButton = PointButton()
    
    
    override func configureHierarchy() {
        [profileImageView, cameraImageView, nicknameTextField, textFieldUnderLine, statusLabel, finishButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureView() {
        
        cameraImageView.design(image: ImageStyle.camera,
                               cornerRadius: cameraImageView.frame.height/2)
        nicknameTextField.design(placeholder: "닉네임을 입력해주세요:)",
                                 cornerRadius: 12)
        
        textFieldUnderLine.backgroundColor = ColorStyle.textColor
        statusLabel.design(text: "", textColor: ColorStyle.pointColor, font: .systemFont(ofSize: 13))
        
        finishButton.setTitle("완료", for: .normal)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalTo(safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
        }
        cameraImageView.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(profileImageView)
            make.size.equalTo(30)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        textFieldUnderLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.horizontalEdges.equalTo(nicknameTextField)
            make.height.equalTo(1)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldUnderLine.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(20)
        }
        finishButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(28)
            make.horizontalEdges.equalTo(nicknameTextField)
            make.height.equalTo(44)
        }
    }
}
