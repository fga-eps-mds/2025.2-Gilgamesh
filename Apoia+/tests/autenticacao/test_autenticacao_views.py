import pytest
from django.urls import reverse
from rest_framework import status
from tests.autenticacao.factories import UsuarioFactory

@pytest.mark.django_db
class TestLoginView:
    
    # CORREÇÃO: Usar 'api_client' em vez de 'client' para padronizar
    def test_login_sucesso(self, api_client):
        # A Factory agora usa 'password' internamente, então não precisamos passar senha aqui.
        # Ela já cria o usuário com a senha 'senha_padrao_123' hashada.
        UsuarioFactory(email="teste@login.com")
        
        data = {
            "email": "teste@login.com",
            "senha": "senha_padrao_123" 
        }
        
        url = reverse('login') 
        response = api_client.post(url, data)
        
        assert response.status_code == status.HTTP_200_OK

    def test_login_senha_incorreta(self, api_client):
        UsuarioFactory(email="teste@erro.com")
        
        data = {
            "email": "teste@erro.com",
            "senha": "SENHA_ERRADA"
        }
        url = reverse('login')
        response = api_client.post(url, data)
        
        assert response.status_code == status.HTTP_401_UNAUTHORIZED

    def test_login_email_inexistente(self, api_client):
        data = {"email": "fantasma@exemplo.com", "senha": "123"}
        url = reverse('login')
        response = api_client.post(url, data)
        
        assert response.status_code == status.HTTP_401_UNAUTHORIZED

    def test_login_campos_faltando(self, api_client):
        data = {} 
        url = reverse('login')
        response = api_client.post(url, data)
        
        assert response.status_code == status.HTTP_400_BAD_REQUEST

    def test_logout_sucesso(self, api_client):
        usuario = UsuarioFactory(email="sair@teste.com")
        
        api_client.force_authenticate(user=usuario)
        
        url = reverse('logout') 
        response = api_client.post(url)
        
        assert response.status_code == status.HTTP_200_OK