#!/bin/zsh

# /***********************************************************************
# * Convert mp3 to caf Script
# * -----------------------
# * Project Name: mp3파일을 caf파일로 변환작업
# * Description: -
# * Author: lunight
# * Date: [2025-01-13]
# * Version: 1.0
# * Notes: 
# 스크립트 사용법 안내
# $0: 현재 실행 중인 스크립트 이름
# *********************************************************************** */

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <output_directory>"
    echo "Example: $0 mp3-dir caf-dir"
    exit 1
fi

# 입력받은 소스 디렉토리와 출력 디렉토리
source_dir="$1" # 첫 번째 인자로 소스 디렉토리 지정 (MP3 파일이 위치한 경로)
output_dir="$2" # 두 번째 인자로 출력 디렉토리 지정 (변환된 CAF 파일 저장 경로)

# 소스 디렉토리 확인 (존재하지 않으면 에러 메시지 출력 후 종료)
if [ ! -d "$source_dir" ]; then
    echo "Error: Source directory '$source_dir' does not exist."
    exit 1
fi

# 출력 디렉토리 생성 (없으면 생성)
mkdir -p "$output_dir"

# 변환 속성 설정
channels=1        # 모노 채널 (1채널)
sample_rate=32000 # 샘플링 레이트 32000 Hz
format="aac"      # AAC 포맷 (기본적으로 CAF 파일에서 자주 사용됨)

# MP3 -> CAF 변환 시작
echo "Starting conversion from MP3 to CAF..."
for file in "$source_dir"/*.mp3; do
    # 파일 이름 가져오기 (확장자 제거)
    filename=$(basename "$file" .mp3)

    # afconvert를 사용하여 변환
    # (afconvert로 원하는 채널 레이아웃을 정확히 설정할 수 없거나 더 많은 제어가 필요하다면 FFmpeg를 사용)
    #   •   -f caff: 파일 포맷을 CAF로 설정.
    #   •   -d aac: 데이터 포맷을 AAC로 설정.
    #   •   -c 1: 모노(1채널)로 설정.
    #   •   -r 32000: 샘플링 레이트를 32000 Hz로 설정.
    afconvert -f caff -d "$format" -c "$channels" -r "$sample_rate" "$file" "$output_dir/$filename.caf"

    # 변환 결과 출력
    if [ $? -eq 0 ]; then
        echo "Converted: $file -> $output_dir/$filename.caf"
    else
        echo "Error: Failed to convert $file"
    fi
done

echo "Conversion completed. CAF files are in '$output_dir'."
