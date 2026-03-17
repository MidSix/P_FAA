#Miembros:
    #- Xoel Sánchez Dacoba
    #- Sebastián David Moreno Expósito
    #- Rodrigo Mariño Álvarez
#Grupo de prácticas 11 (Martes) H

# ----------------------------------------------------------------------
# ------------------------- Ejercicio 2 --------------------------------
# ----------------------------------------------------------------------
using Statistics
using Flux
using Flux.Losses

function oneHotEncoding(feature::AbstractArray{<:Any,1}, classes::AbstractArray{<:Any,1})
# "<:" -> es un operador de subtipo, simplemente le dice que el tipo
# Hereda de lo que sea que esté a su derecha, al heredar de any entonces
# el tipo de los elementos dentro del AbstractArray puede ser cualquier
# cosa, esta por tanto es la definicion mas general de la funcion de
# encoding.

# En python el type hint es opcional e inutil para el interprete
# En Julia el type hint es opcional e util para el compilador, una de
# sus utilidades es facilitarnos el Multiple Dispatch. Sin tipos
# predefinidos en funciones las opciones del multiple Dispatch se nos
# limitan solo al numero de argumentos que recibe la funcion y ya no
# a sus tipos pues porque no tienes tipos xd.

# Aunque en los argumentos de la funcion tenemos que llamar feature a
# uno de ellos, creo que es relevante
# recalcar que en especifico para el dataset iris.data debemos usar la
# codificacion sobre las variables categoricas, NO sobre las numericas,
# es decir, solo se pasara el target del dataset con el que se
# esta trabajando
    if length(classes)<=2
        return reshape(feature .== classes[1], :, 1);
    else
        # Podemos usar el broadcast del operador == para hacer los
        # calculos de forma mas eficiente.
        return (feature .== reshape(classes, 1, :));
    end;
end;

# Sobrecarga para cuando no se pasan las clases
oneHotEncoding(feature::AbstractArray{<:Any,1}) = oneHotEncoding(feature, unique(feature))
# Parte del multiple dispatch, si el usuario no pasa las clases
# y el array de targets NO es un bool(si lo fuera tendriamos abajo
# una definicion mas especifica asi que no entraria en esta) entonces
# llama a una funcion anonima que llama al oneHotEncoding con los
# argumentos requeridos para que tome la primera definicion.
# notar que unique simplemente devuelve un array unidimensional
# con los valores unicos, sin repetir, del iterable que se le pase.
# Y los valores NO repetidos de los targets resultan ser las clases
# asi que gucci.

# Sobrecarga para cuando ya es un vector de booleanos
oneHotEncoding(feature::AbstractArray{Bool,1}) = reshape(feature, (:,1))
# Antes era reshape(feature, :, 1)) pero genuinamente creo los parentesis
# ayudan a la legibilidad dando a entender mas rapidamente que son 2
# y no 3 parametros xd, el primero lo que sea que le quieres cambiar
# la dimension, el segundo la dimension a la que se lo quieres cambiar
# ambas sintaxis son equivalentes y puede verse en la documentacion.

function calculateMinMaxNormalizationParameters(dataset::AbstractArray{<:Real,2})
    return (minimum(dataset,dims=1),maximum(dataset,dims=1))
end;

function calculateZeroMeanNormalizationParameters(dataset::AbstractArray{<:Real,2})
    return (mean(dataset,dims=1),std(dataset,dims=1))
end;

function normalizeMinMax!(dataset::AbstractArray{<:Real,2}, normalizationParameters::NTuple{2, AbstractArray{<:Real,2}})
    minValues = normalizationParameters[1];
    maxValues = normalizationParameters[2];
    dataset .-= minValues;
    dataset ./= (maxValues .- minValues);
    # Manejamos el caso en que el valor maximo y minimo coincidan
    dataset[:, vec(minValues.==maxValues)] .= 0;
    return dataset;
end;

normalizeMinMax!(dataset::AbstractArray{<:Real,2})=normalizeMinMax!(dataset,calculateMinMaxNormalizationParameters(dataset))

function normalizeMinMax(dataset::AbstractArray{<:Real,2}, normalizationParameters::NTuple{2, AbstractArray{<:Real,2}})
    return normalizeMinMax!(copy(dataset),normalizationParameters);
end;

normalizeMinMax(dataset::AbstractArray{<:Real,2})=normalizeMinMax(dataset,calculateMinMaxNormalizationParameters(dataset))

function normalizeZeroMean!(dataset::AbstractArray{<:Real,2}, normalizationParameters::NTuple{2, AbstractArray{<:Real,2}})
    avgValues = normalizationParameters[1];
    stdValues = normalizationParameters[2];
    dataset .-= avgValues;
    dataset ./= stdValues;
    # Manejamos el caso en que la desviacion tipica sea 0
    dataset[:, vec(stdValues.==0)] .= 0;
    return dataset;
end;

normalizeZeroMean!(dataset::AbstractArray{<:Real,2})=normalizeZeroMean!(dataset,calculateZeroMeanNormalizationParameters(dataset))

function normalizeZeroMean(dataset::AbstractArray{<:Real,2}, normalizationParameters::NTuple{2, AbstractArray{<:Real,2}})
    return normalizeZeroMean!(copy(dataset),normalizationParameters);
end;

normalizeZeroMean(dataset::AbstractArray{<:Real,2})=normalizeZeroMean(dataset, calculateZeroMeanNormalizationParameters(dataset))

classifyOutputs(outputs::AbstractArray{<:Real,1}; threshold::Real=0.5) = outputs .>= threshold;
# EL ";" dentro de los () de la funcion simplemente separa los
# argumentos posicionales de los argumentos con clave.
# En python estos argumentos se separan por posicion ya que primero
# se escriben los de posicion y por ultimo los que tienen clave
# valores por defecto, pues aqui se usa el ";" para eso, nada mas.

function classifyOutputs(outputs::AbstractArray{<:Real,2}; threshold::Real=0.5)
    if size(outputs,2)==1
    # Matriz columna es lo mismo conceptualmente que un vector asi que
    # simplemente usamos la definicion de arriba para tratar con este
    # caso, convertimos tipos para poder usar la definicion de arriba
    # y ajustamos la dimension con el reshape
        return reshape(classifyOutputs(vec(outputs); threshold=threshold), :, 1);
    else
        # Aqui manejamos los casos de clasificacion NO binaria.
        (_,indicesMaxEachInstance) = findmax(outputs, dims=2);
        outputs_bool = falses(size(outputs));
        outputs_bool[indicesMaxEachInstance] .= true;
        return outputs_bool;
    end;
end;

accuracy(outputs::AbstractArray{Bool,1}, targets::AbstractArray{Bool,1})=mean(outputs .== targets);

function accuracy(outputs::AbstractArray{Bool,2}, targets::AbstractArray{Bool,2})
    if size(outputs,2)==1
        return accuracy(vec(outputs),vec(targets));
    else
        comparison_matrix = (outputs .== targets);
        correct_matrix = all(comparison_matrix, dims=2); # all(..., dims=2) nos dice si cada fila es completamente true, ya que un patron es correcto si toda su fila lo es
        return mean(correct_matrix);
    end;
end;

accuracy(outputs::AbstractArray{<:Real,1}, targets::AbstractArray{Bool,1}; threshold::Real=0.5)=accuracy(classifyOutputs(outputs;threshold=threshold),targets)

function accuracy(outputs::AbstractArray{<:Real,2}, targets::AbstractArray{Bool,2}; threshold::Real=0.5)
    if size(outputs,2)==1
        return accuracy(vec(outputs), vec(targets); threshold=threshold);
    else
        correct_outputs = classifyOutputs(outputs;threshold=threshold);
        return accuracy(correct_outputs,targets);
    end;
end;

function buildClassANN(numInputs::Int, topology::AbstractArray{<:Int,1}, numOutputs::Int; transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)))
    ann = Chain();
    numInputsLayer = numInputs;
    for (i, numOutputsLayer) in enumerate(topology)
        ann = Chain(ann..., Dense(numInputsLayer, numOutputsLayer, transferFunctions[i]));
        numInputsLayer = numOutputsLayer;
    end;
    if numOutputs==1
        ann = Chain(ann..., Dense(numInputsLayer, 1, σ));
    else
        ann = Chain(ann..., Dense(numInputsLayer, numOutputs, identity), softmax);
    end;
    return ann;
end;

function trainClassANN(topology::AbstractArray{<:Int,1}, dataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}}; transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)),
     maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01)

    inputs = Float32.(dataset[1]);
    outputs = dataset[2];

    # Creamos la red
    ann = buildClassANN(size(inputs,2), topology, size(outputs,2); transferFunctions=transferFunctions);

    # Flux espera los patrones en columnas
    inputs = inputs';
    outputs = outputs';

    loss(m, x, y) = (size(y, 1) == 1) ? Flux.Losses.binarycrossentropy(m(x), y) : Flux.Losses.crossentropy(m(x), y);

    opt_state = Flux.setup(Flux.Adam(learningRate), ann);

    loss_history = Float32[];
    push!(loss_history, Float32(loss(ann, inputs, outputs)));

    for epoch in 1:maxEpochs
        if loss_history[end] <= minLoss
            break;
        end;
        Flux.train!(loss, ann, [(inputs, outputs)], opt_state);
        push!(loss_history, Float32(loss(ann, inputs, outputs)));
    end;

    return (ann, loss_history);
end;

function trainClassANN(topology::AbstractArray{<:Int,1}, (inputs, targets)::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}}; transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)), maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01)
    return trainClassANN(topology, (inputs, reshape(targets, :, 1)); transferFunctions=transferFunctions, maxEpochs=maxEpochs, minLoss=minLoss, learningRate=learningRate);
end;


# ----------------------------------------------------------------------------------------------
# ------------------------------------- Ejercicio 3 --------------------------------------------
# ----------------------------------------------------------------------------------------------

using Random

function holdOut(N::Int, P::Real)
    indices = randperm(N);
    numTest = round(Int, N * P);
    testIndices = indices[1:numTest];
    trainIndices = indices[numTest+1:end];
    return (trainIndices, testIndices);
end;

function holdOut(N::Int, Pval::Real, Ptest::Real)
    (trainingPlusValidationIndices, testIndices) = holdOut(N, Ptest);
    # Pval es respecto al total N, calculamos la tasa respecto al subconjunto restante
    (trainingIndices, validationIndices)         = holdOut(length(trainingPlusValidationIndices), Pval/(1-Ptest));
    return (trainingPlusValidationIndices[trainingIndices], trainingPlusValidationIndices[validationIndices], testIndices);
end;

function trainClassANN(topology::AbstractArray{<:Int,1},
    trainingDataset::  Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}};
    validationDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}}=(Array{eltype(trainingDataset[1]),2}(undef,0,size(trainingDataset[1],2)), falses(0,size(trainingDataset[2],2))),
    testDataset::      Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}}=(Array{eltype(trainingDataset[1]),2}(undef,0,size(trainingDataset[1],2)), falses(0,size(trainingDataset[2],2))),
    transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)),
    maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01, maxEpochsVal::Int=20)

    # Conversión y trasposición
    trainInputs  = Float32.(trainingDataset[1]');
    trainTargets = trainingDataset[2]';

    ann = buildClassANN(size(trainInputs, 1), topology, size(trainTargets, 1); transferFunctions=transferFunctions);

    hasValidation = size(validationDataset[1], 1) > 0;
    hasTest       = size(testDataset[1], 1) > 0;

    if hasValidation
        valInputs  = Float32.(validationDataset[1]');
        valTargets = validationDataset[2]';
    end;

    if hasTest
        testInputs  = Float32.(testDataset[1]');
        testTargets = testDataset[2]';
    end;

    loss(m, x, y) = (size(y, 1) == 1) ? Flux.Losses.binarycrossentropy(m(x), y) : Flux.Losses.crossentropy(m(x), y);
    opt_state = Flux.setup(Flux.Adam(learningRate), ann);

    trainLosses = Float32[];
    valLosses   = Float32[];
    testLosses  = Float32[];

    # Ciclo 0
    push!(trainLosses, loss(ann, trainInputs, trainTargets));
    if hasValidation
        push!(valLosses, loss(ann, valInputs, valTargets));
        bestValLoss = valLosses[end];
        bestANN = deepcopy(ann);
    else
        bestValLoss = Inf;
        bestANN = ann;
    end;
    if hasTest
        push!(testLosses, loss(ann, testInputs, testTargets));
    end;

    epochsWithoutImprovement = 0;

    for epoch in 1:maxEpochs
        if trainLosses[end] <= minLoss
            break;
        end;

        Flux.train!(loss, ann, [(trainInputs, trainTargets)], opt_state);

        # Guardamos perdidas
        push!(trainLosses, loss(ann, trainInputs, trainTargets));

        if hasValidation
            push!(valLosses, loss(ann, valInputs, valTargets));
            if valLosses[end] < bestValLoss
                bestValLoss = valLosses[end];
                bestANN = deepcopy(ann);
                epochsWithoutImprovement = 0;
            else
                epochsWithoutImprovement += 1;
            end;
        end;

        if hasTest
            push!(testLosses, loss(ann, testInputs, testTargets));
        end;

        # Early Stopping
        if hasValidation && (epochsWithoutImprovement >= maxEpochsVal)
            break;
        end;
    end;

    # Si no hay conjutno de validacion, devolvemos el ultimo modelo.
    # La RNA de la ultima epoca
    if !hasValidation
        bestANN = ann;
    end;

    return (bestANN, trainLosses, valLosses, testLosses);
end;

function trainClassANN(topology::AbstractArray{<:Int,1},
    trainingDataset::  Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}};
    validationDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}}=(Array{eltype(trainingDataset[1]),2}(undef,0,size(trainingDataset[1],2)), falses(0)),
    testDataset::      Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}}=(Array{eltype(trainingDataset[1]),2}(undef,0,size(trainingDataset[1],2)), falses(0)),
    transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)),
    maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01, maxEpochsVal::Int=20)

    # Redirigimos a la version de matriz de targets
    return trainClassANN(topology, (trainingDataset[1], reshape(trainingDataset[2], :, 1));
        validationDataset=(validationDataset[1], reshape(validationDataset[2], :, 1)),
        testDataset=(testDataset[1], reshape(testDataset[2], :, 1)),
        transferFunctions=transferFunctions, maxEpochs=maxEpochs, minLoss=minLoss, learningRate=learningRate, maxEpochsVal=maxEpochsVal);
end;




# ----------------------------------------------------------------------------------------------
# ------------------------------------- Ejercicio 4 --------------------------------------------
# ----------------------------------------------------------------------------------------------


function confusionMatrix(outputs::AbstractArray{Bool,1}, targets::AbstractArray{Bool,1})
    #
    # Codigo a desarrollar
    #
end;

function confusionMatrix(outputs::AbstractArray{<:Real,1}, targets::AbstractArray{Bool,1}; threshold::Real=0.5)
    #
    # Codigo a desarrollar
    #
end;

function confusionMatrix(outputs::AbstractArray{Bool,2}, targets::AbstractArray{Bool,2}; weighted::Bool=true)
    #
    # Codigo a desarrollar
    #
end;

function confusionMatrix(outputs::AbstractArray{<:Real,2}, targets::AbstractArray{Bool,2}; threshold::Real=0.5, weighted::Bool=true)
    #
    # Codigo a desarrollar
    #
end;

function confusionMatrix(outputs::AbstractArray{<:Any,1}, targets::AbstractArray{<:Any,1}, classes::AbstractArray{<:Any,1}; weighted::Bool=true)
    #
    # Codigo a desarrollar
    #
end;

function confusionMatrix(outputs::AbstractArray{<:Any,1}, targets::AbstractArray{<:Any,1}; weighted::Bool=true)
    #
    # Codigo a desarrollar
    #
end;

using SymDoME


function trainClassDoME(trainingDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}}, testInputs::AbstractArray{<:Real,2}, maximumNodes::Int)
    #
    # Codigo a desarrollar
    #
end;

function trainClassDoME(trainingDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}}, testInputs::AbstractArray{<:Real,2}, maximumNodes::Int)
    #
    # Codigo a desarrollar
    #
end;


function trainClassDoME(trainingDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{<:Any,1}}, testInputs::AbstractArray{<:Real,2}, maximumNodes::Int)
    #
    # Codigo a desarrollar
    #
end;




# ----------------------------------------------------------------------------------------------
# ------------------------------------- Ejercicio 5 --------------------------------------------
# ----------------------------------------------------------------------------------------------

using Random
using Random:seed!

function crossvalidation(N::Int64, k::Int64)
    #
    # Codigo a desarrollar
    #
end;

function crossvalidation(targets::AbstractArray{Bool,1}, k::Int64)
    #
    # Codigo a desarrollar
    #
end;

function crossvalidation(targets::AbstractArray{Bool,2}, k::Int64)
    #
    # Codigo a desarrollar
    #
end;

function crossvalidation(targets::AbstractArray{<:Any,1}, k::Int64)
    #
    # Codigo a desarrollar
    #
end;

function ANNCrossValidation(topology::AbstractArray{<:Int,1},
    dataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{<:Any,1}},
    crossValidationIndices::Array{Int64,1};
    numExecutions::Int=50,
    transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)),
    maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01, validationRatio::Real=0, maxEpochsVal::Int=20)
    #
    # Codigo a desarrollar
    #
end;
# ----------------------------------------------------------------------------------------------
# ------------------------------------- Ejercicio 6 --------------------------------------------
# ----------------------------------------------------------------------------------------------

using MLJ
using LIBSVM, MLJLIBSVMInterface
using NearestNeighborModels, MLJDecisionTreeInterface

SVMClassifier = MLJ.@load SVC pkg=LIBSVM verbosity=0
kNNClassifier = MLJ.@load KNNClassifier pkg=NearestNeighborModels verbosity=0
DTClassifier  = MLJ.@load DecisionTreeClassifier pkg=DecisionTree verbosity=0

function modelCrossValidation(modelType::Symbol, modelHyperparameters::Dict,
    dataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{<:Any,1}},
    crossValidationIndices::Array{Int64,1})
    #
end;