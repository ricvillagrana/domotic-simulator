UnitType.create!([
  {
    description: 'aslkdn aslknd lasnd {lasnd {lasnd l',
    unit: 'Celcius',
    symbol: '°C'
  },
  {
    description: 'apsldm kansdasndlkna sñldn  alsknd',
    unit: 'Farenheit',
    symbol: '°F'
  },
  {
    description: 'apks dnpkasn dksaln dlaksndlñaskn dl',
    unit: 'Kilogramos',
    symbol: 'kg'
  },
  {
    description: 'apsdn aknsd lñansdlñ knasñldn alsk',
    unit: 'Miligramos',
    symbol: 'mg'
  },
  {
    description: 'Cantidad de mililitros en el suelo por cada centímetro cúbico.',
    unit: 'Humedad',
    symbol: 'ml /cm³'
  },
  {
    description: 'aklsdn lkans lknalksn lkns lkna slknd ',
    unit: 'Lúmenes',
    symbol: 'lm'
  },
  {
    description: 'askdalks nlka snlk naslkn  lksna',
    unit: 'Booleano',
    symbol: 'bool'
  },
  {
    description: 'aslmdnsalkd nlaskn laskn lkasn ',
    unit: 'Hertz',
    symbol: 'hz'
  },
  {
    description: 'askldn laskdn lkasnl knasldk naslkdn ',
    unit: 'Angulo',
    symbol: '∠'
  },
  {
    description: 'asknd alskn dlkasndlkasnldn alksn ',
    unit: 'Porcentaje',
    symbol: '%'
  }
])

Network.create!([
  {
    name: 'Ethernet',
    description: 'Ethernet es una familia de tecnologías de redes informáticas comúnmente utilizadas en redes de área local, redes de área metropolitana y redes de área amplia. Se introdujo comercialmente en 1980 y se estandarizó por primera vez en 1983 como IEEE 802.3, y desde entonces se ha refinado para admitir velocidades de bits más altas y distancias de enlace más largas. Con el tiempo, Ethernet ha reemplazado en gran medida a las tecnologías de LAN cableadas de la competencia, como Token Ring, FDDI y ARCNET.'
  },
  {
    name: 'RF (Radio Frecuency)',
    description: 'La radiofrecuencia (RF) se refiere a una tasa de oscilación de una corriente o tensión eléctrica alterna o de un campo magnético, eléctrico o electromagnético o sistema mecánico en el rango de frecuencia de alrededor de veinte mil veces por segundo (20 kHz) a alrededor de trescientos mil millones de veces por segundo (300 GHz). Esto es aproximadamente entre el límite superior de las frecuencias de audio y el límite inferior de las frecuencias infrarrojas. [1] [2] Diferentes fuentes especifican diferentes límites superior e inferior para el rango de frecuencia. Mientras que RF se refiere generalmente a oscilaciones eléctricas en lugar de mecánicas, los sistemas de RF mecánicos no son infrecuentes (ver filtro mecánico y MEMS de RF).'
  },
  {
    name: 'Bluethoot',
    description: 'Bluetooth es una especificación industrial para Redes Inalámbricas de Área Personal (WPAN) creado por Bluetooth Special Interest Group, Inc. que posibilita la transmisión de voz y datos entre diferentes dispositivos mediante un enlace por radiofrecuencia en la banda ISM de los 2.4 GHz. Los principales objetivos que se pretenden conseguir con esta norma son:
Facilitar las comunicaciones entre equipos móviles.
Eliminar los cables y conectores entre estos.
Ofrecer la posibilidad de crear pequeñas redes inalámbricas y facilitar la sincronización de datos entre equipos personales.
Los dispositivos que con mayor frecuencia utilizan esta tecnología pertenecen a sectores de las telecomunicaciones y la informática personal, como PDA, teléfonos móviles, ordenadores portátiles, ordenadores personales, impresoras o cámaras digitales.'
  },
  {
    name: 'WiFi',
    description: 'El wifi (sustantivo común en español, incluido en el Diccionario de la ASALE)​ es una tecnología que permite la interconexión inalámbrica de dispositivos electrónicos. Los dispositivos habilitados con wifi (tales como computadoras personales, teléfonos, televisores, videoconsolas, reproductores de música...) pueden conectarse entre sí o a internet a través de un punto de acceso de red inalámbrica.'
  }
])

Interface.create!([
  {
    name: "Tarjeta de red WiF",
    description: "adasdasdasd aslkd lkasnd laknsl n",
    network: Network.last
  },
  {
    name: "RJ-45",
    description: "asd aksnd aknsl kansdlk andslnas kldn ",
    network: Network.first
  },
  {
    name: "Transmisor RF",
    description: "askdapksdn kandlasnldkn asklnd lakdsn ",
    network: Network.second
  },
  {
    name: "Tarjeta de red Bluethoot",
    description: "am sdnla snlaskn dlkn lknaslkdn ",
    network: Network.third
  }
])
