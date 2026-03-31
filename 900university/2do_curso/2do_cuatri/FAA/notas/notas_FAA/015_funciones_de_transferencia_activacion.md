
# Funciones de Transferencia (Funciones de Activación)

En el contexto de esta asignatura, los términos **Función de Transferencia** y **Función de Activación** se consideran equivalentes. Estas funciones son un componente crucial en las redes neuronales, ya que introducen no linealidades que permiten a la red aprender relaciones complejas en los datos.

## Restricción General

Una limitación fundamental en la arquitectura de redes neuronales es que **todas las neuronas de una misma capa deben compartir la misma función de transferencia**. Sin embargo, diferentes capas pueden utilizar diferentes funciones.

> [!PDF|yellow] [[Tema 2.3 - Redes de Neuronas Artificiales.pdf#page=57&selection=20,0,20,54&color=yellow|Tema 2.3 - Redes de Neuronas Artificiales, p.57]]
> > Al menos, la misma para todas las neuronas de una capa


---

## 1. Función Sigmoide (Logística)

-   **Descripción:** Transforma los valores de entrada a un rango entre 0 y 1. Fue muy popular en el pasado, pero su uso ha disminuido en las capas ocultas debido a problemas como el desvanecimiento del gradiente.
-   **Fórmula LaTeX:** $$f(x) = \frac{1}{1 + e^{-x}}$$
-   **Tipo de Problema:**
    -   **Capas de Salida:** Ideal para **clasificación binaria** (una sola neurona en la capa de salida) o **clasificación multietiqueta** (múltiples neuronas en la capa de salida, donde cada una representa una etiqueta independiente).
-   **Uso:**
    -   **Capas Ocultas:** No recomendado. La no linealidad es esencial, pero sufre del problema del gradiente desvanecido (los gradientes se vuelven muy pequeños, dificultando el aprendizaje). Si se usara una función lineal en capas ocultas, la red perdería su capacidad para modelar problemas no linealmente separables, haciendo inútiles las capas ocultas.
    -   **Capa de Salida:** Usado comúnmente para problemas de clasificación binaria o multietiqueta, donde la salida se interpreta como una probabilidad.


---

## 2. Función Tangente Hiperbólica (Tanh)

-   **Descripción:** Similar a la sigmoide, pero transforma los valores de entrada a un rango entre -1 y 1 -> [-1,1]. Es centrada en cero, lo que puede ayudar a acelerar la convergencia en el entrenamiento.
-   **Fórmula LaTeX:** $$f(x) = \frac{e^x - e^{-x}}{e^x + e^{-x}}$$`
-   **Tipo de Problema:**
    -   **Capas Ocultas:** Propósitos generales.
-   **Uso:**
    -   **Capas Ocultas:** Fue una opción preferida sobre la sigmoide para capas ocultas debido a que su salida está centrada en cero. Sin embargo, también sufre del problema del gradiente desvanecido.
    -   **Capa de Salida:** Menos común, pero puede usarse en problemas donde la salida deseada está en el rango [-1, 1].

---

## 3. Función ReLU (Rectified Linear Unit)

-   **Descripción:** Es la función de activación más utilizada en las capas ocultas. Devuelve 0 si la entrada es negativa y devuelve la propia entrada si es positiva. Es computacionalmente muy eficiente.
-   **Fórmula LaTeX:** $$f(x) = \max(0, x)$$`
-   **Tipo de Problema:**
    -   **Capas Ocultas:** Propósitos generales, especialmente en redes profundas.
-   **Uso:**
    -   **Capas Ocultas:** Es la opción por defecto para la mayoría de las capas ocultas en redes neuronales y convolucionales. Ayuda a mitigar el problema del gradiente desvanecido y es muy rápida de calcular.
    -   **Capa de Salida:** No se utiliza en la capa de salida, ya que su rango no está acotado.

---

## 4. Leaky ReLU

-   **Descripción:** Una variación de ReLU que, en lugar de devolver 0 para entradas negativas, devuelve un valor pequeño (multiplicado por un coeficiente como 0.01). Esto evita el problema de las "neuronas muertas" que pueden ocurrir con ReLU.
-   **Fórmula LaTeX:** $$f(x) = \begin{cases} x & 	ext{si } x > 0 \ \alpha x & 	ext{si } x \le 0 \end{cases}$$` (donde α es un valor pequeño como 0.01)
-   **Tipo de Problema:**
    -   **Capas Ocultas:** Propósitos generales, como alternativa a ReLU.
-   **Uso:**
    -   **Capas Ocultas:** Se usa en situaciones donde se sospecha que el problema de las "neuronas muertas" de ReLU está afectando el rendimiento.
    -   **Capa de Salida:** No se utiliza.

---

## 5. Función Softmax

-   **Descripción:** Generaliza la función logística a múltiples dimensiones. Transforma un vector de valores reales en una distribución de probabilidad, donde la suma de todos los elementos del vector de salida es 1.
-   **Fórmula LaTeX:** $$f(x_i) = \frac{e^{x_i}}{\sum_{j=1}^{K} e^{x_j}}$$` para `i = 1, ..., K`
-   **Tipo de Problema:**
    -   **Capas de Salida:** Exclusivamente para **clasificación multiclase**, donde las clases son mutuamente excluyentes (una muestra solo puede pertenecer a una clase).
-   **Uso:**
    -   **Capas Ocultas:** No se utiliza.
    -   **Capa de Salida:** Es la función estándar para la capa de salida en problemas de clasificación multiclase. El número de neuronas en la capa de salida debe ser igual al número de clases.

---

## Resumen de Uso (Capas Ocultas vs. Capa de Salida)

| Función | Capas Ocultas | Capa de Salida | Casos de Uso Comunes |
| :--- | :--- | :--- | :--- |
| **Sigmoid** | No recomendado | Sí | Clasificación Binaria, Clasificación Multietiqueta. |
| **Tanh** | Aceptable | Rara vez | Cuando la salida debe estar en el rango [-1, 1]. |
| **ReLU** | **Recomendado (Default)** | No | Capas ocultas en la mayoría de las redes profundas. |
| **Leaky ReLU** | Recomendado (Alternativa) | No | Para evitar el problema de "neuronas muertas" de ReLU. |
| **Softmax** | No | Sí | Clasificación Multiclase. |

La elección de la función de activación en las **capas ocultas** debe ser **no lineal**. Si fuera lineal, una red con múltiples capas ocultas se comportaría como una red de una sola capa, perdiendo su capacidad para modelar problemas complejos y no linealmente separables, que es el propósito principal de usar capas ocultas.
