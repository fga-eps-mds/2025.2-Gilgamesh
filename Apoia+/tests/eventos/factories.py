import factory
from django.utils import timezone
from eventos.models import Evento
# IMPORTANTE: Agora usamos sua factory personalizada, não o User do Django
from tests.autenticacao.factories import UsuarioFactory

class EventoFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Evento

    nome = factory.Faker('catch_phrase')
    descricao = factory.Faker('text')
    data_inicio = factory.LazyFunction(timezone.now)
    local = "UnB - Campus Darcy Ribeiro"
    
    # Conecta com o novo model de usuário
    criado_por = factory.SubFactory(UsuarioFactory)