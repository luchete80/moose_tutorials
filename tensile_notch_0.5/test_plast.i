[Mesh]
  file = notch_0.5.inp
[]

[Variables]
  [./x_disp]
    order = FIRST
    family = LAGRANGE
  [../]
  [./y_disp]
    order = FIRST
    family = LAGRANGE
  [../]
  [./z_disp]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [SolidMechanics]
    displacements = 'x_disp y_disp z_disp'
    use_displaced_mesh = true
  [../]
[]

## This is where mesh adaptivity magic happens
[Adaptivity]
  steps = 1
  max_h_level = 3
  cycles_per_step = 1
  initial_marker = uniform
  marker = errorFraction
  [Markers]
    [uniform]
      #block = 1
      type = UniformMarker
      mark = refine
    []
    [errorFraction]
      type = ErrorFractionMarker
      coarsen = 0.5
      indicator = gradientJump
      refine = 0.5
    []
  []

  [Indicators]
    [gradientJump]
      type = GradientJumpIndicator
      variable = x_disp
    []
  []
[]

#[Physics/SolidMechanics/QuasiStatic]
  #[./block1]
  #displacements = 'x_disp y_disp z_disp'
  #strain = SMALL #Small linearized strain, automatically set to XY coordinates
  #add_variables = true #Add the variables from the displacement string in GlobalParams
  #[../]
#[]

[Materials]
  [./fplastic]
    type = FiniteStrainPlasticMaterial
    #block=0
    #yield_stress='0. 445.e6 0.05 610.e6 0.1 680.e6 0.38 810.e6 0.95 920.0e6 2. 950.0e6'
    yield_stress='0. 270.e6 0.05 300.e6 0.1 310.e6 0.95 310.0e6 2. 310.0e6'
  [../]
  #[./elasticity_tensor]
  #  type = ComputeElasticityTensor
    ##block = 0
  #  C_ijkl = '2.827e5 1.21e5 1.21e5 2.827e5 1.21e5 2.827e5 0.808e5 0.808e5 0.808e5'
  #  fill_method = symmetric9
  #[../]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 210.0e9
    poissons_ratio = 0.3
  [../]
  [./strain]
    type = ComputeFiniteStrain
    #block = 0
    displacements = 'x_disp y_disp z_disp'
  [../]
[]

[Functions]
  [./topfunc]
    type = ParsedFunction
    expression = 't'
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = x_disp
    boundary = left
    value = 0.0
  [../]
  [./back]
    type = DirichletBC
    variable = z_disp
    boundary = back
    value = 0.0
  [../]
  [./bottom]
    type = DirichletBC
    variable = y_disp
    boundary = bottom
    value = 0.0
  [../]
  [./right]
    type = FunctionDirichletBC
    variable = x_disp
    boundary = right
    function = 't*10.0e-3'
  [../]

#  [./right]
#    type = DirichletBC
#    variable = x_disp
#    boundary = right
#    #value = 0.0001
#    #displacements = 'x_disp'
#    function = 't*10.0e-3'
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
  [./SMP]
   type = SMP
   full=true
  [../]
[]

[Executioner]
  type = Transient

  dt=0.001
  dtmax=1
  dtmin=1.0e-5
  end_time=1.0

  nl_abs_tol = 1e-3
[]


[Outputs]
  file_base = out
  exodus = true
  #interval = 1
[]
