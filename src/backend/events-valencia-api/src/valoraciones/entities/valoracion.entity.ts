import { Evento } from 'src/eventos/entities/evento.entity';
import { Usuario } from 'src/usuarios/entities/usuario.entity';
import { Column, Entity, PrimaryColumn, Double, PrimaryGeneratedColumn, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity()
export class Valoracion {
    @PrimaryGeneratedColumn()
    id: number

    @Column({type: 'double precision',nullable: false})
    estrellas: number

    @Column()
    comentario: string

    @ManyToOne(type => Evento, evento => evento.valoraciones, {nullable:false})
    @JoinColumn()
    evento: Evento

    @ManyToOne(type => Usuario, usuario => usuario.valorados, {nullable: false})
    @JoinColumn()
    usuario: Usuario

    @CreateDateColumn()
    fechaCreacion: Date

    @UpdateDateColumn()
    fechaActualizacion: Date
}

    


