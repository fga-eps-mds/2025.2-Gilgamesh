import pytest
from django.urls import reverse
from rest_framework import status
from autenticacao.models import Usuario

@pytest.mark.django_db
class TestCadastroView:
    
    @pytest.fixture
    def url_cadastro(self):
        # Certifique-se que existe path('cadastro/', ..., name='cadastro') no urls.py
        # Se não tiver, ajuste aqui ou crie a rota
        try:
            return reverse('cadastro')
        except:
            return '/api/auth/cadastro/' # Fallback se não tiver name

    def test_cadastro_voluntario_sucesso(self, api_client, url_cadastro):
        data = {
            "nome": "Voluntario Teste",
            "email": "voluntario@teste.com",
            "password": "senha_segura_123",
            "tipo_usuario": "voluntario",
            "cpf": "12345678900",
            "uf": "DF"
        }
        response = api_client.post(url_cadastro, data)
        assert response.status_code == status.HTTP_201_CREATED
        assert Usuario.objects.count() == 1
        assert Usuario.objects.first().cpf == "12345678900"

    def test_cadastro_ong_sucesso(self, api_client, url_cadastro):
        data = {
            "nome": "ONG Teste",
            "email": "ong@teste.com",
            "password": "senha_segura_123",
            "tipo_usuario": "ong",
            "cnpj": "00.000.000/0001-00",
            "uf": "SP"
        }
        response = api_client.post(url_cadastro, data)
        assert response.status_code == status.HTTP_201_CREATED
        assert Usuario.objects.first().cnpj == "00.000.000/0001-00"

    def test_erro_voluntario_sem_cpf(self, api_client, url_cadastro):
        data = {
            "nome": "Voluntario Falho",
            "email": "fail@teste.com",
            "password": "123",
            "tipo_usuario": "voluntario",
            # Faltou CPF
        }
        response = api_client.post(url_cadastro, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert "cpf" in response.data # Verifica se o erro é sobre o CPF

    def test_erro_ong_sem_cnpj(self, api_client, url_cadastro):
        data = {
            "nome": "ONG Falha",
            "email": "fail_ong@teste.com",
            "password": "123",
            "tipo_usuario": "ong",
            # Faltou CNPJ
        }
        response = api_client.post(url_cadastro, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert "cnpj" in response.data

    def test_erro_ong_com_cpf(self, api_client, url_cadastro):
        """Testa a regra: ONGs não devem ter CPF"""
        data = {
            "nome": "ONG Hibrida",
            "email": "hibrida@teste.com",
            "password": "123",
            "tipo_usuario": "ong",
            "cnpj": "0000",
            "cpf": "12345678900" # Errado
        }
        response = api_client.post(url_cadastro, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert "cpf" in response.data

    def test_erro_voluntario_com_cnpj(self, api_client, url_cadastro):
        """Testa a regra: Voluntários não devem ter CNPJ"""
        data = {
            "nome": "Voluntario PJ",
            "email": "pj@teste.com",
            "password": "123",
            "tipo_usuario": "voluntario",
            "cpf": "123",
            "cnpj": "0000000" # Errado
        }
        response = api_client.post(url_cadastro, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert "cnpj" in response.data