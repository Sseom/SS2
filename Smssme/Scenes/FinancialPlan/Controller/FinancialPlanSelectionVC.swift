//
//  FinancialPlanSelectVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import CoreData
import UIKit

protocol FinancialPlanCreateDelegate: AnyObject {
    func didCreateFinancialPlan(_ plan: FinancialPlanDTO)
}
//test
final class FinancialPlanSelectionVC: UIViewController {
    weak var createDelegate: FinancialPlanEditDelegate?
    private let selectionView = FinancialPlanSelectionView()
    private let planService: FinancialPlanService = FinancialPlanService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionView.collectionView.dataSource = self
        selectionView.collectionView.delegate = self
        view.backgroundColor = UIColor(hex: "#e9f3fd")
        tabBarController?.tabBar.backgroundColor = .white 
    }
    
    override func loadView() {
        view = selectionView
    }
}

// MARK: - Collection View Data Source
extension FinancialPlanSelectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlanType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialPlanCell.ID, for: indexPath) as? FinancialPlanCell else {
            return UICollectionViewCell()
        }
        
        let planType = PlanType.allCases[indexPath.item]
        cell.configure(with: planType)
        cell.cellBackgroundColor(UIColor(hex: "#ffffff"))
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension FinancialPlanSelectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPlanType = PlanType.allCases[indexPath.item]
        let planTitle = selectedPlanType.title
        
        if planService.fetchIncompletedPlans().count >= 10 {
            showExistingPlanAlert()
        } else {
            let createPlanVC = FinancialPlanCreationVC(planService: planService)
            createPlanVC.configure(with: planTitle, planType: selectedPlanType)
            navigationController?.pushViewController(createPlanVC, animated: true)
        }
    }
    
    private func showExistingPlanAlert() {
        showSyncAlert2(
            message: "동시에 진행 가능한 플랜은 10개입니다. 플랜을 삭제하거나 완료해주세요",
            AlertTitle: "알림",
            leftButtonTitle: "현재 플랜 보기",
            leftButtonmethod: { [weak self] in
                self?.navigateToCurrentPlanVC()
            },
            rightButtonTitle: "취소",
            rightButtonmethod: { }
        )
    }
    
    private func navigateToCurrentPlanVC() {
        let currentPlanVC = FinancialPlanCurrentPlanVC(planService: planService)
        navigationController?.pushViewController(currentPlanVC, animated: true)
    }
}
