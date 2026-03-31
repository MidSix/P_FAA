## Nice Julia tutorial:
[+3h_Julia](https://www.youtube.com/watch?v=KlorfxsdWDw)

### Languages worth to learn and their use cases.

**Python** → _Apply AI_        | Use models to solve a problem
**Julia** → _Understand AI_  (math and optimization)
**C++** → _Optimize AI_  (Highly used for speed up model's inference and Real-time systems)
**Java / C#** → _Deploy AI_   | Convert those models into a product (Deploy AI in real systems)
**C** → _Understand computers_
# Python to Julia: La Vía Rápida (Cheatsheet)

Esta guía asume que dominas Python y traduce directamente esos conceptos a Julia.
## ⚠️ La Diferencia #1: Índices
*   **Python:** Empieza en **0**. `lista[0]`, `lista[-1]` (último).
*   **Julia:** Empieza en **1**. `lista[1]`, `lista[end]` (último).

## 1. Sintaxis Básica y Bloques

| Concepto                         | Python 🐍                | Julia 🟣                                             |
| :------------------------------- | :----------------------- | :--------------------------------------------------- |
| **Bloques de código**            | Indentación obligatoria. | `end` cierra el bloque (la indentación es estética). |
| **Imprimir**                     | `print("Hola")`          | `println("Hola")` (con salto de línea).              |
| **Comentarios**                  | `# Comentario`           | `# Comentario`                                       |
| **Interpolación**                | `f"Valor: {x}"`          | `"Valor: $x"` o `"Valor: $(x+1)"`                    |
| **Booleanos**                    | `True`, `False`          | `true`, `false`                                      |
| **Nulo**                         | `None`                   | `nothing`                                            |
| **Salir de terminal**            | `exit()`                 | `exit()`                                             |
| **Clear terminal**               |                          | `Ctrl + L`                                           |
| **String_multilinea**            | '''bloque a comentar'''  | #=bloque a comentar=#                                |
| **exec. selected lines of code** | `shift + enter`          | `shift + enter`                                      |
| **Display new lines**            | `\n`                     | `\n`                                                 |
| **Display tabs**                 | `\t`                     | `\t`                                                 |
| **Concatenate**                  | `string1 + string2`      | `string1 * string2`                                  |
| **Unicode char**                 |                          | `\char_name`                                         |
| **Boolean mask**                 | res = array condition    | `res = array .condition`                             |
| **Shell via REPL**               | `NO`                     | `Write ; at the start to enter shell mode`           |
| **Type hint funcs**              | `a:int`                  | `a::Int`                                             |
| **Dimension**                    |                          | `size(matrix)`                                       |
| **Check type**                   | `type()`                 | `typeof()`                                           |
| **Check typev2**                 | `isinstance(x,y)`        | `x isa y o isa(x,y)`                                 |
| **Check type of what's inside**  |                          | `eltype()`                                           |
| **key and value args**           | **posicion los separa**  | ` ; ` los separa \| `num::Int; u::Real=0.5`          |
|                                  |                          |                                                      |
|                                  |                          |                                                      |

Julia: print -> println sin salto de linea, o sea, el print a secas de julia no tiene salto de linea.
En Julia, la indentación es solo por legibilidad; lo que realmente cierra un bloque es la palabra clave end.
  Debes poner un end por cada:
   * if
   * for
   * while
   * function
   * begin (bloques de código agrupado)
   * struct (clases/estructuras)
   * module
En Julia un bloque *BEGIN* devuelve el valor de la ultima linea de codigo.
### Python: Type Hinting (Anotaciones)

- **Naturaleza:** Es **opcional** e **informativo**. El intérprete de Python ignora las anotaciones en tiempo de ejecución.
- **Propósito:** Mejorar el autocompletado en el IDE y permitir el análisis estático de errores (con herramientas como `mypy`).
- **Sintaxis:**
```Python
    def suma(a: int, b: int) -> int:
        return a + b
```
### Julia: Type System (Tipado)
- **Naturaleza:** Es **opcional** pero **funcional**. Afecta directamente cómo se compila y ejecuta el código.
- **Propósito:** Habilitar el **Multiple Dispatch** (despacho múltiple), permitiendo que una función se comporte de forma distinta según el tipo de argumento.
- **Sintaxis:**
```Julia
    function suma(a::Int, b::Int)::Int
        return a + b
    end
```


## 2. Control de Flujo

### Condicionales
**Python:**
```python
if x > 0:
    print("Positivo")
elif x < 0:
    print("Negativo")
else:
    print("Cero")
```

**Julia:**
```julia
if x > 0
    println("Positivo")
elseif x < 0  # Nota: elseif junto
    println("Negativo")
else
    println("Cero")
end
```

### Bucles
**Python:**
```python
# Rango 0 a 9 (excluye fin)
for i in range(10):
    print(i)

# Iterar lista
for item in lista:
    print(item)
```

**Julia:**
```julia
# Rango 1 a 10 (INCLUYE fin)
for i in 1:10
    println(i)
end

# Iterar lista
for item in lista
    println(item)
end
```

**punto (`.`)** Funciona como bucle. En Julia, casi cualquier función u operador puede convertirse en un bucle optimizado simplemente poniéndole un punto:
- `sin.(mi_vector)` -> Calcula el seno de cada elemento.
- `log.(mi_vector)` -> Calcula el logaritmo de cada elemento.
- `vector1 .+ vector2` -> Suma elemento a elemento.
### Try-Except
**Python:**
```python
try:
    1 / 0
except ZeroDivisionError as e:
    print(e)
finally:
    print("Fin")
```

**Julia:**
```julia
try
    1 / 0
catch e
    println(e)
finally
    println("Fin")
end
```

## 3. Funciones

### Definición Estándar
**Python:**
```python
def suma(a, b):
    return a + b
```

**Julia:**
```julia
function suma(a, b)
    return a + b
end
# El return es opcional, retorna la última línea
```

### One-Liners (Matemático)
**Python:**
```python
suma = lambda a, b: a + b
```

**Julia:**
```julia
suma(a, b) = a + b  # Extremadamente común
```

## 4. Arrays y Matemáticas

Indexar con python nativo es `lista[indice_fila][indice_columna]`
python -> Indexa desde 0
Julia -> Indexa desde 1

| Concepto           | Python (NumPy)               | Julia (Nativo)                                   |
| :----------------- | :--------------------------- | :----------------------------------------------- |
| **Crear Array**    | `np.array([1, 2, 3])`        | `[1, 2, 3]`                                      |
| **Matriz 2x2**     | `np.array([[1, 2], [3, 4]])` | `[1 2; 3 4]` (espacio separa col, ; separa fila) |
| **Potencia**       | `2 ** 3`                     | `2 ^ 3`                                          |
| **Mult. Matriz**   | `A @ B` o `np.dot(A, B)`     | `A * B` (Matemática real)                        |
| **Mult. Elemento** | `A * B`                      | `A .* B` (El punto `.` es mágico)                |
| **Indexar**        | `array[fila, columna]`       | `array[fila, columna]`                           |
| Tamaño             |                              | `lenght(array)`                                  |
| Adds               |                              | `sum(array)`                                     |
| Ordenar            |                              | `sort(array)`                                    |
| **dimension**      | `np.array.shape()`           | `size(matrix)`                                   |

### El "Dot Broadcasting" (Magia de Julia)
En Python, si quieres aplicar una función `sin()` a una lista, necesitas un list comprehension o usar NumPy.
En Julia, simplemente añades un punto a **cualquier** función u operador.

*   **Python:** `[math.sin(x) for x in lista]`
*   **Julia:** `sin.(lista)` (Aplica seno a cada elemento).
*   **Julia:** `lista1 .+ lista2` (Suma elemento a elemento).

## 5. Tipado (Opcional pero recomendado)

**Python:**
```python
def f(x: int) -> int:
    return x + 1
```

**Julia:**
```julia
function f(x::Int64)::Int64
    return x + 1
end
```

## 6. "Todo es una Expresión" (Concepto Pro)
(Expresion es todo codigo que devuelve un valor util, una sentencia no devuelve ningun valor util)
En Python, muchas cosas son **sentencias** (instrucciones que no devuelven nada). En Julia, casi todo es una **expresión** que devuelve el valor de la última línea. Esto permite asignar bloques enteros a variables.

### Asignar un `if`
**Python:**
Requiere operador ternario para asignar.
```python
estado = "Aprobado" if nota >= 5 else "Suspenso"
```

**Julia:**
El `if` normal devuelve valor.
```julia
estado = if nota >= 5
    "Aprobado"
else
    "Suspenso"
end
```

### Bloques `begin` y `let`
Puedes encapsular lógica compleja y asignar solo el resultado final.
```julia
# 'x' valdrá 50. Las variables 'a' y 'b' se filtran al scope global si no es local.
x = begin
    a = 5
    b = 10
    a * b
end

# 'let' crea variables privadas que mueren al acabar el bloque
y = let radio = 2
    pi * radio^2
end
# Aquí 'radio' ya no existe
```

## 7. Importar Librerías (Modules)

En Julia, las funciones estándar (como leer CSVs o estadística) suelen estar en módulos separados.

| Julia 🟣                    | Python 🐍                            | Efecto                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| :-------------------------- | :----------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`using Paquete`**         | `from Paquete import *`              | **El estándar en Julia.** Carga las funciones exportadas al namespace global. Usas `funcion()` directamente.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| **`import Paquete`**        | `import Paquete`                     | Debes usar prefijo: `Paquete.funcion()`. Se usa menos, principalmente para extender funciones.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| **`using Paquete: f1, f2`** | `from Paquete import f1, f2`         | Carga solo funciones específicas de Paquete.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `include(soluciones.jl)`    | `exec(open("soluciones.py").read())` | Permite ejecutar modulos.jl en lugar de traerlos al scope local, esto en python no tiene mucho sentido porque ya se hace con las de arriba. Pero en julia comes in handy porque allí un archivo creado NO es un modulo por defecto, tienes que declararlo como modulo y puede llegar a resultar mas lioso. Además, en cada instancia del REPL debes ejecutar todos tus módulos locales para que los reconozca el `.using`(antecedido por un punto para indicar que el modulo no se trata de uno instalado sino de un archivo local). Por eso la convención para archivos locales suele ser `include(...)` y no `using`. |
|                             |                                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
> Lo que pasa es que en Python todo archivo ES un modulo, mientras que en Julia un archivo.jl NO se considera un modulo SOLO por tener codigo .jl, se tiene que declarar como modulo usando el bloque `module module_name .... end` y ya tendremos un modulo pero local, entonces en el using le tendremos que anteceder un punto: `.` para especificar que se trata de un modulo local, y tendremos que ejecutar el archivo.jl para que el modulo se cargue en la memoria del proceso de un `REPL(consola interactiva)` es decir, cada vez que abramos un nuevo REPL se tendrá que ejecutar TODOS los módulos locales para que se carguen en la memoria Main asignada al proceso REPL
---
**Tags:** #Julia #Python #Cheatsheet #Sintaxis
**Relacionado:** [[003_Python_vs_Julia_Criterio_Ingenieril]]