/*
 * Convert "snap" format graph to "graphlab matrix" format .
 * The "graphlab matrix" format : 
 * <source_id>,<sink_id>,<value>
 * Algorithm als's input is this format
 */

#include <gflags/gflags.h>
#include <glog/logging.h>
#include <iostream>
#include <fstream>
#include <sstream>


DEFINE_string(input, "", "path to input graph.");
DEFINE_string(output, "", "paht to output graph.");


typedef uint32_t Vidtype;
typedef double Etype;


void snap2mtx_parser(std::string line, std::string &lout)
{
  std::stringstream ss(line);
  std::stringstream sout;
  Vidtype src, dst;
  Etype val;
  
  ss >> src >> dst >> val;

  CHECK_EQ(ss.fail(), false);

  sout << src <<","<< dst <<"," << val;
  lout = sout.str();
}



int main(int argc, char **argv)
{
  google::ParseCommandLineFlags(&argc, &argv, false);

  std::ifstream ifs(FLAGS_input.c_str(), std::ios_base::in | std::ios_base::binary);
  std::ofstream ofs(FLAGS_output.c_str(), std::ios_base::out | std::ios_base::binary);


  /* parse */
  std::string line;
  size_t tot_read = 0;
  std::string lout;
  while(std::getline(ifs, line)) {
    tot_read ++;
    if (line.empty()) continue;
    if (line[0] == '#')  {
      LOG(INFO) << line;
      continue;
    }
    snap2mtx_parser(line, lout);
    ofs << lout << "\n";
    if (tot_read % 100000 == 0) 
      LOG(INFO) << tot_read << " lines read.";
  }

  LOG(INFO) <<  "lines read : " << tot_read
            << " ifstream rdstate , good, eof, fail, bad. : "<<  ifs.good()
            << " " << ifs.eof() << " " << ifs.fail() << " " << ifs.bad();


  ifs.close();
  ofs.close();

  return 0;
}



