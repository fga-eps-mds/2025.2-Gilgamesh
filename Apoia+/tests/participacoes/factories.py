import factory
from participacoes.models import Participacao
# Importando factories de outros módulos para criar as relações
from tests.autenticacao.factories import UsuarioFactory
from tests.eventos.factories import EventoFactory

class ParticipacaoFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Participacao

    # Cria as chaves estrangeiras automaticamente
    usuario = factory.SubFactory(UsuarioFactory)
    evento = factory.SubFactory(EventoFactory)
    status_confirmacao = 'pendente'