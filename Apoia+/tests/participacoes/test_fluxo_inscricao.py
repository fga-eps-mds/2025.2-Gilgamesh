import pytest
from rest_framework.test import APIClient
from rest_framework import status
from eventos.models import Evento
from participacoes.models import Participacao
from tests.autenticacao.factories import UsuarioFactory
from tests.eventos.factories import EventoFactory

@pytest.mark.django_db
class TestFluxoInscricao:

    def test_inscricao_incrementa_apenas_um(self):
        """
        Verifica se a inscrição aumenta o contador em apenas 1
        e se o cancelamento reduz corretamente.
        """
        # 1. Setup
        user = UsuarioFactory()
        evento = EventoFactory(participantes=0, vagas=10)
        
        client = APIClient()
        client.force_authenticate(user=user)

        # 2. Ação: Inscrever (POST)
        response = client.post('/api/participacoes/', {'evento': evento.id})
        
        assert response.status_code == status.HTTP_201_CREATED
        
        # 3. Verificação Lógica (O Bug morre aqui)
        evento.refresh_from_db()
        assert evento.participantes == 1  # Se der 2, o bug persiste.
        
        # 4. Ação: Cancelar (DELETE)
        participacao_id = response.data['id']
        response_del = client.delete(f'/api/participacoes/{participacao_id}/')
        
        assert response_del.status_code == status.HTTP_204_NO_CONTENT
        
        # 5. Verificação Cancelamento
        evento.refresh_from_db()
        assert evento.participantes == 0

    def test_impedir_inscricao_duplicada(self):
        """Cobre as linhas de validação de duplicidade na View"""
        user = UsuarioFactory()
        evento = EventoFactory(vagas=10)
        client = APIClient()
        client.force_authenticate(user=user)

        # Primeira inscrição (OK)
        client.post('/api/participacoes/', {'evento': evento.id})

        # Segunda inscrição (Erro)
        response = client.post('/api/participacoes/', {'evento': evento.id})
        
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert "inscrito" in str(response.data)

    def test_impedir_inscricao_sem_vagas(self):
        """Cobre as linhas de validação de vagas na View"""
        user = UsuarioFactory()
        # Evento lotado (10/10)
        evento = EventoFactory(participantes=10, vagas=10)
        
        client = APIClient()
        client.force_authenticate(user=user)

        response = client.post('/api/participacoes/', {'evento': evento.id})
        
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert "vagas" in str(response.data)
    
    def test_tentar_inscrever_evento_inexistente(self):
        """
        Cobre o caso de ID inexistente.
        A validação é feita automaticamente pelo Serializer do DRF.
        """
        user = UsuarioFactory()
        client = APIClient()
        client.force_authenticate(user=user)

        # ID 9999 não existe
        response = client.post('/api/participacoes/', {'evento': 9999})
        
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        # Ajuste: A mensagem padrão do DRF contém "does not exist" ou "Invalid pk"
        assert "does not exist" in str(response.data)
