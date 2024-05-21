import { Usuario } from "src/usuarios/entities/usuario.entity";
import { Column, CreateDateColumn, Entity, ManyToMany, PrimaryGeneratedColumn, UpdateDateColumn, Repository, ManyToOne, JoinColumn } from 'typeorm';

@Entity()
export class Notificacion {

    @PrimaryGeneratedColumn()
    id: number

    @Column({nullable: false})
    titulo: string

    @Column({nullable: false})
    descripcion: string

    @ManyToOne(type => Usuario, usuario => usuario.notificaciones)
    @JoinColumn()
    usuario: Usuario

    @CreateDateColumn()
    fechaCreacion: Date

    @UpdateDateColumn()
    fechaActualizacion: Date
}
