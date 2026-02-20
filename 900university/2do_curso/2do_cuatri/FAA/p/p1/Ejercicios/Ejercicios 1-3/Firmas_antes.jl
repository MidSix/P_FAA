
# Tened en cuenta que en este archivo todas las funciones tienen puesta la palabra reservada 'function' y 'end' al final
# Según cómo las defináis, podrían tener que llevarlas o no

# ----------------------------------------------------------------------------------------------
# ------------------------------------- Ejercicio 2 --------------------------------------------
# ----------------------------------------------------------------------------------------------

using Statistics
using Flux
using Flux.Losses


function oneHotEncoding(feature::AbstractArray{<:Any,1}, classes::AbstractArray{<:Any,1})
    if length(classes)<=2
        oneHot = reshape(feature.==classes[1], :, 1);
        return oneHot;
        # Si solo hay dos o menos(1) clases, se genera una matriz con una columna
    else
        # Si hay mas de dos clases se genera una matriz con una columna por clase
        oneHot = convert(BitArray{2}, hcat([instance.==classes for instance in feature]...)');
        return oneHot;
    end;
end;

oneHotEncoding(feature::AbstractArray{<:Any,1}) = oneHotEncoding(feature, unique(feature))

oneHotEncoding(feature::AbstractArray{Bool,1}) = reshape(feature, :, 1)

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
    dataset[:, vec(stdValues.==0)] .= 0;
    return dataset;
end;

normalizeZeroMean!(dataset::AbstractArray{<:Real,2})=normalizeZeroMean!(dataset,calculateZeroMeanNormalizationParameters(dataset))


function normalizeZeroMean(dataset::AbstractArray{<:Real,2}, normalizationParameters::NTuple{2, AbstractArray{<:Real,2}})
    return normalizeZeroMean!(copy(dataset),normalizationParameters);

end;

normalizeZeroMean(dataset::AbstractArray{<:Real,2})=normalizeZeroMean(dataset, calculateZeroMeanNormalizationParameters(dataset))


classifyOutputs(outputs::AbstractArray{<:Real,1}; threshold::Real=0.5) = outputs.>=threshold;

function classifyOutputs(outputs::AbstractArray{<:Real,2}; threshold::Real=0.5)
    if size(outputs,2)==1
        return reshape(classifyOutputs(vec(outputs); threshold=threshold), :, 1);
    else
         (_,indicesMaxEachInstance) = findmax(outputs, dims=2);
         outputs_bool = falses(size(outputs));
         outputs_bool[indicesMaxEachInstance].= true;  
        return outputs_bool;
    end; 
end;

accuracy(outputs::AbstractArray{Bool,1}, targets::AbstractArray{Bool,1})=mean(outputs.==targets);

function accuracy(outputs::AbstractArray{Bool,2}, targets::AbstractArray{Bool,2})
    if size(outputs,2)==1
        return accuracy(vec(outputs),vec(targets));
    else
        comparison_matrix=outputs.==targets;
        correct_matrix=all(comparison_matrix,dims=2);# all(..., dims=2) nos dice si cada fila es completamente true, ya que un patron es correcto si toda su fila lo es
        return mean(correct_matrix);
    end;
end;

accuracy(outputs::AbstractArray{<:Real,1}, targets::AbstractArray{Bool,1}; threshold::Real=0.5)=accuracy(classifyOutputs(outputs;threshold),targets)

function accuracy(outputs::AbstractArray{<:Real,2}, targets::AbstractArray{Bool,2}; threshold::Real=0.5)
    if size(outputs,2)==1
        return accuracy(vec(outputs),vec(targets));
    else
        correct_outputs=classifyOutputs(outputs;threshold);
        return accuracy(correct_outputs,targets);
    end;
end;

function buildClassANN(numInputs::Int, topology::AbstractArray{<:Int,1}, numOutputs::Int; transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)))
    ann = Chain(); #Creamos la ANN
    numInputsLayer=numInputs;
    
    for (i, numOutputsLayer) in enumerate(topology)
        ann = Chain(ann..., Dense(numInputsLayer, numOutputsLayer, transferFunctions[i])); 
        numInputsLayer = numOutputsLayer; # Actualizamos para la siguiente capa
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
    inputs=Float32.(dataset[1]);
    outputs=dataset[2];

    ann=buildClassANN(size(inputs,2),topology,size(outputs,2);transferFunctions);
    
    inputs=inputs'
    outputs=outputs'#Para usar flux hay que tener los patrones en columnas

    loss(x, y) = (size(y, 1) == 1) ? Flux.Losses.binarycrossentropy(ann(x), y) : Flux.Losses.logitcrossentropy(ann(x), y);#Sobrecarga de la función de pérdida para que se adapte a clasificación binaria o multiclase
    opt_state = Flux.setup(Flux.Adam(learningRate), ann);

    loss_history = Float32[];
    push!(loss_history, Float32(loss(inputs, outputs)));

    for epoch in 1:maxEpochs#Bucle de entrenamiento 

        if loss_history[end] <= minLoss # Si ya hemos alcanzado el error mínimo, salimos

            break;
        end;
        Flux.train!(loss, ann, [(inputs, outputs)], opt_state);
        push!(loss_history, Float32(loss(inputs, outputs)));# Añadir el nuevo loss al historial (en Float32)

    end;

    return (ann, loss_history);
end;

function trainClassANN(topology::AbstractArray{<:Int,1}, (inputs, targets)::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}}; transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)), maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01)
    return trainClassANN(topology, (inputs, reshape(targets, :, 1)); transferFunctions, maxEpochs, minLoss, learningRate);
end;


# ----------------------------------------------------------------------------------------------
# ------------------------------------- Ejercicio 3 --------------------------------------------
# ----------------------------------------------------------------------------------------------

using Random

function holdOut(N::Int, P::Real)
    #
    # Codigo a desarrollar
    #
end;

function holdOut(N::Int, Pval::Real, Ptest::Real)
    #
    # Codigo a desarrollar
    #
end;

function trainClassANN(topology::AbstractArray{<:Int,1},
    trainingDataset::  Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}};
    validationDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}}=(Array{eltype(trainingDataset[1]),2}(undef,0,size(trainingDataset[1],2)), falses(0,size(trainingDataset[2],2))),
    testDataset::      Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}}=(Array{eltype(trainingDataset[1]),2}(undef,0,size(trainingDataset[1],2)), falses(0,size(trainingDataset[2],2))),
    transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)),
    maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01, maxEpochsVal::Int=20)
    #
    # Codigo a desarrollar
    #
end;

function trainClassANN(topology::AbstractArray{<:Int,1},
    trainingDataset::  Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}};
    validationDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}}=(Array{eltype(trainingDataset[1]),2}(undef,0,size(trainingDataset[1],2)), falses(0)),
    testDataset::      Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}}=(Array{eltype(trainingDataset[1]),2}(undef,0,size(trainingDataset[1],2)), falses(0)),
    transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)),
    maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01, maxEpochsVal::Int=20)
    #
    # Codigo a desarrollar
    #
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