//
//  MoneyDiaryEditVC.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import UIKit

class MoneyDiaryEditVC: UIViewController {
    
    var transactionItem2: Diary
    //MARK: - Properties
    private let moneyDiaryEditView: MoneyDiaryEditView = MoneyDiaryEditView()
    var uuid: UUID?
    
    // MARK: - ViewController Init
    init(transactionItem2: Diary) {
        
        self.transactionItem2 = transactionItem2
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        configureUI()
        setDeleteButton()
    }
    
    override func loadView() {
        
        super.loadView()
        self.view = moneyDiaryEditView
    }
 
    
    // MARK: - Private Method
    private func setDeleteButton() {
        moneyDiaryEditView.deleteButton.target = self
        moneyDiaryEditView.deleteButton.action = #selector(deleteButtonTapped)
        navigationItem.rightBarButtonItem = moneyDiaryEditView.deleteButton
    }
    
    private func deleteDiary() {
        if let uuid = transactionItem2.key {
            DiaryCoreDataManager.shared.deleteDiary(with: uuid)
        } else {
            print("유효한 내역이 아닙니다.")
        }
    }
    
    //MARK: - Objc
    func addTarget() {
        moneyDiaryEditView.saveButton.addTarget(self, action: #selector(updateData), for: .touchUpInside)
        moneyDiaryEditView.cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
    }
    
    private func configureUI() {
        
        moneyDiaryEditView.priceTextField.text = "\(KoreanCurrencyFormatter.shared.string(from: transactionItem2.amount))"
        moneyDiaryEditView.datePicker.date = transactionItem2.date ?? Date()
        moneyDiaryEditView.titleTextField.text = transactionItem2.title
        moneyDiaryEditView.categoryTextField.text = transactionItem2.category
        moneyDiaryEditView.noteTextView.textColor = .black
        moneyDiaryEditView.noteTextView.text = transactionItem2.note        
        moneyDiaryEditView.viewChange(index: transactionItem2.statement ? 1 : 0)
    }
    
    @objc func updateData() {
        let date = moneyDiaryEditView.datePicker.date
        let statement =
        if moneyDiaryEditView.segmentControl.selectedSegmentIndex == 0 {
            false
        }
        else { true }
        let titleTextField = moneyDiaryEditView.titleTextField.text ?? ""
        let categoryTextField = moneyDiaryEditView.categoryTextField.text ?? ""
        let memo = moneyDiaryEditView.noteTextView.text ?? ""
        let uuid = transactionItem2.key!
        
        DiaryCoreDataManager.shared.updateDiary(with: uuid,
                                                newTitle: titleTextField,
                                                newDate: date,
                                                newAmount: KoreanCurrencyFormatter.shared.number(from: moneyDiaryEditView.priceTextField.text ?? "") ?? 0,
                                                newStatement: statement,
                                                newCategory: categoryTextField,
                                                newNote: memo,
                                                newUserId: "userKim")
        
        self.navigationController?.popViewController(animated: false)
        
    }
    
    @objc func deleteButtonTapped() {
        deleteDiary()
        navigationController?.popViewController(animated: true)
    }

    @objc func didTapCancelButton() {
        self.navigationController?.popViewController(animated: false)
    }
}




