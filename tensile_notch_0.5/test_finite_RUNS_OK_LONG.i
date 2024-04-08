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
#refine_fraction = 0.2
#coarsen_fraction = 0.3
  max_h_level = 3
[]

# This is where mesh adaptivity magic happens
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
#      variable = disp_x
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
      yield_stress = '0.000e+00 1.750e+08 1.000e-01 2.780e+08 2.000e-01 3.366e+08 3.000e-01 3.853e+08 4.000e-01 4.286e+08 5.000e-01 4.681e+08 6.000e-01 5.050e+08 7.000e-01 5.398e+08 8.000e-01 5.729e+08 9.000e-01 6.046e+08 1.000e+00 6.350e+08 1.100e+00 6.644e+08 1.200e+00 6.929e+08 1.300e+00 7.205e+08 1.400e+00 7.475e+08 1.500e+00 7.737e+08 1.600e+00 7.994e+08 1.700e+00 8.245e+08 1.800e+00 8.490e+08 1.900e+00 8.731e+08 2.000e+00 8.968e+08 2.100e+00 9.201e+08 2.200e+00 9.429e+08 2.300e+00 9.655e+08 2.400e+00 9.876e+08 2.500e+00 1.009e+09 2.600e+00 1.031e+09 2.700e+00 1.052e+09 2.800e+00 1.073e+09 2.900e+00 1.094e+09 3.000e+00 1.114e+09 3.100e+00 1.135e+09 3.200e+00 1.155e+09 3.300e+00 1.175e+09 3.400e+00 1.194e+09 3.500e+00 1.213e+09 3.600e+00 1.233e+09 3.700e+00 1.252e+09 3.800e+00 1.271e+09 3.900e+00 1.289e+09 4.000e+00 1.308e+09 4.100e+00 1.326e+09 4.200e+00 1.344e+09 4.300e+00 1.362e+09 4.400e+00 1.380e+09 4.500e+00 1.398e+09 4.600e+00 1.415e+09 4.700e+00 1.433e+09 4.800e+00 1.450e+09 4.900e+00 1.467e+09 '
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

#[NodalKernels]
#  [rxn]
#    type = ReactionNodalKernel
#    variable = disp_x
#  []
#[]

[AuxVariables]
  [./resid_x]
  [../]
  [./resid_y]
  [../]
  [./resid_z]
  [../]
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

[Kernels]
  [./res_y]
    type = StressDivergenceTensors
    component = 1
    variable =disp_y
    save_in = 'resid_y'
  [../]
  [./res_x]
    type = StressDivergenceTensors
    component =0
    variable =disp_x
    save_in = 'resid_x'
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

  end_time = 20.
  dtmin = 1.0e-6
  #num_steps = 10
  nl_abs_step_tol = 1e-2
  nl_rel_step_tol = 1e-2
  nl_rel_tol = 1e-4
[]

[Outputs]
  exodus = true
  vtk = true
[]

