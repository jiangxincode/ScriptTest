#!/bin/bash

# ============================================
# PNG转MP4脚本 - 带过渡动画（修复版：支持不同尺寸图片）
# 用法: ./png_to_mp4.sh [选项]
# ============================================

# 默认配置
INPUT_DIR="."           # 默认当前目录
OUTPUT_FILE="output.mp4"
DISPLAY_DURATION=3      # 每张图片展示时长（秒）
TRANSITION_DURATION=1   # 过渡动画时长（秒）
TRANSITION_TYPE="fade"  # 过渡类型
FPS=30                  # 帧率
CRF=23                  # 视频质量（越小越好，18-28常用）
SCALE_WIDTH=""          # 输出宽度（空则使用第一张图片的宽度）
SCALE_HEIGHT=""         # 输出高度（空则使用第一张图片的高度）
SCALE_MODE="pad"        # 缩放模式: pad(填充黑边), crop(裁剪), stretch(拉伸)

# 支持的过渡类型
VALID_TRANSITIONS=("fade" "wipeleft" "wiperight" "wipeup" "wipedown" "slideleft" "slideright" "slideup" "slidedown" "distance" "smoothleft" "smoothright" "circlecrop" "rectcrop" "fadeblack" "fadewhite")

# 显示帮助
show_help() {
    cat << EOF
用法: $0 [选项]

选项:
    -i, --input DIR         输入目录 (默认: 当前目录)
    -o, --output FILE       输出文件名 (默认: output.mp4)
    -d, --duration SEC      每张图片展示时长，秒 (默认: 3)
    -t, --transition SEC    过渡动画时长，秒 (默认: 1)
    -T, --type TYPE         过渡动画类型 (默认: fade)
    -f, --fps FPS           视频帧率 (默认: 30)
    -q, --quality CRF       视频质量 0-51，越小越好 (默认: 23)
    -W, --width PIXELS      输出宽度 (默认: 第一张图片宽度)
    -H, --height PIXELS     输出高度 (默认: 第一张图片高度)
    -m, --mode MODE         缩放模式: pad/crop/stretch (默认: pad)
    -h, --help              显示此帮助

支持的过渡类型:
    fade, wipeleft, wiperight, wipeup, wipedown,
    slideleft, slideright, slideup, slidedown,
    distance, smoothleft, smoothright,
    circlecrop, rectcrop, fadeblack, fadewhite

缩放模式:
    pad    - 保持比例，不足部分填充黑边 (推荐)
    crop   - 保持比例，超出部分裁剪
    stretch - 不保持比例，强制拉伸

示例:
    $0 -i ./images -o video.mp4 -d 5 -t 2 -T slideleft
    $0 --input ./photos --duration 4 --transition 1.5 --type circlecrop -W 1920 -H 1080
EOF
}

# 验证过渡类型
validate_transition() {
    local type=$1
    for valid in "${VALID_TRANSITIONS[@]}"; do
        if [[ "$valid" == "$type" ]]; then
            return 0
        fi
    done
    echo "错误: 不支持的过渡类型 '$type'"
    echo "支持的类型: ${VALID_TRANSITIONS[*]}"
    exit 1
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--input)
            INPUT_DIR="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -d|--duration)
            DISPLAY_DURATION="$2"
            shift 2
            ;;
        -t|--transition)
            TRANSITION_DURATION="$2"
            shift 2
            ;;
        -T|--type)
            TRANSITION_TYPE="$2"
            shift 2
            ;;
        -f|--fps)
            FPS="$2"
            shift 2
            ;;
        -q|--quality)
            CRF="$2"
            shift 2
            ;;
        -W|--width)
            SCALE_WIDTH="$2"
            shift 2
            ;;
        -H|--height)
            SCALE_HEIGHT="$2"
            shift 2
            ;;
        -m|--mode)
            SCALE_MODE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "未知选项: $1"
            show_help
            exit 1
            ;;
    esac
done

# 验证参数
validate_transition "$TRANSITION_TYPE"

if [[ ! -d "$INPUT_DIR" ]]; then
    echo "错误: 目录不存在 '$INPUT_DIR'"
    exit 1
fi

# 获取所有png文件（按文件名排序）
mapfile -t files < <(find "$INPUT_DIR" -maxdepth 1 -type f -iname "*.png" | sort)

if [[ ${#files[@]} -eq 0 ]]; then
    echo "错误: 在 '$INPUT_DIR' 中未找到PNG文件"
    exit 1
fi

# 获取第一张图片的尺寸作为默认输出尺寸
if [[ -z "$SCALE_WIDTH" || -z "$SCALE_HEIGHT" ]]; then
    first_file="${files[0]}"
    # 使用ffprobe获取尺寸，并清理输出
    dims=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$first_file" | tr -d '\r\n')
    # 移除可能的后缀x
    dims=${dims%x}
    first_w=$(echo "$dims" | cut -d'x' -f1)
    first_h=$(echo "$dims" | cut -d'x' -f2)
    SCALE_WIDTH=${SCALE_WIDTH:-$first_w}
    SCALE_HEIGHT=${SCALE_HEIGHT:-$first_h}
    echo "检测到第一张图片尺寸: ${first_w}x${first_h}，将以此作为输出尺寸"
fi

echo "=========================================="
echo "  图片转视频配置"
echo "=========================================="
echo "  输入目录:    $INPUT_DIR"
echo "  图片数量:    ${#files[@]}"
echo "  输出文件:    $OUTPUT_FILE"
echo "  输出尺寸:    ${SCALE_WIDTH}x${SCALE_HEIGHT}"
echo "  缩放模式:    $SCALE_MODE"
echo "  展示时长:    ${DISPLAY_DURATION}s"
echo "  过渡时长:    ${TRANSITION_DURATION}s"
echo "  过渡类型:    $TRANSITION_TYPE"
echo "  帧率:        ${FPS}fps"
echo "  预计总时长:  $(echo "scale=1; ${#files[@]} * $DISPLAY_DURATION + (${#files[@]} - 1) * $TRANSITION_DURATION" | bc)s"
echo "=========================================="

# 构建缩放滤镜
case $SCALE_MODE in
    pad)
        # 保持比例，黑边填充
        SCALE_FILTER="scale=${SCALE_WIDTH}:${SCALE_HEIGHT}:force_original_aspect_ratio=decrease,pad=${SCALE_WIDTH}:${SCALE_HEIGHT}:(ow-iw)/2:(oh-ih)/2:black"
        ;;
    crop)
        # 保持比例，居中裁剪
        SCALE_FILTER="scale=${SCALE_WIDTH}:${SCALE_HEIGHT}:force_original_aspect_ratio=increase,crop=${SCALE_WIDTH}:${SCALE_HEIGHT}"
        ;;
    stretch)
        # 强制拉伸
        SCALE_FILTER="scale=${SCALE_WIDTH}:${SCALE_HEIGHT}"
        ;;
    *)
        echo "错误: 未知的缩放模式 '$SCALE_MODE'"
        exit 1
        ;;
esac

# 计算每张图片的实际输入时长（展示时长 + 过渡时长，最后一张只需展示时长）
input_duration=$(echo "$DISPLAY_DURATION + $TRANSITION_DURATION" | bc)

# 构建输入参数和滤镜链
inputs=""
filter_parts=()

for i in "${!files[@]}"; do
    file="${files[$i]}"
    inputs+="-loop 1 -t $input_duration -i '$file' "
    
    # 为每个输入添加缩放滤镜，标记为 [v$i]
    filter_parts+=("[$i:v]${SCALE_FILTER},setpts=PTS-STARTPTS,format=pix_fmts=yuv420p[v$i]")
done

# 构建xfade过渡链
prev_label="v0"
for ((i=1; i<${#files[@]}; i++)); do
    offset=$(echo "$i * $DISPLAY_DURATION" | bc)
    curr_label="vt$i"
    
    if [[ $i -eq $((${#files[@]} - 1)) ]]; then
        # 最后一张，输出到[out]
        filter_parts+=("[${prev_label}][v${i}]xfade=transition=${TRANSITION_TYPE}:duration=${TRANSITION_DURATION}:offset=${offset}[out]")
    else
        filter_parts+=("[${prev_label}][v${i}]xfade=transition=${TRANSITION_TYPE}:duration=${TRANSITION_DURATION}:offset=${offset}[${curr_label}]")
        prev_label=$curr_label
    fi
done

# 只有一张图片的特殊处理
if [[ ${#files[@]} -eq 1 ]]; then
    filter_parts+=("[v0]trim=duration=${DISPLAY_DURATION}[out]")
fi

# 组合完整滤镜链（用分号连接）
filter_complex=""
for ((i=0; i<${#filter_parts[@]}; i++)); do
    if [[ $i -gt 0 ]]; then
        filter_complex+=";"
    fi
    filter_complex+="${filter_parts[$i]}"
done

# 构建完整命令
cmd="ffmpeg -y ${inputs} -filter_complex \"${filter_complex}\" -map \"[out]\" -c:v libx264 -pix_fmt yuv420p -r ${FPS} -crf ${CRF} -movflags +faststart '${OUTPUT_FILE}'"

echo "执行命令:"
echo "$cmd"
echo ""

# 执行
eval "$cmd"

if [[ $? -eq 0 ]]; then
    echo ""
    echo "✅ 成功生成视频: $OUTPUT_FILE"
    # 显示视频信息
    ffprobe -v error -show_entries format=duration,size,bit_rate -show_entries stream=width,height -of default=noprint_wrappers=1 "$OUTPUT_FILE" 2>/dev/null || true
else
    echo "❌ 生成失败"
    exit 1
fi