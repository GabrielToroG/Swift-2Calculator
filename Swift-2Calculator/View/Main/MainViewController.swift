//
//  MainViewController.swift
//  Swift-2Calculator
//
//  Created by Gabriel Toro on 19-06-22.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var resultLabel: UILabel!
    
    // NUMBERS
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6 : UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    // OPERATORS
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorPercent: UIButton!
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorAddition: UIButton!
    @IBOutlet weak var operatorSubstraction: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    
    
    
    // MARK: - Variables
    private var total: Double = 0                   // Total
    private var temp: Double = 0                    // Valor por pantalla
    private var isOperating: Bool = false           // Indica si se ha seleccionado algun operador
    private var isDecimal: Bool = false             // Indica si el valor es isDecimal
    private var operation: OperationType = .none    // Operación actual
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    private let kTotal = "total" // total es la clave que tendrá el userDefault
    
    private enum OperationType {
        case none, addiction, substraction, multiplication, division, percent
    }
    
    
    
    // MARK: - Lifecycle
    // VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        // Que el tamaño de la fuente se adapte al espacio disponible: Storyboard: resultLabel - Autoshrink
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        total =  UserDefaults.standard.double(forKey: kTotal)   // Se recupera el dato guardado (historial)
        result()
    }
    
    
    // VIEW DID APPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Numbers
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
                  
        // Operators
        operatorAC.round()
        operatorPlusMinus.round()
        operatorPercent.round()
        operatorResult.round()
        operatorAddition.round()
        operatorSubstraction.round()
        operatorMultiplication.round()
        operatorDivision.round()
    }

    
    
    // MARK: - Actions
    @IBAction func ACAction(_ sender: UIButton) {
        clear()
        sender.shine()
    }
    
    
    @IBAction func plusMinusAction(_ sender: UIButton) {
        temp = temp * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        sender.shine()
    }
    
    
    @IBAction func percentAction(_ sender: UIButton) {
        if operation != .percent {
            result()
        }
        
        isOperating = true
        operation = .percent
        result()
        sender.shine()
    }
    
    
    @IBAction func resultAction(_ sender: UIButton) {
        result()
        sender.shine()
    }
    
    
    @IBAction func additionAction(_ sender: UIButton) {
        // Si estamos 5+5 y se apreta + el programa tiene que mostrar 10 y prepararse para la siguiente operación
        if operation != .none {
            result()
        }

        isOperating = true
        operation = .addiction
        sender.selectOperation(selected: true)
        sender.shine()
    }
    
    
    @IBAction func substractionAction(_ sender: UIButton) {
        // Si estamos 5+5 y se apreta - el programa tiene que mostrar 10 y prepararse para la siguiente operación
        if operation != .none {
            result()
        }

        isOperating = true
        operation = .substraction
        sender.selectOperation(selected: true)
        sender.shine()
    }
    
    
    @IBAction func multiplicationAction(_ sender: UIButton) {
        // Si estamos 5+5 y se apreta * el programa tiene que mostrar 10 y prepararse para la siguiente operación
        if operation != .none {
            result()
        }

        isOperating = true
        operation = .multiplication
        sender.selectOperation(selected: true)
        sender.shine()
    }
    
    
    @IBAction func divisionAction(_ sender: UIButton) {
        // Si estamos 5+5 y se apreta % el programa tiene que mostrar 10 y prepararse para la siguiente operación
        if operation != .none {
            result()
        }

        isOperating = true
        operation = .division
        sender.selectOperation(selected: true)
        sender.shine()
    }
    
    
    @IBAction func decimalAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!    // Número sin comas ni puntos
        if resultLabel.text?.contains(kDecimalSeparator) ?? false || (!isOperating && currentTemp.count >= kMaxLength) {
            return
        }
        
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        isDecimal = true
        
        selectVisualOperation()
        sender.shine()
    }
    
    
    @IBAction func numberAction(_ sender: UIButton) {
        operatorAC.setTitle("C", for: .normal)
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !isOperating && currentTemp.count >= kMaxLength {  // Si el tamaño es mayor a 9 digitos no se hace nada
            return
        }
        
        // Luego de ver el tamaño se vuelve a formatear con comas o puntos
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        // Hemos seleccionado una operación
        if isOperating {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            isOperating = false
        }
        
        // Hemos seleccionado decimales
        if isDecimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            isDecimal = false
        }
        
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        selectVisualOperation()
        sender.shine()
    }
    
    
    
    // MARK: - Functions
    // Limpiar los datos
    private func clear() {
        
        if operation == .none {
            total = 0
        }
        
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        } else {
            total = 0
            result()
        }
    }
    
    // Obtiene el resultado final
    private func result() {
        switch operation {
        case .none:
            break
        case .addiction:
            total = total + temp
            break
        case .substraction:
            total = total - temp
            break
        case .multiplication:
            total = total * temp
            break
        case .division:
            total = total / temp
            break
        case .percent:
            temp = temp / 100
            total = temp
            break
        }
        
        /* Formateo al resultado que se muestra por pantalla
        Si el tamaño total es mayor a 9 se muestra con notación cientifica, sino se muestra normal */
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        operation = .none
        selectVisualOperation()  // Para deseleccionar la operación en la pantalla
        UserDefaults.standard.set(total, forKey: kTotal)
    }
    
    
    // Muestra de forma visual la operación seleccionada
    private func selectVisualOperation() {
        if !isOperating {
            // Cuando no se está operando
            operatorAddition.selectOperation(selected: false)
            operatorSubstraction.selectOperation(selected: false)
            operatorMultiplication.selectOperation(selected: false)
            operatorDivision.selectOperation(selected: false)
        } else {
            switch operation {
            case .none, .percent:
                operatorAddition.selectOperation(selected: false)
                operatorSubstraction.selectOperation(selected: false)
                operatorMultiplication.selectOperation(selected: false)
                operatorDivision.selectOperation(selected: false)
                break
            case .addiction:
                operatorAddition.selectOperation(selected: true)
                operatorSubstraction.selectOperation(selected: false)
                operatorMultiplication.selectOperation(selected: false)
                operatorDivision.selectOperation(selected: false)
                break
            case .substraction:
                operatorAddition.selectOperation(selected: false)
                operatorSubstraction.selectOperation(selected: true)
                operatorMultiplication.selectOperation(selected: false)
                operatorDivision.selectOperation(selected: false)
                break
            case .multiplication:
                operatorAddition.selectOperation(selected: false)
                operatorSubstraction.selectOperation(selected: false)
                operatorMultiplication.selectOperation(selected: true)
                operatorDivision.selectOperation(selected: false)
                break
            case .division:
                operatorAddition.selectOperation(selected: false)
                operatorSubstraction.selectOperation(selected: false)
                operatorMultiplication.selectOperation(selected: false)
                operatorDivision.selectOperation(selected: true)
                break
            }
        }
    }
    
    
    
    // MARK: - Formatting
    // Formateao de valores auxiliares
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    
    // Ahora se controlará el numero total que ibamos a dibujar
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        /* Queremos que este formateado sea capaz de representar numeros de una cadena lo mas grande
        posible para asi poder contar el número de dígitos */
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    
    //Formateo de valores por pantalla por defecto
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumIntegerDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()

    
    //Formateo de valores or pantalla en formato científico
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
}
