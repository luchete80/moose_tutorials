# (modules/solid_mechanics/test/tests/finite_strain_elastic/finite_strain_elastic_new_test.i)
#FROM: https://mooseframework.inl.gov/source/kernels/StressDivergenceTensors.html

[Mesh]
  file = notch_0.5.inp
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Functions]
  [./tdisp]
    type = ParsedFunction
    expression = '0.01 * t'
  [../]
[]


[Adaptivity]
  interval = 2
  # refine_fraction = 0.2
  # coarsen_fraction = 0.3
  max_h_level = 1
[]

## This is where mesh adaptivity magic happens
#[Adaptivity]
#  steps = 1
#  max_h_level = 3
#  cycles_per_step = 1
#  initial_marker = uniform
#  marker = errorFraction
#  [Markers]
#    [uniform]
#      #block = 1
#      type = UniformMarker
#      mark = refine
#    []
#    [errorFraction]
#      type = ErrorFractionMarker
#      coarsen = 0.5
#      indicator = gradientJump
#      refine = 0.5
#    []
#  []
#
#  [Indicators]
#    [gradientJump]
#      type = GradientJumpIndicator
#      variable = x_disp
#    []
#  []
#[]


[Physics]
  [SolidMechanics]
    [QuasiStatic]
      [./all]
        strain = FINITE
        add_variables = true

        #incremental = true

      [../]
    [../]
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0.0
  [../]
  [./back]
    type = DirichletBC
    variable = disp_z
    boundary = back
    value = 0.0
  [../]
  [./bottom]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  [../]
  [./right]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = right
    function = 't*1.0e-3'
  [../]
[]


[Materials]
  [fplastic]
      type = FiniteStrainPlasticMaterial
      yield_stress = '0 270.e6 0.5 280.e6 1.0 300.e6 2.0 320.e6'
  []
  #[./elasticity_tensor]
  #  type = ComputeElasticityTensor
  #  C_ijkl = '1.684e5 0.176e5 0.176e5 1.684e5 0.176e5 1.684e5 0.754e5 0.754e5 0.754e5'
  #  fill_method = symmetric9
  #[../]
  [elastic_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 210.0e9
    poissons_ratio = 0.3
  []  
#  [./stress]
#    type = ComputeFiniteStrainElasticStress
#  [../]
[]


[AuxVariables]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./peeq]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./pe11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./pe22]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./pe33]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
  [./pe11]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = pe11
    index_i = 0
    index_j = 0
  [../]
    [./pe22]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = pe22
    index_i = 1
    index_j = 1
  [../]
  [./pe33]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = pe33
    index_i = 2
    index_j = 2
  [../]
  [./eqv_plastic_strain]
    type = MaterialRealAux
    property = eqv_plastic_strain
    variable = peeq
  [../]
[]


[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  dt = 0.01

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = -pc_hypre_type
  petsc_options_value = boomeramg

  dtmax = 0.1

  end_time = 1
  dtmin = 0.001
  #num_steps = 10
  nl_abs_step_tol = 1e-3
  nl_rel_step_tol = 1e-3
  nl_rel_tol = 1e-3
[]

[Outputs]
  exodus = true
[]

