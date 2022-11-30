function Base.show(io::IO, identifiability_result::IdentifiabilityData)
    println("=== Summary ===")
    println("Globally identifiable parameters:                 [$(join(identifiability_result.identifiability["globally"], ", "))]")
    println("Locally but not globally identifiable parameters: [$(join(identifiability_result.identifiability["locally_not_globally"], ", "))]")
    println("Not identifiable parameters:                      [$(join(identifiability_result.identifiability["nonidentifiable"], ", "))]")
    println("===============")
end

function Base.getindex(identifiability_result::IdentifiabilityData, key::Symbol)
    return getproperty(identifiability_result, key)
end

function Base.getindex(identifiability_result::IdentifiabilityData, key::String)
    return getproperty(identifiability_result, Symbol(key))
end

function count_solutions(identifiability_result::IdentifiabilityData)
    @info "Counting number of solutions per variable"
    globally_id = identifiability_result.identifiability_nemo["globally"]
    locally_not_globally_id = identifiability_result.identifiability_nemo["locally_not_globally"]
    non_id = identifiability_result.identifiability_nemo["nonidentifiable"]
    weights_table = identifiability_result.weights
    non_jet_ring = identifiability_result.non_jet_ring
    n2m = identifiability_result.nemo_mtk
    solutions_table = Dict{Any, Int}()
    for param in globally_id
        v = SIAN.get_order_var(param, non_jet_ring)[1]
        solutions_table[n2m[v]] = 1
    end
    for param in non_id
        v = SIAN.get_order_var(param, non_jet_ring)[1]
        solutions_table[n2m[v]] = 0
    end
    # basis_lex = Groebner.fglm(identifiability_result.basis)
    R = parent(identifiability_result.basis[1])
    SR, svars = Singular.PolynomialRing(Singular.QQ, string.(gens(R)); ordering = :lex)
    basis_sing = [ParameterEstimation.nemo2singular(identifiability_result.basis[i], SR)
                  for i in 1:length(identifiability_result.basis)]
    locally_not_globally_id_sing = [ParameterEstimation.nemo2singular(locally_not_globally_id[i],
                                                                      SR)
                                    for i in 1:length(locally_not_globally_id)]
    SIdeal = Singular.Ideal(SR, basis_sing)

    for (idx, param) in enumerate(locally_not_globally_id_sing)
        others = setdiff(svars, [param])
        elim = Singular.gens(Singular.eliminate(SIdeal, others...))
        polynomials = filter(x -> param in Singular.vars(x),
                             elim)[1]
        param_idx = findfirst(x -> x == param, svars)
        v = SIAN.get_order_var(locally_not_globally_id[idx], non_jet_ring)[1]
        dgrs = Singular.degrees(polynomials)[param_idx] /
               get(weights_table, v, 1)
        solutions_table[n2m[v]] = Int(dgrs)
    end
    return solutions_table
end

function nemo2singular(poly, SingularRing)
    builder = Singular.MPolyBuildCtx(SingularRing)
    for term in zip(Nemo.exponent_vectors(poly), Nemo.coefficients(poly))
        exp, coef = term
        push_term!(builder, SingularRing.base_ring(coef), exp)
    end
    return finish(builder)
end