import pytest
from tests.participacoes.factories import ParticipacaoFactory

@pytest.mark.django_db
class TestParticipacaoModel:
    
    def test_criar_participacao(self):
        participacao = ParticipacaoFactory()
        assert participacao.id is not None
        assert participacao.usuario.email is not None
        assert participacao.evento.nome is not None
        assert participacao.status_confirmacao == 'pendente'

    def test_representacao_string(self):
        """
        ATENÇÃO: Este teste espera que você tenha corrigido o bug do .titulo para .nome
        no models.py de participacoes.
        """
        participacao = ParticipacaoFactory(
            usuario__nome="Maria",
            evento__nome="Python Workshop",
            status_confirmacao="confirmado"
        )
        expected = "Maria - Python Workshop (confirmado)"
        assert str(participacao) == expected