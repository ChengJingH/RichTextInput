
//
//  RichTextInputView.m
//  RichTextInput
//
//  Created by walen on 2019/7/29.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "RichTextInputView.h"
#import <CoreText/CoreText.h>

@interface RichTextInputView ()
@property (assign, nonatomic) CTFrameRef frameRef;
@property (assign, nonatomic) CGRect drawRect;

@property (strong, nonatomic) NSMutableArray *linesPositionArr;

@end

@implementation RichTextInputView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(RichTextInputView.class) owner:self options:nil].firstObject;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        self.linesPositionArr = [[NSMutableArray alloc] init];
        [self.linesPositionArr addObject:@(0.0)];
        
        //更新布局
//        [self setNeedsDisplay];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects.lastObject;
    CGPoint point = [touch locationInView:self];
    
//    NSLog(@"hit position ~ %@",NSStringFromCGPoint(point));
    CFArrayRef linesArrayRef = CTFrameGetLines(self.frameRef);
    CGPoint origins[CFArrayGetCount(linesArrayRef)];//行组
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), origins);
    
    //点击行
    NSInteger pointLine = 0;
    for (int i = 1; i < self.linesPositionArr.count; i ++) {
        NSNumber *pre_linePosition = [self.linesPositionArr objectAtIndex:i-1];
        NSNumber *next_linePosition = [self.linesPositionArr objectAtIndex:i];
        if ((point.y - self.drawRect.origin.y) <= next_linePosition.floatValue && (point.y - self.drawRect.origin.y) >= pre_linePosition.floatValue) {
            pointLine = i;
            NSLog(@"pointLine ~ %ld",(long)pointLine);
            break;
        }
    }
    
//    CGFloat ascent;
//    CGFloat descent;
//    CGFloat leading;
    CTLineRef lineRef = CFArrayGetValueAtIndex(linesArrayRef, pointLine - 1);
    NSNumber *clickPoint_y = [self.linesPositionArr objectAtIndex:pointLine - 1];
    CGPoint click_position = CGPointMake(point.x-self.drawRect.origin.x, clickPoint_y.floatValue);
    CFIndex stringIndex = CTLineGetStringIndexForPosition(lineRef, click_position);
    NSString *clickStr = [self.contentStr substringWithRange:NSMakeRange(stringIndex-1, 1)];
    NSLog(@"clickStr ~ %@",clickStr);
    
}

//文本绘制
- (void)drawRect:(CGRect)rect
{
    self.contentStr = @"八一建军节诞生于1933年，她的第一个节日庆祝活动，是在中央苏区首府——江西瑞金举行的。\n__________，中共苏区中央局发出《关于“八一”国际反战争斗争日及中国工农红军成立纪念日的决定》。决定指出：“中央革命军事委员会为纪念1927年8月1日的南昌暴动，已确定‘八一’为中国工农红军纪念的日子。”尔后，中央革命军事委会员针对为什么确定“八一”为建军节作出这样的解释：“1927年8月1日发生了无产阶级政党——共产党领导的南昌暴动，这一暴动是反帝的土地革命的开始，是英勇的工农红军的来源。中国工农红军在历年的艰苦战争中，打破了帝国主义国民党的历次进攻，根本动摇了帝国主义国民党在中国的统治，已成了革命高涨的基本杠杆之一，成了中国劳苦群众革命斗争的组织者，是彻底进行民族革命战争的主力。本委会为纪念南昌暴动的胜利与红军的成立，特决定自1933年8月1日为中国工农红军成立纪念日。”7月1日，中华苏维埃共和国临时中央政府作出《关于“八一”纪念运动苏区党、政、军领导纷纷作出动员，毛泽东专门撰写了__________一文，发表在7月29日的《红色中华》报上；博古作了以__________为题的多场专题演讲；张闻天到机关、学校作了《“八一”与帝国主义战争危险》的专题报告。与此同时，苏区各级政府组织群众开展了集会、游行、晚会活动，红军各部的宣传活动更为热烈。\n1933年8月1日，第一个“八一”建军节庆祝活动在瑞金城南举行。傍晚，苏区军民打着火把，从四面八方朝这里涌来，工农剧社组成的欢迎表演团站在入口处，边舞边唱。庆祝活动分阅兵式和分列式，为防敌机轰炸，决定阅兵式在十七点到十九点半进行完。十七时，阅兵式开始，军乐奏起，礼炮齐鸣，毛泽东、朱德、项英三位领导策马而行，检阅长达六百余米的红军队列，红军指战员以注目礼相迎，欢呼声、口号声响彻云霄。第二项是宣誓。中央革命军事委员会向新成立的红军工人师和少共国际师授军旗，向两个师发出奔赴前线英勇杀敌的战斗命令，工人师和少共国际师组成两块方阵，指战员高举拳头进行宣誓。第三项是授旗授奖。中革军委领导分别给各红军学校授校旗，给红军各团队授战旗，向功勋卓著的红军指挥员颁发红星奖章。中央政府和各党、群团体代表致祝辞，分列式随之开始。红军第二团第五团第三十七团第四十团等方队在一面面战旗引领下阔步通过检阅台，战士们一面高呼着口号、一面向检阅台上的首长行注目礼。长长的受阅队伍从检阅台前整整走了一个多小时。坚定的步伐踏破夜幕，踏碎尘土，踹动着这个令人难忘的夜晚，把“81”两个大字嵌入史册。__________，在朱日和训练基地举行庆祝中国人民解放军建军90周年阅兵，中共中央总书记、国家主席、中央军委主席习近平检阅部队并发表重要讲话。中央人民广播电台、中央电视台、中国国际广播电台现场直播。 [1]";
    NSString *content = self.contentStr;
    
    //记录输入位置
    NSMutableArray *rangeArr = [[NSMutableArray alloc] init];
    while (true) {
        if ([content rangeOfString:@"__________" options:NSBackwardsSearch].location == NSNotFound) {
            break;
        }else{
            NSRange range = [content rangeOfString:@"__________" options:NSBackwardsSearch];
            NSMutableDictionary *rangeDic = [NSMutableDictionary dictionary];
            [rangeDic setObject:[NSNumber numberWithInteger:range.location] forKey:@"range_location"];
            [rangeDic setObject:[NSNumber numberWithInteger:range.length] forKey:@"range_length"];
            [rangeArr addObject:rangeDic];
            content = [content substringToIndex:range.location];
        }
    }
    NSLog(@"范围 ~ %@",rangeArr);
    self.drawRect = CGRectMake(20, 69, [UIScreen mainScreen].bounds.size.width-40.0, [UIScreen mainScreen].bounds.size.height);

    //绘制路劲
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, &CGAffineTransformIdentity, self.drawRect);
    if (CGPathIsRect(path, &_drawRect)) {
        NSLog(@"矩形");
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.contentStr];
    CFAttributedStringRef attributedStringRef = (__bridge CFAttributedStringRef)attributedString;
    CFRange stringRange = CFRangeMake(0, self.contentStr.length);
    self.frameRef = CTFramesetterCreateFrame(CTFramesetterCreateWithAttributedString(attributedStringRef), stringRange, path, NULL);
    
    //绘制区域
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);

    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -self.drawRect.size.height);
    
    //位置移动
    CGContextTranslateCTM(context, 0.0, -2*self.drawRect.origin.y);
    CTFrameDraw(self.frameRef, context);
    UIGraphicsPopContext();

    //添加位置
    CGFloat str_width = 0.0;
    CFArrayRef linesArrayRef = CTFrameGetLines(self.frameRef);
    CGPoint origins[CFArrayGetCount(linesArrayRef)];//行组
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), origins);
    
    for (int i = 0; i < CFArrayGetCount(linesArrayRef); i ++) {
        CTLineRef lineRef = CFArrayGetValueAtIndex(linesArrayRef, i);
        CGRect lineRect = CTLineGetBoundsWithOptions(lineRef, kCTLineBoundsExcludeTypographicLeading);

        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
        CGFloat line_bottom = self.drawRect.size.height - origins[i].y + descent;
        //保存行底部距离
        [self.linesPositionArr addObject:@(line_bottom)];
        
        //runs
        CFArrayRef runsRef = CTLineGetGlyphRuns(lineRef);
        for (int j = 0; j < CFArrayGetCount(runsRef); j ++) {
            CTRunRef runRef = CFArrayGetValueAtIndex(runsRef, j);
            const CGPoint *run_points = CTRunGetPositionsPtr(runRef);
            CFRange run_range = CTRunGetStringRange(runRef);

            //获取runRef位置
            for (NSDictionary *locationRectDic in rangeArr) {
                NSString *location = locationRectDic[@"range_location"];
                NSString *length = locationRectDic[@"range_length"];
                if ((length.integerValue+location.integerValue) <= (run_range.length+run_range.location)) {
                    if (location.integerValue >= run_range.location) {
                        //匹配字符串宽度
                        CFIndex glyphCount = CTRunGetGlyphCount(runRef);
                        const CGSize *run_size = CTRunGetAdvancesPtr(runRef);
                        
                        str_width = run_size[0].width*glyphCount;
//                        NSLog(@"runsRef Rect ~ %@",NSStringFromCGRect(CGRectMake(self.drawRect.origin.x + run_points->x, self.drawRect.origin.y + line_bottom - lineRect.size.height, str_width, lineRect.size.height)));
                        
                        CGAffineTransform transform = CTRunGetTextMatrix(runRef);
                        CGPathRef rect_path = CGPathCreateWithRect(CGRectMake(self.drawRect.origin.x + run_points->x, self.drawRect.origin.y + line_bottom - lineRect.size.height, str_width, lineRect.size.height), &transform);
                        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                        shapeLayer.path = rect_path;
                        shapeLayer.lineWidth = 1.0;
                        shapeLayer.strokeColor = [UIColor redColor].CGColor;
                        shapeLayer.fillColor = [UIColor clearColor].CGColor;
                        
                        [self.layer addSublayer:shapeLayer];
                        
                        //添加输入框
                        UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.drawRect.origin.x + run_points->x, self.drawRect.origin.y + line_bottom - lineRect.size.height, str_width, lineRect.size.height)];
                        inputTextField.backgroundColor = [UIColor lightGrayColor];
                        [self addSubview:inputTextField];
                    }
                }
            }
        }
        CGMutablePathRef line_path = CGPathCreateMutable();
        CGPathMoveToPoint(line_path, &CGAffineTransformIdentity, self.drawRect.origin.x + lineRect.origin.x, self.drawRect.origin.y + line_bottom);
        CGPathAddLineToPoint(line_path, &CGAffineTransformIdentity, self.drawRect.origin.x + lineRect.size.width + lineRect.origin.x, self.drawRect.origin.y + line_bottom);
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = line_path;
        shapeLayer.lineWidth = 1.0;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        [self.layer addSublayer:shapeLayer];
        
        NSLog(@"lineRect.size.height ~ %f,lineRect.origin.y ~ %f",lineRect.size.height,lineRect.origin.y);
    }
}

@end
