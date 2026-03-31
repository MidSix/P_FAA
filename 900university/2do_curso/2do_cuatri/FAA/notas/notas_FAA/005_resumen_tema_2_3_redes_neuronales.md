# Resumen del Tema 2.3: Redes de Neuronas Artificiales

Este documento resume los conceptos clave del Tema 2.3 de Fundamentos de Aprendizaje Automático (FAA), centrado en las Redes de Neuronas Artificiales (RNA) alimentadas hacia adelante, su estructura, algoritmos de aprendizaje, problemas comunes como el sobreentrenamiento y sus diversas aplicaciones.

## 1. La Neurona Artificial: Unidad Básica de Procesamiento

### Punto Clave
La neurona artificial, también conocida como Elemento de Procesado (EP), es la unidad fundamental de una red neuronal. Recibe múltiples entradas, las procesa mediante una función de propagación, y emite una única salida tras aplicar una función de activación. Para una discusión detallada sobre las funciones de activación más comunes, sus usos y limitaciones, consulta [[015_funciones_de_transferencia_activacion]].

### Explicación Detallada
Una neurona artificial simula el comportamiento básico de una neurona biológica. Cada entrada ($x_j$) es multiplicada por un peso sináptico ($w_{ij}$), que representa la fuerza de la conexión. La suma ponderada de estas entradas, más un término de polarización o *bias* ($b_i$), constituye la entrada neta ($neta_i$). Finalmente, esta entrada neta se pasa a través de una función de activación ($f$) que determina la salida ($y_i$) de la neurona.
Los pesos ($w_{ij}$) y el *bias* ($b_i$) son los parámetros ajustables de la neurona, y su modificación durante el aprendizaje es lo que permite a la red aprender patrones.

### Integración
La neurona artificial es el bloque de construcción de todas las redes neuronales, desde las más simples (como ADALINE o el Perceptrón) hasta las más complejas (como el Perceptrón Multicapa y las redes profundas). La forma en que estas neuronas se conectan y la función de activación que emplean define la arquitectura y la capacidad de la red.

### Ejemplo Práctico y Relevancia Actual
*   **Ejemplo:** Una neurona artificial puede ser entrenada para clasificar si una imagen contiene un gato (salida 1) o no (salida 0). Las entradas serían los valores de píxeles de la imagen, y los pesos se ajustarían para reconocer características que definen a un gato.
*   **Relevancia:** Aunque su concepto es básico, la neurona artificial sigue siendo la piedra angular de la Inteligencia Artificial moderna. En la actualidad, miles de millones de estas "neuronas" se agrupan en arquitecturas complejas (como Transformers en Procesamiento de Lenguaje Natural o Convolucionales en Visión por Computadora) para realizar tareas como la generación de texto, reconocimiento de objetos o traducción automática. Su funcionamiento individual simple, combinado en estructuras masivas, da lugar a la inteligencia artificial avanzada que vemos hoy.

## 2. ADALINE (Adaptive Linear Neuron) y la Regla Delta

### Punto Clave
ADALINE es un modelo básico de red neuronal que utiliza una función de activación lineal y un algoritmo de aprendizaje supervisado conocido como Regla Delta (o *Least Mean Square - LMS*). Su objetivo es minimizar el error cuadrático medio (ECM) entre la salida deseada y la salida real de la neurona.

### Explicación Detallada
A diferencia del Perceptrón original que utiliza una función escalón binaria, ADALINE emplea una función de activación lineal (`purelin`). Esto significa que su salida es directamente proporcional a su entrada neta, permitiendo que el error sea una función continua y derivable de los pesos. La Regla Delta ajusta los pesos de la neurona en proporción directa a la magnitud del error y a la entrada correspondiente, siguiendo el gradiente descendente de la función de error.

La fórmula de actualización del peso $j$ para una muestra $k$ es:
$w_j(t+1) = w_j(t) + \mu \cdot (d_k - y_k) \cdot x_{jk}$
Donde:
*   $w_j(t)$ es el peso actual.
*   $\mu$ es la tasa de aprendizaje.
*   $d_k$ es la salida deseada para la muestra $k$.
*   $y_k$ es la salida real de la neurona para la muestra $k$.
*   $x_{jk}$ es la entrada $j$ de la muestra $k$.

El término $(d_k - y_k)$ es el error, y el ajuste de pesos se hace para reducirlo. El algoritmo se repite en ciclos (épocas) hasta que el ECM sea aceptable o se cumpla una condición de parada.

### Integración
ADALINE fue un paso evolutivo importante más allá del Perceptrón original. Al utilizar una función de activación lineal y un criterio de minimización de error basado en el gradiente, sentó las bases para algoritmos de aprendizaje más sofisticados, como el *Backpropagation* en redes multicapa. Su capacidad para lidiar con problemas linealmente separables es similar a la del Perceptrón, pero su enfoque en la minimización del error lo hizo más robusto y preparó el camino para el aprendizaje de funciones continuas.

### Ejemplo Práctico y Relevancia
*   **Ejemplo:** ADALINE podría usarse para predecir el precio de una casa basándose en características como el número de habitaciones, tamaño y ubicación. La red aprendería a asignar pesos a cada característica para que su salida lineal se acerque lo más posible al precio real.
*   **Relevancia:** Históricamente, ADALINE fue influyente en los inicios de las redes neuronales (años 60). Aunque hoy en día no se usa directamente para problemas complejos, los principios de la Regla Delta (gradiente descendente para minimizar una función de coste) son fundamentales y se encuentran en el corazón de algoritmos modernos de entrenamiento de redes neuronales profundas.

## 3. Perceptrón y Perceptrón Multicapa (MLP)

### Punto Clave
El Perceptrón es un clasificador lineal simple, mientras que el Perceptrón Multicapa (MLP) es una red neuronal más potente capaz de aprender relaciones no lineales mediante la adición de una o más capas ocultas y el algoritmo de *Backpropagation*.

### Explicación Detallada

#### Perceptrón
Desarrollado por Frank Rosenblatt en 1958, el Perceptrón es la primera red neuronal de alimentación directa que podía aprender. Consiste en una única neurona artificial con una función de activación de escalón (generalmente binaria: 0 o 1, o -1 y 1). Puede aprender a clasificar patrones que son linealmente separables, es decir, datos que pueden dividirse por una línea (en 2D), un plano (en 3D) o un hiperplano (en dimensiones superiores). Su regla de aprendizaje es simple: si la clasificación es incorrecta, ajusta los pesos en la dirección que reduce el error.

#### Perceptrón Multicapa (MLP)
El Perceptrón simple tenía una limitación fundamental: no podía resolver problemas no linealmente separables, como el problema XOR (OR exclusivo). La solución a esto fue el Perceptrón Multicapa. Un MLP consiste en:
1.  **Capa de Entrada:** Recibe las características del conjunto de datos.
2.  **Una o más Capas Ocultas:** Contienen neuronas con funciones de activación no lineales (como sigmoide o ReLU). Estas capas permiten a la red aprender representaciones complejas y no lineales de los datos.
3.  **Capa de Salida:** Produce el resultado final (ej. clasificación, regresión).

Las capas en un MLP están completamente conectadas, lo que significa que cada neurona de una capa está conectada a todas las neuronas de la capa siguiente.

### Integración
El MLP supera las limitaciones del Perceptrón simple al introducir capas ocultas y funciones de activación no lineales. Esto le confiere la capacidad de ser un "aproximador universal", es decir, puede aprender cualquier función continua con un número suficiente de neuronas. La magia del aprendizaje en los MLP reside en el algoritmo de *Backpropagation*, que permite ajustar los pesos de todas las capas, incluidas las ocultas.

### Ejemplo Práctico y Relevancia
*   **Problema XOR:** El Perceptrón simple no puede clasificar correctamente la función XOR. Un MLP con una capa oculta sí puede hacerlo, demostrando su capacidad para aprender fronteras de decisión no lineales.
*   **Relevancia Actual:** Los MLP son la base de muchas arquitecturas de redes neuronales profundas. Aunque modelos más complejos como las redes convolucionales o recurrentes dominan campos específicos, los MLP siguen siendo fundamentales en diversas aplicaciones. Por ejemplo, en sistemas de recomendación, detección de fraudes, o como componentes básicos en arquitecturas más grandes.

## 4. Algoritmo de Backpropagation (Retropropagación del Error)

### Punto Clave
El *Backpropagation* es el algoritmo fundamental utilizado para entrenar Perceptrones Multicapa, permitiendo ajustar los pesos de todas las capas (incluidas las ocultas) para minimizar el error de la red.

### Explicación Detallada
Dado que en las capas ocultas no hay salidas deseadas directas, no se puede aplicar la Regla Delta simple. El *Backpropagation* resuelve este problema propagando el error hacia atrás desde la capa de salida hasta las capas ocultas. Funciona en dos fases:
1.  **Fase hacia Adelante (Forward Pass):** Las entradas se propagan a través de la red, capa por capa, hasta calcular la salida final.
2.  **Fase hacia Atrás (Backward Pass):** El error entre la salida calculada y la salida deseada se computa en la capa de salida. Este error se "retropropaga" a las capas ocultas, utilizando la regla de la cadena para calcular el gradiente del error con respecto a cada peso de la red. Cada peso se ajusta en la dirección que reduce este gradiente (descenso de gradiente).

La modificación de un peso se calcula de forma similar a la Regla Delta, pero el "error" para las neuronas ocultas se deriva del error de las neuronas a las que alimentan en la capa siguiente. Una condición clave es que las funciones de activación deben ser derivables.

### Integración
El *Backpropagation* es la generalización de la Regla Delta para redes multicapa. Sin este algoritmo, el entrenamiento efectivo de redes neuronales profundas sería imposible. Es la fuerza motriz detrás de la capacidad de los MLP para aprender representaciones complejas.

### Ejemplo Práctico y Relevancia Actual
*   **Ejemplo:** Cuando un sistema de reconocimiento de voz (basado en redes neuronales) comete un error al transcribir una palabra, el algoritmo de *Backpropagation* se utiliza para ajustar los miles o millones de pesos en la red, de modo que la próxima vez que se encuentre una señal de audio similar, la probabilidad de error sea menor.
*   **Relevancia:** El *Backpropagation* es la espina dorsal de casi todos los algoritmos de entrenamiento de redes neuronales profundas modernas. Desde ChatGPT hasta los sistemas de conducción autónoma, la capacidad de estas IA para aprender de grandes cantidades de datos se basa directamente en la eficiencia y robustez de este algoritmo.

## 5. Sobreentrenamiento (Overfitting) y Estrategias para Mitigarlo

### Punto Clave
El sobreentrenamiento ocurre cuando una red neuronal aprende los datos de entrenamiento (incluido el ruido) tan bien que pierde su capacidad de generalizar a datos nuevos y no vistos. Es un problema común en el aprendizaje automático y existen diversas técnicas para evitarlo.

### Explicación Detallada
Cuando una red está sobreentrenada, su rendimiento en el conjunto de entrenamiento es excelente, pero su rendimiento en un conjunto de validación o prueba (datos no vistos durante el entrenamiento) es pobre. Esto se debe a que la red ha memorizado los ejemplos de entrenamiento en lugar de aprender los patrones subyacentes. Las causas principales son:
1.  **Complejidad Excesiva del Modelo:** Una red demasiado grande (muchas capas o neuronas) para el problema o la cantidad de datos disponibles.
2.  **Entrenamiento Excesivo:** La red se entrena durante demasiados ciclos (épocas), permitiéndole memorizar el ruido de los datos.

### Estrategias para Mitigar el Sobreentrenamiento:
*   **Regularización:**
    *   **L1 (Lasso):** Añade la suma de los valores absolutos de los pesos a la función de coste, fomentando pesos más pequeños y algunos en cero, lo que lleva a la selección de características.
    *   **L2 (Ridge):** Añade la suma de los cuadrados de los pesos a la función de coste, penalizando pesos grandes y promoviendo una distribución más uniforme de los mismos.
    *   **Decaimiento de pesos (Weight Decay):** Es una forma de regularización L2.
*   **Dropout:** Durante el entrenamiento, algunas neuronas se "desactivan" aleatoriamente (sus salidas se ponen a cero). Esto obliga a la red a no depender demasiado de ninguna neurona individual y a aprender representaciones más robustas.
*   **Parada Temprana (Early Stopping):** Monitoriza el rendimiento de la red en un conjunto de validación separado durante el entrenamiento. Cuando el error de validación comienza a aumentar (mientras el error de entrenamiento sigue disminuyendo), se detiene el entrenamiento para evitar el sobreentrenamiento y se utiliza el modelo con el mejor rendimiento en validación.
*   **Aumento de Datos (Data Augmentation):** Generar nuevas muestras de entrenamiento a partir de las existentes mediante transformaciones (rotaciones, recortes, etc.) para aumentar la diversidad del conjunto de datos y reducir el riesgo de memorización.
*   **Conjunto de Entrenamiento, Validación y Prueba:** Dividir los datos en tres conjuntos:
    *   **Entrenamiento:** Usado para ajustar los pesos del modelo.
    *   **Validación:** Usado para monitorizar el rendimiento y ajustar hiperparámetros (como cuándo detener el entrenamiento). No participa en el ajuste directo de pesos.
    *   **Prueba:** Usado para evaluar el rendimiento final del modelo una vez que el entrenamiento y la selección de hiperparámetros han concluido. Debe ser un conjunto de datos completamente nuevo para una evaluación imparcial.

### Integración
El sobreentrenamiento es una de las mayores batallas en el diseño y entrenamiento de modelos de IA. Las estrategias de mitigación son esenciales para construir modelos que no solo funcionen bien con los datos que han visto, sino que también sean capaces de generalizar y hacer predicciones precisas en el mundo real. La parada temprana, en particular, es una aplicación directa del uso de un conjunto de validación para controlar la convergencia del entrenamiento.

### Ejemplo Práctico y Relevancia Actual
*   **Ejemplo:** En un modelo de clasificación de imágenes médicas que detecta tumores, un modelo sobreentrenado podría memorizar las características específicas de las imágenes de entrenamiento (ej. un artefacto en el escáner o una marca de un médico). Cuando se le presenten nuevas imágenes, aunque tengan tumores, si no tienen esos mismos "artefactos" memorizados, el modelo podría fallar en su detección. Las técnicas como *Dropout* o *Data Augmentation* ayudarían a que el modelo se enfoque en las características reales del tumor.
*   **Relevancia:** Es un concepto central en el desarrollo de cualquier modelo de IA. En Deep Learning, donde los modelos son extremadamente grandes, el sobreentrenamiento es una amenaza constante. Técnicas como *Dropout* y la normalización por lotes (*Batch Normalization*) son estándar en casi todas las arquitecturas de redes neuronales profundas para asegurar que los modelos sean robustos y generalizables.

## 6. Aplicaciones de las Redes de Neuronas Artificiales

### Punto Clave
Las Redes de Neuronas Artificiales son herramientas versátiles con una amplia gama de aplicaciones en diversos dominios, especialmente en tareas donde los patrones son complejos o no se pueden modelar con algoritmos tradicionales.

### Explicación Detallada
Las RNA son particularmente útiles en problemas donde:
*   No se sabe cómo resolver el problema de forma algorítmica explícita.
*   No se puede explicitar el conocimiento necesario para la solución.
*   El sistema requiere adaptabilidad y capacidad de generalización.

Sus aplicaciones más comunes incluyen:

1.  **Clasificación:**
    *   Asignar entradas a una de varias categorías discretas.
    *   **Ejemplo:** Clasificación de imágenes (ej. reconocer objetos, detección de ojos), diagnóstico médico (ej. cáncer benigno/maligno). En un sistema de clasificación con múltiples clases, a menudo se usa una función de activación *softmax* en la capa de salida para producir probabilidades de pertenencia a cada clase.

2.  **Predicción / Regresión:**
    *   Predecir un valor continuo a partir de entradas dadas.
    *   **Ejemplo:** Predicción de series temporales (ej. precios de acciones, consumo de energía), previsión meteorológica, estimación de propiedades físicas.

3.  **Clustering (Agrupamiento):**
    *   Agrupar datos similares sin conocimiento previo de las categorías. Es un tipo de aprendizaje no supervisado.
    *   **Ejemplo:** Segmentación de clientes, análisis de documentos, agrupamiento de especies biológicas. (Nota: los perceptrones multicapa suelen usarse en aprendizaje supervisado, pero el concepto de redes neuronales se extiende a modelos que realizan clustering).

4.  **Aproximación de Curvas (Fitting):**
    *   Modelar una función matemática desconocida a partir de datos de ejemplo.
    *   **Ejemplo:** Reconstrucción de señales con ruido, modelado de relaciones complejas en experimentos científicos.

5.  **Eliminación de Ruido:**
    *   Limpiar señales o imágenes contaminadas.
    *   **Ejemplo:** Mejora de la calidad de audio o imagen, filtrado de ruido en transmisiones de datos.

> Aunque se puede decir que TODAS parten de la regresión
### Integración
Las diversas aplicaciones demuestran la flexibilidad de las RNA. La elección de la arquitectura (número de capas, neuronas), la función de activación y el algoritmo de aprendizaje (generalmente *Backpropagation*) se adapta al tipo de problema (clasificación, regresión, etc.). Por ejemplo, para clasificación multiclase, se usarán varias neuronas de salida con función softmax, mientras que para regresión, una única neurona de salida con función lineal.

### Ejemplo Práctico y Relevancia Actual
*   **Ejemplo General:** Un modelo de RNA en un teléfono móvil para reconocer la voz del usuario (Clasificación) o para predecir la próxima palabra al escribir (Predicción).
*   **Relevancia:** Las RNA son el motor detrás de la mayoría de las innovaciones en IA actuales. Desde los asistentes de voz (Siri, Alexa), vehículos autónomos, sistemas de recomendación (Netflix, Spotify), detección de fraudes bancarios, hasta descubrimientos científicos en medicina y materiales. Su capacidad para aprender de datos complejos y adaptarse a nuevas situaciones las hace indispensables en el panorama tecnológico actual.
