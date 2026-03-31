# 007 - Técnicas de Encoding para Machine Learning

Los modelos de Machine Learning son, en esencia, funciones matemáticas. No pueden operar directamente con texto ("rojo", "verde", "azul") o categorías no numéricas. **El** **encoding(codificación) es el proceso de convertir estas variables categóricas en una representación numérica que el modelo pueda entender.**

>El encoding se lleva a cabo en la primera capa del modelo. Logico pues es un proceso que convierte las features o elementos con los que queremos trabajar en el modelo a una representacion numerica con la que podamos trabajar, ya queda de nuestra parte al final interpretar los valores numericos para traducirlos a nuestra realidad.

######  **- Por tanto al aplicarse sobre las features es un mecanismo comun tanto para Aprendizaje supervisado(clasificacion/regresion), NO supervisado(clustering), semi-supervisado, por refuerzo**

---

## 1. Label Encoding

Esta es una de las técnicas más simples. Asigna un número entero único a cada categoría de la variable.

-   **Para qué se usa:**
    -   **Variables Categóricas Ordinales:** Es ideal cuando las categorías tienen un orden intrínseco (ej: "pequeño" < "mediano" < "grande").
    -   **Clasificación Binaria:** Funciona bien para la variable objetivo (target) cuando solo hay dos clases (0 y 1).
    -   **¡Cuidado!** No se recomienda para variables nominales (sin orden) en las features, porque el modelo podría interpretar incorrectamente que una categoría es "mayor" o "mejor" que otra (ej: que `España (2)` es "más grande" que `Rusia (1)`) y no es asi xd.

-   **Ejemplo:**
    Una variable `Talla` con las categorías `["Pequeño", "Mediano", "Grande"]`.
    -   `Pequeño` -> `0`
    -   `Mediano` -> `1`
    -   `Grande`  -> `2`

-   **Etimología del Nombre:**
    El nombre es literal. "Label" (etiqueta) se refiere a la categoría textual, y "Encoding" (codificación) es el proceso de convertirla a un número. Simplemente, "codificas la etiqueta".

---

## 2. One-Hot Encoding

Esta técnica es una de las más populares y robustas para variables nominales. Crea nuevas columnas binarias (0 o 1) para cada categoría presente en la variable original.

-   **Para qué se usa:**
    -   **Variables Categóricas Nominales:** Es el método de referencia cuando las categorías no tienen un orden inherente (ej: "País", "Color").
    -   **Clasificación Multiclase:** Muy común para codificar las `features` de entrada. El modelo ve la presencia o ausencia de una categoría.
    -   **No se usa para:** Regresión (generalmente), y puede ser problemático si la variable tiene muchísimas categorías (dimensionalidad muy alta), lo que se conoce como la "maldición de la dimensionalidad".

-   **Ejemplo:**
    Una variable `Color` con las categorías `["Rojo", "Verde", "Azul"]`.

| Color |        | Color_Rojo | Color_Verde | Color_Azul |
| :---- | :----: | :--------: | :---------: | :--------: |
| Rojo  | **->** |     1      |      0      |     0      |
| Verde | **->** |     0      |      1      |     0      |
| Azul  | **->** |     0      |      0      |     1      |
> En cada columna se pone un 1 si la feature esta presente y 0 si no lo esta. Tendremos tantas filas como features por lo tanto.


-   **Etimología del Nombre:**
    "One-Hot" (uno caliente) viene del campo de la electrónica y los circuitos digitales. Se refiere a un vector donde todos los bits están a `0` (fríos) excepto uno, que está a `1` ("caliente" o activo). La codificación imita este comportamiento, activando solo la columna correspondiente a la categoría presente.
    > **Todas las columnas a cero salvo una.**

---

## 3. Dummy Encoding (Codificación Ficticia)
(Aunque parece mas eficiente complica el proceso de entrenamiento por lo que la convencion es usar One-Hot encoding)
Es una variante de One-Hot Encoding. La diferencia es que, si una variable tiene `k` categorías, Dummy Encoding crea `k-1` columnas nuevas. La categoría que no tiene columna propia se infiere cuando todas las demás columnas son `0`.

-   **Para qué se usa:**
    -   **Evitar Multicolinealidad:** Su principal propósito es evitar la redundancia de datos. En One-Hot, si conoces los valores de `k-1` columnas, puedes deducir el valor de la k-ésima (si todas son 0, la última debe ser 1). Esta dependencia (multicolinealidad) puede ser un problema para algunos modelos, especialmente los lineales como la Regresión Lineal.
    -   **Mismos casos de uso que One-Hot**, pero en contextos donde la multicolinealidad es una preocupación.

-   **Ejemplo:**
    Usando la misma variable `Color`. Se crea una columna menos. La categoría "Azul" es la categoría de referencia.

| Color |        | Color_Rojo | Color_Verde |                        |
| :---- | :----: | :--------: | :---------: | ---------------------- |
| Rojo  |   ->   |     1      |      0      |                        |
| Verde | **->** |     0      |      1      |                        |
| Azul  |   ->   |     0      |      0      | *(Ambas 0 -> es Azul)* |


-   **Etimología del Nombre:**
    En estadística, una "dummy variable" (variable ficticia o maniquí) es una variable que toma valores de 0 o 1 para indicar la ausencia o presencia de algún efecto categórico. El nombre refleja que estas nuevas columnas son "ficticias", no existían originalmente.

---

## 4. Binary Encoding

Es una solución de compromiso entre Label Encoding y One-Hot Encoding, especialmente útil para variables con muchas categorías (alta cardinalidad).

El proceso es:
1.  Se asigna un número entero a cada categoría (como en Label Encoding).
2.  Se convierte ese número entero a su representación binaria.
3.  Cada dígito de la representación binaria se convierte en una nueva columna.

-   **Para qué se usa:**
    -   **Variables de Alta Cardinalidad:** Cuando One-Hot crearía demasiadas columnas (ej: un campo "Ciudad" con 500 ciudades). Binary Encoding crea `log2(n)` columnas, donde `n` es el número de categorías. Para 500 ciudades, One-Hot crea 500 columnas, mientras que Binary Encoding solo crea 9 (`ceil(log2(500))`).
    -   Reduce la dimensionalidad en comparación con One-Hot, pero mantiene la unicidad de cada categoría sin introducir un orden falso.

-   **Ejemplo:**
    Variable `Fruta` con 5 categorías.

| Fruta   | Label | Binario (3 bits) |        | b1  | b2  | b3  |
| :------ | :---: | :--------------: | :----: | :-: | :-: | :-: |
| Manzana |   1   |       001        |   ->   |  0  |  0  |  1  |
| Plátano |   2   |       010        | **->** |  0  |  1  |  0  |
| Naranja |   3   |       011        |   ->   |  0  |  1  |  1  |
| Fresa   |   4   |       100        |   ->   |  1  |  0  |  0  |
| Uva     |   5   |       101        |   ->   |  1  |  0  |  1  |

-   **Etimología del Nombre:**
    Es directo: "Binary" (binario) porque codifica las categorías usando el sistema de numeración binario.
