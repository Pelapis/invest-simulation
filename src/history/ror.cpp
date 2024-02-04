#include <iostream>
#include <random>
#include <ctime>
#include <stdlib.h>
#include <chrono>
using namespace std;



class Investors {
    public:
        Investors() {
            period_return = getPeriodReturn();
            rng = mt19937(rd());
            uniform = uniform_real_distribution<double>(0, 1);
        };
        double level = 0.5;
        double frequency = 1;
        int hold = 1;
        static int num;
        static double transaction_cost;
        static double day_return_data[];
    private:
        int days = getDays();
        static int getDays();
        int periods = days % hold == 0 ? days / hold : days / hold + 1;
        double* period_return;
        double* getPeriodReturn() {
            double* period_return = new double[periods];
            for (int i = 0; i < periods; i++) {
                period_return[i] = 1;
                for (int j = 0; j < hold; j++) {
                    int index = i * hold + j;
                    if (index >= days) {
                        break;
                    }
                    period_return[i] *= day_return_data[index];
                }
            }
            return period_return;
        };
        random_device rd;
        mt19937 rng;
        uniform_real_distribution<double> uniform;
        bool* getIsFocused() {
            bool* is_focused = new bool[periods];
            for (int i = 0; i < periods; i++) {
                is_focused[i] = uniform(rng) < level;
            }
            return is_focused;
        };
        bool* getWillBuy() {
            bool* will_buy = new bool[periods];
            for (int i = 0; i < periods; i++) {
                will_buy[i] = uniform(rng) < level == period_return[i] > 1;
            }
            return will_buy;
        };
    public:
        double* genRORs() {
            double* rors = new double[num];
            for (int i = 0; i < num; i++) {
                bool* is_focused = getIsFocused();
                bool* will_buy = getWillBuy();
                double return_rate = 1;
                for (int i = 0; i < periods; i++) {
                    return_rate *= is_focused[i] && will_buy[i] ? period_return[i] * (1 - transaction_cost) : 1;
                }
                rors[i] = return_rate;
                delete[] is_focused;
                delete[] will_buy;
            }
            return rors;
        };
};

int Investors::num = 100000;
double Investors::day_return_data[] = {1.000578688,1.00458721,0.995796513,1.00031679,1.001757629,0.981292752,1.038055275,1.00703332};
double Investors::transaction_cost = 0.001;
int Investors::getDays() {
    return sizeof(Investors::day_return_data) / sizeof(Investors::day_return_data[0]);
};

int main() {
    // 获取开始时间点
    auto start = std::chrono::high_resolution_clock::now();
    Investors investor;
    cout << "交易成本是：" << Investors::transaction_cost << endl;
    cout << "投资者数量是：" << investor.num << endl;
    cout << "投资者收益率是：";
    double* rors = investor.genRORs();
    for (int i = 0; i < investor.num; i++) {
        cout <<rors[i] << " ";
    }
    cout << endl;

    // 获取结束时间点
    auto end = std::chrono::high_resolution_clock::now();
    // 计算运行时间
    std::chrono::duration<double> diff = end - start;
    std::cout << "Code executed in " << diff.count() << " seconds" << std::endl;
    return 0;
}
