import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { TramosService } from './tramos.service';
import { CreateTramoDto } from './dto/create-tramo.dto';
import { UpdateTramoDto } from './dto/update-tramo.dto';
import { Trafico } from 'src/enums/trafico';

@Controller('tramos')
export class TramosController {
  constructor(private readonly tramosService: TramosService) { }

  @Post()
  create(@Body() createTramoDto: CreateTramoDto) {
    return this.tramosService.create(createTramoDto);
  }
  @Get(':estado')
  findByEstado(@Param('estado') estado: Trafico) {
    return this.tramosService.findByEstado(+estado)
  }

  @Get()
  findAll() {
    return this.tramosService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.tramosService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateTramoDto: UpdateTramoDto) {
    return this.tramosService.update(+id, updateTramoDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.tramosService.remove(+id);
  }
}
