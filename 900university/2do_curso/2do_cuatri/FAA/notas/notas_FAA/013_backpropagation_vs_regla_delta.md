# Backpropagation vs. Regla Delta: Conceptos y Relación

La relación entre Backpropagation (Retropropagación) y la Regla Delta (o Descenso del Gradiente) es fundamental para entender cómo aprenden las redes neuronales artificiales. No son algoritmos de optimización mutuamente excluyentes, **sino que trabajan en conjunto**.

## 1. Regla Delta (Error Delta Rule / Descenso del Gradiente)

### Definición
"La Regla Delta es un algoritmo de optimización basado en el **Descenso del Gradiente(Disminuir el error entre la salida dada por el modelo y la esperada ajustando los pesos que existen ENTRE cada capa de neuronas)** que ajusta los pesos de un modelo minimizando una **función de pérdida(es la funcion que mide el error obtenido por el modelo en el forward-pass especifico)**. Aunque su aplicación más directa es en el **aprendizaje supervisado** (donde el objetivo es una etiqueta conocida -> proporcionada por un tercero), su principio fundamental de corrección de error(entre salida dada y la deseada) es la base del entrenamiento en arquitecturas complejas, incluyendo el aprendizaje por refuerzo y modelos auto-supervisados."

> Lo es porque la adquisicion de la salida deseada SIEMPRE esta presente sin importar el tipo de modelo de Machine Learning. En el caso de aprendizaje supervisado tenemos "Etiquetas" tanto categoricas nominales como ordinales o numericas continuas, pero en ultima instancia se llaman etiquetas por ser proporcionadas por terceros, mientras que en el resto de modelos la salida deseada no se proporciona en el entrenamiento sino que es "calculada".

### Funcionamiento Básico
1.  **Cálculo del Error:** **Se mide el error** entre la salida deseada (real) y la salida obtenida por la red neuronal, como? Eso ya depende del problema especifico porque se usan diversas funciones para este caso, por poner un ejemplo, dentro de regresion se usa Error Cuadratico Medio, la funcion de error que fue usada en la practica de ingenieria de software para la regresion multiple, pues esa funcion de error es la norma en el mercado para regresion, mientras que para clasificacion se suele usar Cross-Entropy, es decir, incluso dentro del aprendizaje supervisado estas funciones cambian, si dentro de un mismo modelo de aprendizaje como el supervisado lo hacen tambien lo haran cuando los modelos de aprendizaje son diferentes. El punto es que TODA RNA debe tener una funcion de error, cual? Eso ya lo investigas tu para el problema en concreto.
2.  **Cálculo del Gradiente:** Se determina cómo un cambio infinitesimal en cada peso individual afectaría el error total. Este es el gradiente del error con respecto a los pesos.
3.  **Actualización de Pesos:** Los pesos se ajustan en la **dirección opuesta** al gradiente (para descender por la "pendiente" de la función de error), proporcionalmente a una tasa de aprendizaje (learning rate).

## 2. Backpropagation (Retropropagación del Error)

### Definición
Backpropagation es una técnica (o algoritmo) para calcular de manera eficiente los gradientes de la función de coste (error) con respecto a todos los pesos en una red neuronal multi-capa (deep neural network). Utiliza la **regla de la cadena** para propagar el error desde la capa de salida hacia atrás a través de las capas ocultas, asignando una "contribución" del error a cada peso.

### Funcionamiento Básico
1.  **Paso Adelante (Forward Pass):** Se introduce una entrada a la red, y las activaciones se propagan hacia adelante a través de todas las capas para producir una salida.
2.  **Cálculo del Error de Salida:** Se compara la salida de la red con la salida real para calcular el error en la capa de salida.
3.  **Paso Hacia Atrás (Backward Pass):** El error se propaga hacia atrás. Para cada capa, Backpropagation calcula:
    *   Cuánto contribuyó cada neurona al error de la capa siguiente.
    *   Cómo deben cambiarse los pesos para reducir ese error.
    *   Estos cálculos se realizan eficientemente utilizando derivadas parciales y la regla de la cadena.
4.  **Gradientes:** El resultado de Backpropagation son los gradientes (las derivadas parciales del error con respecto a cada peso de la red).
5. **Regla delta(Actualizacion):** Una vez tienes los gradientes se aplica la regla delta para actualizar los pesos entre

## 3. Relación y Complementariedad

*   **Backpropagation calcula los "ingredientes" para la Regla Delta**

*   **La Regla Delta utiliza los gradientes de Backpropagation:** Una vez que Backpropagation ha calculado los gradientes para todos los pesos, la Regla Delta (o el algoritmo de Descenso del Gradiente en general) toma esos gradientes y los aplica para actualizar los pesos de la red, moviéndose en la dirección que minimiza la función de error.

### Analogía
Imagina que estás en una montaña (la función de error) y quieres llegar al punto más bajo (el mínimo error).
*   **Backpropagation** sería como un sistema de sensores y un GPS que te dice con precisión la pendiente exacta en cada punto del terreno y la dirección hacia abajo.
*   La **Regla Delta / Descenso del Gradiente** sería el proceso de mover tus pies un pequeño paso en esa dirección que el GPS (Backpropagation) te ha indicado.

Sin Backpropagation, sería muy difícil o imposible saber la dirección correcta en una montaña compleja. Sin la Regla Delta, no harías el movimiento para descender.

## Conclusión

Backpropagation es una técnica fundamental para el **cálculo de gradientes** en redes neuronales multi-capa, permitiendo que algoritmos de optimización basados en gradientes (como la Regla Delta / Descenso del Gradiente) puedan **actualizar los pesos** de la red de manera efectiva para el aprendizaje. Son dos partes interdependientes del proceso de entrenamiento de la mayoría de las redes neuronales artificiales.
