using System;
using System.Device.Gpio;
using System.Threading;

namespace rpitest
{
    class Program
    {

        static void Main(string[] args)
        {

            GpioController controller = new GpioController(PinNumberingScheme.Board);

            Console.WriteLine("Hello World!");

            var pin = 10;
            var lightTime = 300;
            controller.OpenPin(pin, PinMode.Output);

            try
            {
                while (true)
                {
                    controller.Write(pin, PinValue.High);
                    Thread.Sleep(lightTime);
                    controller.Write(pin, PinValue.Low);
                    Thread.Sleep(lightTime);
                }              
            }
            finally
            {
                controller.ClosePin(pin);
            }

        }
    }
}
