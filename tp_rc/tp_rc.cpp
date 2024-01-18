#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <cstdint>

#include "rapidxml-1.13/rapidxml.hpp"
#include "scc/scc.hpp"

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
void replaceOverlapping(std::string& result, const std::string& key, const std::string& value)
{
  size_t pos = result.find(key);
  while(pos != std::string::npos)
  {
    result.replace(pos, key.size(), value);
    pos = result.find(key, pos);
  }
}

//##################################################################################################
void split(std::vector<std::string>& result,
           const std::string& input,
           const std::string& del)
{
  auto addPart = [&](std::vector<std::string>& result, const std::string& input, size_t pos, size_t n)
  {
    if(n==0)
      return;

    result.push_back(input.substr(pos, n));
  };

  std::string::size_type start = 0;
  auto end = input.find(del);
  while (end != std::string::npos)
  {
    addPart(result, input, start, end - start);
    start = end + del.length();
    end = input.find(del, start);
  }

  addPart(result, input, start, input.size()-start);
}

//##################################################################################################
bool preprocessShader(std::string& fileData)
{
  SCC scc(fileData, SCC::Standard::C18);
  fileData = scc.result();

  replaceOverlapping(fileData, "  ", " ");
  replaceOverlapping(fileData, " \n", "\n");
  replaceOverlapping(fileData, "\n\n", "\n");

  return scc.ok();
}

//##################################################################################################
int main(int argc, const char * argv[])
{
  if(argc!=5 && argc!=6)
  {
    std::cerr << "error: Incorrect number of arguments passed to tpRc!" << std::endl;
    return 1;
  }

  bool printDepends = (std::string(argv[1]) == "--depend");
  bool printDebug = false;

  std::string slash="/";

  std::string qrcDirectory(argv[2]);
  qrcDirectory = qrcDirectory.substr(0, qrcDirectory.find_last_of("\\/")) + slash;

  std::vector<std::string> excludes;
  if(argc==6)
  {
    if(printDepends)
      std::cout << argv[5] << std::endl;

    std::cerr << "Parse excludes: " << argv[5] << std::endl;

    std::string rcExclude;
    readBinaryFile(argv[5], rcExclude);
    replaceOverlapping(rcExclude, "\r\n", "\n");
    split(excludes, rcExclude, "\n");

    for(const auto& e : excludes)
      std::cerr << "   " << e << std::endl;
  }

  std::string inputData;
  if(!readBinaryFile(argv[2], inputData))
  {
    std::cerr << "error: Failed to read input qrc!" << std::endl;
    return 1;
  }

  if(printDebug)
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

  if(printDebug)
    std::cout << "prefix: " << prefix << std::endl;

  if(printDepends)
    std::cout << argv[2] << std::endl;

  std::string cppText = "#include \"tp_utils/Resources.h\"\n\nnamespace\n{\n\n";
  std::string initText;
  std::string excludesText =
      "# \n"
      "# Each line is a resource identifier to exclude, adding a # will keep that resource.\n"
      "# Run this in the build dir to compile the list:\n"
      "# rm -f a.txt ; cat */*.rc_excludes >> a.txt ; awk '!x[$0]++' a.txt > rc_excludes.txt ; rm -f a.txt\n"
      "# \n";

  int c=0;
  for(auto fileNode = qresourceNode->first_node("file"); fileNode; fileNode=fileNode->next_sibling("file"))
  {
    std::string inputFile = fileNode->value();
    std::string inputFilePath = qrcDirectory + inputFile;

    if(printDepends)
    {
      std::cout << inputFilePath << std::endl;
      continue;
    }

    std::string alias = inputFile;
    if(auto aliasAttribute = fileNode->first_attribute("alias"); aliasAttribute)
      alias = aliasAttribute->value();

    std::string preprocess;
    if(auto preprocessAttribute = fileNode->first_attribute("preprocess"); preprocessAttribute)
      preprocess = preprocessAttribute->value();

    if(printDebug)
      std::cout << "alias: " << alias << " file: " << inputFilePath << std::endl;

    std::string resourceIdentifier = prefix + alias;
    if(std::find(excludes.begin(), excludes.end(), resourceIdentifier) != excludes.end())
    {
      excludesText += resourceIdentifier + '\n';
      continue;
    }

    excludesText += "# " + resourceIdentifier + '\n';

    std::string fileData;
    if(!readBinaryFile(inputFilePath, fileData))
    {
      std::cerr << "error: Failed to read input file!" << std::endl;
      return 1;
    }

    if(preprocess == "shader")
    {
      if(!preprocessShader(fileData))
      {
        std::cerr << "error: Failed to preprocess shader!" << std::endl;
        return 1;
      }
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
    cppText += "const uint8_t data" + std::to_string(c) + "[] = {";

    for(size_t i=0; i<fileData.size(); i++)
    {
      uint8_t b = uint8_t(fileData.at(i));
      cppText += std::to_string(b);
      cppText += ',';
    }

    cppText += "0};\n";
#endif

    cppText += "size_t size" + std::to_string(c) + "=" + std::to_string(fileData.size()) + ";\n\n";
    initText += "  tp_utils::addResource(\"" + resourceIdentifier + "\",reinterpret_cast<const char*>(data" + std::to_string(c) + "),size" + std::to_string(c) + ");\n";
    c++;
  }

  if(printDepends)
    return 0;

  cppText += "int initialize()\n{\n" + initText + "return 0;\n}\n";
  cppText += "int initialized=initialize();\n";

  cppText += "}\n";

  cppText += "namespace " + std::string(argv[4]) + "\n";
  cppText += "{\n";
  cppText += "  int tp_rc(){return initialized;}\n";
  cppText += "}\n";

  writeBinaryFile(argv[3], cppText);

  {
    std::string excludesOutputFile = argv[3];
    replaceOverlapping(excludesOutputFile, ".cpp", ".rc_excludes");
    writeBinaryFile(excludesOutputFile, excludesText);
  }

  return 0;
}
