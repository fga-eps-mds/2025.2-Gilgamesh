import factory
from participacoes.models import Participacao
from tests.autenticacao.factories import UsuarioFactory
from tests.eventos.factories import EventoFactory

class ParticipacaoFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Participacao

    # CORREÇÃO: Renomeado de 'usuario' para 'voluntario' (igual ao Model)
    voluntario = factory.SubFactory(UsuarioFactory)
    evento = factory.SubFactory(EventoFactory)
    
    # CORREÇÃO: Removido 'status_confirmacao' (campo inexistente no Model)
