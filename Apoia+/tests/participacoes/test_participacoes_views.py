import pytest
from django.urls import reverse
from rest_framework import status
from tests.participacoes.factories import ParticipacaoFactory
from tests.autenticacao.factories import UsuarioFactory # Import necessário

@pytest.mark.django_db
class TestParticipacaoViewSet:
    
    def test_listar_participacoes(self, api_client):
        # CORREÇÃO: Autenticar usuário (Resolve o 401 Unauthorized)
        user = UsuarioFactory()
        api_client.force_authenticate(user=user)

        # 1. Cria duas participações no banco
        ParticipacaoFactory.create_batch(2)
        
        # 2. Acessa a API
        url = reverse('participacao-list') 
        response = api_client.get(url)
        
        # 3. Verifica se retornou 200 OK e os 2 itens
        assert response.status_code == status.HTTP_200_OK
        assert len(response.data) == 2
