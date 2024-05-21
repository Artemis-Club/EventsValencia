import { Trafico } from 'src/enums/trafico';
import { Punto } from 'src/puntos/entities/punto.entity';

export class CreateTramoDto {
    id?: number
    nombre: string
    estado: Trafico
    geometria: Punto[]
}
