# RB-5 Autonomous Mobile Robot — Specification (LEGACY)

**End of sale 31 December 2023. End of support 31 December 2028. New deployments should use the RB-7.**

Product code RB-5. Generation 2. Document PRD-089, revision 14.

## Physical

| Property | Value |
|---|---|
| Payload capacity | 90 kg |
| Deck height | 310 mm |
| Footprint | 740 x 500 mm |
| Mass (empty) | 88 kg |
| Top speed, laden | 1.4 m/s |
| Top speed, unladen | 1.6 m/s |

## Power

36 V lithium iron phosphate pack, 1.1 kWh. Runtime is 6 hours under a typical mixed-pick duty cycle. Charging to 80% takes 70 minutes at a DK-1 dock. The RB-5 is not compatible with the DK-2 or DK-3 docks.

## Sensing

2D safety lidar with a 240 degree field of view, and two depth cameras covering the front arc only. There is no rear depth coverage; the RB-5 reverses at reduced speed for this reason.

Obstacle detection stops the robot within 400 mm at full laden speed.

## Maintenance

The drive wheel torque specification is 38 Nm, checked every 400 operating hours. Castor bearings are replaced every 1,500 hours.

## Limitations

Indoor use only, flat floors, maximum gradient 2 degrees, minimum aisle width 1,000 mm. Not rated for cold storage. The fleet coordinator supports RB-5 in mixed fleets, but RB-5 units do not receive routing improvements released after 2024.
