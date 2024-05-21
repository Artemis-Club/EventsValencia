import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { PuntosService } from './puntos.service';
import { CreatePuntoDto } from './dto/create-punto.dto';
import { UpdatePuntoDto } from './dto/update-punto.dto';

@Controller('puntos')
export class PuntosController {
  constructor(private readonly puntosService: PuntosService) { }

  @Post()
  create(@Body() createPuntoDto: CreatePuntoDto) {
    return this.puntosService.create(createPuntoDto);
  }

  @Get()
  findAll() {
    return this.puntosService.findAll();
  }

  @Get('/search/:calle')
  findByRoad(@Param('calle') calle: string){
    return this.puntosService.findByRoad(calle);
  }

  @Get('/reverse/:latitud,:longitud')
  findByCoordinates(@Param('latitud') lat: number, @Param('longitud') lon: number){
    return this.puntosService.findByReverse(+lat,+lon);
  }

  @Get('/:latitud/:longitud')
  findOne(@Param('latitud') lat: number, @Param('longitud') lon: number) {
    return this.puntosService.findOne(+lat, +lon);
  }

  

  @Patch('/:latitud/:longitud')
  update(@Param('latitud') lat: number, @Param('longitud') lon: number, @Body() updatePuntoDto: UpdatePuntoDto) {
    return this.puntosService.update(+lat, +lon, updatePuntoDto);
  }

  @Delete('/:latitud/:longitud')
  remove(@Param('latitud') lat: number, @Param('longitud') lon: number) {
    return this.puntosService.remove(+lat, +lon);
  }
}
