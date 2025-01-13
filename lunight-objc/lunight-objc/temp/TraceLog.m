///***********************************************************************
//* Copyright (c) 2019, LuLab
//* This file is licenced under a Creative MIT License
//*
//*  * @file - TraceLog.hpp
//*  * @brief - Trace 매크로 C++버전
//*  * @version - 1.0
//*  * @see - .
//*  * @todo - 테스트 필요
//*  * @deprecated - .
//*  * @history
//*   - 2019.8.22 첫작성
//*   - 2020.01.07 주석추가 소스점검.
//*  * @author lunight (kimkshahaha@gmail.com)
//*
//*********************************************************************** */
//
//#ifndef TraceLog_hpp
//#define TraceLog_hpp
////#include <iostream>
//#include <map>
//#include <time.h>
//#include <sys/timeb.h>
//
//
//using std::string;
//using std::map;
//using std::vector;
//using std::cout;
//using std::endl;
//
//namespace TraceLog{
//   class Trace{
//   public:
//       Trace(const string& func)
//       :m_func(func){
//           //cout << "[" << m_func << "]" << " START" << endl;
//           
//           ftime(&itb);
//           lt = localtime(&itb.time);
//           
//           cout << lt->tm_year + 1900 << "-" << lt->tm_mon + 1 << "-" << lt->tm_mday << "__"  << lt->tm_hour << ":"  << lt->tm_min << ":" << lt->tm_sec << "." << itb.millitm <<"__[" << m_func << "]" << " START" << endl;
//           // 함수 runtime 분석시 사용
//           //            beginTimer = clock();
//           //            nowTime = time(NULL);
//           //            st = localtime(&nowTime);
//           //            cout << "[" << st->tm_hour << ":" << st->tm_min << ":" << st->tm_sec << "_" << m_func << "]" << " START" << endl;
//       }
//       
//       ~Trace(){
//           //cout << "[" << m_func << "]" << " END" << endl;
//
//           cout << lt->tm_year + 1900 << "-" << lt->tm_mon + 1 << "-" << lt->tm_mday << "__"  << lt->tm_hour << ":"  << lt->tm_min << ":" << lt->tm_sec << "." << itb.millitm <<"__[" << m_func << "]" << " END" << endl;
//           
//           // 함수 runtime 분석시 사용
//           //            nowTime = time(NULL);
//           //            st = localtime(&nowTime);
//           //            cout << "[" << st->tm_hour << ":" << st->tm_min << ":" << st->tm_sec << "(runtime " << ((float)clock()-beginTimer)/CLOCKS_PER_SEC<< ")_" << m_func << "]" << " END" << endl;
//       }
//   private:
//       string m_func;
//       
//       struct timeb itb;
//       struct tm *lt;
//       
//       
//       // 함수 runtime 분석시 사용
//       //        time_t nowTime;
//       //        struct tm *st;
//       //        clock_t beginTimer;
//       
//   };
//}
//
//#ifdef DEBUG
//#define TraceLog Trace trace(__FUNCTION__)
//#else
//#define TraceLog
//#endif
//
//#endif /* trace_h */
