// Shader 2D para pulsar cor e tamanho
shader_type canvas_item;

// --- Parâmetros customizáveis ---
uniform vec4 pulse_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Cor do pulso (branco por padrão)
uniform float pulse_speed : hint_range(0.1, 10.0) = 2.0;
uniform float color_strength : hint_range(0.0, 1.0) = 0.5; // Renomeado para clareza
uniform float scale_strength : hint_range(0.0, 1.0) = 0.1; // NOVO PARÂMETRO para a escala

// --- Função de Vértice (para animar o tamanho) ---
void vertex() {
	// Usamos a mesma lógica de pulso
	float pulse = (sin(TIME * pulse_speed) + 1.0) / 2.0; // Varia de 0.0 a 1.0
	
	// Calcula a escala final. 1.0 é o tamanho normal.
	// Adicionamos o pulso multiplicado pela sua força.
	float current_scale = 1.0 + (pulse * scale_strength);
	
	// Aplica a escala aos vértices do objeto.
	// Isso faz o objeto crescer e encolher a partir do seu centro.
	VERTEX *= current_scale;
}

// --- Função de Fragmento (para animar a cor) ---
void fragment() {
	// Calcula a onda do pulso usando o tempo
	float pulse = (sin(TIME * pulse_speed) + 1.0) / 2.0; // Varia de 0.0 a 1.0
	
	// Pega a cor original da textura do sprite
	vec4 original_color = texture(TEXTURE, UV);

	// Mistura a cor original com a cor do pulso
	vec3 final_rgb = mix(original_color.rgb, pulse_color.rgb, pulse * color_strength);
	
	// Aplica a cor final
	COLOR = vec4(final_rgb, original_color.a);
}