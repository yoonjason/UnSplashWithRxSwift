![Simulator Screen Recording - iPhone 11 - 2022-04-06 at 14 59 52](https://user-images.githubusercontent.com/10451503/161905600-404ed98e-1bbb-4da9-8fb2-2a05dd3ae1c7.gif)



#Tuist 적용

##기능
* 사진 목록
 - Operation을 이용하여, 이미지를 각 셀에 데이터를 넣어주고, willdisplaycell 일 때, 이미지 변환을 통해 이미지를 보여주고, enddidplaycell에서는 operation을 중지시키고, 이미지를 보여주는 작업을 하지 않습니다.

*  사진 상세 보기
 - 컬렉션뷰를 활용하여, zoom, pinch, douletab으로 이미지를 줌할 수 있고, down제스쳐를 활용하여 현재 보고 있는 이미지 뷰를 내릴 수 있습니다.
 -  down 제스쳐나, X버튼을 이용하여 화면을 닫을 시, 이전의 화면에서는 해당 이미지의 인덱스를 찾아, 화면을 이동시킵니다.
 -  커스텀 트랜지션을 적용하였습니다.
 
* 사진 검색
 - searchController를 이용하여, 입력받은 데이터를 ViewModel로 보내, 값이 입력되면 사진 목록을 다시 불러옵니다.
 - 취소를 누르게 되면, 원래 호출하고 있던, 사진 목록을 불러옵니다.

##전체 앱 구성
- MVVM + RxSwift
- ViewModel: PhotoListViewModel, PhotoViewModel
- View : MainViewController, ImageViewerController, PhotoCell, ImageViewerCell
- Model: PhotoModel


[![Tuist badge](https://img.shields.io/badge/Powered%20by-Tuist-blue)](https://tuist.io)
