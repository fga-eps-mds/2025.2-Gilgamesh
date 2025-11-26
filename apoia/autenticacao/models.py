from django.db import models
import uuid

class Usuario(models.Model):
    nome_usuario = models.TextField(max_length=30)
    id_usuario = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False) #cria id aleatório 
    email = models.TextField(max_length=30)
    senha = models.TextField(max_length=30)
    localizacao = models.TextField(max_length=30)
    idade = models.IntegerField()
    
    class Tipo_Usuario(models.TextChoices):
        ADM = "ADM", "Administrador"
        VOL = "VOL", "Voluntário"
        ONG = "ONG", "Ong"
    
    tipo_usuario = models.CharField(max_length=3,choices=Tipo_Usuario)     
 