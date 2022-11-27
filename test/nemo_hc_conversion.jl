@testset "Convert Nemo polynomial systems into HomotopyContinuation type" begin
    R, (X, Y, Z) = PolynomialRing(QQ, ["x", "y", "z"])
    @var x y z
    Et = [X + Y + Z - 1, X + Y - 2, Z * X - 1]
    E = System([ParameterEstimation.nemo2hc(e) for e in Et])
    E_native = System([x + y + z - 1, x + y - 2, x * z - 1])
    @test E_native == E

    Et = [X^2 + 1 // 3 * Y + Z * X - 1, -X + Y^3 * X^2 - 2, Z * X - 1]
    E = System([ParameterEstimation.nemo2hc(e) for e in Et])
    E_native = System([x^2 + 1 // 3 * y + z * x - 1,
                          -x + y^3 * x^2 - 2,
                          x * z - 1])
    @test E_native == E

    Et = [X * Y * Z * X // 10 - 1, -X - Y - 2, Z * X - 1]
    E = System([ParameterEstimation.nemo2hc(e) for e in Et])
    E_native = System([x * y * z * x // 10 - 1, -x - y - 2, z * x - 1])
    @test E_native == E
end