[Mesh]
  file = notch_0.5.inp
[]

[GlobalParams]
  displacements = 'x_disp y_disp z_disp'
  large_kinematics = true
[]


[Physics/SolidMechanics/QuasiStatic]
  [./all]
  #displacements = 'x_disp y_disp z_disp'
  new_system = true
  #incremental = true
  add_variables = true
  strain = FINITE #Small linearized strain, automatically set to XY coordinates
  formulation = UPDATED
  volumetric_locking_correction = false
  #generate_output = 'vonmises_stress cauchy_stress_xx cauchy_stress_yy cauchy_stress_zz cauchy_stress_xy cauchy_stress_xz cauchy_stress_yz strain_xx strain_yy strain_zz strain_xy strain_xz strain_yz'

  [../]
[]

[Materials]
  #[./fplastic]
  #  type = FiniteStrainPlasticMaterial
    #block=0
    #yield_stress='0. 445.e6 0.05 610.e6 0.1 680.e6 0.38 810.e6 0.95 920.0e6 2. 950.0e6'
  #  yield_stress='0. 270.e6 0.05 300.e6 0.1 310.e6 0.95 310.0e6 2. 310.0e6'
  #[../]
  [stress]
      type = FiniteStrainPlasticMaterial
      yield_stress = '0 0.2e-6 0.8 0.2e-6'
  []
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
    #block = 
    displacements = 'x_disp y_disp z_disp'
  [../]

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
  nl_rel_tol = 1e-3
[]


[Outputs]
  file_base = out
  exodus = true
  #interval = 1
[]
