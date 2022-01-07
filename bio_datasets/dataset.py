from pathlib import Path
from typing import Union

import pandas as pd
import srsly
import torch.utils.data as tc

__all__ = [
    'Dataset'
]


class Dataset(tc.Dataset):
    _annotations: dict
    _data: pd.DataFrame

    def __init__(self, data: pd.DataFrame, annotations: dict):
        self._data = data
        self._annotations = annotations

    def __repr__(self):
        return repr(self._data)

    def __len__(self) -> int:
        return len(self._data)

    def __getitem__(self, item: int) -> dict:
        record = self._data.iloc[item]

        return dict(record)

    @classmethod
    def load(cls, identifier: Union[str, Path]) -> "Dataset":
        pass

    def save(self, path: Union[str, Path]) -> None:
        if isinstance(path, str):
            path = Path(path)

        path.mkdir(parents=True, exist_ok=True)
        srsly.write_jsonl(path / 'data.jsonl', self._data.to_dict(orient='records'))
        srsly.write_json(path / 'annotations.json', self._annotations)

    @property
    def annotations(self) -> dict:
        return self._annotations
