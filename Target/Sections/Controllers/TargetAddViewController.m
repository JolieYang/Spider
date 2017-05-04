//
//  TargetAddViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//
// [todo] 进入该页面时自动弹出键盘

#import "TargetAddViewController.h"
#import "IconTextFieldTableViewCell.h"
#import "IconTextViewTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "TextViewTableViewCell.h"
#import "Target.h"
#import "TargetManager.h"
#import "DateHelper.h"
#import "UITextView+JY.h"
#import "JYImageView.h"

// 访问相册图片
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface TargetAddViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *configTableView;
@property (nonatomic, strong) IconTextFieldTableViewCell *firstCell;
@property (nonatomic, strong) TextViewTableViewCell *secondCell;
@property (nonatomic, strong) UICollectionView *iconCollectionView;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation TargetAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"创建Target";
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self customBackItemWithImageName:Gray_Nav_Back_Icon_Name action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationController.navigationBar.barTintColor = System_Nav_White;
    [self setNavigationBarTitleColor:System_Nav_Gray];
    [self becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setupViews {
    self.view.backgroundColor = App_Bg;
    self.configTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight) style: UITableViewStylePlain];
    self.configTableView.backgroundColor = App_Bg;
    self.configTableView.delegate = self;
    self.configTableView.dataSource = self;
    self.configTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.configTableView];
    
    [self addDoneNavigationItem];
    [self hideRightItem:YES];
    
    [self addResignKeyboardGestures];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setupImagePicker];
    });
}

- (void)addDoneNavigationItem {
    [self customRightItemWithImageName:Gray_Nav_Check_Icon_Name action:^{
        [self doneItemAction];
    }];
}

- (void)doneItemAction {
    // 添加项目
    if ([self.firstCell.inputTextField.text trim].length == 0) {
        [JYProgressHUD showTextHUDWithDetailString:@"请填写Target名称" AddedTo:self.view];
        return;
    }
    if (self.successAddTargetBlock) {
        self.successAddTargetBlock([self addedTarget]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 4.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        return 58;
    } else if(indexPath.section == 1) {
        return 140;
    }else {
        return 0;
    }
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextFieldTableViewCell class])];
    if (!cell) {
        cell = [TextFieldTableViewCell loadFromNib];
    }
    
    if (indexPath.section == 0) {
        self.firstCell = [IconTextFieldTableViewCell loadFromNib];
        self.firstCell.inputTextField.placeholder = @"Target名称，如看电影，跑步";
        self.firstCell.iconImageView.image = Default_Image;
        self.firstCell.inputTextField.returnKeyType = UIReturnKeyDone;
        self.firstCell.inputTextField.font = [UIFont systemFontOfSize:16.0];
        [self.firstCell.iconImageView tapGestureWithBlock:^{
            [self chooseImageFromSystem];
        }];
        self.firstCell.textFieldReturnBlock = ^(NSString *text) {
            [weakSelf.view endEditing:YES];
        };
        self.firstCell.textFieldDidChangeBlock = ^(NSString *text) {
            if (text.length > 0) {
                [weakSelf hideRightItem:NO];
            } else {
                [weakSelf hideRightItem:YES];
            }
        };
        return self.firstCell;

    } else if(indexPath.section == 1) {
        TextViewTableViewCell *cell = [TextViewTableViewCell loadFromNib];
        self.secondCell = cell;
//        cell.textView.font = [UIFont fontWithName:@"PingFangSC-Thin" size:14.0];
        cell.textView.font = [UIFont systemFontOfSize:16.0];
        [cell.textView setPlaceHolder: @"描述Target，也可以是一句激励自己的话"];
        
        return cell;
    } else {
        return cell;
    }
}

- (Target *)addedTarget {
    Target *target = [[Target alloc] init];
    target.targetName = [self.firstCell.inputTextField.text trim];
    target.remarks = [self.secondCell.textView.text trim];
    target.targetIcon = self.firstCell.iconImageView.image;
    target.createUnix = [DateHelper getCurrentTimeInterval];
    target.updateUnix = target.createUnix;
    [TargetManager addTarget:target];
    return target;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)setupImagePicker {
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePickerController.allowsEditing = YES;
}

- (void)chooseImageFromSystem {
    // UIImagePickerControllerDelegate
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        // 无图片访问权限 "请在iPhone的“设置-隐私-照片"选项中，允许微信访问你的手机相册"
        [JYProgressHUD showLongerTextHUDWithString:@"请在iPhone的“设置-隐私-照片“选项中，允许Target访问你的手机相册" AddedTo:self.view];
    } else {
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    self.firstCell.iconImageView.image = image;
}
// choose
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        [self.firstCell.iconImageView round];
        self.firstCell.iconImageView.image = info[UIImagePickerControllerEditedImage];
        //压缩图片
        //        NSData *fileData = UIImageJPEGRepresentation(self.inputImageView.image, 1.0);
        //保存图片至相册
        //        UIImageWriteToSavedPhotosAlbum(self.inputImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        //上传图片
        //        [self uploadImageWithData:fileData];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
// cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
