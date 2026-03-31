# 001 - Técnicas de Normalización para Machine Learning

La **normalización** (a menudo llamada también escalado o *feature scaling*) es el proceso de preprocesamiento que consiste en transformar y reescalar las features (variables) numéricas de un dataset para que todas se encuentren en una escala común.

Su impacto en la IA es crucial: evita que los modelos gasten recursos y tiempo de cómputo en aprender relaciones irrelevantes entre features que simplemente tienen escalas diferentes (ej: una edad de 0-100 vs. un salario de 20,000-100,000). Al normalizar, ponemos todas las variables en "igualdad de condiciones", permitiendo que el modelo se centre en aprender la verdadera relación predictiva entre ellas y converja más rápido y de forma más estable.

> Al ser una técnica de preprocesado de features(y de targets, cuando cabe), la normalización es un paso crucial aplicable a casi todos los tipos de problemas de Machine Learning, incluyendo **Aprendizaje Supervisado (Regresión y Clasificación)**, **No Supervisado (Clustering)** y es fundamental en **Deep Learning**.

---

### "Necesidad" vs. "Recomendación" de la Normalización

No siempre es obligatoria, pero casi siempre es beneficiosa.

-   **Necesidad (Prácticamente Obligatorio):**
    Se considera necesaria cuando se usan algoritmos cuyo funcionamiento se basa en la distancia entre puntos o en la magnitud de los gradientes.
    -   **Algoritmos basados en distancia:** KNN, SVM, K-Means. Una feature con una escala mayor dominará el cálculo de la distancia, sesgando el modelo.
    -   **Algoritmos basados en gradiente:** Redes Neuronales, Regresión Lineal/Logística. Diferentes escalas pueden hacer que el descenso del gradiente sea inestable y mucho más lento.
    -   **Análisis de Componentes Principales (PCA):** PCA busca las direcciones de máxima varianza. Una feature con mayor escala tendrá mayor varianza y dominará el análisis.

-   **Recomendación (Aconsejable):**
    Incluso si todas las features comparten una escala comun pero grande (ej: valores en los miles), la normalización es muy recomendable.
    -   **Prevención de Inestabilidad Numérica:** Durante el entrenamiento de una red neuronal, los cálculos sucesivos en el *forward pass* (multiplicaciones de pesos, sumas, funciones de activación) pueden generar números extremadamente grandes. Si estos números exceden la capacidad del tipo de dato (ej: un `float32`), pueden ocurrir **desbordamientos (*overflows*)** o **gradientes que explotan (*exploding gradients*)**, arruinando el entrenamiento. Mantener los valores en un rango pequeño como [0, 1] o [-1, 1] mitiga este riesgo. En este caso, el objetivo no es evitar malgastar recursos haciendo que el modelo aprenda relaciones de escala (porque ya son comunes), sino asegurar la estabilidad computacional.

---

## 1. Min-Max Scaling (Normalización)

-   **¿Qué hace?**
    Rescala cada feature de forma independiente a un rango fijo, comúnmente **[0, 1]**.
    `X_normalizado = (X - X_min) / (X_max - X_min)`. Para poder rescalarlos dentro de un rango acotado [0,1], una condicion necesaria por supuesto es tener la certeza que los datos estan acotados, de no poder acotarse este tipo de normalizacion no es posible.
    - En terminos practicos a veces se considera que las cotas estan definidas por los valores actualmente presentes dentro del dataset, en el caso de que llegue a existir un valor superior o inferior a las cotas maxima y minima respectivamente el resultado arrojado simplemente sera 1 y 0 respectivamente en el caso de trabajar con [0,1]
    - Otro metodo es fijar voluntariamente las cotas como umbrales, por ejemplo, se podria fijar como cota superior un umbral en cuanto al salario percibido por un trabajador unos 100.000 euros, pues si vemos a fecha actual 2026 la distribucion de sueldos de los españoles asalariados nos encontraremos que este dato ya esta en el percentil 95, es decir, el 95% de los trabajadores asalariados españoles ganan menos de 100.000 euros anuales, entonces puede ser una aproximacion valida establecer la cota superior en ese punto para evitar la presencia de outlier que no forman parte de la mayoria y que nos comprimiria los datos, perdiendo resolucion numerica(necesitar muchos mas decimales para poder representar algo que no hubiera necesitado tantos decimales sin la ausencia del outlier) y dificultando el entrenamiento del modelo, por que? Porque si la diferencia entre estados llega a ser tan pequeña debido a la compresión de los datos en intervalos muy pequeños, el modelo puede ser víctima de underflow, donde le resulta necesario redondear los datos, y al hacerlo, como las cifras pequeñas son  significativas, pierdes información y se traduce en un aprendizaje deficiente.

-   **¿Por qué se hace?**
    Para poner todas las features en la misma escala sin distorsionar las proporciones relativas entre los valores de una misma feature. Es muy útil cuando el algoritmo no hace suposiciones sobre la distribución de los datos.

-   **Orientado a:**
    -   **Deep Learning:** Especialmente en **Visión por Computador**, donde los píxeles de una imagen (0-255) se normalizan a [0, 1].
    -   **Algoritmos basados en distancia** como K-Nearest Neighbors (KNN) cuando no se asume una distribución gaussiana.

-   **Etimología del Nombre:**
    El nombre es literal y descriptivo: utiliza los valores **mínimo (Min)** y **máximo (Max)** de la feature para realizar el escalado.

-  **Desventaja:** 
	Es menos robusto si la feature presenta o puede presentar valores MUY atípicos, outliers. Para estos casos es más seguro llevar a cabo la Standardization(normalizacion de media 0). 
---

## 2. ZeroMean normalization (Z-score / StandartScaler)

-   **¿Qué hace?**
    Transforma los datos para que tengan una **media (μ) de 0** y una **desviación estándar (σ) de 1**. El resultado no está acotado a un rango fijo.
    `X_estandarizado = (X - μ) / σ`

-   **¿Por qué se hace?**
    Es el método preferido cuando los datos siguen (o se aproximan a) una **distribución Gaussiana (normal)**. A diferencia de Min-Max, no comprime los datos en un rango estrecho, lo que puede ser beneficioso, y es menos sensible a la presencia de *outliers*.

-   **Orientado a:**
    -   **Modelos Lineales (Regresión Lineal, Logística)** y **SVM**, que a menudo asumen que los datos están centrados en cero.
    -   **Análisis de Componentes Principales (PCA)**, que requiere datos centrados en la media.
    -   Es una opción por defecto muy robusta para la mayoría de los problemas de aprendizaje supervisado y no supervisado.

-   **Etimología del Nombre:**
    "Standardization" (Estandarización) se refiere a la acción de transformar los datos para que sigan una **distribución normal estándar**. El valor resultante, `(X - μ) / σ`, es la definición estadística del **"Z-score"**, que mide a cuántas desviaciones estándar se encuentra un punto de la media.

---

## 3. Robust Scaling (Escalado Robusto)

-   **¿Qué hace?**
    Escala los datos utilizando estadísticas que son resistentes a los *outliers*. En lugar de la media/desviación estándar o min/max, utiliza los **cuartiles**.
    `X_robusto = (X - Q1) / (Q3 - Q1)`
    Donde `Q1` es el primer cuartil (percentil 25) y `Q3` es el tercer cuartil (percentil 75).

-   **¿Por qué se hace?**
    Se utiliza específicamente cuando el dataset contiene una cantidad significativa de **valores atípicos (*outliers*)**. Min-Max Scaling se ve dramáticamente afectado por ellos (un solo outlier extremo define todo el rango), y Standardization también se ve sesgado (la media y la desviación estándar son sensibles a los outliers). El escalado robusto los ignora en gran medida al centrarse en el rango donde se encuentra el 50% central de los datos.

-   **Orientado a:**
    -   Cualquier tipo de problema de Machine Learning (regresión, clasificación, clustering) donde se sepa o se sospeche que existen **outliers** que podrían corromper el preprocesamiento. Es una alternativa segura a las otras técnicas en estos escenarios.

-   **Etimología del Nombre:**
    Se llama "Robusto" porque el método es matemáticamente **resistente ("robusto")** a la influencia de los valores atípicos en el dataset.
