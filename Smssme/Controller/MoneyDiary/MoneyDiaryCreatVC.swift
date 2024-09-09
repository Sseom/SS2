//
//  MoneyDiaryCreatVC.swift
//  Smssme
//
//  Created by KimRin on 9/5/24.
//
import UIKit


class MoneyDiaryCreatVC: UIViewController {
    
    //    var transactionItem2: Diary
    //MARK: - Properties
    private let moneyDiaryCreateView: MoneyDiaryCreateView = MoneyDiaryCreateView()
    
    // MARK: - ViewController Init
    init() {
        
        //        self.transactionItem2 = transactionItem2
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
    }
    
    override func loadView() {
        
        super.loadView()
        self.view = moneyDiaryCreateView
    }
    
    // MARK: - Method
    
    // MARK: - Private Method
    //    private func setupSegmentEvent() {
    //        moneyDiaryEditView
    //    }
    
    //MARK: - Objc
    func addTarget() {
        moneyDiaryCreateView.saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        moneyDiaryCreateView.cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
    }
    
    
    @objc func saveData() {
        let date = moneyDiaryCreateView.datePicker.date
        let amount = Int64(moneyDiaryCreateView.priceTextField.text ?? "0") ?? 0
        let statement =
        if moneyDiaryCreateView.segmentControl.selectedSegmentIndex == 0 {
            false
        }
        else { true }
        let titleTextField = moneyDiaryCreateView.titleTextField.text ?? ""
        let categoryTextField = moneyDiaryCreateView.categoryTextField.text ?? ""
        let memo = moneyDiaryCreateView.noteTextField.text ?? ""
        DiaryCoreDataManager.shared.createDiary(title: titleTextField, date: date, amount: amount, statement: statement, category: categoryTextField, note: memo, userId: "userKim")
        
        self.navigationController?.popViewController(animated: false)
        
    }
    @objc func didTapCancelButton() {
        self.navigationController?.popViewController(animated: false)
    }
}
