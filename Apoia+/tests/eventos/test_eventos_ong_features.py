import pytest
from rest_framework.test import APIClient
from rest_framework import status
from tests.autenticacao.factories import UsuarioFactory
from tests.eventos.factories import EventoFactory
from tests.participacoes.factories import ParticipacaoFactory
from eventos.models import Evento

@pytest.mark.django_db
class TestEventosONGFeatures:
    def setup_method(self):
        self.client = APIClient()
        self.ong_1 = UsuarioFactory(tipo_usuario='ong', email='ong1@teste.com')
        self.ong_2 = UsuarioFactory(tipo_usuario='ong', email='ong2@teste.com')
        
        self.evento_ong_1 = EventoFactory(criado_por=self.ong_1, titulo="Evento ONG 1")
        self.evento_ong_2 = EventoFactory(criado_por=self.ong_2, titulo="Evento ONG 2")

    def test_listar_apenas_meus_eventos(self):
        self.client.force_authenticate(user=self.ong_1)
        url = '/api/eventos/?meus_eventos=true'
        response = self.client.get(url)
        
        assert response.status_code == status.HTTP_200_OK
        assert len(response.data) == 1
        assert response.data[0]['id'] == self.evento_ong_1.id
        ids_retornados = [e['id'] for e in response.data]
        assert self.evento_ong_2.id not in ids_retornados

    def test_editar_evento_de_outra_ong_proibido(self):
        """
        Teste corrigido para buscar a chave 'detail' gerada pelo PermissionDenied
        """
        self.client.force_authenticate(user=self.ong_1)
        
        url = f'/api/eventos/{self.evento_ong_2.id}/'
        data = {'titulo': 'Tentativa de Hack'}
        
        response = self.client.patch(url, data)
        
        assert response.status_code == status.HTTP_403_FORBIDDEN
        # CORREÇÃO: PermissionDenied retorna 'detail', não 'erro'
        assert "permissão" in str(response.data['detail'])

    def test_editar_meu_evento_permitido(self):
        self.client.force_authenticate(user=self.ong_1)
        url = f'/api/eventos/{self.evento_ong_1.id}/'
        data = {'titulo': 'Titulo Atualizado'}
        
        response = self.client.patch(url, data)
        
        assert response.status_code == status.HTTP_200_OK
        self.evento_ong_1.refresh_from_db()
        assert self.evento_ong_1.titulo == 'Titulo Atualizado'

    def test_visualizar_participantes_meu_evento(self):
        voluntario = UsuarioFactory(tipo_usuario='voluntario')
        ParticipacaoFactory(voluntario=voluntario, evento=self.evento_ong_1)
        
        self.client.force_authenticate(user=self.ong_1)
        
        url = f'/api/eventos/{self.evento_ong_1.id}/participantes/'
        response = self.client.get(url)
        
        assert response.status_code == status.HTTP_200_OK
        assert response.data['evento_id'] == self.evento_ong_1.id
        assert response.data['total_participantes'] == 1
        assert len(response.data['participantes']) == 1

    def test_visualizar_participantes_evento_alheio_proibido(self):
        self.client.force_authenticate(user=self.ong_1)
        url = f'/api/eventos/{self.evento_ong_2.id}/participantes/'
        response = self.client.get(url)
        
        assert response.status_code == status.HTTP_403_FORBIDDEN
        # Aqui ainda usamos 'erro' pois a view 'participantes' retorna Response manual
        assert "permissão" in str(response.data['erro'])
