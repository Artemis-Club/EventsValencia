export class CreateEventoXmlParserDto {
    title: string
    link: string
    description: string
    pubDate: string
    creator: {__prefix: string, __text: string}
    guid: string
}