import { Test, TestingModule } from '@nestjs/testing';
import { PuntosService } from './puntos.service';

describe('PuntosService', () => {
  let service: PuntosService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PuntosService],
    }).compile();

    service = module.get<PuntosService>(PuntosService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
