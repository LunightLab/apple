//
//  ViewController.m
//  lunight-objc
//
//  Created by lunight on 1/13/25.
//



#import "ViewController.h"
#import "ObjcLogger.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;


// 데이터
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<ViewTableItem *> *> *dataByYear;
@property (nonatomic, strong) NSArray<NSString *> *sectionTitles;
@property (nonatomic, strong) NSArray<ViewTableItem *> *filteredItems;
@property (nonatomic, assign) BOOL isFiltering;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDataFromJSON];
    
    [self setupTableView];
    [self setupSearchBar];
    [self.tableView reloadData]; // 데이터 갱신

    // 네비게이션 타이틀
    self.title = @"objc";

    // 왼쪽 버튼 추가
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"info"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(leftButtonTapped)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    // 오른쪽 버튼 추가
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"temp"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(rightButtonTapped)];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
    // 네비게이션 바 스타일 설정
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground]; // 불투명 배경
        appearance.backgroundColor = [UIColor systemBlueColor]; // 배경색 설정
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]}; // 제목 텍스트 색상

        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; // 버튼 색상
    
    // 기본적인 로깅 (타임스탬프만 포함)
    [ObjCLogger logInfo:@"사용자가 로그인했습니다"];

    // 카테고리 지정
    [ObjCLogger logInfo:@"API 호출 시작" category:@"network"];
    NSLog(@"TTTTT");
    // 민감한 정보 로깅
    LOG_PRIVATE(@"사용자 ID: user12345");

    // 디버그 로깅
    LOG_DEBUG(@"UI 디버그 정보");
    
}

// 버튼 동작
- (void)leftButtonTapped {
    NSLog(@"Left button tapped");
}

- (void)rightButtonTapped {
    NSLog(@"Right button tapped");
}

// 테이블 뷰 설정
- (void)setupTableView {
//    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

// 검색 바 설정
- (void)setupSearchBar {
//    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)]; // 크기 지정
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isFiltering ? 1 : self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isFiltering) {
        return self.filteredItems.count;
    }
    NSString *year = self.sectionTitles[section];
    return self.dataByYear[year].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.isFiltering ? nil : self.sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    ViewTableItem *item = self.isFiltering ? self.filteredItems[indexPath.row] : self.dataByYear[self.sectionTitles[indexPath.section]][indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subtitle;
    // 이미지 설정
       UIImage *originalImage;
    // taskStatus에 따라 이미지 설정
    switch (item.taskStatus) {
        case TaskStatusPending:
            originalImage = [UIImage imageNamed:@"task-pending"];
            break;
        case TaskStatusInProgress:
            originalImage = [UIImage imageNamed:@"task-inprogress"];
            break;
        case TaskStatusCompleted:
            originalImage = [UIImage imageNamed:@"task-completed"];
            break;
        case TaskStatusDelete:
            originalImage = [UIImage imageNamed:@"task-delete"];
            break;
        default:
            originalImage = [UIImage imageNamed:@"task-lock"];
            break;
    }
    // 이미지 크기 조정
    CGSize newSize = CGSizeMake(35, 35); // 원하는 크기
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [originalImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.imageView.image = resizedImage;
    
    // 기본 꺽쇠 모양 액세서리 설정
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ViewTableItem *item = self.isFiltering ? self.filteredItems[indexPath.row] : self.dataByYear[self.sectionTitles[indexPath.section]][indexPath.row];
    
    // 선택한 셀의 데이터 가져오기
    NSString *sectionKey = self.sectionTitles[indexPath.section];
    ViewTableItem *selectedItem = self.dataByYear[sectionKey][indexPath.row];
    
    Class viewControllerClass = NSClassFromString(item.viewControllerName);
    if (viewControllerClass) {
        
        UIViewController *viewController = [[viewControllerClass alloc] init];
        viewController.title = [NSString stringWithFormat:@"[%@]%@", sectionKey, selectedItem.title];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else{
        if([sectionKey isEqualToString:@"2024"])
            [self simpleShowAlert:@"알림" :@"프로젝트폴더 참고"];
        else
            [self simpleShowAlert:@"알림" :@"준비중"];
        
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isFiltering = NO;
        self.filteredItems = @[];
    } else {
        self.isFiltering = YES;
        NSMutableArray *filtered = [NSMutableArray array];
        for (NSString *year in self.sectionTitles) {
            for (ViewTableItem *item in self.dataByYear[year]) {
                if ([item.title containsString:searchText] || [item.subtitle containsString:searchText]) {
                    [filtered addObject:item];
                }
            }
        }
        self.filteredItems = filtered;
    }
    [self.tableView reloadData];
}

#pragma mark - ETC


/// json파일을 불러와서 TableItem처리(Dictionary로 전환필요)
- (void)loadDataFromJSON {
    // JSON 파일 경로
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    if (!jsonData) {
        NSLog(@"Error: Could not load JSON file.");
        return;
    }
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"Error parsing JSON: %@", error.localizedDescription);
        return;
    }
    
    // JSON 데이터를 ViewTableItem 객체로 변환
    NSMutableDictionary<NSString *, NSArray<ViewTableItem *> *> *parsedData = [NSMutableDictionary dictionary];
    for (NSString *year in json) {
        NSArray *items = json[year];
        NSMutableArray<ViewTableItem *> *tableItems = [NSMutableArray array];
        
        for (NSDictionary *itemData in items) {
            ViewTableItem *item = [ViewTableItem new];
            item.title = itemData[@"title"];
            item.subtitle = itemData[@"subtitle"];
            item.viewControllerName = itemData[@"viewControllerName"];
            item.taskStatus = [itemData[@"taskStatus"] integerValue];
            [tableItems addObject:item];
        }
        
        parsedData[year] = tableItems;
    }
    
    // 데이터 초기화
    self.dataByYear = parsedData;
    self.sectionTitles = [self.dataByYear.allKeys sortedArrayUsingSelector:@selector(compare:)];
}

- (void)simpleShowAlert:(NSString *)title :(NSString *)message {
    
    // UIAlertController 생성
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    // 확인 버튼 추가
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"확인"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"확인 버튼 클릭됨");
    }];
    [alert addAction:okAction];

//    // 취소 버튼 추가 (선택 사항)
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소"
//                                                           style:UIAlertActionStyleCancel
//                                                         handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"취소 버튼 클릭됨");
//    }];
//    [alert addAction:cancelAction];

    // Alert 표시
    [self presentViewController:alert animated:YES completion:nil];
}
@end
