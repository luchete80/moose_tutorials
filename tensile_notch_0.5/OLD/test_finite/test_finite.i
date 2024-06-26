# (modules/solid_mechanics/test/tests/finite_strain_elastic/finite_strain_elastic_new_test.i)
#https://mooseframework.inl.gov/source/kernels/StressDivergenceTensors.html

[Mesh]
  type = GeneratedMesh
  dim = 3
  elem_type = HEX8
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
  [./symmy]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0
  [../]
  [./symmx]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0
  [../]
  [./symmz]
    type = DirichletBC
    variable = disp_z
    boundary = back
    value = 0
  [../]
  [./tdisp]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = front
    function = tdisp
  [../]
[]

[Materials]
  [fplastic]
      type = FiniteStrainPlasticMaterial
      yield_stress = '0 0.2e-6 0.8 0.2e-6'
  []
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    C_ijkl = '1.684e5 0.176e5 0.176e5 1.684e5 0.176e5 1.684e5 0.754e5 0.754e5 0.754e5'
    fill_method = symmetric9
  [../]
#  [./stress]
#    type = ComputeFiniteStrainElasticStress
#  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  dt = 0.05

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = -pc_hypre_type
  petsc_options_value = boomeramg
  nl_abs_tol = 1e-10
  nl_rel_step_tol = 1e-10
  dtmax = 10.0
  nl_rel_tol = 1e-10
  end_time = 1
  dtmin = 0.05
  num_steps = 10
  nl_abs_step_tol = 1e-10
[]

[Outputs]
  exodus = true
[]

