shader_type canvas_item;

uniform float squash_amount : hint_range(0.0, 1.0) = 0.0; // Controla o grau de achatamento (0 = normal, 1 = achatado ao máximo)
uniform float squash_height_factor = 0.5; // Ajusta qual parte do sprite é mais afetada pelo achatamento (0 = base, 1 = topo)

void vertex() {
    // Calcula o ponto de pivô para o achatamento
    // UV.y varia de 0.0 (topo) a 1.0 (base) do sprite
    // Para que o achatamento aconteça da base para cima, ajustamos o UV.y.
    // Se quiser que o achatamento seja do meio para fora, o pivô seria 0.5.
    float pivot_y = UV.y; 

    // Calcula a deformação vertical.
    // Quanto maior o squash_amount, mais a parte superior (UV.y mais baixo) se move para baixo.
    // A multiplicação por `(1.0 - pivot_y)` faz com que o efeito seja mais intenso no topo
    // e menos intenso na base (onde `1.0 - pivot_y` se aproxima de 0).
    float y_deform = (1.0 - pivot_y) * squash_amount; 

    // Aplica o achatamento na coordenada Y do vértice.
    // VERTEX é a coordenada do vértice no espaço local do objeto.
    // Multiplicamos por uma pequena constante para controlar a intensidade visual da deformação.
    // Usar TEXTURE_PIXEL_SIZE.y ou outras métricas de tamanho da textura diretamente aqui é complicado no vertex shader
    // se não tivermos a textura bindada, então vamos usar um fator direto para controlar a intensidade.
    VERTEX.y += y_deform * 50.0; // Ajuste o '100.0' para controlar a magnitude do squash

    // Opcional: Adicionar uma ligeira expansão horizontal para um efeito mais "esmagador"
    // Isso fará a pedra parecer mais larga ao achatar
    // Usamos sin(y_deform * PI) para que a expansão seja máxima no meio do achatamento e mínima nas extremidades.
    float x_deform = sin(y_deform * PI) * squash_amount * 50.0; // Ajuste o '50.0' para controlar a magnitude da expansão
    
    // A deformação horizontal deve ser aplicada de forma simétrica ao redor do centro horizontal do sprite.
    // Multiplicamos por (UV.x - 0.5) para que o deslocamento seja para a esquerda na metade esquerda do sprite e para a direita na metade direita.
    VERTEX.x += x_deform * (UV.x - 0.5); 
}

void fragment() {
    // No Godot 4, a textura é acessada com a função texture()
    COLOR = texture(TEXTURE, UV);
}