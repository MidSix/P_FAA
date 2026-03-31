# Epoch vs. Batch en Machine Learning

A menudo, los términos "epoch" y "batch" se usan en el contexto del entrenamiento de modelos de Machine Learning y pueden ser confusos. Aquí se desglosan de forma clara y concisa.
> [!PDF|yellow] [[Tema 2.3 - Redes de Neuronas Artificiales.pdf#page=83&selection=28,0,31,33&color=yellow|Tema 2.3 - Redes de Neuronas Artificiales, p.83]]
> > Se repite este proceso durante un número de ciclos (epochs) hasta que se da una condición de parada

- Epochs o épocas, son el número de veces que se procesan TODOS los datos(todos los batch) en el entrenamiento. Y UNA época es simplemente SOLO un ciclo donde se procesan todos los datos del train-set. **El numero de épocas es un hiperparámetro escencial.**
## Batch (Lote)

Un **batch** es un **subconjunto del dataset total** que se procesa en una única iteración del bucle de entrenamiento(hay ocasiones en la que el batch_size == epoch_size, lo que significa que en cada iteracion del bucle principal se procesa TODO el dataset). En lugar de procesar todo el conjunto de datos de una vez (lo cual podría ser imposible por limitaciones de memoria), se divide en trozos más pequeños o "lotes".

- **Propósito**: Permite entrenar modelos con datasets que no caben en la memoria VRAM de la GPU. Además, las actualizaciones de los pesos del modelo son más frecuentes, lo que puede llevar a una convergencia más rápida.
- **Tamaño del Batch (`batch_size`)**: Es un hiperparámetro crucial que determina cuántas muestras se procesan a la vez.

### Ejemplo con una RTX 5060

Imaginemos que tenemos una GPU ficticia, una **RTX 5060**, con las siguientes características para nuestro caso:
- **30 SMs (Streaming Multiprocessors)**: Puede considerarse como 30 "núcleos" de procesamiento paralelo a alto nivel.
- **Capacidad de procesamiento**: Cada SM puede manejar un bloque de trabajo, y en nuestro escenario, el sistema está optimizado para que la GPU procese **30 instancias (muestras) de datos simultáneamente**. Este es nuestro `batch_size`.

Si nuestro dataset completo tiene 30,000 imágenes, en cada iteración del entrenamiento, el sistema enviará un `batch` de 30 imágenes a la GPU.

**¿Y los CUDA Cores?**
Los CUDA Cores son los procesadores numéricos que realizan los cálculos matemáticos (multiplicaciones de matrices, convoluciones, etc.) a muy bajo nivel. El hecho de que una GPU tenga miles de CUDA cores es lo que permite que el procesamiento de esas 30 instancias del batch se realice de forma masivamente paralela y extremadamente rápida. Los SMs gestionan y distribuyen el trabajo a los CUDA cores.

## Epoch (Época)

Una **epoch** representa **un recorrido completo a través de todo el dataset de entrenamiento**.

Siguiendo el ejemplo anterior:
- **Dataset total**: 30,000 imágenes.
- **Batch Size**: 30 imágenes.

Para completar una epoch, el modelo necesita procesar todos los batches:
$$
	{Iteraciones por Epoch} = \frac{	{Tamaño total del Dataset}}{	{Tamaño del Batch}} = \frac{30,000}{30} = 1,000 	{ iteraciones}
$$

Después de que el modelo haya visto las 30,000 imágenes (en 1,000 pasadas(iteraciones) de 30 imágenes cada una), se habrá completado **una epoch**. Pero casi ningún entrenamiento acaba SOLO con una epoch, muy usualmente se requieren de varias epoch. Para qué más? Porque es en la siguiente epoch donde el modelo se vuelve a ejecutar pero sobre el error previamente propagado hacia atras con la "backpropagation technique". Haciendo que en cada epoch vaya reduciendo el error de entrenamiento hasta lo que nosotros queramos teniendo en cuenta las constrains para evitar overfitting(Sobreentrenamiento) y demas que se verán en el siguiente párrafo.


## Sobreentrenamiento

> [!PDF|yellow] [[Tema 2.3 - Redes de Neuronas Artificiales.pdf#page=145&selection=0,0,5,34&color=yellow|Tema 2.3 - Redes de Neuronas Artificiales, p.145]]
> > SOBREENTRENAMIENTO  Cómo evitar el sobreentrenamiento:


El entrenamiento consiste en repetir este proceso durante múltiples epochs. En cada iteración (procesamiento de un batch), el modelo realiza una predicción, calcula el error y ajusta sus pesos.

Este ciclo se repite hasta que se cumple una **condición de parada**:
- Se ha alcanzado un **error de entrenamiento aceptable**.
- Se ha completado un **número de epochs prefijado**.
- **Early Stopping**: No se ha mejorado el menor error de validación durante una serie de ciclos seguidos, para evitar el sobreentrenamiento.
- Otras condiciones para evitar el *overfitting*.

## Comparativa: Batch vs. Epoch

| Característica | Batch (Lote) | Epoch (Época) |
| :--- | :--- | :--- |
| **Definición** | Un subconjunto del dataset. | Un recorrido completo por todo el dataset. |
| **Propósito** | Hacer manejable el entrenamiento y actualizar pesos frecuentemente. | Medir cuántas veces el modelo ha visto todos los datos de entrenamiento. |
| **Escala** | Es una fracción del dataset. | Es el dataset completo. |
| **Relación** | Una epoch se compone de múltiples batches. | Un entrenamiento se compone de múltiples epochs. |
| **Analogía** | Si el dataset es un libro, un batch es una página o un párrafo. | Una epoch es leer el libro entero una vez. |
