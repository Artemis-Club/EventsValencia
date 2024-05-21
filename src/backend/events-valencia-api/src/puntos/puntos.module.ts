import { Module } from '@nestjs/common';
import { PuntosService } from './puntos.service';
import { PuntosController } from './puntos.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Punto } from './entities/punto.entity';
import { ApisModule } from 'src/apis/apis.module';

@Module({
  imports: [TypeOrmModule.forFeature([Punto]), ApisModule],
  controllers: [PuntosController],
  providers: [PuntosService],
  exports: [PuntosService]
})
export class PuntosModule {}
