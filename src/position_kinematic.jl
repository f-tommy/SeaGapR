#using DelimitedFiles
#using Statistics

export position_kinematic
"""
    position_kinematic(;fn,weight,fno)

Caclulate simple statistical values for the positioning results of `kinematic_array()`

* `fn`: Input file (`fn="array_kinematic.out"` by default)
* `fno`: Output file with the format (1: Mean time [sec], 2: Mean EW position [m], 3: Mean NS position [m], 4: UD position [m](Not Available), 5: Std of EW position [m], 6: Std of NS position [m], Std of UD position [m](Not Available); the default is `fno="position_kinematic.out"`. 
* `weight`: If `weight=true`, weighted mean position is calculated using the shot groups with number of shot data for each group >= 4 (`weight=false` by default).

# Example
  position_kinematic(weight=true)

"""

function position_kinematic(;fn="kinematic_array.out",weight=false,fno="position_kinematic.out")
  N, M, dat0 = read_matrix(fn)
  if weight == true
    dat = dat0[dat0[:,2].>=4,:]
    N = size(dat)[1]
    println(stderr,"  Shot for each group >=4: $N")
    t = mean(dat[:,1])
    dx = dat[:,3]; sx = dat[:,6].^(-2)
    dy = dat[:,4]; sy = dat[:,7].^(-2)
    x = sum(sx.*dx)/sum(sx)
    y = sum(sy.*dy)/sum(sy)
    dx = std(dx,mean=x)
    dy = std(dy,mean=y)
  else
    dat = dat0
    t = mean(dat[:,1])
    x = mean(dat[:,3])
    y = mean(dat[:,4])
    dx = std(dat[:,3],mean=x)
    dy = std(dat[:,4],mean=y) 
  end
  println(stderr,"$t $x $y NA $dx $dy NA")
  open(fno,"w") do out
    println(out,"$t $x $y NA $dx $dy NA")
  end
end
    
  
