package com.frigidfish{
   
    import flash.display.Sprite;   
    import flash.text.TextField;
   
    public class Grid extends Sprite{
       
        public var rows:uint;
        public var cols:uint;
        public var cell:Array = new Array();
        public var plot:Array = new Array();
       
        public function Grid(displayObject:*,rows,cols, spacer){
           
            this.rows   = rows;
            this.cols   = cols;
           
            populateCells(displayObject,spacer);
            plotCells(cell);
           
        }
       
		//populates cells by row and column, and spacing them out based on the spacer variable passed in
        private function populateCells(displayObject:*,spacer:int){
           
            var iterator:uint = 0;
            for(var c:uint = 0;c<cols;c++){
                for(var r:uint = 0;r<rows;r++){                                        
                    cell[iterator] = new displayObject;
                    cell[iterator].y = cell[iterator].height  * r + (spacer*r);
                    cell[iterator].x = cell[iterator].width * c + (spacer*c);
					cell[iterator].row = r;
					cell[iterator].col = c;
                    addChild(cell[iterator]);
                    iterator++;
                }
            }          
        }
       
		//adds cells to array so they can be accessed later
        private function plotCells(cell:Array){        
            var iterator:uint = 0;
            for(var c:uint = 0;c<cols;c++){
                plot[c] = new Array;
                for(var r:uint = 0;r<rows;r++){                
                    plot[c][r] = cell[iterator];
                    iterator++;                 
                }
            }          
        }
    }
}