# Data Directory

This directory is mounted to `/workspace/data` in the Docker container.

Place your input files here:

- PDB files (protein structures)
- SDF/MOL files (ligands)
- Configuration files
- Any other input data needed for docking

## Example file structure

```
data/
├── proteins/
│   ├── protein.pdb
│   └── protein.pdbqt
├── ligands/
│   ├── ligand.sdf
│   └── ligand.pdbqt
└── configs/
    └── config.txt
```
