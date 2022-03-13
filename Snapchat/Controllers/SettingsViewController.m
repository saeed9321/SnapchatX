#import "SettingsViewController.h"
#import "SnapchatXPrefs.h"

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SnapchatXPrefs shared] reloadPrefs];

    CGFloat width = self.view.frame.size.width;
    
    self.tableView.delegate = self;
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UIImage *headerImage = [UIImage imageWithContentsOfFile:@"/Library/Application Support/snapchatx/1.png"];
    if(!headerImage){
        // in case the image is added to recources folder
        headerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"]];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 200)];
    [imageView setImage:headerImage];
    
    self.tableView.tableHeaderView = imageView;
    self.tableView.tableFooterView = [UIView new];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Features";
    }
    if(section == 1){
        return @"Developed by";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        return 80;
    }
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 5;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"myCell"];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myCell"];
        }
        UISwitch *mySwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
        mySwitch.tag = indexPath.row;
        mySwitch.onTintColor = [UIColor yellowColor];
        [mySwitch addTarget:self action:@selector(switched:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = mySwitch;
        NSString *text = nil;
        NSString *details = nil;
        
        switch (indexPath.row) {
            case 0:
                text = @"Enable save media button";
                details = @"This will enable you to save images and videos";
                if([[SnapchatXPrefs shared] isSaveMediaEnabled]){
                    mySwitch.on = YES;
                }
                break;
            case 1:
                text = @"Enable loop forever";
                details = @"Snaps images and videos will keep looping";
                if([[SnapchatXPrefs shared] isLoopMediaEnabled]){
                    mySwitch.on = YES;
                }
                break;
            case 2:
                text = @"Disable screenshot detection";
                details = @"Nobody will know if you took screenshot";
                if([[SnapchatXPrefs shared] isDisableScreenshot]){
                    mySwitch.on = YES;
                }
                break;
            case 3:
                text = @"Disable typing";
                details = @"Nobody will know if you are typing";
                if([[SnapchatXPrefs shared] isDisableTyping]){
                    mySwitch.on = YES;
                }
                break;
            case 4:
                text = @"SnapchatX Ghost";
                details = @"Open chats without read receipt"; 
                if([[SnapchatXPrefs shared] isDisableReadReceipt]){
                    mySwitch.on = YES;
                }
                break;
            default:
                break;
        }
        cell.textLabel.text = text;
        cell.detailTextLabel.text = details;
        [cell setBackgroundColor:[UIColor blackColor]];
        [cell.textLabel setTextColor:[UIColor yellowColor]];
        [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
        [cell.detailTextLabel adjustsFontSizeToFitWidth];
        
        return cell;
    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"devCell"];
        cell.textLabel.text = @"Said Mohd";
        cell.textLabel.textColor = [UIColor redColor];
        cell.imageView.image = [UIImage imageWithContentsOfFile:@"Library/Application Support/snapchatx/logo2.png"];
        [cell setBackgroundColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/saeed9321"] options:@{} completionHandler:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return NO;
    }
    return YES;
}

-(void)switched:(UISwitch *)mySwitch{
    switch(mySwitch.tag){
        case 0:
            [[SnapchatXPrefs shared] updatePref:@"saveMediaEnabled" withValue:mySwitch.isOn];
            break;
        case 1:
            [[SnapchatXPrefs shared] updatePref:@"loopMediaEnabled" withValue:mySwitch.isOn];
            break;
        case 2:
            [[SnapchatXPrefs shared] updatePref:@"disableScreenshot" withValue:mySwitch.isOn];
            break;
        case 3:
            [[SnapchatXPrefs shared] updatePref:@"disableTyping" withValue:mySwitch.isOn];
            break;
        case 4:
            [[SnapchatXPrefs shared] updatePref:@"disableReadReceipt" withValue:mySwitch.isOn];
            break;
    }
}
@end


