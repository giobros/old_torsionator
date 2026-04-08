#!/bin/bash
set -euo pipefail

unset PYTHONPATH

# ---------------- USER SETTINGS ----------------
PDB_FILE_NAME_ROOT="NAME"        # CHANGE THIS! file NAME of your PDB file, without .pdb
PDB_FILE_DIR="your_folder_path"  # CHANGE THIS! folder (full path) that contains $PDB_FILE_NAME_ROOT.pdb
METHOD="all"                     # "all" | "mace" | "obi", NN calculator to use (default: obi)
DIHEDRAL="all"                   # "all" | "[a,b,c,d]" | "print" (0-based indices): "all" to scan all rotatable bonds; "print" to list them; "[a,b,c,d]" for a specific one.
CONF_ANALYSIS="false"            # "true" | "false" | "none", "false" → scan minimized input even if clashes exist; "true"  → generate conformers and use a clash-free starting geometry
BCS="false"                      # "true" | "false" | "none", "false" → abort; "true" → use the conformer with lowest LJ energy.
MCS="true"                       # "true" | "false" | "none", "true"→  find lower-energy conformations per angle 
N_CONF=20                        # number of conformers
RMSD=0.5                         # RMSD pruning threshold
MULTIPLICITY=6                   # max expantion multiplicity (0 to keep the GAFF2 original one)
STEP_SIZE=10                     # scan steps (5,10,15,20)
DOUBLE_ROTATION="true"           # "true" | "false" | "none", false" →  just clockwise (cw), "true" →  both clockwise (cw) counterclockwise (ccw) scan when MCS=true; "
# ------------------------------------------------
# use apptainer or singularity 

apptainer exec \
  --nv \
  --bind "../torsionator:/torsionator" \
  --bind "${PDB_FILE_DIR}":/data" \
  --env PYTHONPATH=/ \
  --env HOME=/root \
  torsionator.sif \
  python3.9 -m torsionator.cli \
    --pdb "/data/${PDB_FILE_NAME_ROOT}.pdb" \
    --method "$METHOD" \
    --dihedral "$DIHEDRAL" \
    --conf_analysis "$CONF_ANALYSIS" \
    --BCS "$BCS" \
    --MCS "$MCS" \
    --n_confs "$N_CONF" \
    --RMSD "$RMSD" \
    --multiplicity "$MULTIPLICITY" \
    --step_size "$STEP_SIZE" \
    --double_rotation "$DOUBLE_ROTATION"
