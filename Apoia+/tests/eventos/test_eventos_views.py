import pytest
from django.urls import reverse
from rest_framework import status
from eventos.models import Evento
from tests.eventos.factories import EventoFactory
from tests.autenticacao.factories import UsuarioFactory

@pytest.mark.django_db
class TestEventoViewSet:
    
    @pytest.fixture
    def usuario_ong(self):
        return UsuarioFactory(tipo_usuario='ong')

    @pytest.fixture
    def usuario_comum(self):
        return UsuarioFactory(tipo_usuario='voluntario')

    def test_listar_eventos_publico(self, api_client):
        EventoFactory.create_batch(3)
        url = reverse('evento-list')
        response = api_client.get(url)
        assert response.status_code == status.HTTP_200_OK
        assert len(response.data) == 3

    def test_listar_eventos_com_filtro(self, api_client):
        """
        Cobre linhas 26 e 29 de views.py (filtros de cidade/estado)
        """
        EventoFactory(titulo="Evento A", local="Brasília - DF")
        EventoFactory(titulo="Evento B", local="Goiânia - GO")
        
        url = reverse('evento-list')
        
        # Filtro Cidade
        response = api_client.get(url, {'cidade': 'Brasília'})
        assert response.status_code == status.HTTP_200_OK
        assert len(response.data) == 1
        assert response.data[0]['titulo'] == "Evento A"

        # Filtro Estado
        response = api_client.get(url, {'estado': 'GO'})
        assert response.status_code == status.HTTP_200_OK
        assert len(response.data) == 1
        assert response.data[0]['titulo'] == "Evento B"

    def test_criar_evento_como_ong(self, api_client, usuario_ong):
        api_client.force_authenticate(user=usuario_ong)
        dados = {
            "titulo": "Semana UnB", 
            "descricao": "Tecnologia",
            "data_inicio": "2025-10-10T09:00:00Z",
            "local": "ICC Norte"
        }
        url = reverse('evento-list')
        response = api_client.post(url, dados)
        assert response.status_code == status.HTTP_201_CREATED
        
        assert Evento.objects.count() == 1
        evento = Evento.objects.first()
        assert evento.criado_por == usuario_ong

    def test_impedir_criacao_usuario_comum(self, api_client, usuario_comum):
        api_client.force_authenticate(user=usuario_comum)
        dados = {"titulo": "Evento Fake", "data_inicio": "2025-01-01T00:00:00Z"}
        url = reverse('evento-list')
        response = api_client.post(url, dados)
        assert response.status_code == status.HTTP_403_FORBIDDEN
