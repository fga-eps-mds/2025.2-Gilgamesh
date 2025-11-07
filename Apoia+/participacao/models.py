from django.db import models
from usuario.models import Usuario
from evento.models import Evento

class Participacao(models.Model):
    STATUS_CHOICES = [
        ('pendente','Pendente'),
        ('confirmado','Confirmado'),
        ('cancelado','Cancelado'),
    ]

    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='participacoes')
    evento = models.ForeignKey(Evento, on_delete=models.CASCADE, related_name='participacoes')
    status_confirmacao = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='pendente'
    )
    data_inscricao = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.usuario.nome} - {self.evento.titulo} ({self.status_confirmacao})"

