import pytest
from django.urls import reverse
from rest_framework import status
from tests.autenticacao.factories import UsuarioFactory

@pytest.mark.django_db
class TestLoginView:
    
    def test_login_sucesso(self, client):
        UsuarioFactory(email="teste@login.com")
        
        data = {
            "email": "teste@login.com",
            "senha": "senha_padrao_123" # A factory usa essa senha por padrão
        }
        # Certifique-se que o name='login' existe no seu urls.py
        url = reverse('login') 
        response = client.post(url, data)
        
        # Nota: Este teste pode falhar se o bug de segurança do views.py não for corrigido
        assert response.status_code == status.HTTP_200_OK

    def test_login_senha_incorreta(self, client):
        UsuarioFactory(email="teste@erro.com")
        
        data = {
            "email": "teste@erro.com",
            "senha": "SENHA_ERRADA"
        }
        url = reverse('login')
        response = client.post(url, data)
        
        assert response.status_code == status.HTTP_401_UNAUTHORIZED

    def test_login_email_inexistente(self, api_client):
        # Tenta logar com um email que nunca foi criado na Factory
        data = {"email": "fantasma@exemplo.com", "senha": "123"}
        url = reverse('login')
        response = api_client.post(url, data)
        
        # Deve retornar 401 (cai no except DoesNotExist)
        assert response.status_code == status.HTTP_401_UNAUTHORIZED

    def test_login_campos_faltando(self, api_client):
        # Envia dicionário vazio
        data = {} 
        url = reverse('login')
        response = api_client.post(url, data)
        
        # Deve retornar 400 Bad Request (cai no primeiro if)
        assert response.status_code == status.HTTP_400_BAD_REQUEST

    def test_logout_sucesso(self, api_client):
        # 1. Cria e Loga um usuário
        usuario = UsuarioFactory(email="sair@teste.com")
        api_client.force_authenticate(user=usuario)
        
        # 2. Chama a rota de logout
        url = reverse('logout') 
        response = api_client.post(url)
        
        # 3. Verifica se deu certo
        assert response.status_code == status.HTTP_200_OK