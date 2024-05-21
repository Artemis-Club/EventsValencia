import { Module } from '@nestjs/common';
import { ValoracionesService } from './valoraciones.service';
import { ValoracionesController } from './valoraciones.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Valoracion } from './entities/valoracion.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Valoracion])],
  controllers: [ValoracionesController],
  providers: [ValoracionesService],
})
export class ValoracionesModule { }
