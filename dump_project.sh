#!/bin/bash

# Задаем имя выходного файла
OUTPUT_FILE="project_full_dump.txt"

# Очищаем файл, если он уже существует (символ > означает "создать или перезаписать")
> "$OUTPUT_FILE"

echo "Начинаю сборку реестра проекта..."

# 1. Сохраняем дерево проекта (структуру папок и файлов)
# Мы исключаем папку render3d и кэш, чтобы текстовый файл не раздувался на 480 строк с названиями картинок
echo "=== ДЕРЕВО ПРОЕКТА ===" >> "$OUTPUT_FILE"
tree -I '__pycache__|render3d|*.png|*.mp4|*.pyc' >> "$OUTPUT_FILE"
echo -e "\n\n" >> "$OUTPUT_FILE"

# Функция для удобного добавления содержимого файлов с разделителями
add_file_content() {
    local file_path=$1
    echo "================================================================" >> "$OUTPUT_FILE"
    echo "ФАЙЛ: $file_path" >> "$OUTPUT_FILE"
    echo "================================================================" >> "$OUTPUT_FILE"
    cat "$file_path" >> "$OUTPUT_FILE" # cat выводит содержимое файла
    echo -e "\n\n" >> "$OUTPUT_FILE"
}

# 2. Ищем и сохраняем Dockerfile
echo "Собираю Dockerfile..."
while IFS= read -r -d '' file; do
    add_file_content "$file"
done < <(find . -type f -name "Dockerfile" -print0)

# 3. Ищем и сохраняем все YAML (YAML Ain't Markup Language — язык разметки, как JSON, но читается легче) файлы
echo "Собираю .yml и .yaml файлы..."
while IFS= read -r -d '' file; do
    add_file_content "$file"
done < <(find . -type f \( -name "*.yml" -o -name "*.yaml" \) -print0)

# 4. Ищем и сохраняем Makefile (файл для утилиты make, которая автоматизирует сборку и запуск)
echo "Собираю Makefile..."
while IFS= read -r -d '' file; do
    add_file_content "$file"
done < <(find . -type f -name "Makefile" -print0)

# 5. Ищем и сохраняем все Python (.py) файлы
echo "Собираю .py файлы..."
while IFS= read -r -d '' file; do
    add_file_content "$file"
done < <(find . -type f -name "*.py" -print0)

# 6. Бонус: добавим requirements.txt (список библиотек Python), так как это важно для MLOps
echo "Собираю requirements.txt..."
while IFS= read -r -d '' file; do
    add_file_content "$file"
done < <(find . -type f -name "requirements.txt" -print0)

echo "Готово! Весь реестр сохранен в файл: $OUTPUT_FILE"