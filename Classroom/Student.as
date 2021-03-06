package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author PYS
	 */
	public class Student extends Sprite
	{
		[Embed(source="assets/images/user.png")]
		private var StudentIcon:Class;
		private var studentIcon:Bitmap = new StudentIcon();
		
		[Embed(source="assets/images/desk.png")]
		private var Desk:Class;
		private var desk:Bitmap = new Desk();
		
		[Embed(source="assets/images/girl.png")]
		private var Girl:Class;
		private var girl:Bitmap = new Girl();
		
		[Embed(source="assets/images/boy.png")]
		private var Boy:Class;
		private var boy:Bitmap = new Boy();
		
		[Embed(source="assets/images/question.png")]
		private var Question:Class;
		private var question:Bitmap = new Question();
		
		public var ID:String;
		public var Name:String;
		public var Sort:Number;
		private var textField:TextField;
		private var dragPoint:Point;
		private var stageBackgroundColor:uint = 0x7dde91;
		
		public function Student(name:String,sex:Number)
		{
			this.Name = name;
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "宋体,Verdana";
			textFormat.size = 12;
			textFormat.bold = false;
			textFormat.align = "center";
			textFormat.color = 0xffffff;
			
			
			textField = new TextField();
			textField.text = this.Name;
			textField.border = false;
			textField.borderColor = stageBackgroundColor;
			textField.width = 50;
			textField.height = 20;
			textField.setTextFormat(textFormat);
			
			//textField.autoSize = "center";
			
			this.addChild(desk);
			this.addChild(textField);
			switch(sex)
			{
				case 0:this.addChild(boy); break;
				case 1:this.addChild(girl); break;
				case 2:this.addChild(question); break;				
			}
					
			studentIcon.x = 0;
			studentIcon.y = 0;
			textField.x = 0;
			textField.y = 20;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, function(event:MouseEvent):void
				{
					draw(stageBackgroundColor, 2, 0.5);
				});
			this.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):void
				{
					draw(stageBackgroundColor, 0);
				});
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		public function hitByOther():void
		{
			draw(0x0000ff, 1, 0.2);
		}
		
		public function unHitByOther():void
		{
			draw(stageBackgroundColor, 0, 1);
		
		}
		
		private function mouseDown(event:MouseEvent):void
		{
			this.parent.addChild(this);
			Mouse.cursor = "button";
			this.startDrag();
			dragPoint = new Point(this.x, this.y);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoving);
		}
		
		private function mouseMoving(event:MouseEvent):void
		{
			getHitStudent();
		}
		
		private function mouseUp(event:MouseEvent):void
		{
			this.stopDrag();
			Mouse.cursor = "arrow";
			event.updateAfterEvent();
			// hit someone
			var hitStudent:Student = getHitStudent();
			if (hitStudent != null)
			{
				var tempSort:Number = this.Sort;
				this.Sort = hitStudent.Sort;
				hitStudent.Sort = tempSort;
				Tweener.addTween(this, {x: hitStudent.x, y: hitStudent.y, time: 0.2, transition: "linear"});
				Tweener.addTween(hitStudent, {x: dragPoint.x, y: dragPoint.y, time: 0.5, transition: "linear"});
			}
			else
				// not hit anyone,back to oritional position						
				Tweener.addTween(this, {x: dragPoint.x, y: dragPoint.y, time: 0.2, transition: "linear"});
			this.unHitAll();
		}
		
		private function getHitStudent():Student
		{
			var retStudent:Student = null;
			for (var i:Number = 0; i < this.parent.numChildren; i++)
			{
				var obj:Object = this.parent.getChildAt(i);
				if (obj is Student && obj != this)
				{
					var targetStudent:Student = obj as Student;
					if (this.hitTestObject(targetStudent) && retStudent == null)
					{
						targetStudent.hitByOther();
						retStudent = targetStudent;
					}
					else
						targetStudent.unHitByOther();
				}
			}
			return retStudent;
		}
		
		private function unHitAll()
		{
			for (var i:Number = 0; i < this.parent.numChildren; i++)
			{
				var obj:Object = this.parent.getChildAt(i);
				if (obj is Student)
				{
					var targetStudent:Student = obj as Student;
					targetStudent.unHitByOther();
				}
			}
		}
		
		private function draw(color:uint, lineThickness:uint, alpha = 1):void
		{
			this.graphics.clear();
			this.graphics.beginFill(color, 1);
			if (lineThickness > 0)
				this.graphics.lineStyle(lineThickness, 0x000000);
			var rec:Rectangle = this.getRect(this);
			this.graphics.drawRect(rec.x, rec.y, this.width, this.height);
			this.graphics.endFill();
			this.alpha = alpha;
		}
		
		public function resize():void
		{
		
		}
	}
}