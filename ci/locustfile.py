"""Нагрузочное тестирование Redfish API OpenBMC (Locust)."""
import urllib3
from locust import HttpUser, between, task

urllib3.disable_warnings()


class RedfishUser(HttpUser):
    host = "https://127.0.0.1:2443"
    wait_time = between(0.5, 1.5)

    def on_start(self):
        self.client.verify = False
        self.client.auth = ("root", "0penBmc")

    @task(3)
    def system(self):
        self.client.get("/redfish/v1/Systems/system", name="GET /Systems/system")

    @task(2)
    def chassis(self):
        self.client.get("/redfish/v1/Chassis/chassis", name="GET /Chassis/chassis")

    @task(2)
    def thermal(self):
        self.client.get("/redfish/v1/Chassis/chassis/ThermalSubsystem", name="GET /ThermalSubsystem")

    @task(1)
    def managers(self):
        self.client.get("/redfish/v1/Managers/bmc", name="GET /Managers/bmc")
