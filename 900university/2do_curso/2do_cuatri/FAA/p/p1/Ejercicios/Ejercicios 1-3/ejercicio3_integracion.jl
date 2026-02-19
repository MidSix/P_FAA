using DelimitedFiles
using Statistics
using Plots
include("Firmas.jl")

#-----------------------------------------------------------------------
# Esto es simplemente un archivo de pruebas, esto no se entrega.
#-----------------------------------------------------------------------

# 1. Cargar la base de datos
dataset = readdlm("iris.data", ',');
inputs = convert(Array{Float32,2}, dataset[:, 1:4]);
targets = dataset[:, 5];

# Codificar targets (One-Hot Encoding)
targets_encoded = oneHotEncoding(targets);

# 2. Utilizar la función holdOut para dividir el conjunto de datos
# Proporciones sugeridas: 60% entrenamiento, 20% validación, 20% test
N = size(inputs, 1);
(trainIdx, valIdx, testIdx) = holdOut(N, 0.2, 0.2);

trainInputs = inputs[trainIdx, :];
trainTargets = targets_encoded[trainIdx, :];

valInputs = inputs[valIdx, :];
valTargets = targets_encoded[valIdx, :];

testInputs = inputs[testIdx, :];
testTargets = targets_encoded[testIdx, :];

# 3. Calcular los valores de los parámetros de normalización
# Únicamente del conjunto de entrenamiento
normParams = calculateMinMaxNormalizationParameters(trainInputs);

# 4. Normalizar los 3 conjuntos con los mismos parámetros
normalizeMinMax!(trainInputs, normParams);
normalizeMinMax!(valInputs, normParams);
normalizeMinMax!(testInputs, normParams);

# 5. Entrenar distintas arquitecturas
# Ejemplo con una topología [8, 4]
topology = [8, 4];
maxEpochs = 1000;
maxEpochsVal = 20;
learningRate = 0.01;

println("Entrenando arquitectura ", topology, "...");
(ann, trainLosses, valLosses, testLosses) = trainClassANN(topology, 
    (trainInputs, trainTargets);
    validationDataset=(valInputs, valTargets),
    testDataset=(testInputs, testTargets),
    maxEpochs=maxEpochs,
    maxEpochsVal=maxEpochsVal,
    learningRate=learningRate
);

# 6. Sacar gráficas de evolución de los 3 valores de loss
p = plot(0:length(trainLosses)-1, trainLosses, label="Training Loss", title="Evolución del Loss", xlabel="Época", ylabel="Loss");
if !isempty(valLosses)
    plot!(p, 0:length(valLosses)-1, valLosses, label="Validation Loss");
end;
if !isempty(testLosses)
    plot!(p, 0:length(testLosses)-1, testLosses, label="Test Loss");
end;

# Guardar la gráfica
savefig(p, "evolucion_loss.png");
println("Gráfica guardada como evolucion_loss.png");

# Evaluar el modelo final
outputs_test = ann(testInputs');
acc = accuracy(outputs_test', testTargets);
println("Accuracy en el conjunto de test: ", acc);
