import { Notificacion } from "src/notificaciones/entities/notificacion.entity";
import { Valoracion } from "src/valoraciones/entities/valoracion.entity";
import { Column, CreateDateColumn, Entity, JoinColumn, JoinTable, ManyToMany, ManyToOne, OneToMany, PrimaryColumn, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
@Entity()
export class Usuario {

    @PrimaryGeneratedColumn()
    id: number

    @Column({nullable: false})
    nick: string

    @Column({nullable: false})
    nombre: string

    @Column({nullable: false})
    correo: string

    @Column({nullable: false})
    contrasenya: string

    @OneToMany(type => Valoracion, valoracion => valoracion.usuario)
    valorados: Valoracion[]

    @OneToMany(type => Notificacion, notificacion => notificacion.usuario)
    notificaciones: Notificacion[]

    @CreateDateColumn()
    fechaCreacion: Date

    @UpdateDateColumn()
    fechaActualizacion: Date
}
