# Datos del problema

regiones = ["R1", "R2", "R3", "R4", "R5", "R6"]

ciudades = ["Antofagasta", "Valparaíso", "Santiago", "Concepción", "Puerto Montt"]

tipos_planta = ["Pequeña", "Grande"]

transportes = ["AT1", "AT2", "AT3"]

años = [1, 2, 3]


demanda_actual = {

    "R1": 951776, "R2": 967364, "R3": 512051, "R4": 386248, "R5": 946174, "R6": 303445
}

tasas_crecimiento = {

    "R1": 0.16, "R2": 0.22, "R3": 0.26, "R4": 0.15, "R5": 0.39, "R6": 0.30
}

capacidad_planta = {"Pequeña": 4636446, "Grande": 14966773}

costos_fijos = {

    ("Antofagasta", "Pequeña"): 18236639, ("Antofagasta", "Grande"): 60788796,

    ("Valparaíso", "Pequeña"): 8838286, ("Valparaíso", "Grande"): 32734393,

    ("Santiago", "Pequeña"): 6840758, ("Santiago", "Grande"): 32575039,

    ("Rancagua", "Pequeña"): 13378246, ("Rancagua", "Grande"): 53512984,

    ("Concepción", "Pequeña"): 26394217, ("Concepción", "Grande"): 65985543,

    ("Puerto Montt", "Pequeña"): 3678737, ("Puerto Montt", "Grande"): 26276695
}

costos_variables = {

    ("Antofagasta", "Pequeña"): 28.20, ("Antofagasta", "Grande"): 28.20,

    ("Valparaíso", "Pequeña"): 41.68, ("Valparaíso", "Grande"): 41.68,

    ("Santiago", "Pequeña"): 18.57, ("Santiago", "Grande"): 18.57,

    ("Rancagua", "Pequeña"): 17.68, ("Rancagua", "Grande"): 17.68,

    ("Concepción", "Pequeña"): 50.11, ("Concepción", "Grande"): 50.11,

    ("Puerto Montt", "Pequeña"): 43.55, ("Puerto Montt", "Grande"): 43.55
}

costos_apertura = {

    ("Antofagasta", "Pequeña"): 86626147, ("Antofagasta", "Grande"): 201456157,

    ("Valparaíso", "Pequeña"): 115721215, ("Valparaíso", "Grande"): 199519337,

    ("Santiago", "Pequeña"): 172235977, ("Santiago", "Grande"): 291925385,

    ("Rancagua", "Pequeña"): 0, ("Rancagua", "Grande"): 299031830,

    ("Concepción", "Pequeña"): 57494934, ("Concepción", "Grande"): 179671671,

    ("Puerto Montt", "Pequeña"): 175561277, ("Puerto Montt", "Grande"): 337617842
}

costos_transporte = {

    ("AT1", "Antofagasta", "R1"): 1.06, ("AT1", "Antofagasta", "R2"): 2.80, ("AT1", "Antofagasta", "R3"): 10.29,

    ("AT1", "Antofagasta", "R4"): 4.87, ("AT1", "Antofagasta", "R5"): 6.41, ("AT1", "Antofagasta", "R6"): 10.35,

    ("AT1", "Valparaíso", "R1"): 3.49, ("AT1", "Valparaíso", "R2"): 6.19, ("AT1", "Valparaíso", "R3"): 3.39,

    ("AT1", "Valparaíso", "R4"): 6.77, ("AT1", "Valparaíso", "R5"): 3.07, ("AT1", "Valparaíso", "R6"): 6.61,

    ("AT1", "Santiago", "R1"): 6.38, ("AT1", "Santiago", "R2"): 5.88, ("AT1", "Santiago", "R3"): 5.63,

    ("AT1", "Santiago", "R4"): 1.01, ("AT1", "Santiago", "R5"): 3.15, ("AT1", "Santiago", "R6"): 5.67,

    ("AT1", "Rancagua", "R1"): 3.44, ("AT1", "Rancagua", "R2"): 1.48, ("AT1", "Rancagua", "R3"): 2.79,

    ("AT1", "Rancagua", "R4"): 2.80, ("AT1", "Rancagua", "R5"): 5.30, ("AT1", "Rancagua", "R6"): 1.29,

    ("AT1", "Concepción", "R1"): 5.94, ("AT1", "Concepción", "R2"): 7.33, ("AT1", "Concepción", "R3"): 1.80,

    ("AT1", "Concepción", "R4"): 9.48, ("AT1", "Concepción", "R5"): 2.82, ("AT1", "Concepción", "R6"): 8.25,

    ("AT1", "Puerto Montt", "R1"): 2.57, ("AT1", "Puerto Montt", "R2"): 9.63, ("AT1", "Puerto Montt", "R3"): 4.84,

    ("AT1", "Puerto Montt", "R4"): 6.64, ("AT1", "Puerto Montt", "R5"): 6.48, ("AT1", "Puerto Montt", "R6"): 8.54,

    ("AT2", "Antofagasta", "R1"): 10.03, ("AT2", "Antofagasta", "R2"): 4.09, ("AT2", "Antofagasta", "R3"): 4.55,

    ("AT2", "Antofagasta", "R4"): 7.84, ("AT2", "Antofagasta", "R5"): 5.33, ("AT2", "Antofagasta", "R6"): 10.63,

    ("AT2", "Valparaíso", "R1"): 10.52, ("AT2", "Valparaíso", "R2"): 1.82, ("AT2", "Valparaíso", "R3"): 3.91,

    ("AT2", "Valparaíso", "R4"): 8.20, ("AT2", "Valparaíso", "R5"): 5.88, ("AT2", "Valparaíso", "R6"): 2.33,

    ("AT2", "Santiago", "R1"): 1.90, ("AT2", "Santiago", "R2"): 8.89, ("AT2", "Santiago", "R3"): 6.55,

    ("AT2", "Santiago", "R4"): 9.71, ("AT2", "Santiago", "R5"): 7.03, ("AT2", "Santiago", "R6"): 10.23,

    ("AT2", "Rancagua", "R1"): 2.06, ("AT2", "Rancagua", "R2"): 10.17, ("AT2", "Rancagua", "R3"): 2.12,

    ("AT2", "Rancagua", "R4"): 6.11, ("AT2", "Rancagua", "R5"): 3.79, ("AT2", "Rancagua", "R6"): 6.19,

    ("AT2", "Concepción", "R1"): 2.54, ("AT2", "Concepción", "R2"): 6.95, ("AT2", "Concepción", "R3"): 8.57,

    ("AT2", "Concepción", "R4"): 10.50, ("AT2", "Concepción", "R5"): 4.85, ("AT2", "Concepción", "R6"): 5.31,

    ("AT2", "Puerto Montt", "R1"): 7.92, ("AT2", "Puerto Montt", "R2"): 10.32, ("AT2", "Puerto Montt", "R3"): 1.41,

    ("AT2", "Puerto Montt", "R4"): 4.94, ("AT2", "Puerto Montt", "R5"): 2.74, ("AT2", "Puerto Montt", "R6"): 8.08,

    ("AT3", "Antofagasta", "R1"): 9.86, ("AT3", "Antofagasta", "R2"): 4.30, ("AT3", "Antofagasta", "R3"): 8.10,

    ("AT3", "Antofagasta", "R4"): 9.63, ("AT3", "Antofagasta", "R5"): 7.40, ("AT3", "Antofagasta", "R6"): 6.47,

    ("AT3", "Valparaíso", "R1"): 1.58, ("AT3", "Valparaíso", "R2"): 2.71, ("AT3", "Valparaíso", "R3"): 3.08,

    ("AT3", "Valparaíso", "R4"): 5.91, ("AT3", "Valparaíso", "R5"): 7.99, ("AT3", "Valparaíso", "R6"): 5.11,

    ("AT3", "Santiago", "R1"): 9.13, ("AT3", "Santiago", "R2"): 10.03, ("AT3", "Santiago", "R3"): 6.77,

    ("AT3", "Santiago", "R4"): 5.70, ("AT3", "Santiago", "R5"): 3.62, ("AT3", "Santiago", "R6"): 8.58,

    ("AT3", "Rancagua", "R1"): 8.95, ("AT3", "Rancagua", "R2"): 7.37, ("AT3", "Rancagua", "R3"): 10.29,

    ("AT3", "Rancagua", "R4"): 3.34, ("AT3", "Rancagua", "R5"): 2.21, ("AT3", "Rancagua", "R6"): 4.58,

    ("AT3", "Concepción", "R1"): 9.62, ("AT3", "Concepción", "R2"): 3.78, ("AT3", "Concepción", "R3"): 5.19,

    ("AT3", "Concepción", "R4"): 2.61, ("AT3", "Concepción", "R5"): 3.19, ("AT3", "Concepción", "R6"): 1.78,

    ("AT3", "Puerto Montt", "R1"): 10.32, ("AT3", "Puerto Montt", "R2"): 8.88, ("AT3", "Puerto Montt", "R3"): 10.87,

    ("AT3", "Puerto Montt", "R4"): 10.38, ("AT3", "Puerto Montt", "R5"): 5.83, ("AT3", "Puerto Montt", "R6"): 1.54
}