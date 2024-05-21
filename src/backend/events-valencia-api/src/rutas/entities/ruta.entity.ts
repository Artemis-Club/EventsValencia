import { Entity, JoinColumn, JoinTable, ManyToMany, ManyToOne, PrimaryColumn, PrimaryGeneratedColumn, Column, Unique } from 'typeorm';
import { Punto } from '../../puntos/entities/punto.entity';

@Unique('ruta_unique_contraint',['inicio','fin','perfil'])
@Entity()
export class Ruta {
    
    @PrimaryGeneratedColumn()
    id: number

    @ManyToOne(type => Punto, punto => punto.iniciosRutas, {nullable: false})
    @JoinColumn()
    inicio: Punto

    @ManyToOne(type => Punto, punto => punto.iniciosRutas, {nullable: false})
    @JoinColumn()
    fin: Punto

    @Column()
    perfil: string

    @ManyToMany(type => Punto, punto => punto.rutas, {nullable: false})
    @JoinTable()
    geometria: Punto[]

    @Column('double precision')
    distancia: number

    @Column('double precision')
    duracion: number
    
    
}
