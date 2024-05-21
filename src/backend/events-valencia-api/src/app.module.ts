import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { join } from 'path';
import { EventosModule } from './eventos/eventos.module';
import { PuntosModule } from './puntos/puntos.module';
import { SnakeNamingStrategy } from 'typeorm-naming-strategies';
import { CategoriasModule } from './categorias/categorias.module';
import { ApisModule } from './apis/apis.module';
import { ValoracionesModule } from './valoraciones/valoraciones.module';
import { NotificacionesModule } from './notificaciones/notificaciones.module';
import { UsuariosModule } from './usuarios/usuarios.module';
import { TramosModule } from './tramos/tramos.module';
import { RutasModule } from './rutas/rutas.module';

@Module({
  imports: [
    ConfigModule.forRoot(),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get('DB_HOST'),
        port: +configService.get('DB_PORT'),
        username: configService.get('DB_USERNAME'),
        password: configService.get('DB_PASSWORD'),
        database: configService.get('DB_NAME'),
        entities: [join(process.cwd(), 'dist/**/*.entity.js')],
        // Desactivar synchronize en producción.
        synchronize: true,
        //logging: true,
        namingStrategy: new SnakeNamingStrategy()
      })
    }),
    EventosModule,
    PuntosModule,
    CategoriasModule,
    ApisModule,
    ValoracionesModule,
    NotificacionesModule,
    UsuariosModule,
    TramosModule,
    RutasModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }
