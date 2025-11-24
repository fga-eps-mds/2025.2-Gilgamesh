import pytest
from rest_framework.test import APIClient

@pytest.fixture
def api_client():
    """
    Cria um cliente da API do Django Rest Framework.
    
    Isso substitui o 'client' padrão do Django e permite usar
    funções específicas de API, como:
    - client.force_authenticate(user=...)
    - client.credentials(HTTP_AUTHORIZATION=...)
    """
    return APIClient()