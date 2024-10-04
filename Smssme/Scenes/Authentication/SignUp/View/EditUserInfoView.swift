//
//  SignUpView.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/28/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class EditUserInfoView: UIView {
    
    // 텍스트필드의 공통된 높이
    private let textFieldHeight = 40
    
    // 전체 스크롤뷰
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    //상단 제목 라벨
    private var titleLabel = LabelFactory.titleLabel()
        .setText("내정보 수정")
        .build()
    
    //아이디(이메일)
    let emailLabel = SmallTitleLabel().createLabel(with: "이메일", color: .black)
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
//        textField.keyboardType = UIKeyboardType.emailAddress
//        textField.clearButtonMode = .always
        textField.isEnabled = false
        return textField
    }()
    
    //비밀번호
    let passwordLabel = SmallTitleLabel().createLabel(with: "비밀번호", color: .black)
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요."
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = .always
        textField.textContentType = .oneTimeCode
        textField.isSecureTextEntry = true
        return textField
    }()

    //닉네임
    var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임(10자 이내)"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = .always
        return textField
    }()
    
    //생년월일
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "생년월일 8자리 입력(예:  1900/01/31)"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = .always
        textField.keyboardType = UIKeyboardType.phonePad
        return textField
    }()
    
    //생년월일 데이트피커뷰
    var datePickerView = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let temp = dateFormatter.date(from: "2000-01-01")
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = temp ?? Date()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        return datePicker
    }()
    
    // 성별 선택
    // 성별 라벨
    let genderTitleLabel = SmallTitleLabel().createLabel(with: "성별", color: .darkGray)
    
    // 남성 체크박스
    var maleCheckBox: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tag = GenderTags.male.rawValue
        return button
    }()
    
    let maleCheckBoxLabel: UILabel = {
        let label = UILabel()
        label.text = "남성"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    let maleCheckBoxStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    // 여성 체크박스
    var femaleCheckBox: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tag = GenderTags.female.rawValue
        return button
    }()
    
    let femaleLabel: UILabel = {
        let label = UILabel()
        label.text = "여성"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    let femaleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    // 선택안함 체크박스
    var noneCheckBox: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tag = GenderTags.none.rawValue
        return button
    }()
    
    let noneLabel: UILabel = {
        let label = UILabel()
        label.text = "선택안함"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    let noneStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    // 남성, 여성, 선택안함 담는 가로스택뷰
    let genderOptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // 성별 라벨, 성별 체크박스 담는 세로 스택뷰
    let genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    //소득 구간 선택
    var incomeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "소득 구간을 선택하세요."
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.tintColor = .clear
        textField.layer.cornerRadius = 5
        textField.tag = 1
        return textField
    }()
    
    //지역 선택
    var locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "지역"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.tintColor = .clear
        textField.layer.cornerRadius = 5
        textField.tag = 2
        return textField
    }()
    
    //회원가입 버튼
    var signupButton = BaseButton().createButton(text: "수정", color: UIColor.systemBlue, textColor: UIColor.white)
    
    
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupLayout()
        editUserInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - setupUI
    private func configureUI() {
        
        self.backgroundColor = .white
        
        // 스크롤뷰에서 빈 화면터치 시 키보드 내려감
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        
        scrollView.addGestureRecognizer(recognizer)
        
        [ titleLabel,
          emailTextField,
          passwordTextField,
          nicknameTextField,
          birthdayTextField,
          genderStackView,
          incomeTextField,
          locationTextField,
          signupButton
        ].forEach {
            verticalStackView.addArrangedSubview($0)
        }
        
        // 성별 체크박스
        [maleCheckBox, maleCheckBoxLabel].forEach {maleCheckBoxStackView.addArrangedSubview($0)}
        
        [femaleCheckBox, femaleLabel].forEach {femaleStackView.addArrangedSubview($0)}
        
        [noneCheckBox, noneLabel].forEach {noneStackView.addArrangedSubview($0)}
        
        [genderTitleLabel, maleCheckBoxStackView, femaleStackView, noneStackView].forEach { genderOptionsStackView.addArrangedSubview($0) }
        
        [genderTitleLabel, genderOptionsStackView].forEach { genderStackView.addArrangedSubview($0)}
        
        [verticalStackView].forEach { scrollView.addSubview($0)}
        
        //스크롤뷰
        [scrollView].forEach { self.addSubview($0) }
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(612) //162 432 90
            $0.bottom.equalToSuperview().inset(60)
        }
        
        // 성별 체크박스
        maleCheckBox.snp.makeConstraints {$0.height.width.equalTo(24)}
        femaleCheckBox.snp.makeConstraints {$0.height.width.equalTo(24)}
        noneCheckBox.snp.makeConstraints {$0.height.width.equalTo(24)}
        
        maleCheckBoxStackView.snp.makeConstraints {$0.verticalEdges.equalTo(genderOptionsStackView)}
        
        // 성별 라벨 스택뷰
        genderTitleLabel.snp.makeConstraints {$0.height.equalTo(16)}
        
        // 성별 옵션 스택뷰
        genderOptionsStackView.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        
        // 성별 세로 스택뷰
        genderStackView.snp.makeConstraints {
            $0.height.equalTo(90)
        }
    }
    
    
    //MARK: - func
    private func editUserInfo() {
        guard let user = Auth.auth().currentUser else { return }

            let userInfo = Firestore.firestore().collection("users").document(user.uid)
            userInfo.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    self.emailTextField.text = data?["email"] as? String
                    self.nicknameTextField.text = data?["nickname"] as? String
                    self.birthdayTextField.text = data?["birth"] as? String
                    self.incomeTextField.text = data?["income"] as? String
                    self.locationTextField.text = data?["location"] as? String
                    
                    let gender = data?["gender"] as? String
                    self.loadGender(gender: gender)
                }
                
            }
        
    }
    
    private func loadGender(gender: String?) {
        if gender == "male" {
            self.maleCheckBox.isSelected = true
        } else if gender == "female" {
            self.femaleCheckBox.isSelected = true
        } else if gender == "none" {
            self.noneCheckBox.isSelected = true
        } else {
            return
        }
    }
    
    //MARK: - @objc
    @objc func touch() {
        self.endEditing(true)
    }
    
}


