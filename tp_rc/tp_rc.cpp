#include <iostream>
#include <fstream>

#include "rapidxml-1.13/rapidxml.hpp"

//##################################################################################################
bool readBinaryFile(const std::string& fileName, std::string& results)
{
  try
  {
    std::ifstream in(fileName, std::ios::binary | std::ios::ate);
    auto size = in.tellg();
    if(size>0)
    {
      results.resize(size_t(size));
      in.seekg(0);
      in.read(results.data(), size);
    }
    return true;
  }
  catch(...)
  {
  }
  return false;
}

//##################################################################################################
bool writeBinaryFile(const std::string& fileName, const std::string& textOutput)
{
  try
  {
    std::ofstream out(fileName, std::ios::binary);
    out << textOutput;
    return true;
  }
  catch(...)
  {
    return false;
  }
}

//##################################################################################################
int main(int argc, const char * argv[])
{
  if(argc!=3)
  {
    std::cerr << "error: Incorrect number of arguments passed to tpRc!" << std::endl;
    return 1;
  }

  std::string slash="/";

  std::string qrcDirectory(argv[1]);
  qrcDirectory = qrcDirectory.substr(0, qrcDirectory.find_last_of("\\/")) + slash;

  std::string inputData;
  if(!readBinaryFile(argv[1], inputData))
  {
    std::cerr << "error: Failed to read input qrc!" << std::endl;
    return 1;
  }

  std::cout << inputData << std::endl;
  rapidxml::xml_document<> doc;
  doc.parse<0>(inputData.data());

  auto rccNode = doc.first_node("RCC");
  if(!rccNode)
  {
    std::cerr << "error: Failed to parse RCC node!" << std::endl;
    return 1;
  }

  auto qresourceNode = rccNode->first_node("qresource");
  if(!qresourceNode)
  {
    std::cerr << "error: Failed to parse qresource node!" << std::endl;
    return 1;
  }

  std::string prefix;
  if(auto prefixAttribute = qresourceNode->first_attribute("prefix"); prefixAttribute)
    prefix = prefixAttribute->value();

  prefix += slash;

  std::cout << "prefix: " << prefix << std::endl;

  std::string cppText = "#include \"tp_utils/Resources.h\"\n\nnamespace\n{\n\n";
  std::string initText;

  int c=0;
  for(auto fileNode = qresourceNode->first_node("file"); fileNode; fileNode=fileNode->next_sibling("file"))
  {
    std::string inputFile = fileNode->value();
    std::string alias = inputFile;

    std::string inputFilePath = qrcDirectory + inputFile;

    if(auto aliasAttribute = fileNode->first_attribute("alias"); aliasAttribute)
      alias = aliasAttribute->value();

    std::cout << "alias: " << alias << " file: " << inputFilePath << std::endl;

    std::string fileData;
    if(!readBinaryFile(inputFilePath, fileData))
    {
      std::cerr << "error: Failed to read input file!" << std::endl;
      return 1;
    }

#if 0
    cppText += "const char* data" + std::to_string(c) + " = \"";

    const char digits[] = "0123456789ABCDEF";
    for(size_t i=0; i<fileData.size(); i++)
    {
      uint8_t b = uint8_t(fileData.at(i));
      cppText += "\\x" + std::string(1,digits[b>>4]) + std::string(1,digits[b&0b1111]);
    }

    cppText += "\";\n";
#else
    cppText += "const char data" + std::to_string(c) + "[] = {";

    for(size_t i=0; i<fileData.size(); i++)
    {
      int8_t b = int8_t(fileData.at(i));
      cppText += std::to_string(b);
      cppText += ',';
    }

    cppText += "0};\n";
#endif

    cppText += "size_t size" + std::to_string(c) + "=" + std::to_string(fileData.size()) + ";\n\n";
    initText += "  tp_utils::addResource(\"" + prefix + alias + "\",data" + std::to_string(c) + ",size" + std::to_string(c) + ");\n";
    c++;
  }
  cppText += "extern int initialized;\n";
  cppText += "int initialize()\n{\n" + initText + "return 0;\n}\n";
  cppText += "int initialized=initialize();\n";

  cppText += "}\n";


  writeBinaryFile(argv[2], cppText);

  return 0;
}
