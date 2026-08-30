package ecommerce

import "math"

// CalculateDynamicFee calcula un porcentaje (0.02 - 0.10) en función del ahorro,
// días ahorrados y nivel VIP.
// productPrice: precio original del producto
// savedAmount: cuánto dinero ahorró el usuario gracias a la plataforma
// daysSaved: días que se ahorraron en la entrega
// vipLevel: entero >=0 (a mayor vipLevel, menor comisión)
func CalculateDynamicFee(productPrice, savedAmount float64, daysSaved int, vipLevel int) float64 {
	if productPrice <= 0 {
		return 0.02 // mínimo
	}

	// 1) Efectividad básica: proporción de ahorro respecto al precio, limitado a 1.0
	effectiveness := savedAmount / productPrice
	if effectiveness > 1 {
		effectiveness = 1
	}

	// 2) Añadimos impacto por tiempo ahorrado (normalizado)
	timeScore := math.Min(1.0, float64(daysSaved)/7.0) // 7 días -> 1.0

	// 3) Combinamos métricas (ponderaciones ajustables)
	score := 0.7*effectiveness + 0.3*timeScore // rango [0,1]

	// 4) Calculamos tarifa entre 2% y 10%
	minFee := 0.02
	maxFee := 0.10
	fee := minFee + (maxFee-minFee)*score

	// 5) Aplicamos descuento VIP: cada nivel reduce X% del delta hasta el mínimo
	// Por ejemplo vipLevel 0..5 -> hasta 50% de reducción del delta
	vipCap := 5.0
	if vipLevel < 0 {
		vipLevel = 0
	}
	vipFactor := 1.0 - (math.Min(float64(vipLevel), vipCap) / vipCap * 0.5) // entre 1.0 y 0.5
	fee = minFee + (fee-minFee)*vipFactor

	// 6) Respetar límites
	if fee < minFee {
		fee = minFee
	}
	if fee > maxFee {
		fee = maxFee
	}

	// Redondear a 4 decimales
	return math.Round(fee*10000) / 10000 // e.g., 0.0352 -> 0.0352
}
