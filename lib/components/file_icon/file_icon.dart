import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 文件图标icon
class FileIcon extends StatelessWidget {
  FileIcon({
    super.key,
    required this.name,
    this.size = 18,
  });

  final String name;
  final double size;
  getSvg() {
    if (name == '') return '';
    var fileIcon = fileIcons.firstWhere((item) => item['name'] == name,
        orElse: () => null);
    return fileIcon != null ? fileIcon['show_svg'] : fileIcons.last['show_svg'];
  }

  @override
  Widget build(BuildContext context) {
    String svgXml = getSvg();
    return SizedBox(
      width: size,
      height: size,
      child: svgXml == ''
          ? Icon(Icons.error, size: size)
          : SvgPicture.string(svgXml, width: size, height: size),
    );
  }

  final List fileIcons = [
    {
      "id": 3879164,
      "name": "icon_doc",
      "project_id": 4423801,
      "projectId": 4423801,
      "show_svg":
          "<svg class=\"icon\" style=\"width: 1em;height: 1em;vertical-align: middle;fill: currentColor;overflow: hidden;\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M665.6 51.2H204.8a51.2 51.2 0 0 0-51.2 51.2v819.2a51.2 51.2 0 0 0 51.2 51.2h614.4a51.2 51.2 0 0 0 51.2-51.2V256z m-40.96 768h-38.4l-61.44-212.48-61.44 212.48h-38.4L332.8 555.52h46.08l64 212.48 61.44-215.04h38.4l64 215.04 64-215.04H716.8z\" fill=\"#4A90E2\" /><path d=\"M668.16 51.2l204.8 204.8h-179.2a25.6 25.6 0 0 1-25.6-25.6V51.2z\" fill=\"#7DAFEA\" /></svg>",
      "unicode": "58995",
      "font_class": "docdocx",
      "freeze": 0,
      "path_attributes": "fill=\"#4A90E2\"|fill=\"#7DAFEA\""
    },
    {
      "id": 36824672,
      "name": "icon_mp4",
      "project_id": 4423801,
      "projectId": 4423801,
      "show_svg":
          "<svg class=\"icon\" style=\"width: 1em;height: 1em;vertical-align: middle;fill: currentColor;overflow: hidden;\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M96 64a64 64 0 0 1 64-64h480l185.44 185.44L928 288v672a64 64 0 0 1-64 64H160a64 64 0 0 1-64-64V64z\" fill=\"#5672FC\" /><path d=\"M640 0l144 144L928 288h-224a64 64 0 0 1-64-64V0z\" fill=\"#FFFFFF\" fill-opacity=\".6\" /><path d=\"M160 80h64v64H160zM800 400h64v64h-64zM160 240h64v64H160zM800 560h64v64h-64zM160 400h64v64H160zM800 720h64v64h-64zM160 560h64v64H160zM800 880h64v64h-64zM160 720h64v64H160zM160 880h64v64H160zM636.032 518.08a32 32 0 0 1 0 51.84l-201.28 145.312a32 32 0 0 1-50.752-25.92V398.72a32 32 0 0 1 50.72-25.952l201.312 145.28z\" fill=\"#FFFFFF\" /></svg>",
      "unicode": "59108",
      "font_class": "icon_mp4",
      "freeze": 0,
      "path_attributes":
          "fill=\"#5672FC\"|fill=\"#FFFFFF\";fill-opacity=\".6\"|fill=\"#FFFFFF\""
    },
    {
      "id": 36824673,
      "name": "icon_txt",
      "project_id": 4423801,
      "projectId": 4423801,
      "show_svg":
          "<svg class=\"icon\" style=\"width: 1em;height: 1em;vertical-align: middle;fill: currentColor;overflow: hidden;\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M96 64a64 64 0 0 1 64-64h480l185.44 185.44L928 288v672a64 64 0 0 1-64 64H160a64 64 0 0 1-64-64V64z\" fill=\"#A4A4A4\" /><path d=\"M640 0l144 144L928 288h-224a64 64 0 0 1-64-64V0z\" fill=\"#FFFFFF\" fill-opacity=\".6\" /><path d=\"M256 576h512v64H256zM256 384h224v64H256zM256 768h512v64H256z\" fill=\"#FFFFFF\" /></svg>",
      "unicode": "59109",
      "font_class": "icon_txt",
      "freeze": 0,
      "path_attributes":
          "fill=\"#A4A4A4\"|fill=\"#FFFFFF\";fill-opacity=\".6\"|fill=\"#FFFFFF\""
    },
    {
      "id": 36824674,
      "name": "icon_Excel",
      "project_id": 4423801,
      "projectId": 4423801,
      "show_svg":
          "<svg class=\"icon\" style=\"width: 1em;height: 1em;vertical-align: middle;fill: currentColor;overflow: hidden;\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M96 64a64 64 0 0 1 64-64h480l185.44 185.44L928 288v672a64 64 0 0 1-64 64H160a64 64 0 0 1-64-64V64z\" fill=\"#1FAC78\" /><path d=\"M640 0l144 144L928 288h-224a64 64 0 0 1-64-64V0z\" fill=\"#FFFFFF\" fill-opacity=\".6\" /><path d=\"M472.896 571.2l-115.584-161.504h79.904l75.648 115.584 79.04-115.584h77.376l-118.176 161.504 124.096 171.68h-80.736l-83.296-122.4-83.296 123.264H348.8l124.064-172.544z\" fill=\"#FFFFFF\" /></svg>",
      "unicode": "59107",
      "font_class": "icon_Excel",
      "freeze": 0,
      "path_attributes":
          "fill=\"#1FAC78\"|fill=\"#FFFFFF\";fill-opacity=\".6\"|fill=\"#FFFFFF\""
    },
    {
      "id": 36824675,
      "name": "icon_word",
      "project_id": 4423801,
      "projectId": 4423801,
      "show_svg":
          "<svg class=\"icon\" style=\"width: 1em;height: 1em;vertical-align: middle;fill: currentColor;overflow: hidden;\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M96 64a64 64 0 0 1 64-64h480l185.44 185.44L928 288v672a64 64 0 0 1-64 64H160a64 64 0 0 1-64-64V64z\" fill=\"#2788F9\" /><path d=\"M640 0l144 144L928 288h-224a64 64 0 0 1-64-64V0z\" fill=\"#FFFFFF\" fill-opacity=\".6\" /><path d=\"M264 416h68.864l68.832 259.264h0.864L478.208 416h66.304l76.48 259.264L690.688 416h66.304L655.04 750.08h-68.864l-75.648-256.736h-0.832l-76.512 255.872h-68.864L264 416z\" fill=\"#FFFFFF\" /></svg>",
      "unicode": "59105",
      "font_class": "icon_word",
      "freeze": 0,
      "path_attributes":
          "fill=\"#2788F9\"|fill=\"#FFFFFF\";fill-opacity=\".6\"|fill=\"#FFFFFF\""
    },
    {
      "id": 36824676,
      "name": "icon_jpg",
      "project_id": 4423801,
      "projectId": 4423801,
      "show_svg":
          "<svg class=\"icon\" style=\"width: 1em;height: 1em;vertical-align: middle;fill: currentColor;overflow: hidden;\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M96 64a64 64 0 0 1 64-64h480l185.44 185.44L928 288v672a64 64 0 0 1-64 64H160a64 64 0 0 1-64-64V64z\" fill=\"#FB5E84\" /><path d=\"M640 0l144 144L928 288h-224a64 64 0 0 1-64-64V0z\" fill=\"#FFFFFF\" fill-opacity=\".6\" /><path d=\"M772.288 715.072l-106.24-164.8a16.64 16.64 0 0 0-14.4-7.616 18.848 18.848 0 0 0-14.4 7.648l-56.864 88.288-127.2-206.144a16.544 16.544 0 0 0-14.4-7.648 18.88 18.88 0 0 0-14.4 7.68l-174.72 282.784a15.456 15.456 0 0 0 0 16.96 15.68 15.68 0 0 0 14.4 8.48h493.536a18.88 18.88 0 0 0 15.296-8.48 16.96 16.96 0 0 0-0.8-16.96l0.192-0.224z m-144.224-311.936a42.496 42.496 0 0 0 50.688 41.76 42.368 42.368 0 0 0 33.376-33.376 42.56 42.56 0 0 0-41.6-50.784c-23.424 0-42.432 18.976-42.464 42.4z\" fill=\"#FFFFFF\" /></svg>",
      "unicode": "59101",
      "font_class": "icon_jpg",
      "freeze": 0,
      "path_attributes":
          "fill=\"#FB5E84\"|fill=\"#FFFFFF\";fill-opacity=\".6\"|fill=\"#FFFFFF\""
    },
    {
      "id": 36824677,
      "name": "icon_ppt",
      "project_id": 4423801,
      "projectId": 4423801,
      "show_svg":
          "<svg class=\"icon\" style=\"width: 1em;height: 1em;vertical-align: middle;fill: currentColor;overflow: hidden;\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M96 64a64 64 0 0 1 64-64h480l185.44 185.44L928 288v672a64 64 0 0 1-64 64H160a64 64 0 0 1-64-64V64z\" fill=\"#F86F51\" /><path d=\"M640 0l144 144L928 288h-224a64 64 0 0 1-64-64V0z\" fill=\"#FFFFFF\" fill-opacity=\".6\" /><path d=\"M384 416h187.008c74.784 0 98.592 50.144 98.592 103.68 0 51.008-29.76 102.88-97.76 102.88h-124.096v127.488H384V416z m63.744 154.688h102.848c36.544 0 56.096-11.04 56.096-50.144 0-40.8-26.336-51.008-50.976-51.008h-107.968v101.152z\" fill=\"#FFFFFF\" /></svg>",
      "unicode": "59106",
      "font_class": "icon_ppt",
      "freeze": 0,
      "path_attributes":
          "fill=\"#F86F51\"|fill=\"#FFFFFF\";fill-opacity=\".6\"|fill=\"#FFFFFF\""
    },
    {
      "id": 36824678,
      "name": "icon_pdf",
      "project_id": 4423801,
      "projectId": 4423801,
      "show_svg":
          "<svg class=\"icon\" style=\"width: 1em;height: 1em;vertical-align: middle;fill: currentColor;overflow: hidden;\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M96 64a64 64 0 0 1 64-64h480l185.44 185.44L928 288v672a64 64 0 0 1-64 64H160a64 64 0 0 1-64-64V64z\" fill=\"#F85951\" /><path d=\"M640 0l144 144L928 288h-224a64 64 0 0 1-64-64V0z\" fill=\"#FFFFFF\" fill-opacity=\".6\" /><path d=\"M692.928 812c-44.416 0-84.224-76.16-105.184-125.76-35.232-14.688-74.08-28.416-111.84-37.312-32.992 21.792-89.184 54.4-132.352 54.4-26.784 0-46.08-13.44-53.12-36.896-5.44-19.296-0.864-32.64 4.96-39.84 11.392-15.552 34.848-23.456 69.952-23.456 28.448 0 64.512 4.992 104.736 14.72a670.24 670.24 0 0 0 75.776-62.464c-10.4-49.408-21.792-129.472 7.04-166.4 14.304-17.6 36.096-23.424 62.464-15.52 28.864 8.32 39.808 25.92 43.136 39.808 12.224 48.16-43.136 113.12-80.448 151.264 8.32 33.056 19.264 67.872 32.608 99.808 53.536 23.872 117.216 59.52 124.448 98.368 2.88 13.472-1.28 25.952-12.224 36.928-9.44 7.776-19.424 12.352-29.952 12.352z m-39.936-84c9.792 21.76 19.104 32 24 32 0.768 0 1.824-0.32 3.328-1.664 1.824-1.984 1.824-3.328 1.536-4.544-1.024-5.728-9.28-15.104-28.864-25.792zM371.072 640c-15.616 0-19.904 3.776-21.216 5.536-0.384 0.576-1.504 2.24-0.384 6.656 0.96 3.776 3.552 7.808 11.648 7.808 10.144 0 24.832-5.728 41.888-16a150.848 150.848 0 0 0-31.936-4z m152.928-19.424c9.344 2.592 19.008 5.952 28 9.408a251.712 251.712 0 0 1-8.128-25.984c-6.496 5.664-13.12 11.2-19.872 16.576z m65.952-187.584a9.824 9.824 0 0 0-7.744 3.52c-6.144 7.776-6.848 27.392-2.08 52.48 18.112-19.424 27.936-37.28 25.504-46.816-0.352-1.376-1.408-5.664-9.856-8.128a19.776 19.776 0 0 0-5.824-1.056z\" fill=\"#FFFFFF\" /></svg>",
      "unicode": "59104",
      "font_class": "icon_pdf",
      "freeze": 0,
      "path_attributes":
          "fill=\"#F85951\"|fill=\"#FFFFFF\";fill-opacity=\".6\"|fill=\"#FFFFFF\""
    },
    {
      "id": 36824679,
      "name": "icon_zip",
      "project_id": 4423801,
      "projectId": 4423801,
      "show_svg":
          "<svg class=\"icon\" style=\"width: 1em;height: 1em;vertical-align: middle;fill: currentColor;overflow: hidden;\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M96 64a64 64 0 0 1 64-64h480l185.44 185.44L928 288v672a64 64 0 0 1-64 64H160a64 64 0 0 1-64-64V64z\" fill=\"#818698\" /><path d=\"M640 0l144 144L928 288h-224a64 64 0 0 1-64-64V0z\" fill=\"#FFFFFF\" fill-opacity=\".6\" /><path d=\"M448 0h64v64h-64zM512 64h64v64h-64zM448 128h64v64h-64zM512 192h64v64h-64zM448 256h64v64h-64zM512 320h64v64h-64zM448 384h64v64h-64zM512 448h64v64h-64z\" fill=\"#FFFFFF\" /><path d=\"M576 576h-128v128a32 32 0 0 0 32 32h64a32 32 0 0 0 32-32v-128z m-32 64h-64v64h64v-64z\" fill=\"#FFFFFF\" /></svg>",
      "unicode": "59102",
      "font_class": "icon_zip",
      "freeze": 0,
      "path_attributes":
          "fill=\"#818698\"|fill=\"#FFFFFF\";fill-opacity=\".6\"|fill=\"#FFFFFF\"|fill=\"#FFFFFF\""
    },
    {
      "id": 36824680,
      "name": "icon_未知格式",
      "project_id": 4423801,
      "projectId": 4423801,
      "show_svg":
          "<svg class=\"icon\" style=\"width: 1em;height: 1em;vertical-align: middle;fill: currentColor;overflow: hidden;\" viewBox=\"0 0 1024 1024\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M96 64a64 64 0 0 1 64-64h480l185.44 185.44L928 288v672a64 64 0 0 1-64 64H160a64 64 0 0 1-64-64V64z\" fill=\"#BEBEBE\" /><path d=\"M640 0l144 144L928 288h-224a64 64 0 0 1-64-64V0z\" fill=\"#FFFFFF\" fill-opacity=\".6\" /><path d=\"M517.632 395.264c33.12 0 59.744 9.024 79.872 27.136 20.48 17.728 30.72 42.144 30.72 73.216 0 24.896-6.496 45.728-19.456 62.464-4.448 5.44-18.784 18.752-43.008 39.936a78.816 78.816 0 0 0-21.504 26.624c-5.44 9.888-8.192 21.12-8.192 33.792v8.704H481.28v-8.704c0-19.84 3.424-36.032 10.24-48.64 6.496-13.664 25.76-34.816 57.856-63.488l8.704-9.728c9.536-12.288 14.336-24.768 14.336-37.376 0-17.408-4.96-31.424-14.848-41.984-10.24-10.24-24.736-15.36-43.52-15.36-23.232 0-39.936 7.328-50.176 22.016-9.216 12.288-13.824 29.696-13.824 52.224h-53.76c0-37.216 10.752-66.56 32.256-88.064 21.504-21.856 51.2-32.768 89.088-32.768z m-9.216 299.52c11.264 0 20.32 3.392 27.136 10.24 7.168 6.464 10.752 15.168 10.752 26.112 0 10.24-3.744 19.104-11.264 26.624-7.52 6.816-16.384 10.24-26.624 10.24a36.16 36.16 0 0 1-26.624-10.752 35.52 35.52 0 0 1-10.752-26.112c0-10.944 3.584-19.648 10.752-26.112 6.816-6.848 15.68-10.24 26.624-10.24z\" fill=\"#FFFFFF\" /></svg>",
      "unicode": "59103",
      "font_class": "icon_weizhigeshi",
      "freeze": 0,
      "path_attributes":
          "fill=\"#BEBEBE\"|fill=\"#FFFFFF\";fill-opacity=\".6\"|fill=\"#FFFFFF\""
    }
  ];
}
