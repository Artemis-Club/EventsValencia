import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateTramoDto } from './dto/create-tramo.dto';
import { UpdateTramoDto } from './dto/update-tramo.dto';
import { Repository } from 'typeorm';
import { Tramo } from './entities/tramo.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { ApisService } from 'src/apis/apis.service';
import { AxiosResponse } from 'axios';
import { CreateEventoApiTuristicoDto } from 'src/apis/dto/create-evento-api-turistico.dto';
import { CreateEventoDto } from 'src/eventos/dto/create-evento.dto';
import { CreatePuntoDto } from 'src/puntos/dto/create-punto.dto';
import { Punto } from 'src/puntos/entities/punto.entity';
import { Trafico } from 'src/enums/trafico';
import { CreateTramoApiDto } from 'src/apis/dto/create-tramo-api.dto';
import { stringify } from 'querystring';

@Injectable()
export class TramosService {

  constructor(
    @InjectRepository(Tramo) private tramoRepository: Repository<Tramo>,
    @InjectRepository(Punto) private puntoRepository: Repository<Punto>,
    private apisService: ApisService
  ) { }

  async create(createTramoDto: CreateTramoDto) {

    return `This action creates a tramo`;

  }

  async findAll() {
    try {
      this.apisService
        .obtenerEstadoTraficoApi()
        .toPromise()
        .then(this.persistirTramosApi)
        .catch((err) => console.error)

      return await this.tramoRepository.find({ relations: ['geometria'] });

    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
    }
  }

  async findByEstado(estado: Trafico) {
    try {
      this.apisService
        .obtenerEstadoTraficoApi()
        .toPromise()
        .then(this.persistirTramosApi);

      const tramos = await this.tramoRepository.find({
        where: { estado: estado },
        relations: ['geometria']
      })
      if (tramos.length === 0)
        throw new HttpException('No hay datos', HttpStatus.NOT_FOUND);

      return tramos;

    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
    }
  }

  findOne(id: number) {
    return `This action returns a #${id} tramo`;
  }

  update(id: number, updateTramoDto: UpdateTramoDto) {
    return `This action updates a #${id} tramo`;
  }

  remove(id: number) {
    return `This action removes a #${id} tramo`;
  }


  private persistirTramosApi = (response: AxiosResponse) => {
    try {
      const tramosApi: CreateTramoApiDto[] = response.data.results;
      const tramosAPersistir: CreateTramoDto[] = tramosApi.map((t) => {
        const puntos: CreatePuntoDto[] = t.geo_shape.geometry.coordinates.map((p) => {
          return {
            latitud: p[1],
            longitud: p[0]
          };
        })
        const geometria: Punto[] = this.puntoRepository.create(puntos)
        this.puntoRepository.save(geometria)
        return { id: t.gid, nombre: t.denominacion, estado: t.estado, geometria: geometria }
      });
      this.tramoRepository.save(tramosAPersistir)
    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
    }

  }
}
