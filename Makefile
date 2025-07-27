.PHONY: clean all bibs toc
# 编译输出pdf文件: make, make all

#TEX编译器路径或环境变量
TEX=xelatex -synctex=1 -interaction=nonstopmode -file-line-error 
#参考文献编译器路径或环境变量
BIBTEX=biber
#pdf阅读器路径或环境变量
PDFVIEWER=evince

#TEX文件路径或环境变量
FILENAME=毕业论文

TEXFILE = $(FILENAME).tex

pdf: $(FILENAME).pdf
	$(PDFVIEWER) $<

# 生成 PDF 文档
all: $(TEXFILE)
	$(TEX) $<
	@echo "编译完成，请用 PDF 阅读器打开相关文件"
	@echo "若想要看到最新目录或参考文献变化，请输入:"
	@echo "        make toc       #目录编译"
	@echo "        make bibs      #参考文献编译"
	@echo "        make help      #来获取帮助"


# 生成目录
toc: $(TEXFILE)
	$(TEX) $< # 第一次编译以生成 .aux 文件
	$(TEX) $< # 第二次编译以生成目录
	@echo "已重新生成目录内容"

# 编译参考文献
bibs: $(TEXFILE)
	$(TEX) $(FILENAME) # 第一次编译以生成 .aux 文件
	$(BIBTEX) $(FILENAME)    # 处理引用，生成参考文献
	$(TEX) $(FILENAME) # 第三次编译以更新文献引用
	$(TEX) $(FILENAME) # 第四次编译以确保所有内容正确
	@echo "已重新生成参考文献"


# 清理编译生成的文件
clean:
	rm -f *.bbl *.blg *.toc *.run.xml *.bcf *.aux *.log *.txss2 *.out *.synctex.gz 2>/dev/null
	@echo "编译产物清理完毕"

# 帮助信息
.PHONY: help
help:
	@echo "使用说明:"
	@echo "  make              编译 PDF 文件"
	@echo "  make all          等同于 'make'"
	@echo "  make toc          生成目录"
	@echo "  make bibs         生成参考文献"
	@echo "  make pdf          浏览 PDF 文件"
	@echo "  make clean        清理编译生成的临时文件"
	@echo "  make help         显示此帮助信息"
	@echo "  如果 TEX,BIBTEX,PDFVIEWER,FILENAME 显示未找到，您可以手动编辑 Makefile 更改相关值"
