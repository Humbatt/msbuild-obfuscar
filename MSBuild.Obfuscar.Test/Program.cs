namespace MSBuild.Obfuscar.Test;

public static class Program
{
    public static int Main()
    {
        Console.WriteLine(SecretComputation(20));
        return 0;
    }

    // The test checks this name is gone from the Release build.
    private static int SecretComputation(int value)
    {
        return value + 22;
    }
}
