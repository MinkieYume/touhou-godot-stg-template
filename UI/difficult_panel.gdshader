shader_type canvas_item;

uniform float alpha = 0.5;
void fragment() {
	// Place fragment code here.
	COLOR.a*=alpha;
}
