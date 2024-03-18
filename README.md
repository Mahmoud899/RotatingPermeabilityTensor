# Rotating the Permeability Tensor

Hello,

Reservoir Permeability is often taught as a scalar field. A single value defined for every point in space. However, the permeability is a tensor field. It is a rank two 3-dimensional tensor. 
But what is a tensor? 


 A tensor can be defined in many ways depending on the context and the extent of understanding needed to feel comfortable using that concept. It can be defined as an array, 
 or a geometrical entity that transforms nicely under coordinate transformations, using tensor transformations rule. 
I like to think of it that way, a tensor is a mathematical entity that enables us to describe physical properties and derive equations of the laws physics. 
Examples of tensors are the stress tensor or the electromagnetic tensor. Tensors are like numbers and vectors; tensors are just a bit abstract. Just like vector components, 
tensor components depend on the choice of coordinate system. They transform nicely, under tensor transformation rule.


In the context of reservoir engineering, the permeability tensor is the term in Darcy’s equation that describes the ability of a rock to transmit fluids under pressure gradients. 
It’s like the electrical conductivity of matter. The permeability tensor can be written as a symmetric 2*2matrix in 2D and 3*3 matrix in 3D. 
Which poses questions, are tensors just matrices? Why symmetric?

The anisotropy of the reservoir, the preferred directions of flow, is encoded in the permeability tensor. The permeability tensor can be written as Kij.

Kij : the ability of the rock to transmit fluids in the i direction under a pressure gradient in the j direction.
 
As I said, the tensor components depend on the coordinate system, those Kij will change if we for instance rotate the coordinate basis. Because the permeability tensor is symmetric, it can be diagonalized, as a result of the famous Spectral Theorem. There is a set of basis, the eigen vectors of the permeability matrix, in which the permeability tensor can be written as a diagonal matrix, the diagonal elements are the eigen values of that matrix. It is like the principal stresses or finding the principal components in the context of Machine Learning.
An isotropic reservoir is defined as the one in which all the diagonal elements of the diagonalized permeability tensor are equal. Just like the definition of isotropy in any context.


I ran a 2D Quarter Five Spot simulation using MRST on MATLAB to show the effect of the orientation of the injector and producer relative to the permeability tensor principal directions. 
Initially, the permeability tensor is diagonalized with Kx = 20 md and Ky = 2500 md. The difference is exaggerated to demonstrate the effect. Then I rotated the permeability tensor by 15, 30 and 45 degrees.
