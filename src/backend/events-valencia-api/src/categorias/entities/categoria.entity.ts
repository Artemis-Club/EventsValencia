import { Evento } from "src/eventos/entities/evento.entity";
import { CreateDateColumn, Entity, OneToMany, PrimaryColumn } from "typeorm";


@Entity()
export class Categoria {

    @PrimaryColumn()
    nombre: string

    @CreateDateColumn()
    fechaCreacion: Date

    @OneToMany(type => Evento, evento => evento.categoria)
    eventos: Evento[]

}
