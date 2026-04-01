# Torsionator                                    <img width="133" height="133" alt="logo" src="https://github.com/user-attachments/assets/6a7e153c-b390-4fd2-9eb4-f4c881702db1" />

## 1. **Overview** <br>
Torsionator is an end‑to‑end pipeline for dihedral scans and torsion parameter fitting. It minimizes an input PDB using ML force fields (OBI/MACE), screens for steric clashes, optionally explores RDKit conformers, performs constrained scans, and fits torsional terms with AMBERTools' progam mdgx, finally writing an updated frcmod.<br>

<img width="8285" height="6592" alt="Picture6" src="https://github.com/user-attachments/assets/1fef060d-e89c-4ff0-b222-cbb759c66ebe" />


## 2. **Instalaltion**

   
**Requirements** <br>
- Apptainer ≥ 1.x installed <br>
- NVIDIA GPU (optional) and host NVIDIA drivers; use --nv if you want GPU acceleration <br>
- <your_folder> on the host that will be bind‑mounted as '/data' inside the container <br>

**Clone the repository**<br>
First clone the repo and then move into the top-level directory of the package.<br>
```
git clone https://github.com/giobros/torsionator.git
```

**Build the image**<br>
All the dependencies can be loaded together using the torsionator.sif generated with the .def file and Apptainer.
Enter the folder container and lunch the file .sh to create the image
```
cd torsionator/container
sudo apptainer build torsionator.sif torsionator.def
```

## 3 **Prepare your host work directory**<br>
Place your pdb input and script inside a host directory that you’ll bind to /data, e.g.:
```
/$HOME/<your_folder>/
└── <ROOT>.pdb # your input structure
```

## 4 **Run (detached, with GPU)**<br>
The user can change and use the script run.sh inside the container folder to select which options apply to the scanning.
The modification needed are:
 - change the folder name *your_folder* with the actual folder name in --bind "$HOME/<your_folder>:/data" and the pdb *ROOT* in flag --pdb /data/<ROOT>.pdb 
 - change the scanning options:
```
   --method all|mace|obi \
   --dihedral all|[a,b,c,d]|print \
   --conf_analysis true|false \
   --BCS true|false \
   --MCS true|false \
   --n_confs \
   --RMSD \
   --multiplicity \
   --step_size \
   --double_rotation true|false \ (if MCS = true)
```
Suggestion: print the dihedrals before passing the wanted one, the code should recognize your input but my suggestion is to check the code-preferred dihedral definition.

## 5. **Where outputs are written**<br>
By default the script uses BASE_DIR = "/data"
You will find results under the following directories on the host inside your bound folder:

If BCS=true
```
/<your_folder>/
├── conformers/
│   ├── pdb/*.pdb 
│   └── method/
│      ├── initial_energies.txt
│      ├── optimized_energies.txt
│      ├── sorted_energies.txt
│      ├── min_energy.txt
│      ├── xyz/
│      └── *.pdb  
│   
├── scanning/
│     └── a_b_c_d/
│       ├── method/
│       │   ├── geometries.xyz
│       │   ├── angles_vs_energies.txt
│       │   ├── angles_vs_energies_final.txt   # sorted & min-shifted
│       │   ├── energies.dat                   # single-column, Hartree, min=0 
│       │   ├── scan_pdbs/*.pdb
│       │   └── output                       # MDGX torsion fit
│       │         └──hrst/hrst.dat
│       ├── GAFF2/old/method/           ← old GAFF2 fit
│       ├── GAFF2/new/method/  
│       └── a_b_c_d.png                        # plotted profile (kcal/mol)
└── parameters/<ROOT>_<method>.frcmod  # frcmod with updated DIHE lines


```
If MCS = true:
```
/<your_folder>/
├── conformers/
│   ├── pdb/*.pdb 
│   └──  method/      
│        └── n_confs folders/minimized.pdb  
├── scanning/
│     └── a_b_c_d/
│       ├── method/                     
│       │   ├── n_confs folders (+ n_confs_ccw)/scan_pdbs/*.pdb
│       │   └──  MCS/
│       │       ├── angles_vs_energies_final.txt   # sorted & min-shifted
│       │       ├── geometries.xyz
│       │       ├── energies.dat
│       │       └── output                       # MDGX torsion fit
│       │         └──hrst/hrst.dat
│       ├── GAFF2/old/method/           ← old GAFF2 fit
│       ├── GAFF2/new/method/  
│       └── a_b_c_d_MCS.png                        # plotted profile (kcal/mol)
└── parameters/<ROOT>_<method>.frcmod  # frcmod with updated DIHE lines


```
The workflow togheter with the errors are written to:
```
/data/workflow.log
```
