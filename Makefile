.PHONY: 
	clean all bibs toc help 
	check_all check_tex check_file check_biber check_pdf
	target

#TEX编译器路径或环境变量
TEXP=xelatex
TEX=$(TEXP) -synctex=1 -interaction=nonstopmode -file-line-error 
#参考文献编译器路径或环境变量
BIBTEX=biber
#pdf阅读器路径或环境变量
PDFVIEWER=evince

#TEX文件路径或环境变量
FILENAME=毕业论文
TEXFILE = $(FILENAME).tex
PDFFILE = $(FILENAME).pdf

all: target

# 自定义处理
# 检查文件是否存在
check_file:
	@if [ ! -f $(TEXFILE) ];then \
	    echo "错误: 文件<$(TEXFILE)>不存在！"; \
	    echo "请确保该文件在当前目录中。"; \
	    echo "或者Makefile中<TEXNAME=$(TEXNAME)>存在值错误，请予以修正。";\
	    exit 1; \
	else \
	    echo "文件<$(TEXFILE)>存在，继续执行..."; \
	fi

# 检查 xelatex 是否存在
check_tex:
	@if ! type $(TEXP) > /dev/null 2>&1; then \
	    echo "错误: $(TEXP) 不可用，请确保它已安装并在您的 PATH 中."; \
	    exit 1; \
	else \
	    echo "$(TEXP) 存在，继续执行...";\
	fi

# 检查 bibtex 是否存在
check_biber:
	@if ! type $(BIBTEX) > /dev/null 2>&1; then \
	    echo "错误: $(BIBTEX) 不可用，请确保它已安装并在您的 PATH 中."; \
	    exit 1; \
	else \
	    echo "$(BIBTEX) 存在，继续执行...";\
	fi

# 检查 evince 是否存在
check_pdf:
	@if [ ! -f $(PDFFILE) ];then \
	    echo "错误: 请执行 make！"; \
	    exit 1; \
	fi
	
	@if ! type $(PDFVIEWER) > /dev/null 2>&1; then \
		echo "错误: $(PDFVIEWER) 不可用，请确保它已安装并在您的 PATH 中."; \
	    	exit 1; \
	else \
	    	echo "$(PDFVIEWER) 存在，继续执行...";\
	fi

#检查函数
check_all: check_file check_tex check_biber


# 生成 PDF 文档
target:check_all
	$(TEX) $(TEXFILE)
	@echo "编译完成，请用 PDF 阅读器打开相关文件"
	@echo "若想要看到最新目录或参考文献变化，请输入:"
	@echo "        make toc       #目录编译"
	@echo "        make bibs      #参考文献编译"
	@echo "        make help      #来获取帮助"


# 生成目录
toc: check_all
	$(TEX) $(TEXFILE) # 第一次编译以生成 .aux 文件
	$(TEX) $(TEXFILE) # 第二次编译以生成目录
	@echo "已重新生成目录内容"

# 编译参考文献
bibs: check_all
	$(TEX) $(FILENAME) # 第一次编译以生成 .aux 文件
	$(BIBTEX) $(FILENAME)    # 处理引用，生成参考文献
	$(TEX) $(FILENAME) # 第三次编译以更新文献引用
	$(TEX) $(FILENAME) # 第四次编译以确保所有内容正确
	@echo "已重新生成参考文献"


pdf: check_pdf
	$(PDFVIEWER) $(PDFFILE)


# 清理编译生成的文件
clean:
	rm -f *.bbl *.blg *.toc *.run.xml *.bcf *.aux *.log *.txss2 *.out *.synctex.gz 2>/dev/null
	@echo "编译产物清理完毕"

# 帮助信息
help:
	@echo "使用说明:"
	@echo "  make              编译 PDF 文件"
	@echo "  make all          等同于 'make'"
	@echo "  make toc          生成目录"
	@echo "  make bibs         生成参考文献"
	@echo "  make pdf          浏览 PDF 文件"
	@echo "  make clean        清理编译生成的临时文件"
	@echo "  make help         显示此帮助信息"
	@echo "如果 TEX,BIBTEX,PDFVIEWER,FILENAME 显示未找到，您可以手动编辑 Makefile 更改相关值"
