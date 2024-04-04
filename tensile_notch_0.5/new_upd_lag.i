#https://mooseframework.inl.gov/source/materials/lagrangian/ComputeStVenantKirchhoffStress.html
#https://mooseframework.inl.gov/source/kernels/lagrangian/UpdatedLagrangianStressDivergence.html

# Simple 3D test
[Mesh]
  file = notch_0.5.inp
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
[]

[Kernels]
  [sdx]
    type = UpdatedLagrangianStressDivergence
    variable = disp_x
    displacements = 'disp_x disp_y disp_z'
    component = 0
    use_displaced_mesh = true
    large_kinematics = true
  []
  [sdy]
    type = UpdatedLagrangianStressDivergence
    variable = disp_y
    displacements = 'disp_x disp_y disp_z'
    component = 1
    use_displaced_mesh = true
    large_kinematics = true
  []
  [sdz]
    type = UpdatedLagrangianStressDivergence
    variable = disp_z
    displacements = 'disp_x disp_y disp_z'
    component = 2
    use_displaced_mesh = true
    large_kinematics = true
  []
[]

[AuxVariables]
  [strain_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [strain_yy]
    order = CONSTANT
    family = MONOMIAL
  []
  [strain_zz]
    order = CONSTANT
    family = MONOMIAL
  []
  [strain_xy]
    order = CONSTANT
    family = MONOMIAL
  []
  [strain_xz]
    order = CONSTANT
    family = MONOMIAL
  []
  [strain_yz]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_yy]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_zz]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_xy]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_yz]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_xz]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [stress_xx]
    type = RankTwoAux
    rank_two_tensor = cauchy_stress
    variable = stress_xx
    index_i = 0
    index_j = 0
    execute_on = timestep_end
  []
  [stress_yy]
    type = RankTwoAux
    rank_two_tensor = cauchy_stress
    variable = stress_yy
    index_i = 1
    index_j = 1
    execute_on = timestep_end
  []
  [stress_zz]
    type = RankTwoAux
    rank_two_tensor = cauchy_stress
    variable = stress_zz
    index_i = 2
    index_j = 2
    execute_on = timestep_end
  []
  [stress_xy]
    type = RankTwoAux
    rank_two_tensor = cauchy_stress
    variable = stress_xy
    index_i = 0
    index_j = 1
    execute_on = timestep_end
  []
  [stress_xz]
    type = RankTwoAux
    rank_two_tensor = cauchy_stress
    variable = stress_xz
    index_i = 0
    index_j = 2
    execute_on = timestep_end
  []
  [stress_yz]
    type = RankTwoAux
    rank_two_tensor = cauchy_stress
    variable = stress_yz
    index_i = 1
    index_j = 2
    execute_on = timestep_end
  []

  [strain_xx]
    type = RankTwoAux
    rank_two_tensor = mechanical_strain
    variable = strain_xx
    index_i = 0
    index_j = 0
    execute_on = timestep_end
  []
  [strain_yy]
    type = RankTwoAux
    rank_two_tensor = mechanical_strain
    variable = strain_yy
    index_i = 1
    index_j = 1
    execute_on = timestep_end
  []
  [strain_zz]
    type = RankTwoAux
    rank_two_tensor = mechanical_strain
    variable = strain_zz
    index_i = 2
    index_j = 2
    execute_on = timestep_end
  []
  [strain_xy]
    type = RankTwoAux
    rank_two_tensor = mechanical_strain
    variable = strain_xy
    index_i = 0
    index_j = 1
    execute_on = timestep_end
  []
  [strain_xz]
    type = RankTwoAux
    rank_two_tensor = mechanical_strain
    variable = strain_xz
    index_i = 0
    index_j = 2
    execute_on = timestep_end
  []
  [strain_yz]
    type = RankTwoAux
    rank_two_tensor = mechanical_strain
    variable = strain_yz
    index_i = 1
    index_j = 2
    execute_on = timestep_end
  []
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
    function = 't*10.0e-3'
  [../]
[]


[Materials]
  [./fplastic]
    type = FiniteStrainPlasticMaterial
    #block=0
    #yield_stress='0. 445.e6 0.05 610.e6 0.1 680.e6 0.38 810.e6 0.95 920.0e6 2. 950.0e6'
    yield_stress='0. 270.e6 0.05 300.e6 0.1 310.e6 0.95 310.0e6 2. 310.0e6'
  [../]
  [elastic_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 210.0e9
    poissons_ratio = 0.3
  []
  [compute_stress]
    type = ComputeLagrangianLinearElasticStress
    large_kinematics = true
  []
  [compute_strain]
    type = ComputeLagrangianStrain
    displacements = 'disp_x disp_y disp_z'
    large_kinematics = true
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient

  dt=0.01
  dtmax=1
  dtmin=1.0e-5
  end_time=1.0

  solve_type = 'newton'

  petsc_options_iname = -pc_type
  petsc_options_value = lu

  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-10



[]

[Outputs]
  exodus = true
[]