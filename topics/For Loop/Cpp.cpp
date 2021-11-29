#include <iostream>

int main()
{
  int myint[] = {1, 2, 3, 4, 5};

  for (int i : myint)
  {
    std::cout << i << '\n';
  }
}

// or

// for (auto __anon = begin(myint); __anon != end(myint); ++__anon)
// {
// auto i = *__anon;
// std::cout << i << '\n';
// }