#!/bin/bash
set -euo pipefail

unset PYTHONPATH

# ---------------- USER SETTINGS ----------------

ROOT="ROOT"                     # CHANGE THIS! name of your PDB, without .pdb
DATA_DIR="$HOME/your_folder"    # CHANGE THIS! folder that contains $ROOT.pdb

METHOD="all"                     # "all" | "mace" | "obi"
DIHEDRAL="all"                   # "all" | "[a,b,c,d]" | "print"  (0-based indices)
CONF_ANALYSIS="false"            # "true" | "false" | "none"
BCS="false"                      # "true" | "false" | "none"
MCS="true"                       # "true" | "false" | "none"
N_CONF=20                        # number of conformers
RMSD=0.5                         # RMSD pruning threshold
MULTIPLICITY=6                   # max expantion multiplicity (0 to keep the GAFF2 original one)
SCAN_STEP=10                     # scan steps (5,10,15,20)
DOUBLE_ROTATION="true"           # "true" | "false" | "none", if true both clockwise (cw) and counterclockwise (ccw) scan when MCS=true
# ------------------------------------------------

apptainer exec \
  --nv \
  --bind "$HOME/torsionator/torsionator:/torsionator" \
  --bind "$DATA_DIR:/data" \
  --env PYTHONPATH=/ \
  --env HOME=/root \
  torsionator.sif \
  python3.9 -m torsionator.cli \
    --pdb "/data/${ROOT}.pdb" \
    --method "$METHOD" \
    --dihedral "$DIHEDRAL" \
    --conf_analysis "$CONF_ANALYSIS" \
    --BCS "$BCS" \
    --MCS "$MCS" \
    --n_confs "$N_CONF" \
    --RMSD "$RMSD" \
    --multiplicity "$MULTIPLICITY" \
    --scan_step "$SCAN_STEP" \
    --double_rotation "$DOUBLE_ROTATION"
