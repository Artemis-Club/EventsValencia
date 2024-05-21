import { Controller, Get, Post, Body, Patch, Param, Delete, HttpCode } from '@nestjs/common';
import { NotificacionesService } from './notificaciones.service';
import { CreateNotificacionDto } from './dto/create-notificacion.dto';
import { UpdateNotificacionDto } from './dto/update-notificacion.dto';
import { Usuario } from 'src/usuarios/entities/usuario.entity';

@Controller('notificaciones')
export class NotificacionesController {
  constructor(private readonly notificacionesService: NotificacionesService) {}

  @Post()
  @HttpCode(201)
  async create(@Body() notificacion: CreateNotificacionDto) {
    return this.notificacionesService.create(notificacion)
  }

  @Get()
  findAll() {
    return this.notificacionesService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.notificacionesService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateNotificacioneDto: UpdateNotificacionDto) {
    return this.notificacionesService.update(+id, updateNotificacioneDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.notificacionesService.remove(+id);
  }

}
