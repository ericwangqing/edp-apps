/**
 * @module 
 *  name: HP21
 *  description: 开门模块
 *  author: 黄华明
 *  version: 1.1
 *  last-modified: 2013-1-10
 */

/**
 * @configure-item 
 *  name: DOOR_NAME, description: 门名称
 *  values: 
 *    value: 1, description: 前门
 *    value: 2, description: 后门
 */  

 int open_door(){
  printf("%s\n", DOOR_NAME);
 }