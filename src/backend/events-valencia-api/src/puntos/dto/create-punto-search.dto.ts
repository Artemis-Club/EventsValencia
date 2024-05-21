export class CreatePuntoSearchDto{
    lat: number
    lon: number
    name: string
    display_name: string
    address:{
        road: string
        province?: string
        country: string
    }
    
}