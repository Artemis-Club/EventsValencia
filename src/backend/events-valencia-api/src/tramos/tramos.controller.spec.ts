import { Test, TestingModule } from '@nestjs/testing';
import { TramosController } from './tramos.controller';
import { TramosService } from './tramos.service';

describe('TramosController', () => {
  let controller: TramosController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TramosController],
      providers: [TramosService],
    }).compile();

    controller = module.get<TramosController>(TramosController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
