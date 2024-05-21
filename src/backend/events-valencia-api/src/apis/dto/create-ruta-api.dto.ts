export class CreateRutaApiDto {
    features: [
        {
            properties: {
                summary: {
                    distance: number,
                    duration: number,
                }
            },
            geometry: {
                coordinates: [[number, number]]
            }
        }
    ]
    metada: {
        query: {
            coordinates: [[number, number]],
            profile: string
        }
    }
}