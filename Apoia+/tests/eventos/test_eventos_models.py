import pytest
from tests.eventos.factories import EventoFactory

@pytest.mark.django_db
class TestEventoModel:
    
    def test_representacao_string(self):
        # CORREÇÃO: titulo
        evento = EventoFactory(titulo="Doação - Vestimentas")
        assert str(evento) == "Doação - Vestimentas"

    def test_criacao_evento(self):
        evento = EventoFactory()
        assert evento.id is not None
        # CORREÇÃO: Verifica titulo
        assert evento.titulo is not None
        assert evento.criado_por is not None
