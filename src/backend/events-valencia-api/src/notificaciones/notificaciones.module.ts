import { Module } from '@nestjs/common';
import { NotificacionesService } from './notificaciones.service';
import { NotificacionesController } from './notificaciones.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Notificacion } from './entities/notificacion.entity';
import { Usuario } from 'src/usuarios/entities/usuario.entity';
import { ApisModule } from 'src/apis/apis.module';

@Module({
  imports: [TypeOrmModule.forFeature([Notificacion, Usuario]), ApisModule],
  controllers: [NotificacionesController],
  providers: [NotificacionesService],
})
export class NotificacionesModule {}
