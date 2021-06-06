#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>

using namespace std;
class Matrix
{
    private:
        vector<vector<int>> m;
        int w,h;
        int size_m;
    public:
        Matrix(){w = h = size_m = 0;}
        ~Matrix(){m.clear();w = h = size_m = 0;}
        Matrix getMatrix(string);
        int get_size(){return size_m;}
        int get_width(){return w;}
        int get_height(){return h;}
        Matrix multiplication(const Matrix,const Matrix);
        void printArray()
        {
            for (int i=0; i<this->h; i++){
                for (int j=0; j<this->w; j++) cout << m[i][j] << " ";
            cout << endl;}
        }
        void compareMatrix(Matrix);
};
Matrix Matrix::getMatrix(string filename)
{
    ifstream op;
    op.open(filename);
    string temp;
    while(getline(op,temp))
    {
        stringstream ss(temp);
        vector<int>r1;
        int temp1;
        int c = 0;
        while(ss >> temp1)
        {   c++;
            this->size_m++;
            r1.push_back(temp1);
        }
        this->m.push_back(r1);
        this->h++;
        this->w = c;
    }
     return *this;
}
Matrix Matrix::multiplication(const Matrix a, const Matrix b)
{
    if(a.w != b.h)
        {cout<<"can not perform multiplication";
         return *this;}
    else
    {
        vector<int> var;
        for (int i=0; i<a.h; i++){
            for(int j=0; j<b.w; j++){
            int temp1=0;
            for(int k=0; k< a.w; k++)
                temp1+=a.m[i][k] * b.m[k][j];
            var.push_back(temp1);
        }
        this->m.push_back(var);
        var.clear();}
    }
    this->h = a.h;
    this->w = b.w;
    this->size_m = this->h * this->w;
    return *this;
}
void Matrix::compareMatrix(Matrix b)
{   int count_2 = 0;
    if(this->h != b.h || this->w != b.w)
    {
        cout<<" Cannot compare";
        return;
    }
    for(int i = 0 ; i < this->h;i++)
        for(int j = 0; j < this->w; j++)
            if(this->m[i][j] != b.m[i][j]) count_2++;
    float rate_diff = (float)count_2/this->size_m;
    cout<<rate_diff<<endl;
    return;
}
int main()
{
    Matrix A;
    A.getMatrix("A.txt");
    Matrix B;
    B.getMatrix("B.txt");
    Matrix result;
    result.getMatrix("result.txt");
    Matrix golden_result;
    golden_result.multiplication(A,B);
    if(golden_result.get_size() == 0) return 0;
    result.compareMatrix(golden_result);
}
