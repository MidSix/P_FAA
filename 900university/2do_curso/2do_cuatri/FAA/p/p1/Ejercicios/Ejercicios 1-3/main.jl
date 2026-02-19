using DelimitedFiles
include("Firmas.jl");
# Cargamos el dataset
#=
    **Dataset Overview**
    - **Total Samples:** 150 (50 per species).
    - **Species:** _Iris setosa_, _Iris virginica_, _Iris versicolor_.
    - **Features:**
        - Sepal length (cm)
        - Sepal width (cm)
        - Petal length (cm)
        - Petal width (cm)
    - **Target Variable:** Species.
=#
#-----------------------------------------------------------------------
# Esto es simplemente un archivo de prueba para ir entendiendo el codigo
# nada mas.
#-----------------------------------------------------------------------


COLUMNA_TARGET = 5

dataset = readdlm("iris.data",',');
# El ":" en el indexing es bastante similar que el array slicing
# de python. start:end (inclusive both sides) y se empieza a indexar
# desde 1.

# Los array se indexan[filas,columnas]
inputs = dataset[:,1:COLUMNA_TARGET-1];
targets = dataset[:,COLUMNA_TARGET];

inputs = convert(Array{Float32,2},inputs)
classes = unique(targets)
res = oneHotEncoding(targets, classes)
res = reshape(res, (:,1))
res = res[:]
res2 = oneHotEncoding(res)
println(res2)