﻿var menuRegistroModule = (function (globalData, $) {
    'use strict';

    var me = {};

    var urls = globalData.urlProvider;

    me.Elementos = (function () {
        function getFecha() { return $('input[name=Fecha]'); }
        function getTitulo() { return $('input[name=Titulo]'); }
        function getDescripcion() { return $('textarea[name=Descripcion]'); }
        function getTipo() { return $('select[name=Tipo]'); }
        function getPrecio() { return $('input[name=Precio]'); }
        function getIdDetalle() { return $('input[name=hdIdDetalle]'); }
        return {
            getFecha: getFecha,
            getTitulo: getTitulo,
            getDescripcion: getDescripcion,
            getTipo: getTipo,
            getPrecio: getPrecio,
            getIdDetalle: getIdDetalle
        }
    })();

    me.Servicios = (function () {
        function registrar(formData) {
            return $.ajax({
                url: urls.urlRegistro,
                type: 'POST',
                data: formData,
                dataType: 'json',
                contentType: false,
                processData: false
            });
        }
        return {
            registrar: registrar
        }
    })();

    me.Eventos = (function () {
        function insertarDatos() {
            var formData = new FormData();
            var file = document.getElementById("Foto").files[0];
            formData.append("Foto", file);
            formData.append("Fecha", me.Elementos.getFecha().val());
            formData.append("Titulo", me.Elementos.getTitulo().val());
            formData.append("Descripcion", me.Elementos.getDescripcion().val());
            formData.append("Tipo", me.Elementos.getTipo().val());
            formData.append("Precio", me.Elementos.getPrecio().val());
            formData.append("idDetalle", me.Elementos.getIdDetalle().val());
            var successRegistro = function (r) {
                if (!r.Success) {
                    FuncionesGenerales.AbrirMensaje(r.Message);
                } else {
                    window.location.href = urls.urlPaginaLista;
                }
            }

            me.Servicios.registrar(formData).then(successRegistro, function (e) {
                console.log(e);
            });
        }
        return {
            insertarDatos: insertarDatos
        }
    })();

    me.Funciones = (function () {
        function inicializarEventos() {
            var body = $('body');
            body.on('click', 'button[name=btnGuardar]', me.Eventos.insertarDatos);
            //$('.img-responsive').show();
            me.Elementos.getFecha().prop("disabled", true);

            if (me.Elementos.getIdDetalle().val() == 0) {
                var fecha = new Date();
                me.Elementos.getFecha().val(FuncionesGenerales.ConvertirFechaDDMMYYYY(fecha));
                $('.img-responsive').hide();
            }
        }
        return {
            inicializarEventos: inicializarEventos
        }
    })();

    me.InicializarEventos = function () {
        me.Funciones.inicializarEventos();
    }

    return me;


})(menuRegistroData, jQuery);

window.menuRegistroModule = menuRegistroModule;

$(document).ready(function () {
    menuRegistroModule.InicializarEventos();
});