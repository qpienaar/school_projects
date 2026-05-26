# MS Research: Comparison of Mesh Based and CSG based Particle Transport Simulations

## Overview

Particle transport simulations in the Nuclear community broadly rely on Constructive Solid Geometry (CSG) modeling
regimes. Although these regimes offer cheap particle localization computations, they prove a bottleneck for complex
geometry construction often demanded in next generation nuclear reactors. PUMI PIC, 
offers the capability for GPU accelerated particle transport simulations based on boundary repersentation (BREP) geometry. My ongoing research
seeks to develop a robust pipeline to convert CSG geometry to BREP geometry, before conducting a thorough analysis
on performance and accuracy discrepancies between BREP mesh based particle transport simulations and traditional CSG based simulations.

## Research Questions

- What are the performance and accuracy tradeoffs between conducting particle transport simulations on CSG based geometry and BREP basded geometry?
- Can a robust pipeline be constructed which can move from a CSG based geometry, to a BREP based geometry and simulation?

## Technical Approach

1. Develop a reliable method to convert from CSG geometry to BREP geometry
2. Develop a suite of test geometries which are equivallently repersented in CSG and BREP
3. Conduct equivalent particle transport simulations with traditional CSG based methods and GPU accelerated BREP based methods
4. Analyze performance and accuracy discrepancies between CSG based simulations and BREP based simulations
5. Compile findings into a thesis report

## Tools

1. Conversion utility  https://geouned-org.github.io/GEOUNED/dev/index.html
2. Meshing             https://www.simmetrix.com/index.php/about-us
3. BREP simulation     https://github.com/SCOREC/pumi-pic

## Results

Check back later for results!

## Contributions

- Check back later for contributions!
  
## Publications And Presentations

- Check back later for Publications and Presentations!

## Acknowledgments

Dr. Jacob Merson, Center for Scientific Computation (SCOREC): https://scorec.rpi.edu/
