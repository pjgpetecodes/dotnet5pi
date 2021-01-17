using Tizen.Applications;
using Uno.UI.Runtime.Skia;

namespace uno.Skia.Tizen
{
	class Program
	{
		static void Main(string[] args)
		{
			var host = new TizenHost(() => new uno.App(), args);
			host.Run();
		}
	}
}
