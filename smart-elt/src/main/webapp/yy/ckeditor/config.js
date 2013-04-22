/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	 config.language = 'zh-cn';
	 config.toolbar='Full';
	 config.toolbar_Full   =  [  
    ['Source','-','NewPage','Preview','-','Templates'],  
    ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'],  
    ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],  
    ['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'],  
    ['BidiLtr', 'BidiRtl'],  
    '/',  
    ['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],  
    ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],  
    ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],  
    ['Link','Unlink','Anchor'],  
    ['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak'],  
    '/',  
    ['Styles','Format','Font','FontSize'],  
    ['TextColor','BGColor'],  
    ['Maximize', 'ShowBlocks','-','About']  
];
	// config.uiColor = '#AADC6E';
	config.filebrowserBrowseUrl = 'ckeditor/uploader/browse.jsp';  
    config.filebrowserImageBrowseUrl = 'ckeditor/uploader/browse.jsp?type=Images';  
    config.filebrowserFlashBrowseUrl = 'ckeditor/uploader/browse.jsp?type=Flashs';  
    config.filebrowserUploadUrl = 'ckeditor/uploader/upload.jsp';  
    config.filebrowserImageUploadUrl = 'ckeditor/uploader/upload.jsp?type=Images';  
    config.filebrowserFlashUploadUrl = 'ckeditor/uploader/upload.jsp?type=Flashs';  
    config.filebrowserWindowWidth = '640';  
    config.filebrowserWindowHeight = '480'; 
};
