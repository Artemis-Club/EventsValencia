import express from 'express';
import cors from 'cors';
const app = express();
const port = process.env.PORT || 80; // Asignar puerto

// Cargar frontend estático (carpeta public)
app.use(express.static('public'));

app.use(cors({
    origin: '*',
    credentials: true
}))

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/index.html'); // Enviar archivo index.html
});

// Iniciar servidor
app.listen(port, () => {
    console.log(`Servidor Express corriendo en el puerto ${port}`);
});
