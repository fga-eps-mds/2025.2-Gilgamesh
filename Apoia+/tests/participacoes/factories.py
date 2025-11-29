import factory
from participacoes.models import Participacao
from tests.autenticacao.factories import UsuarioFactory
from tests.eventos.factories import EventoFactory

class ParticipacaoFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Participacao

    # Usa a factory corrigida acima
    usuario = factory.SubFactory(UsuarioFactory)
    evento = factory.SubFactory(EventoFactory)
    
    status_confirmacao = 'pendente'