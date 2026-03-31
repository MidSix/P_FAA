# Conjuntos de Datos para el Entrenamiento de Modelos: Train, Validación, Test

En Machine Learning, es fundamental dividir el dataset disponible en diferentes subconjuntos para entrenar, evaluar(supervisar el entrenamiento instancia por instancia) y probar de manera efectiva el rendimiento de un modelo(test-set). Esta división asegura que el modelo no solo aprenda de los datos, sino que también pueda generalizar bien a datos no vistos.

## 1. Train-set (Conjunto de Entrenamiento)

Es la **porción más grande del dataset**, y es el conjunto de datos que el modelo utiliza para **aprender**. Durante la fase de entrenamiento, el algoritmo ajusta los parámetros internos (pesos y sesgos) del modelo basándose en los patrones y características presentes en estos datos.

-   **Uso real**: Imagina que estás entrenando un modelo para reconocer diferentes tipos de animales en imágenes(Aprendizaje supervisado de clasificacion multietiqueta). El *train-set* estaría compuesto por miles de imágenes de gatos, perros, pájaros, etc., junto con sus etiquetas correctas. El modelo "estudia" estas imágenes una y otra vez, ajustando sus conexiones internas para aprender a distinguir un gato de un perro. Es el material de estudio principal para el modelo.

## 2. Validation-set (Conjunto de Validación)

Es una porción del dataset **separada del conjunto de entrenamiento**, que se utiliza para **evaluar el rendimiento del modelo durante el entrenamiento**, **¿Cuándo? -> después de cada [época](008_epoch_vs_batch_ml).** Y para **ajustar los hiperparámetros**. Es crucial que el modelo no haya "visto" estos datos durante la fase de aprendizaje de pesos.

>Cada vez que se procesa una instancia con un forward pass, se lleva a cabo un **BackPropagation**. Por lo que al completarse una época ya el error ha sido propagado hacia atrás en todas las instancias. Este escenario es con el que trabaja el validation test.

-   **Uso real**: Siguiendo el ejemplo de los animales, una vez que el modelo ha estudiado un poco (entrenado con un subconjunto del train-set), lo probarías con el *validation-set*. Si el modelo funciona mal, podrías decidir cambiar algunos "controles" de su aprendizaje (hiperparámetros como la tasa de aprendizaje, el número de capas, etc.). **No le enseñas las respuestas del validation-set**, solo usas sus resultados para refinar la configuración del entrenamiento. Ayuda a detectar el **sobreajuste (overfitting/sobreentrenamiento)**: si el modelo rinde muy bien en el train-set pero mal en el validation-set, está sobreajustado.

## 3. Test-set (Conjunto de Prueba)

Es un **conjunto de datos completamente independiente y no visto** ni durante el entrenamiento ni durante la validación. Su propósito es proporcionar una **evaluación final, imparcial y objetiva** del rendimiento generalizado del modelo.

-   **Uso real**: Una vez que has terminado de entrenar tu modelo de reconocimiento de animales y has ajustado todos los hiperparámetros usando el validation-set, llega el momento de la "prueba final". Tomas el *test-set*, un conjunto de imágenes de animales que el modelo nunca ha visto antes (ni siquiera para ajustar hiperparámetros), y evalúas su rendimiento. La puntuación que obtenga aquí es la métrica más realista de cómo funcionará tu modelo en el mundo real con datos nuevos. **Nunca se debe ajustar el modelo basándose en el rendimiento del test-set.**

## Comparativa y Relación entre los Conjuntos

| Característica | Train-set | Validation-set | Test-set |
| :------------- | :-------- | :------------- | :------- |
| **Tamaño Típico** | 70-80% del dataset | 10-15% del dataset | 10-15% del dataset |
| **Propósito Principal** | Aprender patrones y ajustar pesos. | Evaluar rendimiento intermedio, ajustar hiperparámetros y detectar sobreajuste. | Evaluación final e imparcial del rendimiento generalizado. |
| **Interacción con el Modelo** | El modelo *aprende* de estos datos. | El modelo *no aprende* de estos datos, pero sus resultados *influyen* en los hiperparámetros. | El modelo *no aprende* ni *influye* en el ajuste. Solo se evalúa. |
| **Momento de Uso** | Durante cada iteración del entrenamiento. | Periódicamente durante el entrenamiento. | Una única vez, al finalizar el entrenamiento. |
| **"Trampa" a Evitar** | Entrenar demasiado (sobreajuste). | Ajustar hiperparámetros usando el test-set (data leakage). | Ajustar el modelo basándose en el test-set. |

La clave de esta división es mantener los conjuntos de validación y prueba completamente separados del entrenamiento para asegurar una evaluación honesta de la capacidad de generalización del modelo. Si se entrenara o validara con datos que luego se usan para probar, se obtendría una estimación engañosamente optimista del rendimiento del modelo.
