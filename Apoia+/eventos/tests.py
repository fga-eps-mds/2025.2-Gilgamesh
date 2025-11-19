from rest_framework.test import APITestCase
from rest_framework import status
from .models import Evento

class EventoAPITestCase(APITestCase):
    
    # 1. PREPARAÇÃO (O que acontece ANTES de cada teste)
    def setUp(self):
        # Vamos criar um evento "de mentirinha" no banco temporário
        # para garantir que sempre tenha algo para listar.
        self.evento_teste = Evento.objects.create(
            nome="Evento Teste Automatizado",
            descricao="Isso é apenas um teste",
            data_inicio="2025-12-25T20:00:00Z"
        )
        # Definimos a URL que vamos testar (o endereço da sua API)
        self.url = '/api/eventos/'

    # 2. TESTE DE LEITURA (GET)
    def test_deve_listar_eventos(self):
        """
        Verifica se a API retorna status 200 e se mostra o evento criado.
        """
        # O robô acessa a URL (simula um navegador)
        resposta = self.client.get(self.url)

        # VERIFICAÇÕES (Asserts):
        # O status code foi 200 (Sucesso)?
        self.assertEqual(resposta.status_code, status.HTTP_200_OK)
        
        # O nome do evento apareceu na resposta?
        self.assertEqual(len(resposta.data), 1) # Tem que ter 1 evento na lista
        self.assertEqual(resposta.data[0]['nome'], "Evento Teste Automatizado")

    # 3. TESTE DE CRIAÇÃO (POST)
    def test_deve_criar_novo_evento(self):
        """
        Verifica se a API aceita criar um novo evento via POST.
        """
        # Dados do novo evento
        novo_evento = {
            "nome": "Novo Evento via Teste",
            "descricao": "Criando pelo script",
            "data_inicio": "2026-01-01T10:00:00Z"
        }

        # O robô envia os dados (POST)
        resposta = self.client.post(self.url, novo_evento, format='json')

        # VERIFICAÇÕES:
        # O status foi 201 (Created/Criado)?
        self.assertEqual(resposta.status_code, status.HTTP_201_CREATED)
        
        # O banco de dados agora tem 2 eventos? (O do setUp + este novo)
        self.assertEqual(Evento.objects.count(), 2)
        
        # O nome salvo é igual ao que enviamos?
        self.assertEqual(Evento.objects.last().nome, "Novo Evento via Teste")