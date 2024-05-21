import { PartialType } from '@nestjs/mapped-types';
import { CreateEventoApiTuristicoDto } from './create-evento-api-turistico.dto';

export class UpdatePuntoDto extends PartialType(CreateEventoApiTuristicoDto) { }
