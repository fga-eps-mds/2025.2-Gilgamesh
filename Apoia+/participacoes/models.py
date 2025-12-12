from django.db import models
from autenticacao.models import Usuario
from eventos.models import Evento

class Participacao(models.Model):
    voluntario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    evento = models.ForeignKey(Evento, on_delete=models.CASCADE)
    data_inscricao = models.DateTimeField(auto_now_add=True)

    class Meta:
        # Garante que o usuário não se inscreva 2vezes no mesmo evento
        unique_together = ('voluntario', 'evento') 

    def __str__(self):
        return f"{self.voluntario.nome} em {self.evento.titulo}"