abstract class BatteryLevelStates{}

class BatteryLevelInitialState extends BatteryLevelStates{}

class BatteryLevelLoadingState extends BatteryLevelStates{}
class BatteryLevelSuccessState extends BatteryLevelStates{

}
class BatteryLevelErrorState extends BatteryLevelStates{}
class BatteryLevelUpdateState extends BatteryLevelStates{}