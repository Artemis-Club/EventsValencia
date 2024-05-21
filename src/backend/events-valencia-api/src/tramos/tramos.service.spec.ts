import { Test, TestingModule } from '@nestjs/testing';
import { TramosService } from './tramos.service';

describe('TramosService', () => {
  let service: TramosService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [TramosService],
    }).compile();

    service = module.get<TramosService>(TramosService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
