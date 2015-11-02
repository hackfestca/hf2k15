
import ClientController
import logging
import sys

class ModelController(ClientController.ClientController):
    def initLogging(self):
        self.logger = logging.getLogger("model_logger")
        self.logger.setLevel(logging.INFO)

        formatter = logging.Formatter('%(asctime)s - %(message)s')

        ch = logging.StreamHandler(sys.stdout)
        ch.setLevel(logging.INFO)
        ch.setFormatter(formatter)

        info_file = logging.FileHandler("controller.log", encoding="utf-8")
        info_file.setLevel(logging.INFO)
        info_file.setFormatter(formatter)

        self.logger.addHandler(ch)
        self.logger.addHandler(info_file)

