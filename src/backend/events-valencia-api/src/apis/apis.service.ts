import { Inject, Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { map, Observable } from 'rxjs';
import { XMLParser } from 'fast-xml-parser';
import { CreateEventoXmlParserDto } from './dto/create-evento-xmlparser';
import { Punto } from 'src/puntos/entities/punto.entity';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class ApisService {
    constructor(
        @Inject(HttpService) private httpService: HttpService,
        @Inject(ConfigService) private readonly configService: ConfigService
    ) { }

    obtenerMonumentosTuristicosApi(): Observable<any> {
        const apiUrl =
            'https://valencia.opendatasoft.com/api/explore/v2.1/catalog/datasets/monuments-turistics-monumentos-turisticos/records?select=gid%2C%20nombre%2C%20telefono%2C%20geo_point_2d&limit=-1';
        return this.httpService.get(apiUrl)

    }

    obtenerEstadoTraficoApi(): Observable<any> {
        const apiUrl =
            'https://valencia.opendatasoft.com/api/explore/v2.1/catalog/datasets/estat-transit-temps-real-estado-trafico-tiempo-real/records?select=gid%2C%20denominacion%2C%20estado%2C%20idtramo%2C%20geo_shape&limit=-1';
        return this.httpService.get(apiUrl);
    }

    obtenerRutaApi(perfil:string, inicio: Punto, fin: Punto): Observable<any> {
        const API_KEY = this.configService.get('OPEN_ROUTE_SERVICE_KEY');
        const START = `${inicio.longitud},${inicio.latitud}`;
        const END = `${fin.longitud},${fin.latitud}`;
        const apiUrl = `https://api.openrouteservice.org/v2/directions/${perfil}?api_key=${API_KEY}&start=${START}&end=${END}`
        return this.httpService.get(apiUrl);
    }

    obtenerCalle(lat:number, lon:number): Observable<any>{
        const apiUrl = 
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat='+lat+'&lon='+lon+'&email=heboyat891@dxice.com'
        return this.httpService.get(apiUrl);
    }

    obtenerCoordenadas(direccion:string): Observable<any>{
        const apiUrl =
        'https://nominatim.openstreetmap.org/search?q='+direccion+'&format=json&addressdetails=1'
        return this.httpService.get(apiUrl);
    }

    async extraerDatosXML(): Promise<any> {

        //https://www.visitvalencia.com/rss.xml
        //https://www.valenciaconventionbureau.com/rss.xml

        const urls:string[] = ["https://www.visitvalencia.com/rss.xml","https://www.valenciaconventionbureau.com/rss.xml"];
        const results = await Promise.all(
            urls.map(async(url) => {
                try {
                    const response = await fetch(url);
                    const xmlString = await response.text();
                    const parser = new XMLParser();
                    const xmlparsed = await parser.parse(xmlString).rss.channel.item;
                    return xmlparsed;
                } catch (error) {
                    console.error('Error al extraer datos:', error);
                    return null; // Or handle the error differently
                }
            })
        )
        return results;
    }


}
