import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateValoracionDto } from './dto/create-valoracion.dto';
import { UpdateValoracionDto } from './dto/update-valoracion.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Valoracion } from './entities/valoracion.entity';
import { Repository } from 'typeorm';

@Injectable()
export class ValoracionesService {
  constructor(@InjectRepository(Valoracion) private valoracionRepository: Repository<Valoracion>) {}
  async create(createValoracioneDto: CreateValoracionDto) {
    return await this.valoracionRepository.save(createValoracioneDto);
  }

  async findAll() {
    try {
      return await this.valoracionRepository.find();
    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
    }

  }

  async findOne(id: number) {
    const valoracion = await this.valoracionRepository.findOneBy({id: id});
    if(!valoracion)
      throw new HttpException('No se ha encontrado la valoración', HttpStatus.NOT_FOUND);
    return valoracion;
  }

  async update(id: number, updateValoracioneDto: UpdateValoracionDto) {
    return await this.valoracionRepository.update({id: id}, updateValoracioneDto);
  }

  async remove(id: number) {
    const valoracion = await this.valoracionRepository.findOneBy({id: id});
    if(!valoracion)
      throw new HttpException('no se ha encontrado la valoración', HttpStatus.NOT_FOUND);
    return await this.valoracionRepository.remove(valoracion);
  }
}
