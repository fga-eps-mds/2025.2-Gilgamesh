import uuid
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
    
    def __str__(self):
        return self.nome_evento


class Participacao(models.Model):
    
    id_usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    id_evento = models.ForeignKey(Evento, on_delete=models.CASCADE)
    
    class Status(models.TextChoices):
        PENDENTE = 'PEN', 'Pendente'
        CONFIRMADO = 'CONF', 'Confirmado'
        CANCELADO = 'CAN', 'Cancelado'

    status = models.CharField(
        max_length=4,
        choices=Status.choices,
        default=Status.PENDENTE
    )
    
    data_inscricao = models.DateTimeField(auto_now_add=True) 
    data_confirmacao = models.DateTimeField(null=True, blank=True)

    # Adicione isso para o painel de admin ler um nome amigável
    def __str__(self):
        # f-string para formatar o texto
        return f"{self.id_usuario.email} em {self.id_evento.nome_evento}"