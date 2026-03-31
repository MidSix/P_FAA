> [!PDF|yellow] [[Ejercicio 3 - Sobreentrenamiento.pdf#page=3&selection=2,44,3,19&color=yellow|Ejercicio 3 - Sobreentrenamiento, p.3]]
> > el conjunto de validación dictamina cuál es la red que se devuelve

- Cual red se devuelve? -> ¿Qué define a una RNA?
  Una RNA no es solo su "esqueleto" (arquitectura: capas, neuronas, funciones de transferencia). Lo que realmente le da su "inteligencia" o comportamiento son sus pesos y bias.       
	* Si tienes dos redes con la misma arquitectura pero distintos pesos, son dos modelos fundamentalmente distintos.
	Como el objetivo de cada época es precisamente cambiar los pesos y bias para aproximarnos a la salida deseada en funcion de la entrada, en cada epoca tienes una red neuronal distinta resultado de ajustar pesos y bias en cada instancia del dataset. NINGUNA red neuronal de la época 1 es la misma que alguna de la época 2. Por eso hablamos de "red que se devuelve"

	 -> Aclarar que en nuestros ejercicios tomamos batch == epoca, es decir, procesamos todo el data set de golpe, pero aunque no fuese asi y dividieramos el procesamiento en N partes, la red neuronal se actualizaria N veces, PERO seguiria siendo la misma red de la epoca en cuestion. SOLO hay una red neuronal por epoca que se podra actualizar N veces dependiendo de cuantas veces(N) dividamos el procesamiento de los datos del dataset.