
# Tened en cuenta que en este archivo todas las funciones tienen puesta la palabra reservada 'function' y 'end' al final
# Según cómo las defináis, podrían tener que llevarlas o no

# ----------------------------------------------------------------------------------------------
# ------------------------------------- Ejercicio 2 --------------------------------------------
# ----------------------------------------------------------------------------------------------

using Statistics
using Flux
using Flux.Losses

Chain(Dense(1 => 10, relu), Dense(10 => 1))(rand(Float32, 1))

function oneHotEncoding(feature::AbstractArray{<:Any,1}, classes::AbstractArray{<:Any,1})
    #
    # Codigo a desarrollar
    #
    
end;

function oneHotEncoding(feature::AbstractArray{<:Any,1})
    #
    # Codigo a desarrollar
    #
end;

function oneHotEncoding(feature::AbstractArray{Bool,1})
    #
    # Codigo a desarrollar
    #
end;

function calculateMinMaxNormalizationParameters(dataset::AbstractArray{<:Real,2})
    #
    # Codigo a desarrollar
    #
end;

function calculateZeroMeanNormalizationParameters(dataset::AbstractArray{<:Real,2})
    #
    # Codigo a desarrollar
    #
end;

function normalizeMinMax!(dataset::AbstractArray{<:Real,2}, normalizationParameters::NTuple{2, AbstractArray{<:Real,2}})
    #
    # Codigo a desarrollar
    #
end;

function normalizeMinMax!(dataset::AbstractArray{<:Real,2})
    #
    # Codigo a desarrollar
    #
end;

function normalizeMinMax(dataset::AbstractArray{<:Real,2}, normalizationParameters::NTuple{2, AbstractArray{<:Real,2}})
    #
    # Codigo a desarrollar
    #
end;

function normalizeMinMax(dataset::AbstractArray{<:Real,2})
    #
    # Codigo a desarrollar
    #
end;

function normalizeZeroMean!(dataset::AbstractArray{<:Real,2}, normalizationParameters::NTuple{2, AbstractArray{<:Real,2}})
    #
    # Codigo a desarrollar
    #
end;

function normalizeZeroMean!(dataset::AbstractArray{<:Real,2})
    #
    # Codigo a desarrollar
    #
end;

function normalizeZeroMean(dataset::AbstractArray{<:Real,2}, normalizationParameters::NTuple{2, AbstractArray{<:Real,2}})
    #
    # Codigo a desarrollar
    #
end;

function normalizeZeroMean(dataset::AbstractArray{<:Real,2})
    #
    # Codigo a desarrollar
    #
end;

function classifyOutputs(outputs::AbstractArray{<:Real,1}; threshold::Real=0.5)
    #
    # Codigo a desarrollar
    #
end;

function classifyOutputs(outputs::AbstractArray{<:Real,2}; threshold::Real=0.5)
    #
    # Codigo a desarrollar
    #
end;

function accuracy(outputs::AbstractArray{Bool,1}, targets::AbstractArray{Bool,1})
    #
    # Codigo a desarrollar
    #
end;

function accuracy(outputs::AbstractArray{Bool,2}, targets::AbstractArray{Bool,2})
    #
    # Codigo a desarrollar
    #
end;

function accuracy(outputs::AbstractArray{<:Real,1}, targets::AbstractArray{Bool,1}; threshold::Real=0.5)
    #
    # Codigo a desarrollar
    #
end;

function accuracy(outputs::AbstractArray{<:Real,2}, targets::AbstractArray{Bool,2}; threshold::Real=0.5)
    #
    # Codigo a desarrollar
    #
end;

function buildClassANN(numInputs::Int, topology::AbstractArray{<:Int,1}, numOutputs::Int; transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)))
    #
    # Codigo a desarrollar
    #
end;

function trainClassANN(topology::AbstractArray{<:Int,1}, dataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}}; transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)), maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01)
    #
    # Codigo a desarrollar
    #
end;

function trainClassANN(topology::AbstractArray{<:Int,1}, (inputs, targets)::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}}; transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)), maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01)
    #
    # Codigo a desarrollar
    #
end;
