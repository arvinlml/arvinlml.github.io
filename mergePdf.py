import sys
from pathlib import Path
from PyPDF2 import PdfMerger
def merge_pdfs(pdf_paths, output_path):
    print(f"Merging {len(pdf_paths)} PDFs into {output_path}...")
    merger = PdfMerger()
    for pdf_path in pdf_paths:
        merger.append(pdf_path)
    merger.write(output_path)
    merger.close()

if __name__ == "__main__":  
    if len(sys.argv) < 3:
        print("Usage: python mergePdf.py output.pdf input1.pdf input2.pdf ...")
        sys.exit(1)

    output_pdf = sys.argv[1]
    input_pdfs = sys.argv[2:]
    merge_pdfs(input_pdfs, output_pdf)
    print("PDFs merged successfully!")

