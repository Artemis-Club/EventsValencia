import { Categoria } from "src/categorias/entities/categoria.entity";
import { Punto } from "src/puntos/entities/punto.entity";
import { Valoracion } from "src/valoraciones/entities/valoracion.entity";
import { Column, CreateDateColumn, Entity, JoinColumn, JoinTable, ManyToMany, ManyToOne, OneToMany, PrimaryColumn, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";

@Entity()
export class Evento {

    @PrimaryColumn()
    id: number

    @Column()
    titulo: string

    @Column({nullable: true})
    descripcion: string

    @Column({nullable: true})
    url: string

    @Column({nullable: true})
    inicio: Date

    @Column({nullable: true})
    fin: Date

    @Column({nullable: true})
    imagen: string

    @ManyToOne(type => Punto, punto => punto.eventos, {nullable: false})
    @JoinColumn()
    posicion: Punto

    @ManyToOne(type => Categoria, categoria => categoria.eventos)
    @JoinColumn()
    categoria: Categoria

    @OneToMany(type => Valoracion, valoracion => valoracion.evento)
    valoraciones: Valoracion[]

    @CreateDateColumn()
    fechaCreacion: Date

    @UpdateDateColumn()
    fechaActualizacion: Date
}
