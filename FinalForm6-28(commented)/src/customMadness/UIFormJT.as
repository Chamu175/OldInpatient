package customMadness
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	public class UIFormJT extends UIForm
	{
		public function UIFormJT(screen:Sprite, xml:XML, attributes:Attributes=null, row:Boolean=false, inGroup:Boolean=false)
		{
			super(screen, xml, attributes, row, inGroup);
		}
		
		override protected function parseBlock(xml:XML, attributes:Attributes, mode:String, row:Boolean):DisplayObject {
			attributes.parse(xml);
			
			if (xml.@width.length()>0)
				attributes.width = xml.@width[0];
			
			if (xml.@height.length()>0)
				attributes.height = xml.@height[0];
			
			if (xml.@widths.length()>0)
				mode = "columns";
			else if (xml.@heights.length()>0)
				mode = "rows";
			var xmlList:XMLList = xml.children();
			var nColumns:int = numberOfColumns(xmlList);
			var pos:Number = ((mode=="vertical" || mode=="rows" || mode.indexOf("Panel")>=0 || mode.indexOf("scroll")>=0) ? attributes.y : attributes.x);
			var columnWidth:Number = (attributes.width - (nColumns - 1) * attributes.paddingH) / nColumns;
			var columnHeight:Number = (attributes.height - (nColumns - 1) * attributes.paddingV) / nColumns;
			var hasPicker:Boolean = false;
			
			_xml = xml;
			_attributes = attributes;
			
			_mode = mode;
			
			_children = [];
			var col:int = 0;
			for (var l:int=0;l<xmlList.length();l++) {
				var line:XML=xmlList[l];
				var localName:String = line.localName();
				
				if (line.nodeKind() == "text" || localName=="data" || localName=="model" || localName=="sendModel")
					continue;
				
				var child:DisplayObject;
				var childAttributes:Attributes = attributes.copy(line, true);
				childAttributes.y = 0;
				
				if (mode=="columns") {
					if (customWidths()) {
						childAttributes.width = columnWidth = _widths[col];
						childAttributes.x = pos;                                                        
					}
					else {
						childAttributes.width = columnWidth;
						childAttributes.x = pos;
					}
				}
				else if (mode=="rows") {
					if (customHeights()) {
						childAttributes.height = columnHeight = _heights[col];
						childAttributes.y = pos;                                                        
					}
					else {
						childAttributes.height = columnHeight;
						childAttributes.y = pos;
					}
				} else if (mode=="horizontal") {
					childAttributes.width += (childAttributes.x-pos);
					if (childAttributes.width < 0)
						childAttributes.width = 0
					childAttributes.x = pos;
				}
				else if (mode!="frame") {
					childAttributes.height += (childAttributes.y-pos);
					if (childAttributes.height < 0)
						childAttributes.height = 0
					childAttributes.y = pos;
				}
				
				child = UI.containers(this, line, childAttributes);
				if (!child)
					switch(localName) {
						case 'group':
						case 'clickableGroup': 
						case 'frame':
						case 'horizontal':
						case 'vertical':
						case 'rows':
						case 'columns': var newAttributes:Attributes = childAttributes.copy();
							newAttributes.x=0;
							newAttributes.y=0;
							//                      if (localName=="rows" || localName=="columns")
							//                              newAttributes.hasBorder = false;
							child = new UI.FormClass(this, line, newAttributes, row, _inGroup);
							break;
						case 'search':child = new UISearch(this, line, childAttributes);break;
						case 'imageLoader':child = new UIImageLoader(this, line, childAttributes);break;
						case 'picker':child = new UIPicker(this, line, childAttributes,mode!="columns" || l==0,mode!="columns" || l==xmlList.length()-1, _pickerHeight,_cursorHeight);
							hasPicker = true;
							break;
						case 'label':child = parseLabel(line, childAttributes);break;
						case 'touchLabel':child = parseTouchLabel(line, childAttributes);break;
						case 'button':child = parseButton(line, childAttributes);break;
						case 'image':child = new UIImage(this, line, childAttributes);break;
						case 'input':child = parseInputJT(line, childAttributes);break;
						case 'password':child = parsePassword(line, childAttributes);break;
						case 'switch':child = parseSwitch(line, childAttributes);break;
						case 'slider':child = parseSlider(line, childAttributes);break;
						case 'arrow':child = new UIArrow(this, childAttributes.x, childAttributes.y, childAttributes.colour, childAttributes.backgroundColours);break;
						default:child = otherCommands(line, childAttributes);
					}
				
				if (child) {
					if (child is MadSprite && line.@includeInLayout=="false")
						MadSprite(child).includeInLayout=false;
					
					_children[l] = child;
					
					if (row) {
						childAttributes.initPosition(child);
					}
					else {
						childAttributes.position(child,_inGroup);
					}
					
					if (_style) {
						var groupHeight:Number = ((mode=="rows") ? columnHeight : child.height) + _attributes.paddingV;
						var top:Number = pos-_attributes.paddingV/2 + GROUP_OFFSET;
						var doLines:UIForm = (line.@lines.length()>0 && line.@lines[0].toString()!="false" && child is UIForm) ? UIForm(child) : null;
						groupedBackground(l==0, l>=nColumns-1, pos-_attributes.paddingV/2 + GROUP_OFFSET, groupHeight, col, false, doLines);
					}
					
					if (!childAttributes.visible)
						child.visible = false;
					
					if (mode == "columns") {
						pos += columnWidth + attributes.paddingH;
					}
					else if (mode == "rows") {
						pos += columnHeight + attributes.paddingV;
					}
					else if (included(child)) {
						if (mode == "horizontal") {
							pos = child.x + child.width + attributes.paddingH;
						}
						else if (mode != "frame") {
							pos = child.y + child.height + attributes.paddingV;
						}
					}
				}
				col++;
			}
			_extra = 0;
			if (row) {
				layout(attributes);
			} else if (_mode == "columns" && hasPicker) {
				pickerBackground(attributes);
				_extra = UI.PADDING;
			}
			else if (_mode.indexOf("scroll")<0 && !_style && attributes.backgroundColours.length>0) {
				drawBackground();
			}
			return child;
		}
		
		override public function layout(attributes:Attributes):void {
			_attributes = attributes; //.copy(_xml);
			
			if (_lazyRender)
				return;
			
			if (_style || _xml.@border.length()>0 && _xml.@border[0]=="true") {
				_attributes.y = UI.PADDING + _attributes.paddingV/2;
				_attributes.x += UI.PADDING;
				_attributes.width -= 2*UI.PADDING;
				_attributes.height -= 2*UI.PADDING + _attributes.paddingV;
			}
			if (_xml.@width.length()>0)
				_attributes.width = _xml.@width[0];
			if (_xml.@height.length()>0)
				_attributes.height = _xml.@height[0];
			
			if (_row) {
				_attributes.height = height;
			}
			_positions = [];
			var xmlList:XMLList = xml.children();
			var pos:Number = ((_mode=="vertical" || _mode=="rows" || _mode.indexOf("Panel")>=0 || _mode.indexOf("scroll")>=0) ? attributes.y : attributes.x);
			var nColumns:int = numberOfColumns(xmlList);
			var columnWidth:Number = (_attributes.width - (nColumns - 1) * _attributes.paddingH) / nColumns;
			var columnHeight:Number = (_attributes.height - (nColumns - 1) * _attributes.paddingV) / nColumns;
			var hasPicker:Boolean = false;
			var col:int = 0;
			if (_style)
				_style.graphics.clear();
			for (var l:int=0;l<xmlList.length();l++) {
				var line:XML=xmlList[l];
				var localName:String = line.localName();
				
				if (line.nodeKind() == "text" || localName=="data" || localName=="model" || localName=="sendModel")
					continue;
				
				var childAttributes:Attributes = _attributes.copy(line, true);
				childAttributes.y = 0;
				var child:DisplayObject = _children[l];
				
				if (_mode=="columns") {
					if (customWidths()) {
						childAttributes.width = columnWidth = _widths[col];
						childAttributes.x = pos;
					}
					else {
						childAttributes.width = columnWidth;
						childAttributes.x = pos;
					}
				}
				else if (_mode=="rows") {
					if (customHeights()) {
						childAttributes.height = columnHeight = _heights[col];
						childAttributes.y = pos;                                                        
					}
					else {
						childAttributes.height = columnHeight;
						childAttributes.y = pos;
					}
				}
				else if (_mode=="horizontal") {
					childAttributes.width += (childAttributes.x-pos);
					if (childAttributes.width < 0)
						childAttributes.width = 0       
					childAttributes.x = pos;
				}
				else if (_mode != "frame") {
					childAttributes.height += (childAttributes.y-pos);
					if (childAttributes.height < 0)
						childAttributes.height = 0
					childAttributes.y = pos;
				}
				if (UI.isContainer(localName)) {
					if (child is IContainerUI) {
						IContainerUI(child).layout(childAttributes);
						child.x = childAttributes.x;
						child.y = childAttributes.y;
					}
				}
				else switch(localName) {
					case 'group':
					case 'clickableGroup':
					case 'frame':
					case 'horizontal':
					case 'vertical':
					case 'columns':
					case 'rows': var newAttributes:Attributes = childAttributes.copy();
						if (localName=="rows" || localName=="columns")
							newAttributes.hasBorder = false;
						newAttributes.x=0;
						newAttributes.y=0;
						UI.FormClass(child).layout(newAttributes);
						break;
					
					case 'picker': hasPicker = true;
						IContainerUI(child).layout(childAttributes);break;
					break;
					
					case 'label':
						//      if (_xml.@height.length()>0 && child is UILabel) 
						//              UILabel(child).fixheight = Number(_xml.@height[0]);
						//      if (childAttributes.fillH || _xml.@height.length()>0) {
						//              UILabel(child).fixwidth = childAttributes.widthH;
						//      }
						if (line.@height.length()>0 && child is UILabelJT) 
							UILabelJT(child).fixheight = Number(line.@height[0]);
						if (childAttributes.fillH || line.@height.length()>0) {
							UILabelJT(child).fixwidth = childAttributes.widthH;
						}
						break;
					
					case 'touchLabel':
						//      if (_xml.@height.length()>0 && child is UILabel) 
						//              UILabel(child).fixheight = Number(_xml.@height[0]);
						//      if (childAttributes.fillH || _xml.@height.length()>0) {
						//              UILabel(child).fixwidth = childAttributes.widthH;
						//      }
						if (line.@height.length()>0 && child is UITouchLabel) 
							UITouchLabel(child).fixheight = Number(line.@height[0]);
						if (childAttributes.fillH || line.@height.length()>0) {
							UITouchLabel(child).fixwidth = childAttributes.widthH;
						}
						break;
					
					case 'button':
						if (childAttributes.fillV) {
							UIButton(child).skinHeight = childAttributes.heightV;
						}
						if (childAttributes.fillH) {
							UIButton(child).fixwidth = childAttributes.widthH;
						}
						break;
					case 'input':
					case 'slider': 
						if (childAttributes.fillH) {
							Object(child).fixwidth = childAttributes.widthH;
						}
						break;
					case 'search':
						UISearch(child).fixwidth = childAttributes.width;
						break;
					
					case 'arrow':
					case 'switch': break;
					
					case 'image':
					case 'imageLoader': UIImage(child).attributesWidth = childAttributes.widthH;
						UIImage(child).attributesHeight = childAttributes.heightV;
						break;
					default:
						if (childAttributes.fillH) {
							Object(child).width = childAttributes.widthH;
						}                                                       
				}
				
				childAttributes.position(child, _inGroup && !_row);
				_positions.push(child.x);
				
				if (_style) {
					var groupHeight:Number = ((_mode=="rows") ? columnHeight : child.height) + _attributes.paddingV;
					var top:Number = pos-_attributes.paddingV/2 + GROUP_OFFSET;
					var doLines:UIForm = (line.@lines.length()>0 && line.@lines[0].toString()!="false" && child is UIForm) ? UIForm(child) : null;
					groupedBackground(l==0, l>=nColumns-1, top, groupHeight, col, false, doLines);
				}
				
				if (_mode == "columns") {
					pos += columnWidth + _attributes.paddingH;
				}
				else if (_mode == "rows") {
					pos += columnHeight + _attributes.paddingV;
				}
				else if (included(child)) {
					if (_mode == "horizontal") {
						pos = child.x + child.width + _attributes.paddingH;
					}
					else if (_mode != "frame"){
						pos = child.y + child.height + _attributes.paddingV;
					}
				}
				col++;
			}
			_extra = 0;
			if (_mode == "columns" && hasPicker) {
				pickerBackground(_attributes);
				_extra = UI.PADDING;
			}
			else if (_mode.indexOf("scroll")<0 && !_style && !_row && _attributes.backgroundColours.length>0) {
				drawBackground();
			}
		}
		
		protected override function parseLabel(xml:XML, attributes:Attributes):DisplayObject {
			var label:UILabelJT=new UILabelJT(this, attributes.x, attributes.y, xml.toString());
			assignToLabel2(xml, label);
			if (xml.@height.length()>0)
				label.fixheight = Number(xml.@height[0]);
			if (attributes.fillH || xml.@height.length()>0) {
				label.fixwidth = attributes.widthH;
				var textAlign:String = attributes.textAlign;
				if (textAlign != "") {
					var format:TextFormat = new TextFormat();
					format.align = textAlign;
					label.defaultTextFormat = format;
				}
			}
			return label;
		}
		
		protected function parseTouchLabel(xml:XML, attributes:Attributes):DisplayObject {
			var label:UITouchLabel=new UITouchLabel(this, attributes.x, attributes.y, xml.toString(), xml.@id.toString());
			assignToLabel2(xml, label);
			if (xml.@height.length()>0)
				label.fixheight = Number(xml.@height[0]);
			if (attributes.fillH || xml.@height.length()>0) {
				label.fixwidth = attributes.widthH;
				var textAlign:String = attributes.textAlign;
				if (textAlign != "") {
					var format:TextFormat = new TextFormat();
					format.align = textAlign;
					label.defaultTextFormat = format;
				}
			}
			return label;
		}
		
		protected function assignToLabel2(xml:XML, label:UILabelJT):Boolean {
			if (xml.hasComplexContent()) {
				var xmlString:String = xml.toXMLString();
				var htmlText:String = xmlString.substring(xmlString.indexOf(">")+1,xmlString.lastIndexOf("<"));
				
				label.htmlText = htmlText;
				if (label.text=="") {
					label.text=" ";
				}
				return true;
			}
			return false
		}
		
		protected function parseInputJT(xml:XML, attributes:Attributes):DisplayObject {
			var inputText:UIInputJT = new UIInputJT(this, attributes.x, attributes.y, xml.toString(), attributes.backgroundColours, xml.@alt.length()>0, xml.@prompt.length()>0 ? xml.@prompt[0].toString() : "", xml.@promptColour.length()>0 ? UI.toColourValue(xml.@promptColour[0].toString()) : UIBlueText.GREY);
			if (attributes.fillH) {
				inputText.fixwidth = attributes.widthH;
			}
			return inputText;
		}
		
		protected function parsePassword(xml:XML, attributes:Attributes):DisplayObject {
			var inputText:UIPassword = new UIPassword(this, attributes.x, attributes.y, xml.toString(), attributes.backgroundColours, xml.@alt.length()>0, xml.@prompt.length()>0 ? xml.@prompt[0].toString() : "", xml.@promptColour.length()>0 ? UI.toColourValue(xml.@promptColour[0].toString()) : UIBlueText.GREY);
			if (attributes.fillH) {
				inputText.fixwidth = attributes.widthH;
			}
			return inputText;
		}
	}
}