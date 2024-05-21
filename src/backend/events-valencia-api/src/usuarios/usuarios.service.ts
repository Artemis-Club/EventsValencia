import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateUsuarioDto } from './dto/create-usuario.dto';
import { UpdateUsuarioDto } from './dto/update-usuario.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Usuario } from './entities/usuario.entity';
import { Repository } from 'typeorm';
import { Valoracion } from 'src/valoraciones/entities/valoracion.entity';
import { Notificacion } from 'src/notificaciones/entities/notificacion.entity';
import { ApisService } from '../apis/apis.service';

@Injectable()
export class UsuariosService {
  constructor(
    @InjectRepository(Usuario) private usuarioRepository: Repository<Usuario>,
  ) {}
  async create(createUsuarioDto: CreateUsuarioDto) {
    try{
      const {nick, nombre, correo, contrasenya} = createUsuarioDto
      if(!nick || !nombre || !correo || ! contrasenya)
        throw new HttpException('Todos los campos son obligatorios', HttpStatus.BAD_REQUEST)

      return await this.usuarioRepository.save(createUsuarioDto);
    }catch(error){
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException('Error interno del servidor', HttpStatus.INTERNAL_SERVER_ERROR)
    }
  }

  async findAll() {
    try {

      return await this.usuarioRepository.find({ relations: ['valorados', 'notificaciones'] });

    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
    }
  }

  async findOneById(id: number) {
    const usuario = await this.usuarioRepository.findOneBy({id: id});
    if (!usuario)
      throw new HttpException('No se ha encontrado el usuario', HttpStatus.NOT_FOUND);
    return usuario;
  }

  async findOneByName(nombre: string) {
    const usuario = await this.usuarioRepository.findOneBy({nombre: nombre});
    if (!usuario)
      throw new HttpException('No se ha encontrado el usuario', HttpStatus.NOT_FOUND);
    return usuario;
  }

  async findOneByNick(nick: string) {
    const usuario = await this.usuarioRepository.findOneBy({nick: nick});
    if (!usuario)
      throw new HttpException('No se ha encontrado el usuario', HttpStatus.NOT_FOUND);
    return usuario;
  }

  async update(id: number, updateUsuarioDto: UpdateUsuarioDto) {
    return await this.usuarioRepository.update(id, updateUsuarioDto);
  }

  async remove(id: number) {
    const usuario = await this.usuarioRepository.findOneBy({id: id});
    if(!usuario)
      throw new HttpException('No se ha encontrado el usuario', HttpStatus.NOT_FOUND);
    return await this.usuarioRepository.remove(usuario);
  }
}
