@ make-hash. Count word frequencies in two documents with hash tables.

@(make-hash.cpp@>=
// make-hash.cpp - Test Sedgewick's hash functions.
// Copyright 2011 - Humberto Ortiz-Zuazaga

#include <iostream>
#include <fstream>
#include <list>

#include "hash.cpp"
#include "ST.cxx"

using namespace std;

int main() {
  ifstream pg1 ("pg1.txt");
  ifstream pg11 ("pg11.txt");

  ST<Key> table1 (1024);
  ST<Key> table2 (1024);
  ST<Key> table3 (1024);

  string word;

  int i = 0;

  while (pg1 >> word) {

    Item item(word, 1);
    table1.insert(item);
    table3.insert(item);
  }

  while (pg11 >> word) {

    Item item(word, 1);
    table2.insert(item);
    table3.insert(item);
  }

  list<string> words = table3.flatten();

  list<string>::iterator it;

  string myword;

  cout << "mylist contains:";
  for ( it=words.begin() ; it != words.end(); it++ ) {
    myword = *it;
    cout << myword << ": ";
    Item col1 = table1.search(myword);
    if (!col1.null()) {
      col1.show();
    } else {
      cout << "not found";
    }
    cout << ":" ;
    Item col2 = table2.search(myword);
    if (!col2.null()) {
      col2.show();
    } else {
      cout << "not found";
    }
  }
}

@ The hash function.

@(hash.cpp@>=
// This code is from "Algorithms in C++, Third Edition," by Robert
// Sedgewick, Addison-Wesley, 1999."

#include <string>

using namespace std;

int hashU(string str, int M)
  { int h, a = 31415, b = 27183;
    const char *v = str.c_str();

    for (h = 0; *v != 0; v++, a = a*b % (M-1)) 
        h = (a*h + *v) % M;
    return (h < 0) ? (h + M) : h;
  }

@ The hash table (a symbol table).

@(ST.cxx@>=
// This code is from "Algorithms in C++, Third Edition," by Robert
// Sedgewick, Addison-Wesley, 1999."

// Stolen from Program 12.6
// Modified with code from Program 14.3

#include <stdlib.h>
#include <list>
#include "Item.cpp"

typedef string Key;

template <class Key>
class ST 
  {
    private:
      Item nullItem;
      struct node 
        { Item item; node* next; 
          node(Item x, node* t)
            { item = x; next = t; } 
        }; 
      typedef node *link;
      Item searchR(link t, Key v)
        { if (t == 0) return nullItem;
          if (t->item.key() == v) return t->item;
          return searchR(t->next, v);
        }
  link* heads;
  int N, M;

  public:
    ST(int maxN)
    { 
      N = 0; M = maxN/5;
      heads = new link[M]; 
      for (int i = 0; i < M; i++) heads[i] = 0;
    }
  Item search(Key v)
    { return searchR(heads[hashU(v, M)], v); }

    void insert(Item item) { 
      Key key = item.key();
      int i = hashU(item.key(), M);
      for (link ptr = heads[i]; ptr != NULL; ptr = ptr->next) {
	if (ptr->item.key() == key) {
	  ptr->item.addone();
	  N++;
	  return;
	}
      }
      heads[i] = new node(item, heads[i]); 
      N++; 
    }

    int count() { 
	  return N; 
    }

    void show() {
      link nodeptr;
      for (int i = 0; i < M; i++) {
	nodeptr = heads[i];
	while (NULL != nodeptr) {
	  nodeptr->item.show();
	  nodeptr = nodeptr->next;
	}
      }
    }

    list<string> flatten() {
      link nodeptr;
      list<string> retval;

      for (int i = 0; i < M; i++) {
	nodeptr = heads[i];
	while (NULL != nodeptr) {
	  retval.push_back(nodeptr->item.key());
	  nodeptr = nodeptr->next;
	}
      }
      return retval;
    }

};

@ Hash table entries are word, frequency.

@(Item.cpp@>=
// This code is from "Algorithms in C++, Third Edition," by Robert
// Sedgewick, Addison-Wesley, 1999."

#include <stdlib.h>
#include <iostream>

using namespace std;

static int maxKey = 1000;
typedef string Key;
class Item 
  { 
    private:
      Key keyval; 
      int info;
    public:
      Item() 
        { keyval = maxKey; } 
    Item(Key k, int v) 
    { keyval = k; info = v; } 
      Key key()
        { return keyval; }
      int null()
        { return keyval == ""; }
      int scan(istream& is = cin)
        { return (is >> keyval >> info) != 0; }
      void show(ostream& os = cout)
        { os << keyval << " " << info << endl; }
    void addone() {
      info++;
    }
   }; 

ostream& operator<<(ostream& os, Item& x)
  { x.show(os); return os; }
