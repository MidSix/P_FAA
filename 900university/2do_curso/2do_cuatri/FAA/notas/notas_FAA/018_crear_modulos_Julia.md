# 018 - Crear y Usar Módulos en Julia

Esta nota explica la arquitectura de módulos en Julia, diferenciándola de Python, y aclara el uso de las palabras clave `module`, `include` y `using`.

## 1. La Filosofía: Julia vs. Python
*   **Python:** Todo archivo `.py` es automáticamente un módulo.  (`import mi_archivo`).
*   **Julia:** Un archivo `.jl` es solo un contenedor de texto. Un **Módulo** es una entidad lógica que debe declararse explícitamente con el bloque `module ... end`. 

> [!IMPORTANT]
> En Julia, puedes tener múltiples módulos en un solo archivo
> (multiples `mudule .. end`  blocks). El archivo y el módulo son conceptos desacoplados.

---

## 2. Cómo Crear un Módulo
Todo módulo debe tener un **nombre** para poder ser referenciado (no existen módulos anónimos).

```julia
module MiModulo
    export mi_funcion  # Hace que la función sea visible al usar 'using'
    # De no usar la keyword "export" aunque el modulo sea importado
    # correctamente, NO se podra usar la funcion simplemente con llamarla.

    function mi_funcion(x)
        return x * 2
    end
    
    # Esta función es "privada" (requiere prefijo si no se exporta)
    function funcion_interna()
        println("Solo me ves con MiModulo.funcion_interna()")
    end
end
```

---

## 3. `include` vs. `using`: ¿Cuál es la diferencia?

### `include("archivo.jl")` (La Orden de Ejecución)
Es un **"copiar y pegar"** literal. Julia lee el archivo y ejecuta su contenido en el lugar donde se llamó.
*   **Efecto:** Si el archivo tiene un `module`, ese módulo ahora existe en la memoria de tu sesión (REPL) (Por ello para usar using en módulos locales se acompaña con `include`, el modulo no se carga a la memoria del REPL solo por existir en el disco duro).
*   **Equivalente en Python:** No tiene un uso estándar, pero sería algo como `exec(open("file.py").read())`.

### `using .MiModulo` (La Apertura del Namespace)
Se usa para cargar las funcionalidades de un módulo que **ya existe en memoria**.
*   **El Punto (`.`):** Indica que el módulo es **local** (está definido en tu sesión actual o archivo). Sin el punto, Julia buscaría un paquete instalado en el sistema (como `DataFrames`).
*   **Efecto:** Trae todas las funciones marcadas con `export` al espacio global (`Main`) para que puedas usarlas sin escribir el prefijo `MiModulo.`.

---

## 4. El Flujo de Trabajo Típico (Evitando la "Ladilla")

Para usar un módulo que tienes guardado en un archivo local:

1.  **Cargas el código:** `include("MiModulo.jl")` (El módulo `MiModulo` nace en la memoria).
2.  **Cargas el namespace:** `using .MiModulo` (Las funciones exportadas quedan libres para usar).

### ¿Por qué usar ambos?
*   Si solo haces `include`, tienes que escribir `MiModulo.mi_funcion()`.
*   Si haces `include` + `using`, puedes escribir simplemente `mi_funcion()`.

---

## 5. FAQ y Errores Comunes (Dudas del Futuro)

### "Acabo de hacer include y me da UndefVarError"
**Causa:** Probablemente definiste la función **dentro** de un bloque `module` pero no has hecho `using .Modulo` ni estás usando el prefijo.
*   *Recuerda:* Todo lo que esté dentro de un `module` está "bajo llave" (encapsulado).

### "Si cambio el código del archivo, ¿tengo que reiniciar?"
En una REPL estándar, sí, tendrías que volver a hacer `include`. Para evitar esto, se usa **`Revise.jl`**:
```julia
using Pkg; Pkg.add("Revise") # Solo una vez
using Revise
include("MiModulo.jl")
using .MiModulo
# Ahora, cada vez que guardes el archivo, Julia actualiza el módulo solo.
```

### "¿Tengo que ejecutar el módulo en cada nueva REPL?"
**Sí.** Al ser módulos locales y no paquetes instalados, viven en la memoria volátil del proceso de la REPL. Si cierras la consola, la memoria `Main` se vacía y debes volver a hacer el `include`.

### "Hice include y la función me funciona sin using"
**Causa:** Tienes la función definida **fuera** del bloque `module` en tu archivo. Al hacer `include`, esa función se inyectó directamente en el espacio global (`Main`) como un script cualquiera.

---
**Tags:** #Julia #Modulos #Namespace #Include #Using #Programacion
**Relacionado:** [[004_Python_to_Julia_Cheatsheet]]