import { Usuario } from '../../usuarios/entities/usuario.entity';
export class CreateNotificacionDto {
    id? : number
    titulo: string
    descripcion: string
    usuario: Usuario
}
