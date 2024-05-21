import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { RutasService } from './rutas.service';
import { CreateRutaDto } from './dto/create-ruta.dto';
import { UpdateRutaDto } from './dto/update-ruta.dto';

@Controller('rutas')
export class RutasController {
  constructor(private readonly rutasService: RutasService) {}

  @Post()
  create(@Body() createRutaDto: CreateRutaDto) {
    return this.rutasService.create(createRutaDto);
  }

  @Get()
  findAll() {
    return this.rutasService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.rutasService.findOne(+id);
  }

  @Get(':perfil/@:latIni,:longIni/@:latDest,:longDest')
  obtenerRuta(
    @Param('perfil') perfil: string,
    @Param('latIni') latIni: string,
    @Param('longIni') longIni: string,
    @Param('latDest') latDest: string,
    @Param('longDest') longDest: string,
  ) {
    return this.rutasService.obtenerRuta(
      perfil,
      +latIni,
      +longIni,
      +latDest,
      +longDest,
    );
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateRutaDto: UpdateRutaDto) {
    return this.rutasService.update(+id, updateRutaDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.rutasService.remove(+id);
  }
}
