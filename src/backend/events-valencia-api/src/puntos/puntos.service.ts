import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreatePuntoDto } from './dto/create-punto.dto';
import { UpdatePuntoDto } from './dto/update-punto.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Punto } from './entities/punto.entity';
import { ApisService } from 'src/apis/apis.service';
import { AxiosResponse } from 'axios';
import { CreatePuntoReverseDto } from './dto/create-punto-reverse.dto';
import { CreatePuntoSearchDto } from './dto/create-punto-search.dto';

@Injectable()
export class PuntosService {
    constructor(
    @InjectRepository(Punto) private puntoRepository: Repository<Punto>,
    private apisService: ApisService,
  ) { }
  async create(createPuntoDto: CreatePuntoDto) {
    const punto_norm:CreatePuntoDto = {
      latitud: roundToSevenDecimals(createPuntoDto.latitud),
      longitud: roundToSevenDecimals(createPuntoDto.longitud),
      direccion: createPuntoDto.direccion,
    }
    return await this.puntoRepository.save(punto_norm);
  }

  async findAll() {
    try {
      return await this.puntoRepository.find();
    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
    }
  }

  async findOne(latitud: number, longitud: number) {
    const latnorm: number = roundToSevenDecimals(latitud);
    const lonnorm: number = roundToSevenDecimals(longitud);

    const punto = await this.puntoRepository.findOneBy({ latitud: latnorm, longitud: lonnorm });
    if (!punto) {
      throw new HttpException('No se ha encontrado el punto', HttpStatus.NOT_FOUND);
    }
    return punto;
  }

  async findByReverse(lat: number, lon:number){
    let puntoexists:Punto = null;
    try{
      puntoexists = await this.findOne(lat,lon);
      return puntoexists
    }catch(error){
    }

    if(puntoexists != null){
      return puntoexists
    }else{
      return await this.apisService.obtenerCalle(lat,lon)
      .toPromise().then(this.persistirPuntoReverse)
    }
  }


  //No usado de momento
  async findByRoad(street: string){
    /*const result:Punto = await this.puntoRepository.findOneBy({direccion:street})
    if(result.direccion != null) 
      return await this.puntoRepository.findOneBy({direccion:street})*/
    try{
      if(street == "No hay lugar definido") return;
      const puntoApi = await this.apisService.obtenerCoordenadas(street).toPromise();
      const persistedPuntos = await this.persistirPuntoSearch(puntoApi);
      return persistedPuntos;
    }catch(error){
      console.error(error);
    }
  }
  //No usado de momento
  private persistirPuntoSearch = (response: AxiosResponse) =>{
    const puntoApi: CreatePuntoSearchDto[] = response.data;
    return puntoApi.map(async (e) => {
      try{
        if(e.address.country != "España" || e.address.province == null || !e.address.province.includes("Valencia"))  {
          console.log("No pertenece a españa");return;//throw new Error("Country is not Spain or Province different from Valencia");
        }
        const puntoAPersistir: CreatePuntoDto = {
          latitud: e.lat,
          longitud: e.lon,
          direccion: e.address.road
        }
        const puntoDevolver:Punto = await this.create(puntoAPersistir)
        console.log("Pertenece y persiste:",puntoAPersistir)
        return puntoAPersistir
      }catch(error){
        console.error('Error persisting persistirPuntoReverse:', error);
      }
    })[0] //Devuelvo la primera coincidencia
  }

  private persistirPuntoReverse = async (response: AxiosResponse) =>{
    const puntoApi: CreatePuntoReverseDto = response.data;
    try{
      //if(puntoApi.address.country != "España" || puntoApi.address.province == null || !puntoApi.address.province.includes("Valencia"))  {
      //  throw new Error("Country is not Spain or Province different from Valencia");
      //}

      const puntoAPersistir: CreatePuntoDto = {
        latitud: puntoApi.lat,
        longitud: puntoApi.lon,
        direccion: puntoApi.address.road
      }
      const punto:Punto = await this.create(puntoAPersistir)
      return punto
    }catch(error){
      console.error('Error persisting persistirPuntoReverse:', error);
      return undefined;
    }

  }



  async update(latitud: number, longitud: number, updatePuntoDto: UpdatePuntoDto) {
    // return await this.puntoRepository.update({ latitud: latitud, longitud: longitud }, updatePuntoDto)
  }


  async remove(latitud: number, longitud: number) {

    //Cuando lo pruebo retorna code 500
    /* const punto = await this.puntoRepository.findOneBy({ latitud: latitud, longitud: longitud });
    if (!punto)
      throw new HttpException(
        'No se ha encontrado el punto',
        HttpStatus.NOT_FOUND,
      );
    return await this.puntoRepository.remove(punto); */
  }

  
}

async function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function roundToSevenDecimals(num: number): number {
  const factor = 10 ** 7;
  const roundedNum = Math.round(num * factor) / factor;
  return parseFloat(roundedNum.toFixed(7));
}