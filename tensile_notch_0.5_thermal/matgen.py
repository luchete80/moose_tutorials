n=0.65
A=175.e6
B=460.e6
points = 50
eps_max = 5.0
deps = eps_max/points

f = open("out.txt","w")
eps = 0.0

for i in range (points):
  sy = A+B*pow(eps,n)
  f.write("%.3e %.3e " % (eps, sy))
  eps += deps

f.close()
  
