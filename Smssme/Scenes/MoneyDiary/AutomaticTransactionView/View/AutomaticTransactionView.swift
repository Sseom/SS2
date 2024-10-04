//
//  AutomaticTransactionView.swift
//  Smssme
//
//  Created by KimRin on 9/12/24.
// 코드검토 (2024.09.15)

import UIKit
import SnapKit

class AutomaticTransactionView: UIView {
    
    private let titleLabel: UILabel = LargeTitleLabel().createLabel(with: "지출내역 자동입력 기능", color: .black)
    
    let submitButton: UIButton = ActionButtonBorder().createButton(text: "변환하여 저장하기", color: UIColor.systemBlue, textColor: .white)

    let howToUselabel = BaseLabelFactory().createLabel(with: "문자를 복사 한후 하단에 붙혀넣기 해주세요", color: .black)
    
     let inputTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        howToUselabel.textAlignment = .left
        howToUselabel.font = UIFont.systemFont(ofSize: 14)
        submitButton.backgroundColor = .systemBlue
        submitButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        self.backgroundColor = .white
        
        [
            titleLabel,
            inputTextView,
            submitButton,
            howToUselabel
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        inputTextView.snp.makeConstraints {
            $0.top.equalTo(howToUselabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(150)
        }
        
        submitButton.snp.makeConstraints {
            $0.top.equalTo(inputTextView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalTo(inputTextView)
            $0.height.equalTo(50)
        }
        
        howToUselabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }

}
