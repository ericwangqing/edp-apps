/**
 * @module 
 *  name: HP21
 *  description: 洗碗机开、关门控制模块，惠普芯片HP21
 *  author: 范冰冰
 *  version: 1.1
 */

/**
 * @config-item 
 *  name: DOOR_NAME, description: 门的名字
 *  value: 字符串
 */  

/**
 * @config-item 
 *  name: DEFAULT_STATUS, description: 门默认开关的状态
 *  values: 
 *    value: 1, description: 前门
 *    value: 2, description: 后门
 */  

/**
 * @config-item 
 *  name: CONTROL_PINS[], description: 控制信号输入引脚
 *  values: [0..5]
 *  multiple: 2
 */  

 int open_door(){
  printf("%s\n", DOOR_NAME);
 }