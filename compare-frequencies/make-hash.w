\def\covernote{Copyright 2012 Humberto Ortiz-Zuazaga -- University of Puerto Rico}

@* make-hash.
Use hash tables to count word frequencies in two documents. Output the
words in either document, and the frequencies of ocurrence of each word in each document.

@(make-hash.cpp@>=
#include <iostream>
#include <fstream>
#include <list>

#include "hash.cpp"
#include "ST.cxx"

using namespace std;

int main() {
  ifstream pg1 ("pg1.txt");   // stream for Declaration of Independence
  ifstream pg11 ("pg11.txt"); // stream for Alice in Wonderland
  
  ST<Key> table1 (1024); // words in pg1 
  ST<Key> table2 (1024); // words in pg11
  ST<Key> table3 (1024); // the union of the words in pg1 and pg11

  string word;

  int i = 0;

  @<Read the inputs.@>;
  @<For each word seen, print word and frequencies@>;
}

@ To read the inputs, we use the C++ input tokenizer. Each word found
is inserted into a hash table specific to the file and a hash table
common to both files. Inserting a word already present results in the
word count being incremented.

@<Read the inputs.@>=
  while (pg1 >> word) {

    Item item(word, 1); // create an Item
    table1.insert(item); // insert into table1
    table3.insert(item); // and into the union
  }

  while (pg11 >> word) {

    Item item(word, 1);
    table2.insert(item); // insert into table2
    table3.insert(item); // and the union
  }

@ |table3| has the list of all words in either document. We can
flatten the table into a list, and then iterate over all the
words. For each word, print the word, then look up the word in the
hash tables and print the frequencies.

@<For each word seen, print word and frequencies@>=
  list<string> words = table3.flatten();

  list<string>::iterator it;

  string myword;

  cout << "mylist contains:" << endl;
  for ( it=words.begin() ; it != words.end(); it++ ) {
    myword = *it;
    cout << myword << ": ";
    table1.search(myword).show(); // print frequency in pg1
    cout << ":" ;
    table2.search(myword).show(); // print frequency in pg11
    cout << endl;
  }

@* The hash function.

@(hash.cpp@>=
// This code is from "Algorithms in C++, Third Edition," by Robert
// Sedgewick, Addison-Wesley, 1999.

#include <string>

using namespace std;

int hashU(string str, int M)
  { int h, a = 31415, b = 27183;
    const char *v = str.c_str();

    for (h = 0; *v != 0; v++, a = a*b % (M-1)) 
        h = (a*h + *v) % M;
    return (h < 0) ? (h + M) : h;
  }

@* The hash table (a symbol table).

@(ST.cxx@>=
// This code is from "Algorithms in C++, Third Edition," by Robert
// Sedgewick, Addison-Wesley, 1999.

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

@ Hash table entries are word as a |string| in |keyval|, frequency in |info|.

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
        { keyval = ""; info=0; } 
    Item(Key k, int v) 
    { keyval = k; info = v; } 
      Key key()
        { return keyval; }
      int null()
        { return keyval == ""; }
      int scan(istream& is = cin)
        { return (is >> keyval >> info) != 0; }
      void show(ostream& os = cout)
        { os << info; }
    void addone() {
      info++;
    }
   }; 

ostream& operator<<(ostream& os, Item& x)
  { x.show(os); return os; }
