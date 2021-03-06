﻿using System;
using System.ComponentModel.DataAnnotations;

namespace APPRestaurante.Models
{
    public class Menu
    {
        public int id { get; set; }
        public int idMenu { get; set; }
        public string fecha { get; set; }
        public DateTime fechaMenu { get; set; }
        public string usuario { get; set; }
        public string titulo { get; set; }
        public string descripcion { get; set; }
        public string tipo { get; set; }
        public double precio { get; set; }
        public string foto { get; set; }
        public int idUsuario { get; set; }
        public int idDetalle { get; set; }
        public int estado { get; set; }
        public string precioString { get; set; }
    }
}
