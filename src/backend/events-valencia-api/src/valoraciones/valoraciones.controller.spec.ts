import { Test, TestingModule } from '@nestjs/testing';
import { ValoracionesController } from './valoraciones.controller';
import { ValoracionesService } from './valoraciones.service';

describe('ValoracionesController', () => {
  let controller: ValoracionesController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ValoracionesController],
      providers: [ValoracionesService],
    }).compile();

    controller = module.get<ValoracionesController>(ValoracionesController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
