using System;
using System.Collections.Generic;

var demos = new Dictionary<string, Action>(StringComparer.OrdinalIgnoreCase)
{
    ["factory"] = FactoryMethod.Demo.Run,
    ["builder"] = Builder.Demo.Run,
    ["adapter"] = Adapter.Demo.Run,
    ["decorator"] = Decorator.Demo.Run,
    ["facade"] = Facade.Demo.Run,
    ["strategy"] = Strategy.Demo.Run,
    ["observer"] = Observer.Demo.Run,
    ["command"] = Command.Demo.Run
};

if (args.Length > 0)
{
    if (demos.TryGetValue(args[0], out var selected)) selected();
    else Console.WriteLine("Patrón desconocido. Opciones: " + string.Join(", ", demos.Keys));
}
else foreach (var (name, run) in demos)
{
    Console.WriteLine("\n=== " + name.ToUpperInvariant() + " ===");
    run();
}

namespace FactoryMethod
{
    public interface ITransporte { void Entregar(); }
    public sealed class Camion : ITransporte { public void Entregar() => Console.WriteLine("Entrega terrestre"); }
    public sealed class Barco : ITransporte { public void Entregar() => Console.WriteLine("Entrega marítima"); }
    public abstract class Logistica
    {
        protected abstract ITransporte CrearTransporte();
        public void RealizarEntrega() => CrearTransporte().Entregar();
    }
    public sealed class LogisticaTerrestre : Logistica { protected override ITransporte CrearTransporte() => new Camion(); }
    public sealed class LogisticaMaritima : Logistica { protected override ITransporte CrearTransporte() => new Barco(); }
    public static class Demo { public static void Run() { new LogisticaTerrestre().RealizarEntrega(); new LogisticaMaritima().RealizarEntrega(); } }
}
namespace Builder
{
    public sealed record Reporte(string Titulo, string Contenido);
    public sealed class ReporteBuilder
    {
        private string titulo = "";
        private string contenido = "";
        public ReporteBuilder ConTitulo(string valor) { titulo = valor; return this; }
        public ReporteBuilder ConContenido(string valor) { contenido = valor; return this; }
        public Reporte Construir() => new(titulo, contenido);
    }
    public static class Demo { public static void Run() => Console.WriteLine(new ReporteBuilder().ConTitulo("Ventas").ConContenido("Resumen mensual").Construir()); }
}
namespace Adapter
{
    public interface IProcesadorPago { void Pagar(decimal monto); }
    public sealed class PasarelaExterna { public void EjecutarTransaccion(decimal monto) => Console.WriteLine($"Pasarela externa: ₡{monto}"); }
    public sealed class AdaptadorPago : IProcesadorPago
    {
        private readonly PasarelaExterna externo;
        public AdaptadorPago(PasarelaExterna externo) => this.externo = externo;
        public void Pagar(decimal monto) => externo.EjecutarTransaccion(monto);
    }
    public static class Demo { public static void Run() { IProcesadorPago pago = new AdaptadorPago(new PasarelaExterna()); pago.Pagar(15000m); } }
}
namespace Decorator
{
    public interface INotificador { void Enviar(string mensaje); }
    public sealed class Email : INotificador { public void Enviar(string mensaje) => Console.WriteLine("Correo: " + mensaje); }
    public sealed class AuditoriaDecorator : INotificador
    {
        private readonly INotificador interno;
        public AuditoriaDecorator(INotificador interno) => this.interno = interno;
        public void Enviar(string mensaje) { Console.WriteLine("Auditoría registrada"); interno.Enviar(mensaje); }
    }
    public static class Demo { public static void Run() { INotificador n = new AuditoriaDecorator(new Email()); n.Enviar("Pedido aprobado"); } }
}
namespace Facade
{
    public sealed class InventarioService { public void Reservar() => Console.WriteLine("Inventario reservado"); }
    public sealed class PagoService { public void Cobrar() => Console.WriteLine("Pago procesado"); }
    public sealed class FacturaService { public void Generar() => Console.WriteLine("Factura generada"); }
    public sealed class CompraFacade
    {
        private readonly InventarioService inventario = new();
        private readonly PagoService pago = new();
        private readonly FacturaService factura = new();
        public void Procesar() { inventario.Reservar(); pago.Cobrar(); factura.Generar(); }
    }
    public static class Demo { public static void Run() => new CompraFacade().Procesar(); }
}
namespace Strategy
{
    public interface IDescuentoStrategy { decimal Calcular(decimal subtotal); }
    public sealed class Regular : IDescuentoStrategy { public decimal Calcular(decimal subtotal) => subtotal * 0.95m; }
    public sealed class Premium : IDescuentoStrategy { public decimal Calcular(decimal subtotal) => subtotal * 0.85m; }
    public sealed class Carrito
    {
        private readonly IDescuentoStrategy estrategia;
        public Carrito(IDescuentoStrategy estrategia) => this.estrategia = estrategia;
        public decimal Total(decimal subtotal) => estrategia.Calcular(subtotal);
    }
    public static class Demo { public static void Run() => Console.WriteLine("Total premium: ₡" + new Carrito(new Premium()).Total(10000m)); }
}
namespace Observer
{
    public sealed class Pedido
    {
        public event Action<string>? EstadoCambiado;
        public void CambiarEstado(string estado) => EstadoCambiado?.Invoke(estado);
    }
    public sealed class Notificador { public void Avisar(string estado) => Console.WriteLine("Nuevo estado: " + estado); }
    public static class Demo
    {
        public static void Run()
        {
            var pedido = new Pedido();
            var notificador = new Notificador();
            pedido.EstadoCambiado += notificador.Avisar;
            pedido.CambiarEstado("Enviado");
            pedido.EstadoCambiado -= notificador.Avisar;
        }
    }
}
namespace Command
{
    public interface ICommand { void Ejecutar(); }
    public sealed class Editor { public void Guardar() => Console.WriteLine("Documento guardado"); }
    public sealed class GuardarCommand : ICommand
    {
        private readonly Editor editor;
        public GuardarCommand(Editor editor) => this.editor = editor;
        public void Ejecutar() => editor.Guardar();
    }
    public sealed class Boton
    {
        private readonly ICommand comando;
        public Boton(ICommand comando) => this.comando = comando;
        public void Presionar() => comando.Ejecutar();
    }
    public static class Demo { public static void Run() => new Boton(new GuardarCommand(new Editor())).Presionar(); }
}
