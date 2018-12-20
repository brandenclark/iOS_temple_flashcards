//
//  TempleCardViewController.swift
//  Project2 Clark Branden
//
//  Created by Branden Clark on 10/18/18.
//  Copyright © 2018 Branden Clark. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Constants
    private struct Storyboard {
        static let BorderWidth: CGFloat = 2
        static let CornerRadius : CGFloat = 0.05
        static let ModeSwitchAnimationTime: Double = 1.0
        static let PickResetValue = -1
        static let TableViewStudyModeWidth: CGFloat = 0
        static let TableViewGameModeWidthModifier: CGFloat = 3
        static let TempleImageHeight: CGFloat = 80
        
        static let GameModeLabel = "Game Mode"
        static let StudyModeLabel = "Study Mode"
        static let TempleLabelCellIdentifier = "TempleLabelCellIdentifier"
        static let TempleImageCellIdentifier = "TempleImageCellIdentifier"
        static let RightChoiceMessage = "Correct!"
        static let WrongChoiceMessage = """
                                            WRONG!
                                            Better luck next time!
                                        """
    }
    
    
    
    //MARK: - Properties
    private var imageDeck = TempleDeck()
    private var labelDeck = TempleDeck()
    private var imagePick = Storyboard.PickResetValue
    private var labelPick = Storyboard.PickResetValue
    private var rightChoicesCounter = 0
    private var wrongChoicesCounter = 0
    private var choiceAlertMessage = ""
    private var labelIndexPath: IndexPath?, imageIndexPath: IndexPath?
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var TempleImagesTable: UICollectionView!
    @IBOutlet weak var TempleLabelTable: UITableView!
    @IBOutlet weak var RightNameLabel: UILabel!
    @IBOutlet weak var WrongNameLabel: UILabel!
    @IBOutlet weak var RightScoreLabel: UILabel!
    @IBOutlet weak var WrongScoreLabel: UILabel!
    @IBOutlet weak var ModeButtonLabel: UIBarButtonItem!
    @IBOutlet weak var RefreshButtonIcon: UIBarButtonItem!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var TempleLabelTableWidth: NSLayoutConstraint!
    
    
    
    //MARK: - Actions
    @IBAction func ModeButtonToggle(_ sender: Any) {
        let studyMode = (ModeButtonLabel.title == Storyboard.StudyModeLabel)

        resetModel(to: studyMode)
    }
    
    
    @IBAction func RefreshButton(_ sender: Any) {
        let studyMode = (ModeButtonLabel.title == Storyboard.GameModeLabel)
        
        rightChoicesCounter = 0
        wrongChoicesCounter = 0
        
        resetModel(to: studyMode)
//        updateUI(to: studyMode)
    }
    
    
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    
    
    //MARK: - Helpers
    private func checkMatch() {
        if (imagePick > Storyboard.PickResetValue)
            && (labelPick > Storyboard.PickResetValue) {
            let result = (imageDeck.temples[imagePick].getName()
                == labelDeck.temples[labelPick].getName())
            
            if result {
                removeMatch()
            }
            counterIncrement(result)
            matchAlert(result)
            resetPickValues(result)
        }
    }
    
    
    private func counterIncrement(_ result: Bool) {
        if result {
            rightChoicesCounter += 1
            RightScoreLabel.text = String(rightChoicesCounter)
        } else {
            wrongChoicesCounter += 1
            WrongScoreLabel.text = String(wrongChoicesCounter)
        }
    }
    
    
    private func matchAlert(_ result: Bool) {
        if result {
            choiceAlertMessage = Storyboard.RightChoiceMessage
        } else {
            choiceAlertMessage = Storyboard.WrongChoiceMessage
        }
        
        let alert = UIAlertController(title: "\(choiceAlertMessage)",
            message: nil, preferredStyle: .alert)

        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: Storyboard.ModeSwitchAnimationTime,
                             repeats: false,
                             block: { _ in alert.dismiss(animated: true,
                                                         completion: nil)} )
    }
    
    
    private func removeMatch() {
        imageDeck.remove(at: imagePick)
        labelDeck.remove(at: labelPick)
        self.TempleImagesTable.deleteItems(at: [imageIndexPath!])
        self.TempleLabelTable.deleteRows(at: [labelIndexPath!],
                                         with: UITableView.RowAnimation.fade)
    }
    
    
    private func resetPickValues(_ result: Bool) {
        
        if result || !result {
            imagePick = Storyboard.PickResetValue
            labelPick = Storyboard.PickResetValue
            
            imageIndexPath = nil
            labelIndexPath = nil
        }
        
    }
    
    
    private func resetModel(to studyMode: Bool) {
        imageDeck = TempleDeck()
        
        if studyMode {
            for i in 0..<imageDeck.temples.count {
                imageDeck.temples[i].toggleStudyMode()
            }
            
            rightChoicesCounter = 0
            wrongChoicesCounter = 0
        } else {
            imageDeck.shuffle()
            labelDeck = TempleDeck()
        }

        updateUI(to: studyMode)
    }
    
    
    func setup() {
        TempleLabelTable.delegate = self
        TempleLabelTable.dataSource = self
        
        TempleImagesTable.delegate = self
        TempleImagesTable.dataSource = self
        
        TempleLabelTableWidth.constant = MainView.bounds.width
            / Storyboard.TableViewGameModeWidthModifier
    }
    
    
    private func updateUI(to changeToStudyMode: Bool) {
        if changeToStudyMode {
            ModeButtonLabel.title = Storyboard.GameModeLabel
            
            TempleLabelTableWidth.constant = Storyboard.TableViewStudyModeWidth
            
            RefreshButtonIcon.isEnabled = false
            
            RightScoreLabel.isHidden = true
            WrongScoreLabel.isHidden = true
            
            RightNameLabel.isHidden = true
            WrongNameLabel.isHidden = true
            
        } else {
            ModeButtonLabel.title = Storyboard.StudyModeLabel
            
            TempleLabelTableWidth.constant = MainView.bounds.width
                / Storyboard.TableViewGameModeWidthModifier
            
            RefreshButtonIcon.isEnabled = true
            
            RightScoreLabel.text = String(rightChoicesCounter)
            WrongScoreLabel.text = String(wrongChoicesCounter)

            RightScoreLabel.isHidden = false
            WrongScoreLabel.isHidden = false
            
            RightNameLabel.isHidden = false
            WrongNameLabel.isHidden = false
        }
        
        TempleLabelTable.layoutIfNeeded()
        TempleLabelTable.reloadData()
        self.TempleImagesTable.layoutIfNeeded()
        
        UIView.animate(withDuration: TimeInterval(Storyboard.ModeSwitchAnimationTime) ){
            self.TempleImagesTable.reloadData()
            
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    //MARK: - Table View Data Source
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return labelDeck.temples.count
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TempleLabelCellIdentifier,
                                                 for: indexPath)
        
        cell.textLabel?.text = labelDeck.temples[indexPath.row].getName()
        cell.detailTextLabel?.text = labelDeck.temples[indexPath.row].getRegion()
        
        return cell
    }
    
    
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        labelPick = indexPath.row
        labelIndexPath = indexPath
        checkMatch()
    }
    
    
    
    
    //MARK: - Collection View Data Source
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageDeck.temples.count
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.TempleImageCellIdentifier,
                                                      for: indexPath)
        
        if let templeCardCell = cell as? TempleCardCell {
            templeCardCell.templeCardView.templeCard = imageDeck.temples[indexPath.row]
            templeCardCell.templeCardView.setNeedsDisplay()
        }
        
        return cell
    }
    
    
    
    //MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        //Show item was selected in game mode
        if ModeButtonLabel.title == Storyboard.StudyModeLabel {
            cell?.layer.borderColor = UIColor.black.cgColor
            cell?.layer.borderWidth = Storyboard.BorderWidth
            cell?.layer.cornerRadius = (cell?.bounds.width)! * Storyboard.CornerRadius
        }
        
        imagePick = indexPath.row
        imageIndexPath = indexPath
        checkMatch()
    }
    
    //Reset border when unselected
    func collectionView(_ collectionView: UICollectionView,
                                didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = Storyboard.BorderWidth
        cell?.layer.cornerRadius = (cell?.bounds.width)! * Storyboard.CornerRadius
    }
    
    
    //MARK: - Collection View Flow Delegate
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let image = UIImage(named: imageDeck.temples[indexPath.row].getFileName()) else {
            return CGSize(width: -1, height: -1)
        }
        
        return CGSize(width: image.size.width/image.size.height
                            * Storyboard.TempleImageHeight,
                      height: Storyboard.TempleImageHeight)
    }
}
