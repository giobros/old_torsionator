from dataclasses import dataclass
from mace.calculators import mace_off
from ase.calculators.obi import Obiwan


@dataclass
class CalculatorFactory:
    obiwan_path: str

    def get(self, method: str):
        """Return (ase_calculator, label) for 'mace' or 'obi'."""
        if method == "mace":
            return mace_off(model="medium", device="cuda"), "mace"
        if method == "obi":
            model_path = f"{self.obiwan_path}/obiwan_ani1Uani2_FH_VL_2.404"
            return Obiwan(model_path=model_path), "obi"
        raise ValueError(f"Unknown method: {method!r}")

    def label(self, method: str) -> str:
        labels = {"mace": "mace", "obi": "obi"}
        if method not in labels:
            raise ValueError(f"Unknown method: {method!r}")
        return labels[method]
