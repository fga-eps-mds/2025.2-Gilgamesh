import pytest
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from tests.autenticacao.factories import UsuarioFactory

# Fixture global
@pytest.fixture
def api_client():
    return APIClient()

@pytest.mark.django_db
class TestLoginView:
    
    def test_login_sucesso(self, api_client):
        # Configura usuário com senha conhecida
        email = "teste@login.com"
        senha_plana = "SenhaForte123"
        user = UsuarioFactory(email=email)
        user.set_password(senha_plana)
        user.save()
        
        # Payload EXATO conforme seu código (views.py:22-23)
        data = {
            "email": email, 
            "senha": senha_plana 
        }
        
        url = reverse('login')
        response = api_client.post(url, data)
        
        assert response.status_code == status.HTTP_200_OK
        assert 'token' in response.data

    def test_login_senha_incorreta(self, api_client):
        """Cobre a linha 49 (else: Credenciais inválidas)"""
        email = "teste@erro.com"
        user = UsuarioFactory(email=email)
        user.set_password("SenhaCerta")
        user.save()
        
        data = {
            "email": email, 
            "senha": "SENHA_ERRADA"
        }
        url = reverse('login')
        response = api_client.post(url, data)
        assert response.status_code == status.HTTP_401_UNAUTHORIZED
        assert response.data['erro'] == 'Credenciais inválidas'

    def test_login_email_inexistente(self, api_client):
        """Também cobre a linha 49 (usuário None)"""
        data = {
            "email": "fantasma@exemplo.com", 
            "senha": "123"
        }
        url = reverse('login')
        response = api_client.post(url, data)
        assert response.status_code == status.HTTP_401_UNAUTHORIZED

    def test_login_campos_faltando(self, api_client):
        """Cobre linha 26 (if not email or not senha)"""
        url = reverse('login')
        # Envia vazio
        response = api_client.post(url, {})
        assert response.status_code == status.HTTP_400_BAD_REQUEST

    def test_logout_sucesso(self, api_client):
        usuario = UsuarioFactory(email="sair@teste.com")
        api_client.force_authenticate(user=usuario)
        url = reverse('logout')
        response = api_client.post(url)
        assert response.status_code == status.HTTP_200_OK


@pytest.mark.django_db
class TestPerfilUsuarioView:
    
    @pytest.fixture
    def usuario(self):
        return UsuarioFactory(nome="Original", uf="DF")

    def test_obter_dados_usuario(self, api_client, usuario):
        api_client.force_authenticate(user=usuario)
        url = reverse('usuario')
        response = api_client.get(url)
        assert response.status_code == status.HTTP_200_OK
        assert response.data['nome'] == "Original"

    def test_atualizar_usuario_sucesso(self, api_client, usuario):
        api_client.force_authenticate(user=usuario)
        url = reverse('usuario')
        data = {"nome": "Novo Nome", "telefone": "99999999"}
        response = api_client.put(url, data)
        assert response.status_code == status.HTTP_200_OK
        usuario.refresh_from_db()
        assert usuario.nome == "Novo Nome"

    def test_atualizar_usuario_erro_validacao(self, api_client, usuario):
        api_client.force_authenticate(user=usuario)
        url = reverse('usuario')
        data = {"uf": "SPP"} # Inválido (max 2 chars)
        response = api_client.put(url, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST


@pytest.mark.django_db
class TestAlterarSenhaView:

    @pytest.fixture
    def usuario(self):
        u = UsuarioFactory()
        u.set_password("SenhaAntiga123")
        u.save()
        return u

    def test_alterar_senha_sucesso(self, api_client, usuario):
        api_client.force_authenticate(user=usuario)
        url = reverse('alterar-senha')
        
        data = {
            "senha_atual": "SenhaAntiga123",
            "nova_senha": "NovaSenha123",
            "confirma_senha": "NovaSenha123"
        }
        
        response = api_client.post(url, data)
        assert response.status_code == status.HTTP_200_OK

    def test_alterar_senha_campos_vazios(self, api_client, usuario):
        """Cobre linha 144: if not senha_atual..."""
        api_client.force_authenticate(user=usuario)
        url = reverse('alterar-senha')
        data = {"nova_senha": "123"} # Faltam campos
        response = api_client.post(url, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert 'Todos os campos são obrigatórios' in response.data['erro']

    def test_alterar_senha_atual_incorreta(self, api_client, usuario):
        """Cobre linha 150: if not check_password..."""
        api_client.force_authenticate(user=usuario)
        url = reverse('alterar-senha')
        data = {
            "senha_atual": "Errada",
            "nova_senha": "Nova",
            "confirma_senha": "Nova"
        }
        response = api_client.post(url, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert 'Senha atual incorreta' in response.data['erro']

    def test_alterar_senha_divergente(self, api_client, usuario):
        """Cobre linha 156: if nova != confirma..."""
        api_client.force_authenticate(user=usuario)
        url = reverse('alterar-senha')
        data = {
            "senha_atual": "SenhaAntiga123",
            "nova_senha": "SenhaA",
            "confirma_senha": "SenhaB"
        }
        response = api_client.post(url, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert 'As novas senhas não coincidem' in response.data['erro']

    def test_senha_nova_igual_atual(self, api_client, usuario):
        """Cobre linha 162: if atual == nova..."""
        api_client.force_authenticate(user=usuario)
        url = reverse('alterar-senha')
        data = {
            "senha_atual": "SenhaAntiga123",
            "nova_senha": "SenhaAntiga123",
            "confirma_senha": "SenhaAntiga123"
        }
        response = api_client.post(url, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert 'A nova senha deve ser diferente da atual' in response.data['erro']

    def test_senha_curta(self, api_client, usuario):
        """Cobre linha 168: if len < 6..."""
        api_client.force_authenticate(user=usuario)
        url = reverse('alterar-senha')
        data = {
            "senha_atual": "SenhaAntiga123",
            "nova_senha": "123",
            "confirma_senha": "123"
        }
        response = api_client.post(url, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert 'A senha deve ter no mínimo 6 caracteres' in response.data['erro']
