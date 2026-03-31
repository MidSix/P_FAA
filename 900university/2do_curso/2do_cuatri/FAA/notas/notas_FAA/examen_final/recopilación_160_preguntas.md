> El examen teórico final es de 40 preguntas. Según dicen, de estas 160 preguntas, suelen caer unas 10. Mitad para el aprobado.
---

> [!PDF|yellow] [[FAA_Solución_Preguntas.pdf#page=8&selection=96,0,99,25&color=yellow|FAA_Solución_Preguntas, p.8]]
> > 41- ¿Cómo se entrena ADALINE?

41- ¿Cómo se entrena ADALINE?
- a. Usando el algoritmo de backpropagation
- b. Usando LMS o la Regla Delta
- c. Usando el algoritmo de aprendizaje por refuerzo
- d. Usando el algoritmo de máxima verosimilitud

> [!CHECK]- Respuesta
>> **Correcta: B** ADALINE es la red más sencilla de todas que cuenta SOLO con una capa. Por tanto NO necesita "Backpropagation" que es simplemente la generalizacion de la Regla Delta para propagar el error a traves de capas ocultas, pero ADALINE NO tiene capas ocultas porque solo tiene una capa xd. 
> >
> > NO a. -> Usa la regla Delta, no cesita la generalizacion para multiples capas que no tiene porque solo tiene una.
> 
> > NO c. ->Es de aprendizaje por refuerzo, ADALINE es un modelo de aprendizaje supervisado porque necesitamos etiquetas, necesitas respuestas correctas asociadas a cada instancia para comparar con las respuestas arrojadas por el modelo e ir poco a poco disminuyendo el error.
> 
> > NO d. -> No tiene cabida en el ADALINE

---

> [!PDF|yellow] [[FAA_Solución_Preguntas.pdf#page=30&selection=20,0,23,15&color=yellow|FAA_Solución_Preguntas, p.30]]
> > 160- La Regla Delta:

160- La Regla Delta: 
- a. Modifica los pesos (signo) del cambio realizado en el ciclo anterior 
- b. Modifica los pesos en el sentido (signo) opuesto del cambio realizado en el ciclo anterior 
- c. Modifica los pesos en el sentido (signo) de la pendiente del error 
- d. Modifica los pesos en sentido (signo) opuesto de la pendiente del error

> [!CHECK]- Respuesta
>> **Correcta: d** "La pendiente del error" es el gradiente. Y el gradiente nos dice hacia que sentido crece el error, por tanto nosotros tenemos que irnos al lado opuesto para disminuirlo(Descenso del gradiente).
> >
> > NO a. -> NO se toca el ciclo anterior(epoca) solo se trabaja con la epoca actual para modificar los pesos
> 
> > NO b. -> "Ciclo anterior" -> No, nada, no hace nada en el ciclo anterior
> 
> > NO c. -> No queremos aumentar el error asi que no(Ascenso del gradiente)

---

> [!PDF|yellow] [[FAA_Solución_Preguntas.pdf#page=29&selection=119,0,126,13&color=yellow|FAA_Solución_Preguntas, p.29]]
> > 158- Al recibir las entradas de una neurona artificial, estas se combinan en primer lugar mediante una:

158- Al recibir las entradas de una neurona artificial, estas se combinan en primer lugar mediante una: 
- a. Función de activación 
- b. Regla Delta 
- c. Regla de propagación 
- d. Función de transferencia

> [!CHECK]- Respuesta
>> **Correcta: c** NO confundir con backpropagation no tiene NADA que ver. **La regla de propagacion** es el procesado de datos que sufren las entradas en cada neurona, es decir, **La sumatoria de las entradas por sus pesos + bias**, el proceso que lleva a cabo esa operacion para cada neurona individual se llama **Regla de propagacion.**
> >
> > NO b. -> La regla Delta es la usada para modificar los pesos de las conexiones entre capas, y eso ocurre luego en el backwards que a su vez tiene lugar luego de hacer un forward pass, o sea nada que ver
> 
> > NO a. -> En este procedimiento las entradas YA combinadas y tratadas se pasan por esta funcion y son enviadas a las neuronas de las siguientes capas.
> 
> > NO c. -> En este procedimiento las entradas YA combinadas y tratadas se pasan por esta funcion y son enviadas a las neuronas de las siguientes capas. (Transferencia y activacion son ambos terminos intercambiables y equivalentes en esta asignatura)

---
> [!PDF|yellow] [[FAA_Solución_Preguntas.pdf#page=30&selection=91,0,94,62&color=yellow|FAA_Solución_Preguntas, p.30]]
> > 163- Las neuronas de la capa de entrada de un perceptrón multicapa:

163- Las neuronas de la capa de entrada de un perceptrón multicapa: 
a. Aplican la funciona de transferencia a las entradas que reciben 
b. Emiten su salida como la suma de las entradas multiplicadas por los pesos 
c. Emiten su salida como el resultado de aplicar una función de transferencia a la suma de las entradas multiplicadas por los pesos 
d. Todas son falsas

> [!CHECK]- Respuesta
>> **Correcta: d -> pues es correcta porque el resto son incorrectas xd. La capa de entrada NO lleva a cabo ninguna operacion matematica, seria aquella que representa al array de una instancia que cada coordenada son sus features, esto simplemente se pasa a la siguiente capa para que los datos sean procesados, no se hace la regla de propagacion(Definida en preguntas anteriores) ni se aplica funciones de transferencia ni nada por el estilo
> >
> > NO b. No se aplica ninguna funcion matematica ni cambio en los datos de entrada
> 
> > NO a. No se aplica ninguna funcion matematica ni cambio en los datos de entrada
> 
> > NO c. No se aplica ninguna funcion matematica ni cambio en los datos de entrada

---

> [!PDF|yellow] [[FAA_Solución_Preguntas.pdf#page=8&selection=126,0,126,84&color=yellow|FAA_Solución_Preguntas, p.8]]
> > ¿Cómo se resuelven los problemas que no son linealmente separables en el perceptrón?

42- ¿Cómo se resuelven los problemas que no son linealmente separables en el perceptrón? 
a. Añadiendo más capas 
b. Conectando las salidas de algunos perceptrones como entradas de otros 
c. La A y la B son correctas
d. Ninguna es correcta

> [!CHECK]- Respuesta
>> **Correcta: c -> Añadiendo al menos una capa oculta(Y esto por supuesto implica añadir más capas) podemos permitirle al perceptrón resolver problemas que no son linealmente separables. Y un perceptron es una neurona, entonces conectar las salidas de algunos perceptrones como entradas de otros, ese statement implica que, al menos, tenemos una capa oculta, pues de no tenerla no seria posible conectar una salida de un perceptron con otro(Ya que los nodos de la capa de entrada NO se consideran perceptrones), asi que si tenemos al menos una capa oculta podemos resolver problemas NO linealmente separables.
> >
> > NO a. Es correcta pero la b también, por eso hay que elegir la c
> 
> > NO b. Es correcta pero la a también, por eso hay que elegir la c
> 
> > NO d. No es correcta porque al menos una se comprueba correcta

---

> [!PDF|yellow] [[FAA_Solución_Preguntas.pdf#page=8&selection=73,0,76,16&color=yellow|FAA_Solución_Preguntas, p.8]]
> > 40- ¿Qué es ADALINE?

a. Un modelo básico de Red Neuronal Artificial
b. Una técnica avanzada de entrenamiento de redes neuronales 
c. Un método para agregar capas a una red neuronal 
d. Un algoritmo para eliminar ruido en señales

> [!CHECK]- Respuesta
>> **Correcta: a. Pues es el ADAptive LINear Element es el modelo más básico de RNA. Aunque no fue el primero en salir(Ese fue el Perceptron Simple) es considerado el mas simple de todos.
> >
> > NO b. 
> 
> > NO c. 
> 
> > NO d. 

---
> [!PDF|yellow] [[FAA_Solución_Preguntas.pdf#page=2&selection=34,72,34,73&color=yellow|FAA_Solución_Preguntas, p.2]]
> > En una matriz de confusión, la tasa de verdaderos positivos se denomina:
> 
> 

7- En una matriz de confusión, la tasa de verdaderos positivos se denomina: 
a. Precisión 
b. Tasa de error 
c. Sensibilidad 
d. Especificidad

> [!CHECK]- Respuesta
>> **Correcta: a. Pues es el ADAptive LINear Element es el modelo más básico de RNA. Aunque no fue el primero en salir(Ese fue el Perceptron Simple) es considerado el mas simple de todos.
> >
> > NO b. 
> 
> > NO c. 
> 
> > NO d. 