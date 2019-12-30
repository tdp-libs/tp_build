#include <iostream>
#include <string>
#include <vector>

#include <stdio.h>

struct Translation_lt
{
  std::string original;
  std::string file;
  int line{0};
};

//##################################################################################################
std::string runPreprocessor(const std::string& cmd) 
{
  const int maxBuffer = 256;
  char buffer[maxBuffer];

  std::string data;
  {
    FILE* stream = popen(cmd.c_str(), "r");
    if(stream) 
    {
      while(!feof(stream))
        if(fgets(buffer, maxBuffer, stream) != nullptr) 
          data.append(buffer);
      pclose(stream);
    }
  }
  return data;
}

//##################################################################################################
bool readString(const std::string& data, size_t& i, const std::string& endSequence, std::string& result)
{
  auto start=i;
  while(i<data.size())
  {
    i = data.find(endSequence, i);

    if(i == std::string::npos)
      return false;

    if(data.at(i-1) != '\\')
    {
      result = data.substr(start, i-start);
      i+=endSequence.size();
      return true;
    }

    i++;
  }

  return false;
}

//##################################################################################################
std::vector<Translation_lt> extractTranslations(const std::string& data)
{
  std::vector<Translation_lt> translations;
  
  //We are looking for:
  //tp_utils::translate("str","__FILE__",__LINE__)

  std::string headder = "tp_utils::translate(";
  for(size_t i=0; i<data.size(); i++)
  {
    i = data.find(headder, i);
    if(i == std::string::npos)
      break;
    std::cerr << " A: " << data.substr(i, 50) <<std::endl;

    i+=headder.size();

    Translation_lt translation;


    if(!readString(data, i, "\",\"", translation.original))
      break;
    std::cerr << " B" << translation.original << std::endl;

    if(!readString(data, i, "\",", translation.file))
      break;
    std::cerr << " C" << translation.file << std::endl;

    std::string lineStr;
    if(!readString(data, i, ");", lineStr))
      break;
    std::cerr << " C" << lineStr << std::endl;


    if(lineStr.empty())
      break;

    translation.line = std::stoi(lineStr);

    translations.push_back(translation);
  }

  return translations;
}

//##################################################################################################
int main(int argc, char* argv[])
{
  std::string cmd = "/usr/libexec/gcc/x86_64-redhat-linux/9/cc1plus ";

  for(int i=1; i<argc; i++)
    cmd += std::string(argv[i]) + std::string(" ");
 
  std::string preprocessed = runPreprocessor(cmd);

  std::cerr << "Z:" << preprocessed << std::endl;

  std::vector<Translation_lt> translations = extractTranslations(preprocessed);
  std::cerr << "Found translations: " << translations.size() <<std::endl;
  for(const auto& translation : translations)
    std::cerr << "  original: " << translation.original << " file: " << translation.file << " line:" << translation.line << std::endl;
    

  //Print out the preprocessed string so that the compiler can use it.
  std::cout << preprocessed;

  return 0;
}

