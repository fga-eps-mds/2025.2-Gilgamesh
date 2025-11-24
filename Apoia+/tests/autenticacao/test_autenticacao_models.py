import pytest
from tests.autenticacao.factories import UsuarioFactory

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