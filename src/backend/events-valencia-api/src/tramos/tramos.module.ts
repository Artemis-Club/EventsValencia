import { Module } from '@nestjs/common';
import { TramosService } from './tramos.service';
import { TramosController } from './tramos.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Tramo } from './entities/tramo.entity';
import { ApisModule } from 'src/apis/apis.module';
import { Punto } from 'src/puntos/entities/punto.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Tramo, Punto]), ApisModule],
  controllers: [TramosController],
  providers: [TramosService],
})
export class TramosModule { }
