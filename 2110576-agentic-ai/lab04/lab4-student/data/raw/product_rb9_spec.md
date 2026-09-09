# RB-9 Cold Chain Robot — Specification

Product code RB-9. Generation 1. In production since September 2025. Document PRD-131, revision 5.

## Positioning

RB-9 is the cold-storage variant of the platform. It shares the RB-7 chassis and control stack but adds a sealed, heated electronics bay and a different battery chemistry. Choose RB-9 when the operating environment is below 2 degrees Celsius; choose RB-7 for ambient warehouses, where it is cheaper and slightly faster.

## Physical

| Property | Value |
|---|---|
| Payload capacity | 100 kg |
| Operating temperature | -25 to +25 degrees Celsius |
| Footprint | 780 x 560 mm |
| Mass (empty) | 112 kg |
| Top speed, laden | 1.5 m/s |
| Ingress protection | IP65 |

Payload and speed are both lower than RB-7. The extra mass is insulation and the heated bay.

## Power

48 V lithium titanate pack, 1.4 kWh. Runtime is 7 hours at -20 degrees Celsius and 8.5 hours at ambient. Lithium titanate is used instead of lithium iron phosphate because it charges reliably below freezing, which LFP does not. Charging to 80% takes 25 minutes at a DK-3 dock. RB-9 is not compatible with the DK-2 dock used by RB-7.

Condensation management: after leaving cold storage, an RB-9 must dwell for 20 minutes in the transition zone before entering an ambient area, otherwise condensation forms on the optics and triggers safety stops.

## Sensing

Same sensor suite as RB-7 with heated lidar and camera windows. Obstacle detection stops the robot within 300 mm at full laden speed, helped by the lower top speed.

## Maintenance

Drive wheel torque specification is 42 Nm, identical to RB-7. Door and bay seals are inspected every 1,000 operating hours; a failed seal admits moisture into the electronics bay and is the most expensive field failure on this product.
