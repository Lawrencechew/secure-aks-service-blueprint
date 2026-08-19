import logging
import sys
import structlog


def configure_logging(level: str = "INFO"):
    logging.basicConfig(stream=sys.stdout, level=getattr(logging, level.upper(), logging.INFO))
    processors_list = [
        structlog.processors.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.JSONRenderer(),
    ]
    structlog.configure(
        processors=processors_list,
        logger_factory=structlog.stdlib.LoggerFactory(),
    )


logger = structlog.get_logger()
