
# Normalización de Entradas vs. Normalización de Salidas

## Tesis Principal: Son Procesos Desacoplados

Normalizar las entradas de un modelo **no obliga** a normalizar sus salidas. El modelo, a través del ajuste de sus pesos (`w`) y sesgos (`b`), es teóricamente capaz de aprender a mapear entradas en una escala (ej: [0, 1]) a salidas en una escala completamente diferente (ej: [50.000, 100.000]).

- **Normalizar Entradas**: Es una técnica de **optimización del entrenamiento**.
- **Normalizar Salidas**: Es una técnica de **optimización del entrenamiento**.

---

## 1. El Propósito de Normalizar las Entradas

La normalización/estandarización de las características de entrada es una práctica casi universal y altamente recomendada. Sus objetivos principales son:

- **Convergencia Eficiente**: Ayuda a que el algoritmo de optimización (ej: descenso de gradiente) converja de manera más rápida y estable. Con todas las características en una escala similar, la función de error tiene una forma más simétrica, permitiendo al optimizador encontrar el mínimo de manera más directa.
- **Igualdad de Contribución**: Asegura que las características con magnitudes más grandes no dominen el proceso de aprendizaje sobre aquellas con magnitudes más pequeñas.

---

## 2. El Propósito de Normalizar las Salidas (en Regresión)

A diferencia de la normalización de entradas, escalar la variable objetivo (`target`) en problemas de **regresión** es una decisión que depende del contexto. No siempre es necesario, pero se vuelve crucial en dos escenarios:

#### A. Restricciones de la Función de Activación de Salida

Si la neurona o capa final de la red utiliza una función de activación con un rango acotado, la salida del modelo estará matemáticamente limitada a ese rango.

- **Sigmoide**: Limita la salida al rango `[0, 1]`.
- **Tangente Hiperbólica (Tanh)**: Limita la salida al rango `[-1, 1]`.

Si tu objetivo es predecir un valor que excede este rango (como el precio de una casa), estás **obligado** a normalizar el `target` para que encaje en el rango de la función. La alternativa es usar una función de activación lineal en la capa de salida, que no tiene rango acotado.

#### B. Estabilidad Numérica y del Gradiente

Si los valores de salida son de una magnitud muy grande (ej: millones o miles de millones), el error calculado (`y_pred - y_real`) también será enorme. Al usar funciones de pérdida como el Error Cuadrático Medio (MSE), usado en regresion, este error se eleva al cuadrado, generando valores astronómicos.

- **Gradientes Explosivos**: Un error gigante produce gradientes gigantes, lo que puede causar que los pesos se actualicen de forma tan violenta que el modelo se vuelve inestable y nunca converge (el error puede resultar en `NaN` o `Inf`).
- **Precisión de Punto Flotante**: Los computadores tienen una precisión finita. Manejar simultáneamente gradientes enormes y ajustes de pesos pequeños puede llevar a errores de redondeo que degradan el aprendizaje.

Normalizar la salida mantiene todos los números del proceso de entrenamiento en un "rango saludable", protegiendo la estabilidad del modelo.

---

## 3. El Contraste Clave: Clasificación vs. Regresión

La necesidad de interpretar o "des-normalizar" la salida del modelo depende fundamentalmente del tipo de problema.

### En Problemas de **Clasificación**:

La interpretación de la salida es **siempre obligatoria**, pero no por una cuestión de escala numérica, sino de **semántica**.

1.  **Entrada**: Se normalizan las características de entrada por eficiencia y se codifican en el caso de haber texto por necesidad.
2.  **Salida del Modelo**: El modelo no produce una categoría como "Perro" o "Gato". Produce un vector de probabilidades (tras una capa Softmax) como `[0.98, 0.02]`.
3.  **Interpretación Requerida**: Tu código debe traducir ese resultado numérico a la etiqueta de texto correspondiente. El `0.98` en la primera posición significa "Perro" según el mapeo que definiste (ej: `LabelEncoder`). Esta traducción es conceptual, no una operación matemática de escala.

### En Problemas de **Regresión**:

La interpretación de la salida es **opcional** y depende directamente de si el `target` fue normalizado durante el entrenamiento.

-   **Escenario A: Target NO Normalizado**
    1.  **Entrenamiento**: El modelo aprende a predecir la temperatura real en grados Celsius.
    2.  **Salida del Modelo**: Devuelve `25.4`.
    3.  **Interpretación Requerida**: **Ninguna**. El valor ya está en la escala real y es directamente interpretable. El modelo "sufrió" más para aprender, pero te da el resultado listo para usar.

-   **Escenario B: Target SÍ Normalizado**
    1.  **Entrenamiento**: El modelo aprende a predecir la temperatura escalada a un rango `[0, 1]`.
    2.  **Salida del Modelo**: Devuelve `0.75`.
    3.  **Interpretación Requerida**: **Obligatoria**. Debes aplicar la operación inversa a la normalización para convertir `0.75` de nuevo a los `25.4` grados Celsius reales.

---

## Resumen Comparativo

| Tipo de Tarea | ¿Entradas Normalizadas? | ¿Salidas Normalizadas? | ¿Requiere Interpretar/Des-normalizar la Salida? |
| :--- | :--- | :--- | :--- |
| **Clasificación** | Sí (Recomendado) | No (se transforma a Probabilidad) | **Sí, siempre** (Mapeo semántico de número a categoría) |
| **Regresión** | Sí (Recomendado) | **Depende** (de la escala y la estabilidad) | **Solo si la salida fue normalizada en el entrenamiento** |
