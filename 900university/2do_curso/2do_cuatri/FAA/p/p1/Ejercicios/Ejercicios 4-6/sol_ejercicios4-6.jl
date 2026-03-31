#Miembros:
    #- Xoel Sánchez Dacoba
    #- Sebastián David Moreno Expósito
    #- Rodrigo Mariño Álvarez
#Grupo de prácticas 11 (Martes) H

# ----------------------------------------------------------------------------------------------
# ------------------------------------- Ejercicio 4 --------------------------------------------
# ----------------------------------------------------------------------------------------------

function confusionMatrix(outputs::AbstractArray{Bool,1}, targets::AbstractArray{Bool,1})
    @assert(length(outputs) == length(targets))
    
    # Calculamos los componentes básicos de la matriz
    tp = count(outputs .& targets)
    tn = count(.!outputs .& .!targets)
    fp = count(outputs .& .!targets)
    fn = count(.!outputs .& targets)
    
    # Estructura: filas=clase real (neg/pos), columnas=predicción (neg/pos)
    matriz_conf = [tn fp; fn tp]
    
    # Cálculo de la precisión global y tasa de error
    n_total = length(targets)
    exactitud = (tp + tn) / n_total
    tasa_error = 1.0 - exactitud
    
    # Métricas específicas con protección contra división por cero (0/0 -> 1.0)
    # Sensibilidad (recall)
    sens = (tp + fn == 0) ? 1.0 : tp / (tp + fn)
    # Especificidad
    espec = (tn + fp == 0) ? 1.0 : tn / (tn + fp)
    # Valor Predictivo Positivo (precision)
    vpp = (tp + fp == 0) ? 1.0 : tp / (tp + fp)
    # Valor Predictivo Negativo
    vpn = (tn + fn == 0) ? 1.0 : tn / (tn + fn)
    
    # F1-score: media armónica entre precisión y sensibilidad
    f1 = (sens + vpp == 0) ? 0.0 : (2 * sens * vpp) / (sens + vpp)
    
    return (exactitud, tasa_error, sens, espec, vpp, vpn, f1, matriz_conf)
end

# Sobrecarga para salidas continuas con umbral
confusionMatrix(outputs::AbstractArray{<:Real,1}, targets::AbstractArray{Bool,1}; threshold::Real=0.5) = confusionMatrix(outputs .>= threshold, targets)

function confusionMatrix(outputs::AbstractArray{Bool,2}, targets::AbstractArray{Bool,2}; weighted::Bool=true)
    @assert(size(outputs) == size(targets))
    num_inst, num_clases = size(targets)
    @assert(num_clases != 2) # El pdf dice que no son válidas
    # las matrices de dos columnas
    
    if num_clases == 1
        return confusionMatrix(vec(outputs), vec(targets))
    end

    # Verificamos que cada patrón tenga exactamente una clase asignada
    @assert(all(sum(outputs, dims=2) .== 1))

    # Almacenes para las métricas individuales de cada clase
    s_vec = zeros(num_clases)
    e_vec = zeros(num_clases)
    p_vec = zeros(num_clases)
    n_vec = zeros(num_clases)
    f_vec = zeros(num_clases)

    for i in 1:num_clases
        # Obtenemos las métricas tratando cada clase como un problema binario (One-vs-Rest)
        res = confusionMatrix(outputs[:, i], targets[:, i])
        s_vec[i], e_vec[i], p_vec[i], n_vec[i], f_vec[i] = res[3], res[4], res[5], res[6], res[7]
    end

    # Construcción de la matriz multiclase mediante comprensión (Sugerencia PDF 7)
    c_matrix = [count(targets[:, fil] .& outputs[:, col]) for fil in 1:num_clases, col in 1:num_clases]

    if weighted
        # Media ponderada por la frecuencia de cada clase
        inst_clase = vec(sum(targets, dims=1))
        puntos = inst_clase ./ num_inst
        sens = sum(s_vec .* puntos)
        espec = sum(e_vec .* puntos)
        vpp = sum(p_vec .* puntos)
        vpn = sum(n_vec .* puntos)
        f1 = sum(f_vec .* puntos)
    else
        # Media macro (aritmética simple)
        sens, espec, vpp, vpn, f1 = mean(s_vec), mean(e_vec), mean(p_vec), mean(n_vec), mean(f_vec)
    end

    acc = accuracy(outputs, targets)
    err = 1.0 - acc

    return (acc, err, sens, espec, vpp, vpn, f1, c_matrix)
end

confusionMatrix(outputs::AbstractArray{<:Real,2}, targets::AbstractArray{Bool,2}; threshold::Real=0.5, weighted::Bool=true) = confusionMatrix(classifyOutputs(outputs; threshold=threshold), targets; weighted=weighted)

function confusionMatrix(outputs::AbstractArray{<:Any,1}, targets::AbstractArray{<:Any,1}, classes::AbstractArray{<:Any,1}; weighted::Bool=true)
    # Verificación defensiva (PDF 15)
    @assert(all(in(c, classes) for c in vcat(targets, outputs)))
    # Codificamos ambas a One-Hot usando el mismo conjunto de clases para coherencia
    out_oh = oneHotEncoding(outputs, classes)
    tar_oh = oneHotEncoding(targets, classes)
    return confusionMatrix(out_oh, tar_oh; weighted=weighted)
end

function confusionMatrix(outputs::AbstractArray{<:Any,1}, targets::AbstractArray{<:Any,1}; weighted::Bool=true)
    # Calculamos las clases únicas presentes en ambos conjuntos
    clases_unicas = unique(vcat(targets, outputs))
    return confusionMatrix(outputs, targets, clases_unicas; weighted=weighted)
end

# Visualización de resultados
function printConfusionMatrix(outputs::AbstractArray{Bool,2}, targets::AbstractArray{Bool,2}; weighted::Bool=true)
    m = confusionMatrix(outputs, targets; weighted=weighted)
    acc, err, sens, espec, vpp, vpn, f1, mat = m
    n = size(mat, 1)
    
    sep = " " * ("-" ^ (n * 8 + 8))
    println(sep)
    print("      | ")
    if n == 2
        println("  -  \t  +  |")
    else
        for i in 1:n print("Cl. $i \t") end
        println("|")
    end
    println(sep)
    
    for i in 1:n
        if n == 2
            print(i == 1 ? "  -   | " : "  +   | ")
        else
            print("Cl. $i | ")
        end
        for j in 1:n print("$(mat[i,j]) \t") end
        println("|")
    end
    println(sep)
    
    println("Exactitud: $acc")
    println("Tasa error: $err")
    println("Sensibilidad: $sens")
    println("Especificidad: $espec")
    println("VPP (Precisión): $vpp")
    println("VPN: $vpn")
    println("F1-score: $f1")
    return m
end

printConfusionMatrix(outputs::AbstractArray{<:Real,2}, targets::AbstractArray{Bool,2}; weighted::Bool=true) = printConfusionMatrix(classifyOutputs(outputs), targets; weighted=weighted)
printConfusionMatrix(outputs::AbstractArray{Bool,1}, targets::AbstractArray{Bool,1}) = printConfusionMatrix(reshape(outputs, :, 1), reshape(targets, :, 1))
printConfusionMatrix(outputs::AbstractArray{<:Real,1}, targets::AbstractArray{Bool,1}; threshold::Real=0.5) = printConfusionMatrix(outputs .>= threshold, targets)
printConfusionMatrix(outputs::AbstractArray{<:Any,1}, targets::AbstractArray{<:Any,1}, classes::AbstractArray{<:Any,1}; weighted::Bool=true) = printConfusionMatrix(oneHotEncoding(outputs, classes), oneHotEncoding(targets, classes); weighted=weighted)

function printConfusionMatrix(outputs::AbstractArray{<:Any,1}, targets::AbstractArray{<:Any,1}; weighted::Bool=true)
    clases = unique(vcat(targets, outputs))
    printConfusionMatrix(outputs, targets, clases; weighted=weighted)
end

using SymDoME

function trainClassDoME(trainingDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}}, testInputs::AbstractArray{<:Real,2}, maximumNodes::Int)
    x_train, y_train = trainingDataset
    # Forzamos Float64 para precisión
    x_train_64 = Float64.(x_train)
    x_test_64 = Float64.(testInputs)

    dome_model, _, _, _ = dome(x_train_64, y_train; maximumNodes=maximumNodes)

    y_pred = evaluateTree(dome_model, x_test_64)
    # Si el modelo es constante, evaluateTree devuelve un escalar (PDF 11)
    if y_pred isa Real
        y_pred = fill(y_pred, size(testInputs, 1))
    end
    return y_pred
end

function trainClassDoME(trainingDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}}, testInputs::AbstractArray{<:Real,2}, maximumNodes::Int)
    x, y = trainingDataset
    cols = size(y, 2)

    if cols == 1
        return reshape(trainClassDoME((x, vec(y)), testInputs, maximumNodes), :, 1)
    end

    @assert(cols > 2) # Caso multiclase One-vs-All
    res_mat = zeros(Float64, size(testInputs, 1), cols)
    for i in 1:cols
        res_mat[:, i] .= trainClassDoME((x, y[:, i]), testInputs, maximumNodes)
    end
    return res_mat
end

function trainClassDoME(trainingDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{<:Any,1}}, testInputs::AbstractArray{<:Real,2}, maximumNodes::Int)
    x, y = trainingDataset
    labels = unique(y)
    
    # Entrenamiento con One-Hot encoding (PDF 14)
    y_oh = oneHotEncoding(y, labels)
    preds_dome = trainClassDoME((x, y_oh), testInputs, maximumNodes)
    
    # Clasificamos usando umbral 0 (PDF 14)
    preds_bool = classifyOutputs(preds_dome; threshold=0)
    n_test = size(testInputs, 1)
    final_out = Array{eltype(y), 1}(undef, n_test)

    if length(labels) <= 2
        p_vec = vec(preds_bool)
        final_out[p_vec] .= labels[1]
        if length(labels) == 2
            final_out[.!p_vec] .= labels[2]
        end
    else
        # Asignación por clase multiclase (PDF 15)
        for i in eachindex(labels)
            final_out[preds_bool[:, i]] .= labels[i]
        end
    end
    return final_out
end

# ----------------------------------------------------------------------------------------------
# ------------------------------------- Ejercicio 5 --------------------------------------------
# ----------------------------------------------------------------------------------------------

using Random

function crossvalidation(N::Int64, k::Int64)
    # Generamos repeticiones de 1:k usando repeat y ceil
    indices = repeat(1:k, ceil(Int, N/k))[1:N]
    shuffle!(indices)
    return indices
end

function crossvalidation(targets::AbstractArray{Bool,1}, k::Int64)
    idx_final = zeros(Int, length(targets))
    # Partición estratificada: tratamos positivos y negativos por separado
    pos = findall(targets)
    neg = findall(.!targets)
    @assert(length(pos) >= k && length(neg) >= k, "Cada clase debe tener al menos k patrones")
    idx_final[pos] = crossvalidation(length(pos), k)
    idx_final[neg] = crossvalidation(length(neg), k)
    return idx_final
end

function crossvalidation(targets::AbstractArray{Bool,2}, k::Int64)
    n_clases = size(targets, 2)
    @assert(n_clases != 2)
    if n_clases == 1
        return crossvalidation(vec(targets), k)
    end
    
    idx_res = zeros(Int, size(targets, 1))
    for i in 1:n_clases
        filas_clase = targets[:, i]
        @assert(count(filas_clase) >= k, "La clase $i no tiene suficientes patrones (mínimo k=$k)")
        idx_res[filas_clase] = crossvalidation(count(filas_clase), k)
    end
    return idx_res
end

crossvalidation(targets::AbstractArray{<:Any,1}, k::Int64) = crossvalidation(oneHotEncoding(targets), k)

function ANNCrossValidation(topology::AbstractArray{<:Int,1},
    dataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{<:Any,1}},
    crossValidationIndices::Array{Int64,1};
    numExecutions::Int=50,
    transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)),
    maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01, validationRatio::Real=0, maxEpochsVal::Int=20)

    x, y = dataset
    @assert(size(x, 1) == length(y))
    
    clases = unique(y)
    num_clases = length(clases)
    y_encoded = oneHotEncoding(y, clases)

    n_folds = maximum(crossValidationIndices)
    
    # Vectores para promediar resultados de cada fold
    acc_folds, err_folds = zeros(n_folds), zeros(n_folds)
    sen_folds, esp_folds = zeros(n_folds), zeros(n_folds)
    vpp_folds, vpn_folds = zeros(n_folds), zeros(n_folds)
    f1s_folds = zeros(n_folds)
    
    mat_conf_global = zeros(num_clases, num_clases)

    for f in 1:n_folds
        # División de datos según el fold actual
        mask_test = (crossValidationIndices .== f)
        mask_train = .!mask_test
        
        x_tr, y_tr = x[mask_train, :], y_encoded[mask_train, :]
        x_te, y_te = x[mask_test, :],  y_encoded[mask_test, :]

        # Almacenes para las ejecuciones dentro del fold
        acc_rep, err_rep = zeros(numExecutions), zeros(numExecutions)
        sen_rep, esp_rep = zeros(numExecutions), zeros(numExecutions)
        vpp_rep, vpn_rep = zeros(numExecutions), zeros(numExecutions)
        f1s_rep = zeros(numExecutions)
        mats_rep = zeros(num_clases, num_clases, numExecutions)

        for r in 1:numExecutions
            if validationRatio > 0
                # Hold-Out para validación (PDF 8)
                ratio_ajustado = validationRatio * size(x, 1) / size(x_tr, 1)
                idx_tr, idx_val = holdOut(size(x_tr, 1), ratio_ajustado)
                
                modelo, = trainClassANN(topology, (x_tr[idx_tr, :], y_tr[idx_tr, :]),
                    validationDataset = (x_tr[idx_val, :], y_tr[idx_val, :]),
                    testDataset = (x_te, y_te),
                    transferFunctions = transferFunctions,
                    maxEpochs=maxEpochs, minLoss=minLoss, learningRate=learningRate, maxEpochsVal=maxEpochsVal)
            else
                modelo, = trainClassANN(topology, (x_tr, y_tr),
                    testDataset = (x_te, y_te),
                    transferFunctions = transferFunctions,
                    maxEpochs=maxEpochs, minLoss=minLoss, learningRate=learningRate)
            end

            # Evaluación de la repetición
            pred_rep = collect(modelo(Float32.(x_te'))')
            metras = confusionMatrix(pred_rep, y_te)
            acc_rep[r], err_rep[r], sen_rep[r], esp_rep[r], vpp_rep[r], vpn_rep[r], f1s_rep[r], mats_rep[:, :, r] = metras
        end

        # Promediamos resultados de las repeticiones para este fold
        acc_folds[f] = mean(acc_rep); err_folds[f] = mean(err_rep)
        sen_folds[f] = mean(sen_rep); esp_folds[f] = mean(esp_rep)
        vpp_folds[f] = mean(vpp_rep); vpn_folds[f] = mean(vpn_rep)
        f1s_folds[f] = mean(f1s_rep)
        
        # Sumamos la matriz promedio del fold a la global (PDF 9)
        mat_conf_global .+= mean(mats_rep, dims=3)[:, :, 1]
    end

    # Retornamos tuplas (media, std) para cada métrica y la matriz final
    return (mean(acc_folds), std(acc_folds)), (mean(err_folds), std(err_folds)), 
           (mean(sen_folds), std(sen_folds)), (mean(esp_folds), std(esp_folds)), 
           (mean(vpp_folds), std(vpp_folds)), (mean(vpn_folds), std(vpn_folds)), 
           (mean(f1s_folds), std(f1s_folds)), mat_conf_global
end

# ----------------------------------------------------------------------------------------------
# ------------------------------------- Ejercicio 6 --------------------------------------------
# ----------------------------------------------------------------------------------------------

using MLJ
using LIBSVM, MLJLIBSVMInterface
using NearestNeighborModels, MLJDecisionTreeInterface

# Carga de modelos MLJ (PDF 2)
SVC_M = MLJ.@load SVC pkg=LIBSVM verbosity=0
KNN_M = MLJ.@load KNNClassifier pkg=NearestNeighborModels verbosity=0
DTC_M = MLJ.@load DecisionTreeClassifier pkg=DecisionTree verbosity=0

function modelCrossValidation(modelType::Symbol, modelHyperparameters::Dict, dataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{<:Any,1}}, crossValidationIndices::Array{Int64,1})
    x_total, y_total = dataset
    @assert(size(x_total, 1) == length(y_total))

    # Caso especial para Redes Neuronales (redirigimos a ANNCrossValidation)
    if modelType == :ANN
        return ANNCrossValidation(modelHyperparameters["topology"], dataset, crossValidationIndices;
            numExecutions     = get(modelHyperparameters, "numExecutions", 50),
            transferFunctions = get(modelHyperparameters, "transferFunctions", fill(σ, length(modelHyperparameters["topology"]))),
            maxEpochs         = get(modelHyperparameters, "maxEpochs", 1000),
            minLoss           = get(modelHyperparameters, "minLoss", 0.0),
            learningRate      = get(modelHyperparameters, "learningRate", 0.01),
            validationRatio   = get(modelHyperparameters, "validationRatio", 0),
            maxEpochsVal      = get(modelHyperparameters, "maxEpochsVal", 20))
    end

    # Pre-procesamiento: etiquetas como string para compatibilidad (PDF 9)
    y_str = string.(y_total)
    clases = unique(y_str)
    n_folds = maximum(crossValidationIndices)
    
    # Contenedores para métricas por fold
    acc_v, err_v, sen_v, esp_v, vpp_v, vpn_v, f1s_v = [zeros(n_folds) for _ in 1:7]
    mat_global = zeros(Int, length(clases), length(clases))

    for f in 1:n_folds
        mask_te = (crossValidationIndices .== f)
        mask_tr = .!mask_te
        
        x_tr, y_tr = x_total[mask_tr, :], y_str[mask_tr]
        x_te, y_te = x_total[mask_te, :], y_str[mask_te]

        if modelType == :DoME
            # Algoritmo DoME (PDF 12)
            y_out = trainClassDoME((x_tr, y_tr), x_te, modelHyperparameters["maximumNodes"])
        else
            # Modelos MLJ
            if modelType == :SVC
                k_val = modelHyperparameters["kernel"]
                @assert k_val in ["linear", "rbf", "poly", "sigmoid"] "El kernel '$k_val' no es válido para SVC. Usa 'linear', 'rbf', 'poly' o 'sigmoid'."
                k_obj = k_val == "linear" ? LIBSVM.Kernel.Linear :
                        k_val == "rbf"    ? LIBSVM.Kernel.RadialBasis :
                        k_val == "poly"   ? LIBSVM.Kernel.Polynomial :
                        k_val == "sigmoid" ? LIBSVM.Kernel.Sigmoid : nothing
                
                model = SVC_M(kernel = k_obj,
                    cost   = Float64(modelHyperparameters["C"]),
                    gamma  = Float64(get(modelHyperparameters, "gamma", -1)),
                    degree = Int32(get(modelHyperparameters, "degree", -1)),
                    coef0  = Float64(get(modelHyperparameters, "coef0", -1)))
            elseif modelType == :DecisionTreeClassifier
                model = DTC_M(max_depth = modelHyperparameters["max_depth"], rng=Random.MersenneTwister(1))
            elseif modelType == :KNeighborsClassifier
                model = KNN_M(K = modelHyperparameters["n_neighbors"])
            else
                error("Tipo de modelo '$modelType' no soportado.")
            end

            # Ajuste y predicción con MLJ (PDF 4-5)
            m_obj = machine(model, MLJ.table(x_tr), categorical(y_tr))
            MLJ.fit!(m_obj, verbosity=0)
            
            y_pred_mlj = MLJ.predict(m_obj, MLJ.table(x_te))
            # Para Árboles y kNN obtenemos la clase más probable con mode (PDF 6)
            y_out = modelType == :SVC ? y_pred_mlj : mode.(y_pred_mlj)
        end

        # Evaluación del fold
        res_fold = confusionMatrix(y_out, y_te, clases)
        acc_v[f], err_v[f], sen_v[f], esp_v[f], vpp_v[f], vpn_v[f], f1s_v[f], mat_f = res_fold
        mat_global .+= mat_f
    end

    return (mean(acc_v), std(acc_v)), (mean(err_v), std(err_v)), 
           (mean(sen_v), std(sen_v)), (mean(esp_v), std(esp_v)), 
           (mean(vpp_v), std(vpp_v)), (mean(vpn_v), std(vpn_v)), 
           (mean(f1s_v), std(f1s_v)), mat_global
end