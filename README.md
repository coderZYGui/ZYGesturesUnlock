# ZYGesturesUnlock
### 效果如下<br>
    ![](https://github.com/coderZYGui/ZYGesturesUnlock/blob/master/ZYGesturesUnlock/img/ZYGesturesUnlock.gif)<br>

### 实现思路:
分析界面,当手指在上面移动时,当移动到一个按钮范围内当中, 它会把按钮给成为选中的状态.<br>
并且把第一个选中的按钮当做一个线的起点,当手指移动到某个按钮上时,就会添加一根线到选中的那妞上.<br>
当手指松开时,所有按钮取消选中.所有的线都清空.<br>

#### 实现思路:<br>
	先判断点前手指在不在当前的按钮上.如果在按钮上,就把当前按钮成为选中状态.<br>
	并且把当前选中的按钮添加到一个数组当中.如果当前按钮已经是选中状态,就不需要再添加到数组中了.<br>
	每次移动时,都让它进行重绘.<br>
	在绘图当中,遍历出所有的选中的按钮,<br>
	判断数组当中的第一个无素,如果是第一个,那么就把它设为路径的起点.其它都在添加一根线到按钮的圆心.<br>
	如果当前点不在按钮上.那么就记录住当前手指所在的点.直接从起点添加一根线到当前手指所在的点.<br>
	

#### 实现步骤:<br>
1.搭建界面<br>
    界面是一个九宫格的布局.九宫格实现思路.<br>
	先确定有多少列  cloum = 3;<br>
	计算出每列之间的距离<br>
	计算为: CGFloat margin = (当前View的宽度 - 列数 * 按钮的宽度) / 总列数 + 1<br>
	每一列的X的值与它当前所在的行有关<br>
	当前所在的列为:curColum = i % cloum<br>
	每一行的Y的值与它当前所在的行有关.<br>
	当前所在的行为:curRow = i / cloum<br>
	
	每一个按钮的X值为, margin + 当前所在的列 * (按钮的宽度+ 每个按钮之间的间距)
	每一个按钮的Y值为 当前所在的行 * (按钮的宽度 + 每个按钮之间的距离)
	
	具体代码为:
	总列娄
	int colum = 3;
	每个按钮的宽高
	CGFloat btnWH = 74;
	每个按钮之间的距离
	CGFloat margin = (self.bounds.size.width - colum * btnWH) / (colum + 1);
    for(int i = 0; i < self.subviews.count; i++ ){
		当前所在的列
        int curColum = i % colum;
        当前所在的行
        int curRow = i / colum;
        CGFloat x = margin + (btnWH + margin) * curColum;
        CGFloat y = (btnWH + margin) * curRow;
        取出所有的子控件
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, btnWH, btnWH);
    }
    
 2.监听手指在上面的点击,移动,松开都需要做操作.
 	
 	2.1在手指开始点击屏幕时,如果当前手指所在的点在按钮上, 那就让按钮成为选中状态.
		所以要遍历出所有的按钮,判断当前手指所在的点在不在按钮上,
		如何判断当前点在不在按钮上?
		当前方法就是判断一个点在不在某一个区域,如果在的话会返回Yes,不在的话,返回NO.
		CGRectContainsPoint(btn.frame, point)
 	
		在手指点击屏幕的时候,要做的事分别有
		1.获取当前手指所在的点.
			UITouch *touch = [touches anyObject];
			CGPoint curP =  [touch locationInView:self];
		2.判断当前点在不在按钮上.
			 for (UIButton *btn in self.subviews) {
    			if (CGRectContainsPoint(btn.frame, point)) {
      				  return btn;
    			}
		     }
   		3.如果当前点在按钮上,并且当前按钮不是选中的状态.
   		  那么把当前的按钮成为选中状态.
   		  并且把当前的按钮添加到数组当中.

   	
   	2.2 当手指在移动的时也需要判断.
		  判断当前点在按钮上,并且当前按钮不是选中的状态.
   		  那么把当前的按钮成为选中状态.
   		  并且把当前的按钮添加到数组当中.
		 在移动的时候做重绘的工作.
		 
    2.3 当手指离开屏幕时.
        取出所有的选中按钮,把所有选中按钮取消选中状态.
        清空选中按钮的数组.
        绘重绘的工作.
        
        
 3. 在绘图方法当中.<br>
 	创建路径 <br>
 	遍历出有的选中按钮.如果是第一个按钮,把第一个按钮的中心点当做是路径的起点.<br>
 	其它按钮都直接添加一条线,到该按钮的中心.<br>
 	
 	遍历完所有的选中按钮后.<br>
 	最后添加一条线到当前手指所在的点.<br>
  
