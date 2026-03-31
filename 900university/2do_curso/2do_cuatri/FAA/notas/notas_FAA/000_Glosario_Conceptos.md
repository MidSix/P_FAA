# Glosario de Conceptos de Programación
[+3h_Julia](https://www.youtube.com/watch?v=KlorfxsdWDw)
Definiciones claras y concisas de términos fundamentales para el ingeniero de software.

## Expresión vs. Sentencia

*   **Expresión (Expression):** Todo código que, al ejecutarse, **produce y devuelve un valor útil**.
    *   *Prueba:* ¿Puedo asignarlo a una variable? `x = (mi_expresion)`. Si funciona, es una expresión (asignar "None" o "nothing" en julia, no cuenta ya que no son utiles de por si).
    *   *Ejemplos:* `2 + 2`, `funcion()`, `lista[0]`.
    *   *En Julia:* `if`, `for`, `begin`, `try` son expresiones (devuelven el valor de la última línea ejecutada).

*   **Sentencia (Statement):** Una instrucción u **orden** que realiza una acción (cambio de estado, control de flujo) pero **no devuelve ningún valor útil** por sí misma.
    *   *Ejemplos en Python:* `if x: ...`, `import math`, `class MiClase: ...`. No puedes hacer `x = import math`.

## REPL (Read-Eval-Print Loop)

Es el **Bucle de Lectura-Evaluación-Impresión**, comúnmente conocido como **"consola interactiva"** o "shell interactivo". Es el entorno donde escribes código línea a línea y obtienes respuesta inmediata.
*   **En Python:** Al ejecutar `python` en la terminal (prompt `>>>`).
*   **En Julia:** Al ejecutar `julia` (prompt `julia>`). Es mucho más potente y tiene "modos" que se activan con teclas especiales:
    *   `?` -> Modo Ayuda (Documentación) "Escribes nombre de funciones y te da su doc".
    *   `]` -> Modo Paquetes (`pkg>`).
    *   `;` -> Modo Shell (comandos del sistema).

## Compilación y Rendimiento: JIT vs. AOT

Entender cómo se ejecuta el código es vital para escribir Julia eficiente.

### 1. Tipos de Ejecución
*   **AOT (Ahead-Of-Time - C/C++):** El código se compila a binario (`.exe`) **antes** de ejecutarse. Si hay un error, no compila. Es rapidísimo pero rígido.
*   **Interpretado (Python):** Un programa lee y ejecuta línea a línea. Si hay un error en la línea 100, las 99 anteriores ya se ejecutaron. Es flexible pero lento.
*   **JIT (Just-In-Time - Julia):** Híbrido. Se siente como interpretado (ejecutas script), pero **compila cada función a código máquina justo antes de usarla**.

### 2. La Trampa del Global Scope
Julia necesita conocer los tipos de datos para optimizar.
*   **En Funciones:** El compilador deduce que `i` es entero y genera código máquina puro (Velocidad C).
*   **En Global Scope:** Una variable global puede cambiar de tipo en cualquier momento. El compilador añade chequeos de seguridad en cada paso (Velocidad Python).

**El impacto es brutal:**
Un mismo bucle sumatorio de 1 a 100 millones:
*   **Global Scope:** `0.455583 seconds` (Velocidad Python). Millones de asignaciones de memoria.
*   **Función (1ª vez):** `0.001267 seconds` (Incluye tiempo de compilación).
*   **Función (2ª vez):** `0.000001 seconds` (Velocidad C/C++). **¡450,000 veces más rápido!**

### 3. Herramientas de Medición (Benchmarking)
*   **`@time`**: Macro básico nativo. Mide tiempo y memoria.
    ```julia
    #Definicion de funcion:
    @time function nombre_funcion(variables::el_tipo)
	    contenido
	end
	#Llamada a la funcion
    @time mi_funcion()
    
    #Al hacer esto imprira el tiempo que tomo en ejecutar y compilar esa
    #funcion
    ```
*   **`BenchmarkTools.jl`**: Estándar profesional. Ejecuta la función miles de veces para dar una media precisa.
    ```julia
    using BenchmarkTools
    @btime mi_funcion()
    ```

## Conceptos de Inteligencia Artificial y Redes Neuronales

*   **Instancia:**
    *   **Programación Orientada a Objetos (POO):** Una instancia es un objeto concreto creado a partir de una clase. La clase define la estructura y el comportamiento (atributos y métodos), mientras que la instancia es la materialización de esa clase con sus propios valores. Por ejemplo, si `Coche` es una clase, `miCoche = new Coche()` crea una instancia de `Coche`.
    *   **Redes Neuronales Artificiales (RNA):** En el contexto de las RNA, una instancia es cada elemento o patrón individual que la red procesa a la vez. Cada instancia es una unidad de entrada completa que se pasa a través de la red para una inferencia o entrenamiento. Por ejemplo:
        *   Si la red procesa imágenes, una instancia podría ser una única foto, donde cada píxel o grupo de píxeles son sus "features".
        *   Si la red analiza datos biométricos, una instancia podría ser el registro completo de un ojo humano, y sus "features" serían características como el color del iris, la forma de la pupila, la distancia entre los ojos, etc.


> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=2&selection=35,0,35,79&color=yellow|Ejercicio 1 - Introduccion, p.2]]
> > Fig. 2. Matrices con las entradas y salidas deseadas para resolver un problema.
> 

*   Una instancia, sin importar el número de sus *features*, siempre se asocia con **una única etiqueta de salida(Pero esa etiqueta de salida es un vector, pues se trabajan con funciones vectoriales, por eso se puede hablar de "varias salidas" -> La respuesta correcta es el contenido)** 
    *   La naturaleza de la etiqueta puede variar:
        *   **Categórica (Clasificación):** Si la salida esperada es una categoría (ej. "perro", "gato" en una clasificación de imágenes; "spam", "no spam" en un filtro de correo). Puede ser nominal (sin orden, ej. colores) u ordinal (con orden, ej. "pequeño", "mediano", "grande").
        *   **Numérica Continua (Regresión):** Si la salida esperada es un valor numérico dentro de un rango continuo (ej. el precio de una casa, la temperatura).

*   **Features (Características/Atributos):** En el ámbito de las Redes Neuronales Artificiales y el Aprendizaje Automático en general, las "features" son las propiedades o atributos medibles de una instancia (o ejemplo) que son relevantes para la tarea que la red está tratando de aprender o predecir. Son las variables de entrada que la red utiliza para tomar decisiones o hacer predicciones.
    *   *Ejemplos:*
        *   Para una imagen: los valores de los píxeles (intensidad, color).
        *   Para un ojo humano: el color del iris, el tamaño de la pupila, la posición, la textura.
        *   Para un dataset de casas: el número de habitaciones, el tamaño en metros cuadrados, la ubicación, el año de construcción.

*   **Etiqueta (Label):** En el contexto de las Redes Neuronales Artificiales (RNA) y el Aprendizaje Supervisado, una etiqueta es la **respuesta correcta o valor de salida esperado** para una instancia dada. Es el "conocimiento" que un humano (o un proceso predefinido) le "impone" al modelo para que aprenda a asociar ciertas características de entrada (features) con una salida específica. Las etiquetas son fundamentales para que el algoritmo pueda calcular su error y ajustar sus parámetros durante el entrenamiento. Es importante destacar que el concepto de "etiqueta" se usa principalmente en el aprendizaje supervisado; en el no supervisado o por refuerzo, aunque también hay salidas deseadas, estas no son impuestas directamente por un humano y por ello no se denominan etiquetas.


- **Regla de propapagacion:** NO confundir con backpropagation no tiene NADA que ver. **La regla de propagacion** es el procesado de datos que sufren las entradas en cada neurona, es decir, **La sumatoria de las entradas por sus pesos + bias**, el proceso que lleva a cabo esa operacion para cada neurona individual se llama **Regla de propagacion.**

---
**Tags:** #Programacion #Conceptos #Glosario #IngenieriaSoftware
**Relacionado:** [[004_Python_to_Julia_Cheatsheet]]