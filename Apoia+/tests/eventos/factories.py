import factory
from django.utils import timezone
from django.contrib.auth.models import User
from eventos.models import Evento

class DjangoUserFactory(factory.django.DjangoModelFactory):
    """Factory para o User padrão do Django usado pelo app Eventos"""
    class Meta:
        model = User

    username = factory.Sequence(lambda n: f'user_evento_{n}')
    email = factory.LazyAttribute(lambda o: f'{o.username}@exemplo.com')

class EventoFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Evento

    nome = factory.Faker('catch_phrase')
    descricao = factory.Faker('text')
    data_inicio = factory.LazyFunction(timezone.now)
    local = "UnB - Campus Darcy Ribeiro"
    criado_por = factory.SubFactory(DjangoUserFactory)