import factory
from django.contrib.auth.hashers import make_password
from autenticacao.models import Usuario

class UsuarioFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Usuario

    nome = factory.Faker('name', locale='pt_BR')
    email = factory.Sequence(lambda n: f'usuario{n}@exemplo.com')
    # Gera o hash da senha automaticamente
    senha = factory.LazyFunction(lambda: make_password('senha_padrao_123'))
    tipo_usuario = 'voluntario'