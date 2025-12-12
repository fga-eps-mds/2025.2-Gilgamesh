import pytest
from rest_framework import status
from rest_framework.test import APIClient

@pytest.mark.django_db
class TestCadastroView:
    @pytest.fixture
    def api_client(self):
        return APIClient()

    @pytest.fixture
    def url_cadastro(self):
        return '/api/auth/cadastro/'

    def test_cadastro_voluntario_sucesso(self, api_client, url_cadastro):
        # CPF VÁLIDO (Matemática correta) e SENHA FORTE
        data = {
            "nome": "Voluntario Teste",
            "email": "voluntario@teste.com",
            "password": "SenhaForte123", 
            "tipo_usuario": "voluntario",
            "cpf": "52998224725", 
            "uf": "DF"
        }
        response = api_client.post(url_cadastro, data)
        assert response.status_code == status.HTTP_201_CREATED
        
        # O backend retorna os dados dentro da chave 'usuario'
        assert response.data['usuario']['email'] == data['email']

    def test_cadastro_ong_sucesso(self, api_client, url_cadastro):
        # CNPJ VÁLIDO (11.111.111/0001-91)
        data = {
            "nome": "ONG Teste",
            "email": "ong@teste.com",
            "password": "SenhaForte123",
            "tipo_usuario": "ong",
            "cnpj": "11111111000191", 
            "uf": "SP"
        }
        response = api_client.post(url_cadastro, data)
        
        if response.status_code != 201:
            print(f"\nERRO ONG: {response.data}")
            
        assert response.status_code == status.HTTP_201_CREATED
        assert response.data['usuario']['email'] == data['email']

    def test_erro_voluntario_sem_cpf(self, api_client, url_cadastro):
        data = {
            "nome": "Voluntario Falho",
            "email": "fail@teste.com",
            "password": "SenhaForte123", 
            "tipo_usuario": "voluntario",
            # Faltou CPF
        }
        response = api_client.post(url_cadastro, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert "cpf" in response.data

    def test_erro_ong_sem_cnpj(self, api_client, url_cadastro):
        data = {
            "nome": "ONG Falha",
            "email": "fail_ong@teste.com",
            "password": "SenhaForte123",
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
            "password": "SenhaForte123",
            "tipo_usuario": "ong",
            "cnpj": "11111111000191", 
            "cpf": "52998224725"
        }
        response = api_client.post(url_cadastro, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert "cpf" in response.data 

    def test_erro_voluntario_com_cnpj(self, api_client, url_cadastro):
        """Testa a regra: Voluntários não devem ter CNPJ"""
        data = {
            "nome": "Voluntario PJ",
            "email": "pj@teste.com",
            "password": "SenhaForte123",
            "tipo_usuario": "voluntario",
            "cpf": "52998224725",      
            "cnpj": "11111111000191"   
        }
        response = api_client.post(url_cadastro, data)
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert "cnpj" in response.data
