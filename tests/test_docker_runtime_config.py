from pathlib import Path

import yaml


def test_compose_sets_keep_alive_env_default_on():
    compose_path = Path(__file__).resolve().parents[1] / "docker-compose.yml"
    compose = yaml.safe_load(compose_path.read_text(encoding="utf-8"))
    env = compose["services"]["researchclaw"]["environment"]
    assert "RC_KEEP_ALIVE=${RC_KEEP_ALIVE:-1}" in env


def test_dockerfile_uses_wrapper_entrypoint():
    dockerfile_path = Path(__file__).resolve().parents[1] / "Dockerfile"
    dockerfile = dockerfile_path.read_text(encoding="utf-8")
    assert 'ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]' in dockerfile
