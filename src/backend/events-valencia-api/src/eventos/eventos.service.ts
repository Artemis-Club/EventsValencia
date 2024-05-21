import { HttpException, HttpStatus, Inject, Injectable } from '@nestjs/common';
import { CreateEventoDto } from './dto/create-evento.dto';
import { UpdateEventoDto } from './dto/update-evento.dto';
import { InjectRepository, TypeOrmModule } from '@nestjs/typeorm';
import { Evento } from './entities/evento.entity';
import { Repository } from 'typeorm';
import { Punto } from 'src/puntos/entities/punto.entity';
import { Categoria } from 'src/categorias/entities/categoria.entity';
import { ApisService } from 'src/apis/apis.service';
import { AxiosResponse } from 'axios';
import { CreateEventoApiTuristicoDto } from 'src/apis/dto/create-evento-api-turistico.dto';
import { CreatePuntoDto } from 'src/puntos/dto/create-punto.dto';
import { HttpService } from '@nestjs/axios';
import { CreateEventoXmlParserDto } from 'src/apis/dto/create-evento-xmlparser';
import { Response } from 'express';
import { PuntosService } from 'src/puntos/puntos.service';
import { CreatePuntoSearchDto } from 'src/puntos/dto/create-punto-search.dto';
import { CreateCategoriaDto } from 'src/categorias/dto/create-categoria.dto';

@Injectable()
export class EventosService {
  constructor(
    @InjectRepository(Evento) private eventoRepository: Repository<Evento>,
    @InjectRepository(Punto) private puntoRepository: Repository<Punto>,
    @InjectRepository(Categoria) private categoriaRepository: Repository<Categoria>,
    private puntosService: PuntosService,
    @Inject(ApisService) private apisService: ApisService,
  ) { }

  async create(createEventoDto: CreateEventoDto) {
    try {
      const { posicion, categoria } = createEventoDto
      if (!posicion) throw new HttpException('Falta posicion', HttpStatus.BAD_REQUEST)
      await this.puntoRepository.save(posicion)
      if (categoria) await this.categoriaRepository.save(categoria)
      return await this.eventoRepository.save(createEventoDto);
    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException('Error interno del servidor', HttpStatus.INTERNAL_SERVER_ERROR)
    }
  }

  async findAll() {
    try {

        this.apisService
          .obtenerMonumentosTuristicosApi()
          .toPromise()
          .then(this.persistirEventosApiTuristico)
          .catch((err) => console.error)
        
        this.apisService
        .extraerDatosXML()
        .then(this.persistirEventosXml)
        .catch((err) => console.error);
        
      return await this.eventoRepository.find({ relations: ['posicion', 'categoria'] });

    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
    }
  }

  async findByRadius(latitud: number, longitud: number, radio: number) {
    try {
      if (!latitud || !longitud || !radio)
        throw new HttpException('Faltan parametros', HttpStatus.BAD_REQUEST);

       this.apisService
        .obtenerMonumentosTuristicosApi()
        .toPromise()
        .then(this.persistirEventosApiTuristico)
        .catch((err) => console.error);

        this.apisService
        .extraerDatosXML()
        .then(this.persistirEventosXml)
        .catch((err) => console.error);

      const eventosCercanos = await this.eventoRepository
        .createQueryBuilder('evento')
        .leftJoinAndMapOne(
          'evento.posicion', // Nombre de la propiedad en la entidad Evento
          Punto, // Entidad Punto
          'p', // Alias de la tabla punto
          'evento.posicion_latitud = p.latitud AND evento.posicion_longitud = p.longitud',
        )
        .leftJoinAndMapOne(
          'evento.categoria',
          Categoria,
          'cat',
          'evento.categoria_nombre = cat.nombre'
        )
        .where(
          `6371 * acos(cos(radians(:latitud)) * cos(radians(p.latitud)) * cos(radians(p.longitud) - radians(:longitud)) + sin(radians(:latitud)) * sin(radians(p.latitud))) <= :radio`,
          { latitud, longitud, radio },
        )
        .getMany();
      const eventosConDistancia = eventosCercanos.map((e) => {
        const distancia = calcularDistancia(
          e.posicion.latitud,
          e.posicion.longitud,
          latitud,
          longitud,
        );
        return { ...e, distancia };
      })
        .sort((a, b) => a.distancia - b.distancia);

      return eventosConDistancia;

    } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
    }
  }

  async findOne(id: number) {
    const evento = await this.eventoRepository.findOneBy({ id: id });
    if (!evento)
      throw new HttpException('No se ha encontrado el evento', HttpStatus.NOT_FOUND);
    return evento;
  }

  async lastId() {
    return {id: await this.eventoRepository.maximum("id")};
  }

  async update(id: number, updateEventoDto: UpdateEventoDto) {
    return await this.eventoRepository.update(id, updateEventoDto);
  }

  async remove(id: number) {
    const evento = await this.eventoRepository.findOneBy({ id: id });
    if (!evento)
      throw new HttpException(
        'No se ha encontrado el evento',
        HttpStatus.NOT_FOUND,
      );
    return await this.eventoRepository.remove(evento);
  }

  private persistirEventosApiTuristico = async (response: AxiosResponse) => {
    const eventosApi: CreateEventoApiTuristicoDto[] = response.data.results;
    try{
      for (const e of eventosApi) {
        await new Promise((resolve) => setTimeout(resolve, 1500)); 
        try {
          let eventoturisticoexist = null;
          try{
            eventoturisticoexist = await this.findOne(e.gid);
            //console.log(evento)
          }catch(error){
            //console.error(error)
          }
          if (eventoturisticoexist!= null) return;
              
          const punto:Punto = await this.puntosService.findByReverse(e.geo_point_2d.lat, e.geo_point_2d.lon);
          const categoriaAPersistir:CreateCategoriaDto = {
            nombre: "Monumento historico",
          }
          const categoria:Categoria = await this.categoriaRepository.create(categoriaAPersistir);
  
          const evento: CreateEventoDto = {
            id: e.gid,
            titulo: e.nombre,
            descripcion: null,
            posicion: punto,
            imagen: null,
            categoria: categoria,
            url: null
          }
    
          try {
            await this.create(evento);
          } catch (error) {
            console.error("Error creando evento:", e.gid, error);
          }
        } catch (error) {
          console.error("Problema en el persistir eventos api:", error);
        }
      }
    }catch(error){
      console.error(error)
    }
  }

  private persistirEventosXml = (response: any) =>  {
    try{
      response.forEach(async element => {
        const eventosApi: CreateEventoXmlParserDto[] = element;
        return await Promise.all(
          eventosApi.map(async (e) => {

            const regex_id = /\d+/;
            const coinciencia = regex_id.exec(e.guid);
            const guid = parseInt("9"+coinciencia[0],10);
            var eventoxmlexist = null;
            try{
              eventoxmlexist = await this.findOne(guid);
              //console.log(evento)
            }catch(error){
              //console.error(error)
            }
            if (eventoxmlexist!= null) return;

            const regex_descripcion = /<[^>]+>/g;
            const textosinHTML = e.description.replace(regex_descripcion, "");
            //const descripcion = textosinHTML;
            var descripcion = textosinHTML
            .replace(/\s+/g, ' ')  // Reemplaza cualquier secuencia de espacios en blanco por un único espacio
            .replace(/^\s+|\s+$/g, '')  // Elimina espacios al inicio y al final
            .replace(/\n+/g, ' ')  // Reemplaza múltiples saltos de línea por un único espacio
            .replace(/\&nbsp/g,' ')
            .trim();  // Remueve espacios adicionales al principio y al final (por seguridad)

            //Hay que guardar los dates antes del VTC O External links, porque el start y end dates estan en el bloque VTC
            const fechas: Date[] = fechasEventoXml(descripcion); 

            const index_ext:number = descripcion.indexOf("External links");
            if(index_ext >0)
              descripcion = descripcion.substring(0,index_ext);

            const index_vtc:number = descripcion.indexOf("VTC");
            if(index_vtc >0 )
              descripcion = descripcion.substring(0,index_vtc);

            const randompoint : number[] = generateRandomPoint(39.474780461536376, -0.3766163827860723,3270);      
            const punto: CreatePuntoDto = {
              latitud: randompoint[0],
              longitud: randompoint[1],
              direccion: lugarEventoXml(e.description)
            };
            const posicion: Punto = await this.puntosService.create(punto)

            const category:Categoria = this.categoriaRepository.create(await generateRandomCategory(this.categoriaRepository));
            this.categoriaRepository.save(category).catch(() => console.error);

            const eventoAPersistir: CreateEventoDto = {id: guid, titulo: e.title, posicion: posicion, descripcion: descripcion, imagen: null, categoria: category, url: e.link, inicio: fechas[0], fin:fechas[1]};
            this.create(eventoAPersistir).catch(() => console.error);
          })
        ).catch(() => console.error)
    });
    }catch(error){console.error(error)}
  }



  async eventsFromXML(latitud: number, longitud: number){
    try {
      this.apisService
      .extraerDatosXML()
      .then(this.persistirEventosXml);
      const eventosCercanos = await this.eventoRepository.find();
      const eventosConDistancia = eventosCercanos.map((e) => {
        const distancia = calcularDistancia(
          e.posicion.latitud,
          e.posicion.longitud,
          latitud,
          longitud,
        );
        return { ...e, distancia };
      })
        .sort((a, b) => a.distancia - b.distancia);

      return eventosConDistancia;

     } catch (error) {
      if (error instanceof HttpException)
        throw error
      else
        throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR)
     } 
  }
}


function fechasEventoXml(texto:string): [Date,Date]{
  const regexStart = /Event start date (\w+), (\d{1,2})\/(\d{1,2})\/(\d{4}) - (\d{1,2}):(\d{2})/;
  const regexEnd = /Event end date (\w+), (\d{1,2})\/(\d{1,2})\/(\d{4}) - (\d{1,2}):(\d{2})/;;
  const eventStartMatch = texto.match(regexStart)
  const eventEndMatch = texto.match(regexEnd)
  var f_inicio: Date = new Date();
  var f_fin: Date = new Date();

  if (eventStartMatch && eventStartMatch.length === 7) {
    const [, dayOfWeek, day, month, year, hour, minute] = eventStartMatch;
    const monthNumber = parseInt(month, 10) - 1; // Meses en JavaScript van de 0 a 11
    f_inicio = new Date(parseInt(year), monthNumber, parseInt(day, 10), parseInt(hour, 10), parseInt(minute, 10));            
  }

  if (eventEndMatch && eventEndMatch.length === 7) {
    const [, dayOfWeek, day, month, year, hour, minute] = eventEndMatch;
    const monthNumber = parseInt(month, 10) - 1; // Meses en JavaScript van de 0 a 11
    f_fin = new Date(parseInt(year), monthNumber, parseInt(day, 10), parseInt(hour, 10), parseInt(minute, 10));           
  }
  return [f_inicio,f_fin]
}

function lugarEventoXml(htmlstring:string): string{
  const regex = /<div class="field__label">Event address<\/div>\n.*?<div class="field__item">([^<]*?)<\/div>\n/;
  const match = regex.exec(htmlstring);
  return match?.[1] || "No hay lugar definido"
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function calcularDistancia(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number,
): number {
  const R = 6371;
  const dLat = aRadianes(lat2 - lat1);
  const dLon = aRadianes(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(aRadianes(lat1)) *
    Math.cos(aRadianes(lat2)) *
    Math.sin(dLon / 2) *
    Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const distance = R * c;
  return distance; //kilometros
}

function aRadianes(degrees: number): number {
  return degrees * (Math.PI / 180);
}

function getRandomNumber(min: number, max: number): number {
  return Math.random() * (max - min) + min;
}

function generateRandomPoint(latitude: number, longitude: number, radius: number): number[] {

  const radiusInDegrees = radius / (111111 * Math.cos(latitude * Math.PI / 180));

    const angle = getRandomNumber(0, 2 * Math.PI);

    const randomLatitude = latitude + radiusInDegrees * Math.sin(angle);
    const randomLongitude = longitude + radiusInDegrees * Math.cos(angle);

    return [randomLatitude, randomLongitude];
}

async function generateRandomCategory(repository:Repository<Categoria>):Promise<CreateCategoriaDto>{
  const categorias:Categoria[] = await repository.find();
  if(categorias.length == 0) return null;
  const index:number = Math.floor(getRandomNumber(0,categorias.length-1))

  const punto:CreateCategoriaDto = {
    nombre: categorias[index].nombre
  }

  return punto;
}