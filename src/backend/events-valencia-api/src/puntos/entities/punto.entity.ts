import { Evento } from "src/eventos/entities/evento.entity";
import { Ruta } from "src/rutas/entities/ruta.entity";
import { Tramo } from "src/tramos/entities/tramo.entity";
import { Column, CreateDateColumn, Double, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryColumn, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";

@Entity()
export class Punto {

    @PrimaryColumn('double precision')
    latitud: number

    @PrimaryColumn('double precision')
    longitud: number

    @Column({nullable: true})
    direccion: string

    @OneToMany(type => Evento, evento => evento.posicion)
    eventos: Evento[]

    @ManyToOne(type => Tramo, tramo => tramo.geometria)
    @JoinColumn()
    tramo: Tramo

    @OneToMany(type => Ruta, ruta => ruta.inicio)
    iniciosRutas: Ruta[]

    @OneToMany(type => Ruta, ruta => ruta.fin)
    finalesRutas: Ruta[]

    @ManyToMany(type => Ruta, ruta => ruta.geometria)
    rutas: Ruta[]
}
