


#Tuist 적용

#2022.02.13 - 02.12일 코로나 확진으로 인하여, 완성하지 못 하더라도, 최대한 작업하고 커밋 하겠습니다..


##기능
* 사진 목록
 - Operation을 이용하여, 이미지를 각 셀에 데이터를 넣어주고, willdisplaycell 일 때, 이미지 변환을 통해 이미지를 보여주고, enddidplaycell에서는 operation을 중지시키고, 이미지를 보여주는 작업을 하지 않습니다.

*  사진 상세 보기
 - 컬렉션뷰를 활용하여, zoom, pinch, douletab으로 이미지를 줌할 수 있고, down제스쳐를 활용하여 현재 보고 있는 이미지 뷰를 내릴 수 있습니다.
 -  down 제스쳐나, X버튼을 이용하여 화면을 닫을 시, 이전의 화면에서는 해당 이미지의 인덱스를 찾아, 화면을 이동시킵니다.
 
* 사진 검색
 - searchController를 이용하여, 입력받은 데이터를 ViewModel로 보내, 값이 입력되면 사진 목록을 다시 불러옵니다.
 - 취소를 누르게 되면, 원래 호출하고 있던, 사진 목록을 불러옵니다.

##전체 앱 구성
- MVVM + RxSwift
- ViewModel: PhotoListViewModel, PhotoViewModel
- View : MainViewController, ImageViewerController, PhotoCell, ImageViewerCell
- Model: PhotoModel


##트러블슈팅

이미지 뷰어 제작<br>
- 이미지 뷰어는 현재 서비스에서도 라이브러리를 사용하지않고, 만들어 보았으나, 이번에는 custom transition을 활용하여, ios의 사진첩이나, 인스타의 이미지뷰어처럼 처리하려고 했습니다만, 코로나 확진으로 인하여 컨디션이 좋지않아, 작업하지 못하여 제외하였습니다.

lik a photo<br>
- 각 이미지당 id를 가지고, lika photo api호출을 하면 되겠다라고 계획을 하였지만, 위와 같은 이유로 작업을 못 하였습니다.


 

##과제를 진행하며 배운점 / 느낀점
* 흔히 이미지뷰어 같은 경우 라이브러리를 많이 사용하고 있고, 회사의 기본 앱의 이미지뷰어를 만들기도 해보았지만, custom transtion을 꼭 적용하고 싶었지만 아쉽습니다.
* tuist 학습하여, 실제 프로젝트에 반영되듯이 적용해볼 수 있어서 좋았습니다.
* 어떻게 하면 모듈화를 시킬 수 있을까에 대한 고민을 많이 하게되었고 결과적으로는 모듈화를 세세하게 할 수는 없었지만, tuis를 통하여 미약하게나마 모듈화를 할 수 있었습니다.


<br>
###마지막 한마디 
몇 일전 일정이 있어 출근하게 되었는 데, 과제를 주신 시점과 코로나 의심증상으로 여러 차례 검사와 확진으로 인하여 과제를 성공적으로 끝마치지는 못 하였습니다.
하지만, 면접의 기회를 주신다면, 과제보다 더 꾸준히 하는 모습을 보여드리겠습니다.
감사합니다.    


[![Tuist badge](https://img.shields.io/badge/Powered%20by-Tuist-blue)](https://tuist.io)
