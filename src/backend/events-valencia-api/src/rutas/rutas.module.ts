import { Module } from '@nestjs/common';
import { RutasService } from './rutas.service';
import { RutasController } from './rutas.controller';
import { ApisModule } from 'src/apis/apis.module';
import { PuntosModule } from 'src/puntos/puntos.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Punto } from 'src/puntos/entities/punto.entity';
import { Ruta } from './entities/ruta.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Punto, Ruta]) ,ApisModule],
  controllers: [RutasController],
  providers: [RutasService],
})
export class RutasModule {}
