import { Trafico } from 'src/enums/trafico';
import { Punto } from 'src/puntos/entities/punto.entity';
import { Column, CreateDateColumn, Entity, OneToMany, PrimaryColumn, UpdateDateColumn } from 'typeorm';

@Entity()
export class Tramo {
    @PrimaryColumn()
    id: number

    @Column()
    nombre: string

    @Column()
    estado: Trafico

    @OneToMany(type => Punto, punto => punto.tramo)
    geometria: Punto[]

    @CreateDateColumn()
    fechaCreacion: Date

    @UpdateDateColumn()
    fechaActualizacion: Date
}
