import pytest
from django.urls import reverse
from rest_framework import status
from eventos.models import Evento
# CORREÇÃO: Removemos DjangoUserFactory e importamos UsuarioFactory do outro app
from tests.eventos.factories import EventoFactory
from tests.autenticacao.factories import UsuarioFactory

@pytest.mark.django_db
class TestEventoViewSet:
    
    @pytest.fixture
    def usuario_ong(self):
        # CORREÇÃO: Usa a factory do nosso sistema, criando uma ONG
        return UsuarioFactory(tipo_usuario='ong')

    @pytest.fixture
    def usuario_comum(self):
        # CORREÇÃO: Usa a factory do nosso sistema, criando um voluntário
        return UsuarioFactory(tipo_usuario='voluntario')

    def test_listar_eventos_publico(self, api_client):
        EventoFactory.create_batch(3)
        url = reverse('evento-list')
        response = api_client.get(url)
        assert response.status_code == status.HTTP_200_OK
        assert len(response.data) == 3

    def test_criar_evento_como_ong(self, api_client, usuario_ong):
        api_client.force_authenticate(user=usuario_ong)
        dados = {
            "nome": "Semana UnB",
            "descricao": "Tecnologia",
            "data_inicio": "2025-10-10T09:00:00Z",
            "local": "ICC Norte"
        }
        url = reverse('evento-list')
        response = api_client.post(url, dados)
        assert response.status_code == status.HTTP_201_CREATED

    def test_impedir_criacao_usuario_comum(self, api_client, usuario_comum):
        api_client.force_authenticate(user=usuario_comum)
        dados = {"nome": "Evento Fake", "data_inicio": "2025-01-01T00:00:00Z"}
        url = reverse('evento-list')
        response = api_client.post(url, dados)
        
        # Espera erro 403 Forbidden (Bloqueado pelo IsONG)
        assert response.status_code == status.HTTP_403_FORBIDDEN