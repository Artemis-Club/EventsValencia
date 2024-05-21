const formulario = document.getElementById('formulario');
const respuesta = document.getElementById('respuesta');
const id = document.getElementById('id');
const dataListCategorias = document.getElementById('categorias');

async function fetchLastId() {
    const response = await fetch('http://montnoirr.ddns.net:5500/eventos/lastId');
    const data = await response.json();
    id.value = ++data.id;
    return data.id;
}

async function fetchCategorias() {
    const response = await fetch('http://montnoirr.ddns.net:5500/categorias');
    const categorias = await response.json();
    categorias.forEach(categoria => {
        const optionElement = document.createElement('option');
        optionElement.value = categoria.nombre;
        optionElement.textContent = categorias.nombre;
        dataListCategorias.appendChild(optionElement);
    });
}



fetchLastId();
fetchCategorias();

let imagen;

formulario.addEventListener('submit', async (event) => {
    event.preventDefault(); // Evitar recarga de página

    const datos = {
        id: +id.value,
        titulo: document.getElementById('titulo').value,
        descripcion: document.getElementById('descripcion').value,
        url: document.getElementById('url').value == "" ? null : document.getElementById('url').value,
        posicion: {
            latitud: parseFloat(document.getElementById('coordenada').value.split(',')[0].trim()),
            longitud: parseFloat(document.getElementById('coordenada').value.split(',')[1].trim()),
            direccion: document.getElementById('direccion').value == "" ? null : document.getElementById('direccion').value == "",
        },
        categoria: { nombre: document.getElementById('categoria').value.trim() },
        imagen: imagen
    };

    fetch('http://montnoirr.ddns.net:5500/eventos', {
        method: 'POST',
        body: JSON.stringify(datos), // Convertir datos a JSON
        headers: {
            'Content-Type': 'application/json' // Indicar tipo de contenido
        }
    })
        .then(response => {
            if (response.ok) {
                respuesta.innerHTML = '¡Datos enviados correctamente!';
                alert('¡Datos enviados correctamente!');
            } else {
                respuesta.innerHTML = 'Error: ' + response.status + " " + response.text;
                alert('Error: ' + response.status + " " + response.text);
            }
        }) // Parsear respuesta JSON
        .catch(error => {
            respuesta.innerHTML = 'Error de conexión: ' + error;
        });
});


const selectorImagen = document.getElementById('seleccionador-imagen');
const vistaPrevia = document.getElementById('vista-previa');
const btnSubir = document.getElementById('btn-subir');

selectorImagen.addEventListener('change', () => {
    const archivo = selectorImagen.files[0];
    if (archivo) {
        const reader = new FileReader();
        reader.onload = function () {
            vistaPrevia.src = reader.result;
            imagen = reader.result;
            console.log(imagen)
        };
        reader.readAsDataURL(archivo);
    } else {
        vistaPrevia.src = "";
    }
});

btnSubir.addEventListener('click', () => {
    // Aquí debes agregar la lógica para subir la imagen al servidor
    // (subir archivo a un servidor web, API, etc.)
    console.log('¡Imagen seleccionada!');
});

const coordenadaInput = document.getElementById('coordenada');
const mapaContenedor = document.getElementById('mapa-contenedor');

let marker; // Global variable to store the map marker
const markerIcon = L.icon({
    iconUrl: './img/location.png',
    iconSize: [30, 30]
})
let hasClickedMarker = false;

// ... existing form submission logic ...

// Initialize map (no API key required)
const map = L.map('mapa-contenedor', {
    center: [39.46762050889846, -0.37734261337589753], // Initial center (replace with your desired location)
    zoom: 12,
});

// Add base layer (e.g., OpenStreetMap tiles)
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map);

async function clearForm() {
    document.getElementById('id').value = await fetchLastId()
    document.getElementById('titulo').value = ""
    document.getElementById('categoria').value = ""
    document.getElementById('url').value = ""
    document.getElementById('descripcion').value = ""
    document.getElementById('direccion').value = ""
    coordenadaInput.value = ""
}

async function fetchEventos() {
    const response = await fetch('http://montnoirr.ddns.net:5500/eventos');
    const eventos = await response.json();
    eventos.forEach(evento => {
        L.marker([evento.posicion.latitud, evento.posicion.longitud], { title: evento.titulo }).addTo(map).on('click', async (e) => {
            hasClickedMarker = true;
            await clearForm();
            document.getElementById('id').value = evento.id;
            document.getElementById('titulo').value = evento.titulo;
            document.getElementById('categoria').value = evento.categoria && evento.categoria.nombre.trim() != "" ? evento.categoria.nombre : null;
            document.getElementById('url').value = evento.url;
            document.getElementById('descripcion').value = evento.descripcion;
            document.getElementById('direccion').value = evento.posicion.direccion;
            coordenadaInput.value = `${evento.posicion.latitud},${evento.posicion.longitud}`
            vistaPrevia.src = evento.imagen
        })
    })
}

fetchEventos();

// Add click event listener to map
map.on('click', onMapClick);

async function onMapClick(event) {
    if (hasClickedMarker) {await clearForm(); hasClickedMarker = false;}
    const lat = event.latlng.lat
    const lng = event.latlng.lng
    coordenadaInput.value = `${lat.toFixed(6)},${lng.toFixed(6)}`;

    // Add or update marker
    if (marker) {
        marker.setLatLng([lat, lng])
    } else {
        marker = L.marker([lat, lng], { icon: markerIcon }).addTo(map);
    }
}