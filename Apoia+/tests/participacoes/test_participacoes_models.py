import pytest
from tests.participacoes.factories import ParticipacaoFactory

@pytest.mark.django_db
class TestParticipacaoModel:
    
    def test_criar_participacao(self):
        participacao = ParticipacaoFactory()
        assert participacao.id is not None
        # CORREÇÃO: O campo no model é 'voluntario', não 'usuario'
        assert participacao.voluntario.email is not None
        assert participacao.evento.titulo is not None
        # CORREÇÃO: O model atual não possui campo 'status_confirmacao', removido.

    def test_representacao_string(self):
        """
        Testa se o método __str__ do modelo retorna o formato esperado:
        'NomeVoluntario em NomeEvento'
        """
        participacao = ParticipacaoFactory(
            voluntario__nome="Maria",  # CORREÇÃO: usuario -> voluntario
            evento__titulo="Python Workshop"
            # CORREÇÃO: removido status_confirmacao
        )
        
        # O __str__ do model é: f"{self.voluntario.nome} em {self.evento.titulo}"
        expected = "Maria em Python Workshop" 
        
        assert str(participacao) == expected
