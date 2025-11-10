import uuid #para o id aleatório
from django.db import models
from autenticacao.models import Usuario

class Evento(models.Model):
    nome_evento = models.TextField(max_length=255)
    id_evento = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False) #cria id aleatório
    descricao_evento = models.TextField(max_length=255)
    data_evento = models.DateField()
    localizacao_evento = models.TextField(max_length=25)
    vagas_totais = models.IntegerField()
    numero_participantes = models.IntegerField()

class Participacao(models.Model):
    
    #id_usuario
    id_usuario = Usuario.id_usuario
    #id_evento
    id_evento = Evento.id_evento
    
    class Status(models.TextChoices):
        PENDENTE = 'PEN', 'Pendente'
        CONFIRMADO = 'CONF', 'Confirmado'
        CANCELADO = 'CAN', 'Cancelado'

    # O status da participação 
    status = models.CharField(
        max_length=4,
        choices=Status.choices,
        default=Status.PENDENTE
    )
    
    data_inscricao = models.DateTimeField(auto_now_add=True) 
    
    data_confirmacao = models.DateTimeField(null=True, blank=True)