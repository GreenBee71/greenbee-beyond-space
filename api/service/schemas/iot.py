from pydantic import BaseModel
from typing import Optional, Dict, List
from datetime import datetime

class IoTDeviceBase(BaseModel):
    device_name: str
    device_type: str # LIGHT, AC, TV, etc.
    provider_name: str # SAMSUNG, LG, etc.
    connection_config: Dict # JSON payload for keys/tokens

class IoTDeviceCreate(IoTDeviceBase):
    pass

class IoTDeviceRead(IoTDeviceBase):
    id: int
    user_id: int
    is_active: bool
    last_seen: Optional[datetime] = None
    created_at: datetime

    class Config:
        from_attributes = True

class IoTDeviceUpdate(BaseModel):
    device_name: Optional[str] = None
    is_active: Optional[bool] = None
    connection_config: Optional[Dict] = None

class IoTScenarioActionBase(BaseModel):
    device_id: int
    target_state: Dict

class IoTScenarioActionRead(IoTScenarioActionBase):
    id: int
    class Config:
        from_attributes = True

class IoTScenarioCreate(BaseModel):
    name: str
    icon: str
    actions: List[IoTScenarioActionBase]

class IoTScenarioRead(BaseModel):
    id: int
    name: str
    icon: str
    is_active: bool
    actions: List[IoTScenarioActionRead]
    created_at: datetime

    class Config:
        from_attributes = True
