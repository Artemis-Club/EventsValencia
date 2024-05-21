import { HttpException, HttpStatus, Inject, Injectable } from '@nestjs/common';
import { CreateRutaDto } from './dto/create-ruta.dto';
import { UpdateRutaDto } from './dto/update-ruta.dto';
import { ApisService } from 'src/apis/apis.service';
import { Punto } from 'src/puntos/entities/punto.entity';
import { CreatePuntoDto } from 'src/puntos/dto/create-punto.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AxiosResponse } from 'axios';
import { CreateRutaApiDto } from 'src/apis/dto/create-ruta-api.dto';
import { Ruta } from './entities/ruta.entity';

@Injectable()
export class RutasService {

  constructor(
    @InjectRepository(Punto) private puntoRepository: Repository<Punto>,
    @InjectRepository(Ruta) private rutaRepository: Repository<Ruta>,
    @Inject(ApisService) private apisService: ApisService) {}
  create(createRutaDto: CreateRutaDto) {
    return 'This action adds a new ruta';
  }

  async findAll() {
    return await this.rutaRepository.find();
  }

  findOne(id: number) {
    return `This action returns a #${id} ruta`;
  }

  async obtenerRuta(perfil: string, latIni: number, longIni: number, latDest: number, longDest: number) {
    try {

      const inicio: Punto = this.puntoRepository.create({latitud: latIni, longitud: longIni})
      const fin: Punto = this.puntoRepository.create({latitud: latDest, longitud: longDest})

      const ruta: Ruta = await this.rutaRepository.findOne({where: {inicio: inicio, fin: fin, perfil: perfil}, relations: ['inicio','fin','geometria']})

      if (ruta) return ruta;

      const respuesta: AxiosResponse = await this.apisService
              .obtenerRutaApi(perfil,inicio, fin)
              .toPromise()

      const rutaApi: CreateRutaApiDto = respuesta.data
      const puntos: CreatePuntoDto[] = rutaApi.features[0].geometry.coordinates.map((p) => {return {latitud: p[1], longitud: p[0]}})
      const geometria: Punto[] = await this.puntoRepository.save(puntos)

      return await this.rutaRepository.save({
        inicio: await this.puntoRepository.save(inicio),
        fin: await this.puntoRepository.save(fin),
        perfil: perfil,
        geometria: geometria,
        distancia: rutaApi.features[0].properties.summary.distance,
        duracion: rutaApi.features[0].properties.summary.duration
      })
      

    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
    }
  }

  update(id: number, updateRutaDto: UpdateRutaDto) {
    return `This action updates a #${id} ruta`;
  }

  remove(id: number) {
    return `This action removes a #${id} ruta`;
  }
}
