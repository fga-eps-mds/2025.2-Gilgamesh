import factory
from django.contrib.auth.hashers import make_password
from autenticacao.models import Usuario

class UsuarioFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Usuario
        # Garante que se chamar a factory 2x com mesmo email, ele pega o existente
        django_get_or_create = ('email',)

    nome = factory.Faker('name', locale='pt_BR')
    email = factory.Sequence(lambda n: f'usuario{n}@exemplo.com')
    
    # O campo agora é 'password' (padrão do AbstractBaseUser) e não 'senha'
    password = factory.LazyFunction(lambda: make_password('senha_padrao_123'))
    
    tipo_usuario = 'voluntario'
    
    # O model exige UF e não pode ser nulo
    uf = 'DF'