from rest_framework.test import APITestCase
from rest_framework import status
from django.contrib.auth import get_user_model # <--- Usa o modelo de usuário correto do projeto
from .models import Evento

class EventoCRUDTestCase(APITestCase):
    
    def setUp(self):
        # Pega a classe de usuário correta (seja a padrão ou customizada)
        User = get_user_model()

        # 1. Criamos um usuário comum
        self.user = User.objects.create_user(
            username='ong_tester', 
            password='123',
            email='ong@teste.com'
        )

        # 2. O SEGREDO: Colocamos a etiqueta de ONG nele
        # Isso satisfaz a regra: request.user.tipo_usuario == 'ong'
        self.user.tipo_usuario = 'ong' 
        self.user.save() # Salva a alteração no banco
        
        # 3. Autenticamos o robô com esse usuário ONG
        self.client.force_authenticate(user=self.user)
        
        # Criação do evento inicial (igual antes)
        self.evento = Evento.objects.create(
            nome="Evento Original",
            descricao="Descrição Original",
            data_inicio="2025-01-01T12:00:00Z"
        )
        self.list_url = '/api/eventos/'
        self.detail_url = f'/api/eventos/{self.evento.id}/'

    # --- TESTES DE LEITURA (READ) ---
    
    def test_deve_listar_eventos(self):
        response = self.client.get(self.list_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

    def test_deve_buscar_um_evento_especifico(self):
        response = self.client.get(self.detail_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['nome'], "Evento Original")

    # --- TESTE DE CRIAÇÃO (CREATE) ---

    def test_deve_criar_evento(self):
        dados = {
            "nome": "Novo Evento",
            "data_inicio": "2025-12-31T23:59:59Z",
            "descricao": "Testando criação"
        }
        response = self.client.post(self.list_url, dados, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Evento.objects.count(), 2)

    def test_nao_deve_criar_evento_sem_nome(self):
        dados = {
            "data_inicio": "2025-12-31T23:59:59Z"
        }
        response = self.client.post(self.list_url, dados, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    # --- TESTE DE ATUALIZAÇÃO (UPDATE) ---

    def test_deve_atualizar_evento(self):
        novos_dados = {
            "nome": "Evento Atualizado",
            "data_inicio": "2025-01-01T12:00:00Z"
        }
        response = self.client.put(self.detail_url, novos_dados, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        
        self.evento.refresh_from_db()
        self.assertEqual(self.evento.nome, "Evento Atualizado")

    # --- TESTE DE REMOÇÃO (DELETE) ---

    def test_deve_deletar_evento(self):
        response = self.client.delete(self.detail_url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(Evento.objects.count(), 0)