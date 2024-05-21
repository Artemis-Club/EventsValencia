import { Module } from '@nestjs/common';
import { EventosService } from './eventos.service';
import { EventosController } from './eventos.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Evento } from './entities/evento.entity';
import { Punto } from 'src/puntos/entities/punto.entity';
import { Categoria } from 'src/categorias/entities/categoria.entity';
import { ApisModule } from 'src/apis/apis.module';
import { PuntosModule } from 'src/puntos/puntos.module';


@Module({
  imports: [TypeOrmModule.forFeature([Evento, Punto, Categoria]),PuntosModule, ApisModule],
  controllers: [EventosController],
  providers: [EventosService],
})
export class EventosModule {}
