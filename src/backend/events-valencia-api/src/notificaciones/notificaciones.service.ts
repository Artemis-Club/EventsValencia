import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateNotificacionDto } from './dto/create-notificacion.dto';
import { UpdateNotificacionDto } from './dto/update-notificacion.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Notificacion } from './entities/notificacion.entity';
import { Repository } from 'typeorm';
import { Usuario } from 'src/usuarios/entities/usuario.entity';
import { CreateUsuarioDto } from 'src/usuarios/dto/create-usuario.dto';

@Injectable()
export class NotificacionesService {
  constructor(
    @InjectRepository(Notificacion) private notificacionRepository: Repository<Notificacion>,
    @InjectRepository(Usuario) private usuarioRepository: Repository<Usuario>
  ) {}
  
  async create(notificacion: CreateNotificacionDto) {
    try {
      const notif = await this.notificacionRepository.findOneBy({titulo: notificacion.titulo})
      if (notif) {
        delete notificacion.id
        delete notificacion.usuario // temporal
        return await this.notificacionRepository.save({...notif, ...notificacion });
      }
      return await this.notificacionRepository.save(notificacion)
    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
    }
  }

  async findAll() {
    try {

      return await this.notificacionRepository.find({ relations: ['usuario'] ,order: {fechaCreacion: 'DESC'}});

    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
    }
  }

  async findOne(id: number) {
    const notificacion = await this.notificacionRepository.findOneBy({id: id});
    if (!notificacion)
      throw new HttpException('No se ha encontrado la notificacion', HttpStatus.NOT_FOUND);
    return notificacion;
  }

  async update(id: number, updateNotificacioneDto: UpdateNotificacionDto) {
    return await this.notificacionRepository.update(id, updateNotificacioneDto);
  }

  async remove(id: number) {
    const notificacion = await this.notificacionRepository.findOneBy({id: id});
    if(!notificacion)
      throw new HttpException('No se ha encontrado la notificacion', HttpStatus.NOT_FOUND);
    return await this.notificacionRepository.remove(notificacion);
  }
}
