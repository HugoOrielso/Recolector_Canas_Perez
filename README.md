# Recolector de monedas: Cañas y Perez

Taller de Diseño Multimedia y Videojuegos. Proyecto construido y comprobado con **Godot 4.5 stable**, renderizador Compatibility.

## Integrantes

- Hugo Cañas
- Elkin Perez

**Repositorio público:** pendiente de agregar por los integrantes.
**Número de pareja:** pendiente de confirmar; reemplazar por el número asignado al publicar la entrega.

## Abrir y jugar

1. Abrir Godot 4.5 y elegir **Import** en el Project Manager.
2. Seleccionar `project.godot` de esta carpeta y abrir el proyecto.
3. Pulsar **F5**. En el menú, elegir **Jugar**.
4. Usar las flechas izquierda/derecha para caminar y Espacio o Enter para saltar.
5. Recoger las seis monedas. Los pinchos o una caída al hueco descuentan una de las tres vidas y devuelven al jugador al inicio. Las monedas ya recogidas se conservan durante esa partida.
6. La victoria muestra «¡Ganaste!» y vuelve al menú a los dos segundos. La tercera vida perdida vuelve al menú. **Salir** cierra el juego.

Para probar el reto, abrir `nivel_reto.tscn` y pulsar **F6**. El jugador empuja la caja con un impulso de 20.

## Escenas por nivel

| Etapa del taller | Archivos principales |
| --- | --- |
| 1: recursos y proyecto | `project.godot`, `assets/`, `icon.svg` |
| 2: TileMapLayer y colisiones | `nivel.tscn`, `suelo_tileset.tres` |
| 3: personaje y cámara | `jugador.tscn`, `jugador.gd` |
| 4: monedas y peligros | `moneda.tscn`, `moneda.gd`, `pinchos.tscn`, `pinchos.gd` |
| 5: HUD y reglas | `nivel.tscn`, `nivel.gd` |
| 6: menú principal | `menu.tscn`, `menu.gd` |
| Reto opcional | `nivel_reto.tscn` y empuje en `jugador.gd` |

La carpeta `evidencias/etapas/` contiene escenas de comprobación reproducibles para las etapas 1 a 5. Se abren en el editor y se ejecutan con F6. Las etapas 3 y 4 aún no tienen vidas ni reinicio: eso se añade en la etapa 5. La etapa 1 es una escena vacía para comprobar la carga del proyecto. La escena principal siempre es `menu.tscn`.

`evidencias/` contiene capturas reales del editor y de las escenas ejecutadas en Godot 4.5. La captura de victoria se obtuvo colocando al jugador en las monedas mediante un script de comprobación; las colisiones y señales son las del juego.

## Validación

Se comprobaron el mapa de 90 baldosas, el hueco de 54 px, las colisiones del TileSet, la caída al suelo, la velocidad horizontal, los saltos reales a P1 y P2, la animación y orientación, las seis monedas, el HUD fijo, los daños, el reinicio, las transiciones al menú y el empuje de la caja. El registro está en `evidencias/verificacion_godot_4_5.log`.

Las comprobaciones se pueden repetir con el ejecutable de Godot desde una terminal:

```text
godot --headless --path . --script res://evidencias/comprobaciones/verificar.gd
godot --headless --path . --script res://evidencias/comprobaciones/comparar_impulsos.gd
```

El segundo script compara impulsos aislados de 5, 20 y 100, con masa 1 y sin gravedad ni amortiguamiento, para observar la relación entre impulso y velocidad.

Las escenas de moneda y pinchos se instancian; no se duplican sus scripts. Se añadió una protección de 0,6 s después del daño, un guardado de moneda ya recogida y bloqueo del movimiento al ganar. Los cambios de escena originados por peligros o caídas se aplazan fuera del paso de física.

## Publicar el repositorio después

1. Crear en GitHub o GitLab un repositorio **público**. El nombre de la guía es `Recolector_ParejaN`; sustituir N por el número asignado.
2. Subir **el contenido** de esta carpeta, con `project.godot` en la raíz. Incluir los `.uid` y `.import`, las imágenes y su licencia.
3. Excluir `.godot/`, como ya indica `.gitignore`. No subir los ejecutables de Godot ni la carpeta temporal del espacio de trabajo.
4. Reemplazar el enlace pendiente en este README y en la portada del informe. Renombrar el PDF como `Taller_Recolector_ParejaN_Canas_Perez.pdf`.
5. Comprobar el enlace en una ventana privada y abrir una descarga limpia con Godot 4.5 antes de entregar.

## Créditos y referencias

Gráficos: [Pixel Platformer de Kenney](https://kenney.nl/assets/pixel-platformer), licencia CC0. Se conserva el `License.txt` original en `assets/`.

Documentación de [Godot 4.5](https://docs.godotengine.org/en/4.5/) y [Singletons (Autoload)](https://docs.godotengine.org/en/4.5/tutorials/scripting/singletons_autoload.html).
