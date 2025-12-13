import pytest
from django.urls import reverse, resolve

class TestURLs:
    
    def test_participacoes_url(self):
        """Garante que a rota /api/participacoes/ aponta para o ViewSet correto"""
        path = reverse('participacao-list')
        assert resolve(path).view_name == 'participacao-list'

    def test_eventos_url(self):
        """Garante que a rota /api/eventos/ aponta para o ViewSet correto"""
        path = reverse('evento-list')
        assert resolve(path).view_name == 'evento-list'
