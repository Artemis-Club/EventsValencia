import { Trafico } from 'src/enums/trafico'
import { Punto } from 'src/puntos/entities/punto.entity'

export class CreateTramoApiDto {
    gid: number
    estado: Trafico
    denominacion: string
    idtramo: number
    geo_shape: {
        geometry: {
            coordinates: []
        }
    }
}

