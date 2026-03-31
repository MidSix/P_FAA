> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=1&selection=10,0,11,74&color=yellow|Ejercicio 1 - Introduccion, p.1]]
> > Problemas de clasificación: desarrollar un modelo que, a partir de ciertas características de un elemento, sea capaz de clasificarlo en una de varias clases conocidas.
> 

- ### Ejemplo de Clasificación (Categorizar)
Imagina una app donde el sistema analiza una imagen de una parte de la casa y decide qué parte de la casa es.
- **Características (Entradas):** Los píxeles de la imagen, los colores dominantes y las formas detectadas.
- **Proceso AA(Aprendizaje Automatico):** El modelo compara los patrones con categorías que ya conoce.
- **Salida (Resultado):** Una etiqueta o clase. Por ejemplo: **"Cocina"**, **"Baño"** o **"Jardín"**.

> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=1&selection=15,0,16,77&color=yellow|Ejercicio 1 - Introduccion, p.1]]
> > Problemas de regresión: desarrollar un modelo que, a partir de ciertas características de un elemento, sea capaz de predecir uno o varios valores numéricos del elemento.

### Ejemplo de Regresión (Predecir un número)
Imagina que quieres vender tu casa y la aplicación debe decirte cuál es el **precio justo** de mercado.
- **Características (Entradas):** Metros cuadrados, número de habitaciones, código postal, antigüedad de la casa y si tiene garaje.
- **Proceso AA:** El modelo analiza miles de ventas anteriores con características similares.
- **Salida (Resultado):** Un valor numérico continuo. Por ejemplo: **$250,500**.

> 	En ambos casos el AA se lleva a cabo con UN solo **elemento** a la vez, las múltiples entradas son características(features) de ese ÚNICO elemento y puede tener multiples salidas que se ajustaran de forma distinta en funcion de si estamos en un AA Multiclase, Multietiqueta, etc. Lo que nosotros usamos para entrenar **varios elementos a la vez** es el **"Batch Processing"(Paralelismo)** Ahi es donde entra la asignatura de **"Computacion Concurrente Paralela y Distribuida"** Tu no puedes meter dos elementos a la vez al modelo, lo que sí puedes hacer es tener múltiples instancias del modelo que corran de forma independiente en los cores de la GPU, de esa forma se tienen múltiples procesos del entrenamiento, del modelo, pero cada proceso de entrenamiento SOLO puede recibir un elemento a la vez y la salida retornada es con respecto a ese único elemento.

--- 
Desde el punto de vista del diseño de la red
- El modelo es una función matemática $f(x) = y$.
- $x$ es el vector de **características de un único elemento**.
- $y$ es la **salida (o salidas)** de ese único elemento
- **No existe el "entrelazamiento"**: el modelo no mezcla los píxeles de una foto de un perro con los de una de un gato para dar una respuesta.

> [!PDF|red] [[Ejercicio 1 - Introduccion.pdf#page=1&selection=18,0,18,26&color=red|Ejercicio 1 - Introduccion, p.1]]
> > Fig. 1. Sistema a obtener


- De este sistema lo importante y mas complejo de explicar son la **posibilidad de multiples salidas.** Sabemos que las multiples salidas se interpretan y configuran segun la naturaleza del problema, bien puede ser regresion/clasificacion(En el contexto de nuestras practicas, en teoria hay mas) entonces las multiples salidas pueden ser la solucion de un problema de multiclase, multietiqueta, regresion multiple, simple, etc.
#### Diferencia entre clasificacion multiclase y multietiqueta.

La elección depende exclusivamente de la **naturaleza de los datos** y de **la pregunta que quieres responder**:
- **Eliges Multiclase (Excluyente)** cuando las categorías son mutuamente excluyentes por definición (Usa softmax).
    - _Ejemplo:_ Clasificar el sentimiento de un tuit como "Positivo", "Neutro" o "Negativo". No puede ser las tres cosas a la vez con la misma intensidad (La probabilidad de la suma de las 3 debe ser menor que 1, con lo cual no pueden tener la misma probabilidad basicamente, son mutuamente excluyentes, la mayor probabilidad de una reduce necesariamente la probabilidad del resto).
- **Eliges Multietiqueta (No excluyente)** cuando las categorías son descriptores independientes (Usa sigmoide).
    - _Ejemplo:_ Etiquetar un artículo de noticias con temas como "Política", "Economía" y "Europa". Un artículo de economía puede tratar perfectamente sobre política europea.

> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=1&selection=31,6,31,70&color=yellow|Ejercicio 1 - Introduccion, p.1]]
> > ya se conoce la salida que se quiere obtener (salidas deseadas).

-> Eso significa que, al menos en esta practica, estamos trabajando con un **Aprendizaje Supervisado**, De hecho, **Siempre** que tenemos pares de datos de entrada y salida (deseada), estamos **"Supervisando"** el entrenamiento. 
### 1. Aprendizaje Supervisado = Predicción
Aquí siempre hay una "verdad" conocida (etiqueta) con la que comparar el error del modelo.
- **Clasificación:** La salida es una **categoría** (perro/gato, spam/no spam).
- **Regresión:** La salida es un **número real** (precio, temperatura, probabilidad).
> **Regla nemotécnica:** Si el modelo "adivina" algo que ya sabemos de antemano en los datos de entrenamiento, es supervisado.
### 2. Aprendizaje No Supervisado = Descripción
Aquí no hay etiquetas. El modelo no "adivina", sino que "resume" o "encuentra".
- **Clustering:** Agrupa elementos que se parecen entre sí (ej. segmentar clientes por comportamiento de compra).
### 3. Func sigmoide y softmax(func-clasificacion).
Ambas son funciones **(para problemas de clasificacion)** usadas en la ULTIMA capa, la capa de salida. Se usan para filtrar la salida de nuestro modelo de AA. En todo caso hay que saber que para que un modelo tenga un numero N de salidas debe tener un numero N de neuronas de salida, es decir, cada neurona de salida se encarga de devolver el resultado de clasificar/predecir solo UNA etiqueta, clase en concreto del elemento que introducimos en el modelo.

- Softmax: Se usa cuando las categorias son mutuamente excluyentes(Ser/haber/tener una cosa implica no ser otra, o eres hombre o eres mujer, no puedes ser sexo fluido) -> **Transforma los valores que devuelve en probabilidades 0-1 que juntos deben sumar 1.**

- Sigmoide: Se usa cuando las categorias son independientes(Ser una cosa es independiente con que se pueda ser otra. Una pelicula puede ser de categoria "terror", pero tambien "gore",etc)-> permite calcular la probabilidad 0-1 **Independiente** de cada categoria en el elemento que le pasamos al modelo.  

>Hay un cosa relevante de tocar. En un problema binario de clasificacion solo hay 2 categorias que en el caso que sean mutuamente excluyentes se puede usar softmax, y softmax seria eficaz(resolveria el problema) pero no eficiente(desperdicio de recursos, redundancia). Para este caso concreto es mejor usar sigmoide porque de hacerlo en lugar de necesitar 2 neuronas de salida, una por cada categoria, solo necesitariamos una neurona que nos puede devolver o bien la probabilidad de caer o no dentro de la categoria y ya es nuestro trabajo restar ese resultado a la probabilidad total que es 1, y asi conseguimos la probabilidad de estar y de no estar en las categorias, aplicamos nuestro umbral para decidir que probabilidad es suficiente para decir que esta y listo

> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=2&selection=35,79,35,80&color=yellow|Ejercicio 1 - Introduccion, p.2]]
> > Fig. 2. Matrices con las entradas y salidas deseadas para resolver un problema.

- Cada patron/fila  tiene un numero n de caracteristicas.
- Cada patron/fila tiene un numero n de salidas.

> A cada patron/fila se le corresponde un pipeline(todo el proceso de coger los inputs y devolver outputs) de entrada/salida. Ese proceso de coger entradas de una fila y devolver salidas de una fila se le llama **Forward pass o inferencia**. El modelo se ejecutara tantas veces como filas haya(Cada fila se corresponde con un elemento o si le quieres dar otro nombre: La unidad minima de procesamiento del AA(Aprendizaje Automatico)). Generalmente la grafica dedicada(GPU) maneja estas tareas, y para hacerlo hace uso de su paralelismo, lo que le permite tener multiples instancias del AA y con ello poder resolver varias filas a la vez, en el caso de una RTX 5060 tiene 30 SMs con lo que puede procesar en rigor 30 filas en el mismo instance de tiempo, y la grafica usa sus CUDA Cores que son los que se encargan de las operaciones matematicas, en esta grafica son 3840 a 2.50 GHz con lo que en escala temporal humana estamos hablando de miles y miles de filas procesadas por segundo. Entonces el proceso es ir de bloque en bloque(**Batch**, el conjunto de filas que puede procesar a la vez) y cada vez que terminamos un bloque que se ve limitado por el numero de SMs(**Streaming Multiprocessors**) de la grafica, hemos hecho una **Iteracion**. Si para entrenar un modelo en una RTX 5060 se requirieron 3 millones de iteraciones quiere decir entonces que su base de conocimiento fueron de 90 millones de patrones/filas.


> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=1&selection=34,63,34,74&color=yellow|Ejercicio 1 - Introduccion, p.1]]
> > instancias,
> 
> 

-> Un sinonimo de los patrones/filas. Cada instancia es simplemente una fila de la matriz.

---

> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=2&selection=0,41,0,72&color=yellow|Ejercicio 1 - Introduccion, p.2]]
> >  y la salida que debe devolver.

-> Solo en el caso de aprendizaje supervisado, si fuese no supervisado NO necesitariamos las 
etiquetas/salidas que debe devolver:

> [!PDF|yellow] [[Tema 1 - Introduccion.pdf#page=15&selection=17,0,22,13&color=yellow|Tema 1 - Introduccion, p.15]]
> > Aprendizaje no supervisado:  No se tienen etiquetas en los ejemplos de entrenamiento

---
> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=2&selection=109,0,109,86&color=yellow|Ejercicio 1 - Introduccion, p.2]]
> > Si solamente hay dos categorías, por ejemplo verdadero/falso, verde/azul, madera/metal

-> Usa Label encoding

---
> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=3&selection=5,0,29,56&color=yellow|Ejercicio 1 - Introduccion, p.3]]
> > Si hay más de dos categorías, por ejemplo rojo/verde/azul, madera/metal/plástico o coche/barco/avión/tren, se transforma en tantos atributos como posibilidades haya, uno para a cada categoría, con valor 1 para aquellas instancias que pertenezcan a ella y 0 para las que no. Por ejemplo, en el caso rojo/verde/azul los patrones con valor “rojo” pasarán a ser (1, 0, 0), los “verde” (0, 1, 0) y los “azul” (0, 0, 1).

-> Usa OneHot encoding

---

> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=3&selection=33,0,82,30&color=yellow|Ejercicio 1 - Introduccion, p.3]]
> > Existe una tercera posibilidad, cuando hay más de dos categorías, que consiste en convertirlas en un único número real. Por ejemplo, A/B/C/D podría convertirse en 0/0.33/0.66/1. Sin embargo, este caso solamente es interesante cuando en el mundo real exista un orden A < B < C < D.

-> Usa Label encoding

---

> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=3&selection=97,0,98,56&color=yellow|Ejercicio 1 - Introduccion, p.3]]
> > ¿Sería necesario realizar este preprocesado cuando las entradas son los valores de intensidad de cada pixel en una imagen en blanco y negro? ¿Por qué?

->Necesario: No.
->Altamente recomendado: Si.
> Cuando en el pre-procesado se habla de "entradas" nos referimos a las features de una instancia.
> Si las features de la instancia(Una imagen en este caso) son la intensidad de cada pixel DENTRO de la escala de blanco y negro, fijate que estan dentro de la misma escala, con lo cual el modelo NO desperdiciará épocas en aprender la relación entre escalas porque ya todas las features están en la misma.
> Pero si se pasan todos a una escala mas pequeña como la [0,1] se puede llegar a converger mas rapido, y mitigar los riesgo de en alguna de las operaciones conseguir numeros demasiado grandes o pequeños que ralenticen algo los calculos.

---

> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=4&selection=19,0,25,47&color=yellow|Ejercicio 1 - Introduccion, p.4]]
> > En este tipo de normalización, si min=max, se puede realizar otro preprocesado distinto en este atributo, ¿en qué consistiría?

Varias opciones
-> Elimina la feature cuyo min=max porque no aporta ninguna informacion con variabilidad xd, es decir, es cte para todas las instancias. Hay herramientras automatizadas que se encargan de esto.

-> Otra opcion si se preve que en un futuro puede haber variabilidad y que dichos resultados se debieron a una cantidad de muestras insuficientes o fallos a la hora de recopilarlas. Es aplicar un encoding binario sobre esta feature y establecer un umbral o (Threshold) si es superior a cierto valor es 1, si es inferior es 0.  Haciendo esto YA estaria en una escala [0,1] como el resto de nuestras features, todos los valores de la feature que hayan sido tratada con esta opcion por el hecho de tener max=min serian o bien 0 u o bien 1, pero eso da igual, estaria en la escala correcta y NO aplicariamos Min-Max normalization pues ya estaria normalizado.

---

> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=4&selection=41,0,44,26&color=yellow|Ejercicio 1 - Introduccion, p.4]]
> > Sabiendo que los modelos de Aprendizaje Automático en general suponen que los patrones se distribuyen en filas, pero en el mundo de las RR.NN.AA. se distribuyen en columnas, ¿en qué casos habría que normalizar cada fila por separado y en qué casos habría que normalizar cada columna por separado?

-> **SIEMPRE hay que normalizar por feature**, JAMAS en ML convencional se puede normalizar un patron/instancia concreto porque cada instancia tendria unos valores distintos correspondientes al mismo valor. Si tienes un atributo habitaciones y otro precio. Comparando dos instancias, ambas con 6 habitaciones pero una con precio 2_000_000 euros y otra 100_000 euros. entonces el valor correspondiente a las 6 habitaciones para la primera instancia en la escala [0,1] seria distinto al de la instancia 2 para la misma escala [0,1], es decir, aunque esten en la misma escala el mapeo no se hace correctamente. Eso lo primero, y lo segundo como se puede ver en ese mismo ejemplo es la compresion de los datos en la escala)

-> Entonces como **SIEMPRE hay que normalizar por feature**, **normalizas por columna cuando** las instancias esten dispuestas en fila y **normalizas por fila** cuando las instancias esten dispuestas por columna, ya esta.

---

> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=5&selection=16,1,16,67&color=yellow|Ejercicio 1 - Introduccion, p.5]]
> > Por qué no se realiza en las salidas de problemas de clasificación


-> Cuidado aqui. Cuando habla de "normalizar salidas de la RNA" NO se esta refiriendo a las salidas que devuelve la propia RNA en cada forward pass, NO. Se esta refiriendo a las salidas predichas/esperadas, los targets que si lo podemos modificar nosotros significa que los tenemos de antemano(Es decir esta pregunta va completamente orienta al aprendizaje supervisado ). Por eso de no normalizarce obligamos a la red a trabajar mas y a tener pesos muy distintos de los que podria. Habiendo aclarado esto, los targets de los problemas de clasificacion no tiene sentido normalizarlos porque los valores no representan cantidades sino categorias

---

> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=5&selection=20,69,22,48&color=yellow|Ejercicio 1 - Introduccion, p.5]]
> > una vez entrenado, un modelo no está preparado para que se le pasen los datos originales, sino que si se desea aplicar los datos, estos tendrán que ser transformados de la misma manera

->Es decir, hay que que normalizar tambien las features no solo en el proceso de entrenamiento sino tambien en el proceso de uso del modelo ya entrenado y tambien interpretar o des-normalizar las salidas(En el caso de haberse normalizado) para saber interpretar la respuesta del modelo.

> Habras de usar EXACTAMENTE las mismas tecnicas de normalizacion que usaste para cada feature en especifico durante el proceso de entrenamiento. Ejemplo: Si tienes 2 features: Si durante el entrenamiento una la normalizaste con min-max y la otra con zero-mean, entonces al meter data nueva para usar el modelo ya entrenado, dicha data, dichas features deberan estar normalizadas con min-max y zero-mean respectivamente respetando la normalizacion usada en el entrenamiento.

>El modelo aprende a emitir salidas normalizadas siempre y cuando las salidas deseadas usadas en el entrenamiento hayan sido normalizadas, dicho de otro modo, teoricamente la normalizacion de las entradas y salidas es independiente, puedes tener entradas normalizadas y salidas no normalizadas, es decir, que las salidas esten o no normalizadas lo define que hayas o no normalizado las salidas deseadas en el proceso de entrenamiento solamente. 
---


> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=5&selection=9,0,11,69&color=yellow|Ejercicio 1 - Introduccion, p.5]]
> > También es importante tener en cuenta que este proceso ocurre en las salidas de la RNA. Es decir, si las salidas están en intervalos distintos, la RNA tiene que aprender esto también, con lo que se puede “ayudar” a la RNA mediante la normalización de los datos de salida. E

-> Importante aclarar el: "ayudar" porque no es condicion necesaria normalizar las salidas deseadas para poder entrenar el modelo. Esto lo hacemos para optimizar el proceso de entrenamiento cuando es inteligente hacerlo(En clasificacion NO y en regresion SI, por ejemplo), nada mas.

---

> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=5&selection=42,0,42,72&color=yellow|Ejercicio 1 - Introduccion, p.5]]
> > En caso de problemas de regresión, desnormalizar las salidas del modelo.

-> Porque suponemos que las salidas deseadas fueron normalizadas en el proceso de entrenamiento, pero en caso de no haberlo hecho(No recomendado cuando es buena idea hacerlo, pero posible) NO habria que desnormalizar la salida porque ya devolveria la prediccion que se corresponde.

---
> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=6&selection=24,61,24,62&color=yellow|Ejercicio 1 - Introduccion, p.6]]
> > ¿Hay entradas o salidas categóricas? ¿Cómo se van a procesar?

- **Clasificación Binaria:** 1 neurona de salida (Sigmoide).
- **Clasificación Multiclase ($N$ clases):** $N$ neuronas de salida (Softmax).
- **Clasificación Multietiqueta ($N$ etiquetas):** $N$ neuronas de salida (Sigmoide por cada una).

> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=6&selection=19,0,20,9&color=yellow|Ejercicio 1 - Introduccion, p.6]]
> > ¿Cuántos atributos tiene cada patrón? ¿Son todos relevantes? ¿Qué describe cada atributo?

**Dataset Overview**
- **Total Samples:** 150 (50 per species).
- **Species:** _Iris setosa_, _Iris virginica_, _Iris versicolor_.
- **Features:**
    - Sepal length (cm)
    - Sepal width (cm)
    - Petal length (cm)
    - Petal width (cm)
- **Target Variable:** Species.

---
> [!PDF|yellow] [[Ejercicio 1 - Introduccion.pdf#page=6&selection=24,0,24,60&color=yellow|Ejercicio 1 - Introduccion, p.6]]
> > ¿Hay entradas o salidas categóricas? ¿Cómo se van a procesar


- Los target para cada instancia son categoricos nominales, simplemente se codifican con OneHot Encoding porque necesitamos numeros y listo(No se usa Label encoding porque NO son ordinales).