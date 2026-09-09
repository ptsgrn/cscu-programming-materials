# RB-7 Autonomous Mobile Robot — Specification

Product code RB-7. Generation 3. In production since March 2024. Document PRD-107, revision 11.

## Physical

| Property | Value |
|---|---|
| Payload capacity | 120 kg |
| Deck height | 340 mm |
| Footprint | 780 x 520 mm |
| Mass (empty) | 96 kg |
| Top speed, laden | 1.8 m/s |
| Top speed, unladen | 2.2 m/s |
| Turning radius | zero (differential drive) |

## Power

48 V lithium iron phosphate pack, 1.6 kWh. Runtime is 9 hours under a typical mixed-pick duty cycle and about 5.5 hours at continuous maximum load. Charging to 80% takes 45 minutes at a DK-2 dock; a full charge takes 90 minutes. The pack is rated for 3,000 cycles to 80% of original capacity.

Opportunity charging is supported and recommended: the fleet coordinator sends a robot to a dock whenever it is idle for more than 4 minutes and below 60% state of charge.

## Sensing

- 2D safety lidar, 270 degree field of view, SIL 2 rated.
- Four depth cameras giving 360 degree coverage above deck height.
- Wheel odometry with an IMU, fused for localisation against a prior map.

Obstacle detection stops the robot within 350 mm at full laden speed.

## Maintenance

The drive wheel torque specification is 42 Nm, checked every 500 operating hours. Castor bearings are replaced every 2,000 hours. The safety lidar window must be cleaned weekly; a dirty window is the single most common cause of spurious safety stops in the field.

## Limitations

RB-7 is rated for indoor use on flat floors with a maximum gradient of 3 degrees and a minimum aisle width of 900 mm. It is not rated for cold storage below 2 degrees Celsius; the RB-9 is the cold-storage model.
