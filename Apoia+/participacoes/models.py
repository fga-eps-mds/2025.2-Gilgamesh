from django.db import models
from autenticacao.models import Usuario
from eventos.models import Evento # Certifique-se que o import está certo

class Participacao(models.Model):
    voluntario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    evento = models.ForeignKey(Evento, on_delete=models.CASCADE)
    data_inscricao = models.DateTimeField(auto_now_add=True)

    class Meta:
        # Garante que o usuário não se inscreva 2 vezes no mesmo evento
        unique_together = ('voluntario', 'evento') 

    def __str__(self):
        return f"{self.voluntario.nome} em {self.evento.titulo}"

    def save(self, *args, **kwargs):
        
        eh_nova_inscricao = self._state.adding
        

        super().save(*args, **kwargs)
        
        if eh_nova_inscricao:
            self.evento.participantes += 1
            self.evento.save()
            print(f"--- SUCESSO: Evento atualizado para {self.evento.participantes} participantes ---")

    def delete(self, *args, **kwargs):
        if self.evento.participantes > 0:
            self.evento.participantes -= 1
            self.evento.save()
            print(f"--- SUCESSO: Evento reduzido para {self.evento.participantes} participantes ---")
        

        super().delete(*args, **kwargs)