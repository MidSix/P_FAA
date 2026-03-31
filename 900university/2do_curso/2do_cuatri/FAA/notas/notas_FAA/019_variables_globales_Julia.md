# 019 - Variables Globales y Macros de Sistema en Julia

Esta nota detalla las variables "mágicas" y macros que Julia utiliza para interactuar con el sistema de archivos y el entorno, comparándolas con sus equivalentes en Python.

## 1. Localización del Archivo y Directorio

En Julia, obtener la ruta del archivo actual no se hace mediante una variable, sino mediante una **macro** que se evalúa en tiempo de compilación.

| Concepto | Julia 🟣 | Python 🐍 |
| :--- | :--- | :--- |
| **Ruta del archivo actual** | `@__FILE__` | `__file__` |
| **Directorio del archivo** | `@__DIR__` | `os.path.dirname(__file__)` |
| **Script principal** | `PROGRAM_FILE` | `sys.argv[0]` |

> [!TIP]
> **@__DIR__** es la forma más común y segura de referenciar archivos locales (datasets, includes) de manera relativa al script actual.

---

## 2. Argumentos y Entorno del Sistema

| Julia 🟣 | Python 🐍 | Descripción |
| :--- | :--- | :--- |
| **`ARGS`** | `sys.argv[1:]` | Vector con los argumentos pasados por terminal. |
| **`ENV`** | `os.environ` | Diccionario (Dict) con las variables de entorno. |
| **`VERSION`** | `sys.version` | Objeto con la versión de Julia instalada. |

---

## 3. Gestión de Rutas de Carga (Path)

Julia gestiona dónde busca el código de forma distinta a Python:

*   **`LOAD_PATH`**: Equivalente a `sys.path`. Es un vector de strings donde Julia busca módulos.
*   **`DEPOT_PATH`**: (Único de Julia) Rutas donde se buscan paquetes instalados, artefactos y entornos precompilados.

---

## 4. El equivalente a `if __name__ == "__main__":`

Julia no tiene un sistema de "nombres de módulo" igual al de Python. Para detectar si un archivo se está ejecutando directamente como un script, se usa la siguiente comparación de rutas:

```julia
if abspath(PROGRAM_FILE) == @__FILE__
    println("Este código solo corre si ejecutas 'julia script.jl'")
    # Ideal para tests o ejemplos dentro de un archivo de funciones
end
```

---

## 5. Diferencia Crítica: Macro vs Variable

Es vital entender que `@__FILE__` es una **macro**. 
*   Se sustituye por la ruta real **antes** de que el código empiece a correr.
*   Si metes `@__FILE__` dentro de una función en un módulo, esa macro siempre devolverá la ruta de donde está *escrito* ese archivo del módulo, sin importar desde qué otro script llames a esa función.

---
**Tags:** #Julia #Macros #Path #PythonVsJulia #Programacion #FAA
**Relacionado:** [[018_crear_modulos_Julia]], [[004_Python_to_Julia_Cheatsheet]]