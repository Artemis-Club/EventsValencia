import { PartialType } from '@nestjs/mapped-types';
import { CreatePuntoDto } from './create-punto.dto';

export class UpdatePuntoDto extends PartialType(CreatePuntoDto) {}
