import pytest
from django.urls import reverse
from rest_framework import status
from tests.participacoes.factories import ParticipacaoFactory
from tests.autenticacao.factories import UsuarioFactory

@pytest.mark.django_db
class TestParticipacaoViewSet:
    
    def test_listar_participacoes(self, api_client):
        # 1. Cria usuário e autentica
        user = UsuarioFactory()
        api_client.force_authenticate(user=user)

        # 2. Cria participações VINCULADAS ao usuário logado
        # CORREÇÃO CRÍTICA: Passamos 'voluntario=user'. 
        # Sem isso, a factory cria donos aleatórios e a API retorna vazio.
        ParticipacaoFactory.create_batch(2, voluntario=user)
        
        # 3. Acessa a API
        url = reverse('participacao-list') 
        response = api_client.get(url)
        
        # 4. Verifica se retornou 200 OK e os 2 itens do usuário
        assert response.status_code == status.HTTP_200_OK
        assert len(response.data) == 2
