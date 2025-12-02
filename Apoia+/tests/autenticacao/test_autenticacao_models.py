import pytest
from tests.autenticacao.factories import UsuarioFactory
from autenticacao.models import Usuario  # <--- Adicionado para acessar o Manager

@pytest.mark.django_db
class TestUsuarioModel:
    
    def test_criar_usuario_com_sucesso(self):
        usuario = UsuarioFactory(nome="Ana", tipo_usuario="ong")
        assert usuario.id is not None
        assert usuario.email is not None
        assert usuario.tipo_usuario == "ong"

    def test_representacao_string(self):
        usuario = UsuarioFactory(nome="Carlos", tipo_usuario="admin")
        # O __str__ definido no models.py retorna: "{nome} ({tipo})"
        assert str(usuario) == "Carlos (Administrador)"

    def test_manager_criar_usuario(self):
        """Testa o create_user do manager (aumenta cobertura do models.py)"""
        user = Usuario.objects.create_user(
            email="normal@teste.com",
            nome="User Normal",
            password="123"
        )
        assert user.email == "normal@teste.com"
        assert user.is_staff is False
        assert user.check_password("123") # Verifica se a senha foi criptografada

    def test_manager_criar_superuser(self):
        """Testa o create_superuser do manager"""
        admin = Usuario.objects.create_superuser(
            email="admin@teste.com",
            nome="Admin User",
            password="123"
        )
        assert admin.is_staff is True
        assert admin.is_superuser is True
        assert admin.check_password("123")

    def test_manager_criar_usuario_sem_email(self):
        """Testa o erro ao tentar criar user sem email (Linha 9 do models.py)"""
        with pytest.raises(ValueError) as erro:
            Usuario.objects.create_user(email="", nome="Sem Email", password="123")
        assert str(erro.value) == "O email é obrigatório"

    def test_manager_superuser_sem_is_staff(self):
        """Testa o erro ao criar superuser com is_staff=False (Linha 23)"""
        with pytest.raises(ValueError) as erro:
            Usuario.objects.create_superuser(
                email="admin@teste.com", 
                nome="Admin", 
                password="123", 
                is_staff=False
            )
        assert str(erro.value) == "Superuser precisa ter is_staff=True."

    def test_manager_superuser_sem_is_superuser(self):
        """Testa o erro ao criar superuser com is_superuser=False (Linha 25)"""
        with pytest.raises(ValueError) as erro:
            Usuario.objects.create_superuser(
                email="admin@teste.com", 
                nome="Admin", 
                password="123", 
                is_superuser=False
            )
        assert str(erro.value) == "Superuser precisa ter is_superuser=True."
