﻿using APPRestaurante.UnitOfWork;
using APPRestaurante.Web.Areas.Admin.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace APPRestaurante.Web.Areas.Admin.Controllers
{
    [Autenticado]
    public class EmpleadoController : BaseController
    {
        public EmpleadoController(IUnitOfWork unit) : base(unit)
        {

        }

        // GET: Admin/Empleado
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Registro(int id = 0)
        {
            return View();
        }
    }
}