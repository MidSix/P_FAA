# 001 - Explicación Detallada: Pipeline de Aprendizaje Automático y Resolución del Ejercicio 3

Esta nota tiene como objetivo desglosar el funcionamiento completo del código desarrollado para el Ejercicio 3, explicando cada componente como una pieza de un sistema mayor (Pipeline), y narrar el proceso de pensamiento, errores y correcciones realizados durante la implementación.

---

## Parte 1: El Pipeline de Aprendizaje Automático (Los Bloques de Lego)

Para que una máquina "aprenda", seguimos una serie de pasos secuenciales y lógicos. Aquí explico qué hace cada parte del código en este flujo.

### 1. Preparación de los Ingredientes (Preprocesamiento)

Antes de cocinar (entrenar), necesitamos preparar los ingredientes (datos).

*   **Carga de Datos (`readdlm`):** Leemos el archivo `.csv`. La máquina no entiende de "Flores", entiende de matrices numéricas.
*   **Codificación (One-Hot Encoding):**
    *   *Problema:* La red neuronal da salidas numéricas (probabilidades). No puede escupir el texto "Iris Setosa".
    *   *Solución:* Convertimos las clases en vectores.
        *   Setosa -> `[1, 0, 0]`
        *   Versicolor -> `[0, 1, 0]`
        *   Virginica -> `[0, 0, 1]`
    *   *En el código:* Función `oneHotEncoding`.
*   **Partición de Datos (Hold-Out):**
    *   *Concepto:* No podemos evaluar al estudiante (Red Neuronal) con las mismas preguntas que estudió para el examen. Necesitamos dividir los datos.
    *   *Entrenamiento (Train):* Para que la red ajuste sus pesos (estudie).
    *   *Validación (Validation):* Para que nosotros, los profesores, veamos cómo va el estudio y decidamos cuándo parar (para que no memorice de más).
    *   *Test:* El examen final. Datos que la red NUNCA ha visto, ni para entrenar ni para decidir cuándo parar.
    *   *En el código:* Función `holdOut`.
*   **Normalización:**
    *   *Problema:* Si una entrada es "longitud de pétalo" (0.1 cm) y otra es "área" (1000 cm²), la red le dará demasiada importancia a los números grandes.
    *   *Solución:* Ponemos todo en la misma escala (ej. entre 0 y 1).
    *   *Regla de Oro (Data Leakage):* Calculamos los mínimos y máximos **SOLO usando el conjunto de entrenamiento**. Luego, aplicamos esa fórmula a validación y test. Si usáramos datos de test para calcular el máximo, estaríamos "haciendo trampa" (la red sabría algo sobre el rango de los datos futuros).

### 2. La Arquitectura (El Cerebro)

*   **Capas (`Dense`):** Conjuntos de neuronas. Cada neurona toma las entradas, las multiplica por unos **pesos** ($w$), les suma un **bias** ($b$) y pasa el resultado por una función de activación.
*   **Funciones de Activación ($\sigma$, ReLU, Softmax):** Deciden si la neurona se "enciende" o no. Sin ellas, la red sería una simple multiplicación lineal y no podría aprender formas complejas.
    *   *Capa de Salida:* Usamos `Softmax` para clasificación multiclase porque transforma los números brutos en una distribución de probabilidad (todos suman 1).

### 3. El Entrenamiento (El Gimnasio)

Este es el bucle principal (`trainClassANN`).

1.  **Forward Pass (Predicción):** La red toma los datos de entrada y lanza una predicción.
2.  **Cálculo del Loss (La nota):** Comparamos la predicción con la realidad (`targets`).
    *   Usamos `crossentropy` (Entropía Cruzada). Si la red predice 0.9 para la clase correcta, el error es bajo. Si predice 0.1, el error es altísimo.
3.  **Backpropagation (La culpa):** Calculamos "de quién fue la culpa" del error. ¿Qué peso ($w$) contribuyó más al fallo? (Esto lo hace Flux con gradientes).
4.  **Optimización (`Adam`):** Ajustamos los pesos ligeramente en la dirección opuesta al error para mejorar.

### 4. Parada Temprana (El Árbitro)

Aquí es donde entra el **Ejercicio 3**.

*   *El Riesgo:* El **Sobreentrenamiento (Overfitting)**. Si entrenas demasiado, la red empieza a memorizar el ruido de los datos de entrenamiento en lugar de aprender el patrón general. Funciona perfecto en entrenamiento, pero falla en el mundo real.
*   *La Solución:* Miramos el error en el conjunto de **Validación** en cada época.
    *   Si el error baja: ¡Bien! Guardamos una copia de esta red (`deepcopy`) porque es la mejor hasta ahora.
    *   Si el error sube o no mejora: Esperamos un poco (`maxEpochsVal` o paciencia).
    *   Si pasan muchas épocas sin mejorar: **PARAMOS**. Restauramos la mejor red guardada y esa es la que entregamos.

---

## Parte 2: Criterios Específicos del Ejercicio 3

Para resolver este ejercicio, seguí estas reglas estrictas del PDF:

1.  **Sin Bucles en `holdOut`:**
    *   Prohibido usar `for` o `while` para repartir los índices.
    *   *Solución:* Usar `randperm(N)` (permutación aleatoria de índices) y cortar el vector con slicing (`indices[1:num]`).
2.  **Matemática de los Porcentajes (`holdOut` de 3 conjuntos):**
    *   Al llamar a `holdOut` la segunda vez para separar Validación de Entrenamiento, el conjunto ya es más pequeño (porque quitamos Test).
    *   *Fórmula:* Si quiero un 20% del total para validación, pero ya quité un 20% para test, el porcentaje relativo es $P_{val} / (1 - P_{test})$.
3.  **Parámetros Opcionales:** `trainClassANN` debe aceptar tuplas vacías para validación/test y funcionar igual que antes si no se le pasan.
4.  **Copia Profunda (`deepcopy`):** No basta con decir `mejor_red = red_actual`, porque en Julia (y Python) esto es solo una referencia. Si la `red_actual` sigue entrenando y empeora, `mejor_red` también empeoraría. `deepcopy` clona la memoria.
5.  **Historial Completo:** Devolver vectores de Loss que incluyan el estado inicial (época 0) antes de entrenar.

---

## Parte 3: Diario de Desarrollo (Mi Proceso de Pensamiento y Errores)

Aquí detallo la narrativa de cómo construí la solución, dónde fallé y cómo lo arreglé, para que puedas replicar mi lógica de depuración.

### Paso 1: Implementación Inicial
Programé la función `trainClassANN` integrando la lógica de validación.
*   *Pensamiento:* "Necesito un bucle que entrene, calcule el loss en validación, y si es mejor que el récord, guarde la red."
*   *Acción:* Usé `Flux.train!` para el entrenamiento y variables auxiliares para llevar la cuenta de `epochsWithoutImprovement`.

### Paso 2: El Primer Error (Sintaxis de Flux)
Al ejecutar el test, recibí un error: `MethodError: no method matching loss...`.
*   *Análisis:* La función `loss` que definí tomaba `(x, y)`, pero `Flux.train!` (en versiones recientes o dependiendo de cómo se pase el optimizador) a veces prefiere que la función de pérdida reciba el modelo explícitamente o maneje los parámetros de cierta forma.
*   *Corrección:* Redefiní la función interna como `loss(m, x, y)` para ser explícito: "Calcula el error del modelo `m` con entrada `x` y salida `y`". Esto solucionó el error de ejecución.

### Paso 3: El Error Numérico (El Bug del "Doble Softmax")
El script de autoevaluación fallaba diciendo que mis valores de Loss no coincidían con los esperados.
*   *Observación:*
    *   Mi valor: `~1.107`
    *   Valor esperado: `~1.213`
*   *Pensamiento (Depuración):* "¿Por qué da distinto si la semilla aleatoria (`seed!`) es la misma? La inicialización de pesos es idéntica."
*   *Hipótesis:* La función de coste es diferente.
*   *Investigación:* Revisé mi código. Estaba usando `Flux.Losses.logitcrossentropy`.
    *   *Teoría:* `logitcrossentropy` es numéricamente más estable, PERO asume que la red neuronal devuelve **logits** (valores crudos, sin acotar).
    *   *Hecho:* La función `buildClassANN` (del ejercicio anterior) termina con una capa `softmax` (para multiclase).
    *   *El Problema:* Estaba haciendo `Softmax` (en la red) + `LogitCrossEntropy` (que aplica Softmax internamente). **Estaba aplicando Softmax dos veces.** Esto "suavizaba" demasiado las probabilidades, bajando artificialmente el error inicial.
*   *Corrección:* Cambié la función de pérdida a `Flux.Losses.crossentropy` (que espera probabilidades ya calculadas, las que salen del Softmax de la red).
*   *Resultado:* El primer valor de Loss coincidió exactamente (`1.2139...`).

### Paso 4: El Error de Dimensiones (Broadcasting)
Después de arreglar el valor numérico, el test falló con `DimensionMismatch`.
*   *Análisis:* El mensaje decía que un array tenía 18 elementos y otro 12.
*   *Causa:* El script de test espera que, debido a la "Parada Temprana", el entrenamiento se detenga en la época 12 (aprox). Si mi lógica de parada estaba mal, yo seguiría hasta las 100 épocas, generando un vector de historial mucho más largo.
*   *Solución:* Revisé la condición `if hasValidation && (epochsWithoutImprovement >= maxEpochsVal)`. Me aseguré de que el bucle `break` ocurriera exactamente cuando la paciencia se agotaba. Al corregir el tipo de Loss (Paso 3), la dinámica de entrenamiento cambió (los valores de error cambiaron), lo que hizo que la condición de parada se activara en el momento correcto esperado por el test.

### Conclusión
El proceso no fue lineal. Requirió entender no solo el código que estaba escribiendo ahora, sino cómo interactuaba con el código del Ejercicio 2 (`buildClassANN`) y con las asunciones matemáticas de la librería `Flux`. La clave fue aislar el problema numérico (el valor del Loss) antes de preocuparse por la lógica de control (el bucle de parada).
