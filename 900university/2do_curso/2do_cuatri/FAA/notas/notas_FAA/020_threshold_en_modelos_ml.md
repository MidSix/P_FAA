# 020 - Threshold (Umbral) en Modelos de Machine Learning

El **Threshold** (Umbral) es el valor de corte o límite de decisión que se utiliza para convertir una salida numérica continua (generalmente una probabilidad o un logit) en una etiqueta discreta o una acción específica.

---

## 1. ¿Qué es exactamente el Threshold?
En modelos que devuelven un valor entre 0 y 1 (como una red neuronal con activación `Sigmoid`), el modelo no dice "esto es un Perro", sino "hay un 0.85 de probabilidad de que sea un Perro".
- **Decisión:** Para dar una respuesta final, aplicamos el threshold.
- **Ejemplo:** Con un threshold de **0.5**:
  - $Valor \ge 0.5 \implies$ Clase A (Positivo)
  - $Valor < 0.5 \implies$ Clase B (Negativo)

---

## 2. Uso del Threshold según el tipo de Modelo

Siguiendo la clasificación de modelos de Machine Learning:

### A. Según el Resultado Deseado

1. **Clasificación (Supervisado):**
   - Es su uso principal. En **Clasificación Binaria**, define la frontera entre las dos clases.
   - En **Clasificación Multiclase**, aunque se suele elegir la clase con mayor probabilidad (Softmax), se pueden usar thresholds mínimos para rechazar clasificaciones dudosas ("No lo sé").

2. **Regresión (Supervisado):**
   - Normalmente **no se usa** en la salida final (que es un número continuo).
   - **Excepción interna:** Algoritmos como los **Árboles de Decisión** usan thresholds internamente en cada nodo para decidir por qué rama de la "bifurcación" ir según el valor de una feature.

3. **Clustering (No Supervisado):**
   - Se usa para definir la pertenencia a un grupo basada en la **distancia**. 
   - Si la distancia a un centroide es superior a un **Threshold**, el elemento puede ser descartado o marcado como **Anomalía (Outlier)**.

4. **Generación:**
   - Se usa para filtrar o "podar" (pruning) resultados de baja probabilidad, asegurando que el contenido generado sea coherente.

### B. Según el Comportamiento / Aprendizaje

1. **Aprendizaje Supervisado:**
   - Fundamental para convertir predicciones de probabilidad en etiquetas reales que el usuario pueda entender.

2. **Aprendizaje No Supervisado:**
   - Vital en la **Detección de Anomalías**. Si el error de reconstrucción (en un Autoencoder) supera un threshold, se dispara una alerta de fraude o fallo.

3. **Aprendizaje por Refuerzo:**
   - Se utiliza en las **políticas de decisión**. Por ejemplo, en la estrategia *epsilon-greedy*, se compara un número aleatorio contra un threshold ($\epsilon$) para decidir si el agente explora el entorno o explota lo que ya sabe.

4. **Aprendizaje Semi-Supervisado:**
   - Se usa en técnicas de **Pseudo-labeling**. Solo si el modelo tiene una confianza (probabilidad) superior a un threshold alto (ej. 0.95), se le asigna una etiqueta automática al dato no etiquetado para re-entrenar.

---
**Tags:** #MachineLearning #Threshold #Clasificacion #FAA #IA
**Relacionado:** [[006_modelos_ml]], [[015_funciones_de_transferencia_activacion]]
