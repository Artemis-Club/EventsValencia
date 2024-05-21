import { Categoria } from "src/categorias/entities/categoria.entity"
import { Punto } from "src/puntos/entities/punto.entity"

export class CreateEventoDto {
    id?: number
    titulo: string
    descripcion?: string
    posicion: Punto
    imagen?: string
    categoria: Categoria
    url?: string
    inicio?: Date
    fin?: Date
}
