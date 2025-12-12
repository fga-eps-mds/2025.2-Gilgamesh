from django.urls import path
from .views import LoginView, LogoutView, CadastroView, ListaOngsView, AtualizarUsuarioView, AlterarSenhaView

urlpatterns = [
    path('cadastro/', CadastroView.as_view(), name='cadastro'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('usuario/', AtualizarUsuarioView.as_view(), name='usuario'), 
    path('alterar-senha/', AlterarSenhaView.as_view(), name='alterar-senha'),
    path('ongs/', ListaOngsView.as_view(), name='lista-ongs'),
]