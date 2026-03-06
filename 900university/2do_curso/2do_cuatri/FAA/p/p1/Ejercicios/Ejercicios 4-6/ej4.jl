function confusionMatrix(outputs::AbstractArray{Bool,1},
                         targets::AbstractArray{Bool,1})

    # Matriz de confusión según el enunciado:
    #            Real
    #          N       P
    # Pred N  VN      FN
    # Pred P  FP      VP

    VN = sum((.!outputs) .& (.!targets))
    FP = sum(outputs .& (.!targets))
    FN = sum((.!outputs) .& targets)
    VP = sum(outputs .& targets)

    # Precisión (accuracy)
    accuracy = (VN + VP) / (VN + VP + FN + FP)

    # Tasa de error
    error_rate = (FN + FP) / (VN + VP + FN + FP)

    # Sensibilidad (recall)
    sensitivity =
        (VP == 0 && FN == 0) ? 1 :
        VP / (VP + FN)

    # Especificidad
    specificity =
        (VN == 0 && FP == 0) ? 1 :
        VN / (VN + FP)

    # Valor predictivo positivo (precision)
    vpp =
        (VP == 0 && FP == 0) ? 1 :
        VP / (VP + FP)

    # Valor predictivo negativo (NPV)
    vpn =
        (VN == 0 && FN == 0) ? 1 :
        VN / (VN + FN)

    # F1-score
    F1 =
        (sensitivity == 0 && vpp == 0) ? 0 :
        2 * (vpp * sensitivity) / (vpp + sensitivity)

    # Matriz de confusión
    M = [
        VN FP
        FN VP
    ]

    return accuracy, error_rate, sensitivity, specificity, vpp, vpn, F1, M
end
#---------------------------------------------------------------------------------
function confusionMatrix(outputs::AbstractArray{<:Real,1},
                         targets::AbstractArray{Bool,1};
                         threshold::Real=0.5)

    bin = outputs .>= threshold
    return confusionMatrix(bin, targets)
end

#-----------------------------------------------------------------------------
function printConfusionMatrix(outputs::AbstractArray{Bool,1},
                              targets::AbstractArray{Bool,1})
    acc, err, sens, spec, vpp, vpn, F1, M =
        confusionMatrix(outputs, targets)

    println("Accuracy: ", acc)
    println("Error rate: ", err)
    println("Sensitivity: ", sens)
    println("Specificity: ", spec)
    println("VPP (Precision): ", vpp)
    println("VPN (NPV): ", vpn)
    println("F1-score: ", F1)
    println("Confusion Matrix:\n", M)
end
#-----------------------------------------------------------------------------------

function printConfusionMatrix(outputs::AbstractArray{<:Real,1},
                              targets::AbstractArray{Bool,1};
                              threshold::Real=0.5)

    acc, err, sens, spec, vpp, vpn, F1, M =
        confusionMatrix(outputs, targets; threshold=threshold)

    println("Accuracy: ", acc)
    println("Error rate: ", err)
    println("Sensitivity: ", sens)
    println("Specificity: ", spec)
    println("VPP (Precision): ", vpp)
    println("VPN (NPV): ", vpn)
    println("F1-score: ", F1)
    println("Confusion Matrix:\n", M)
end
#------------------------------------------------------------------------------------
