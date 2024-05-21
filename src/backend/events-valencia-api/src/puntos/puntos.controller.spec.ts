import { Test, TestingModule } from '@nestjs/testing';
import { PuntosController } from './puntos.controller';
import { PuntosService } from './puntos.service';

describe('PuntosController', () => {
  let controller: PuntosController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PuntosController],
      providers: [PuntosService],
    }).compile();

    controller = module.get<PuntosController>(PuntosController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
