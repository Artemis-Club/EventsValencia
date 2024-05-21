import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateCategoriaDto } from './dto/create-categoria.dto';
import { UpdateCategoriaDto } from './dto/update-categoria.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Categoria } from './entities/categoria.entity';
import { Repository } from 'typeorm';

@Injectable()
export class CategoriasService {

  constructor(@InjectRepository(Categoria) private categoriaRepository: Repository<Categoria>) { }

  async create(createCategoriaDto: CreateCategoriaDto) {
    return await this.categoriaRepository.save(createCategoriaDto);
  }

  async findAll() {
    try {
      return await this.categoriaRepository.find();
    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
    }
  }

  async findOne(id: string) {
    const categoria = await this.categoriaRepository.findOneBy({ nombre: id });
    if (!categoria)
      throw new HttpException('No se ha encontrado la categoria', HttpStatus.NOT_FOUND);
    return categoria;
  }

  async update(id: string, updateCategoriaDto: UpdateCategoriaDto) {
    await this.categoriaRepository.update(id, updateCategoriaDto);
  }

  async remove(id: string) {
    const categoria = await this.categoriaRepository.findOneBy({ nombre: id });
    if (!categoria)
      throw new HttpException(
        'No se ha encontrado la categoria',
        HttpStatus.NOT_FOUND,
      );
    return await this.categoriaRepository.remove(categoria);
  }
}
