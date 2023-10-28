#include <iostream>
#include <random>
using namespace std;

class Investors {
    public:
        Investors() {
            period_return = getPeriodReturn();
            rors = genRORs();
        };
        double level = 0.5;
        double frequency = 1;
        int hold = 1;
        static int num;
        static double transaction_cost;
        static double day_return_data[];
        int days = getDays();
        static int getDays();
        int periods = days % hold == 0 ? days / hold : days / hold + 1;
        double* period_return;
        double* rors;
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
        bool* getIsFocused() {
            bool* is_focused = new bool[periods];
            // Use random library to generate random number
            default_random_engine e;
            uniform_real_distribution<double> u(0, 1);
            for (int i = 0; i < periods; i++) {
                is_focused[i] = u(e) < level;
            }
            return is_focused;
        };
        bool* getWillBuy() {
            bool* will_buy = new bool[periods];
            default_random_engine e;
            uniform_real_distribution<double> u(0, 1);
            for (int i = 0; i < periods; i++) {
                will_buy[i] = u(e) < level == period_return[i] > 1;
            }
            return will_buy;
        };
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

int Investors::num = 10;
double Investors::day_return_data[] = {1.02, 0.97};
double Investors::transaction_cost = 0.001;
int Investors::getDays() {
    return sizeof(Investors::day_return_data) / sizeof(Investors::day_return_data[0]);
};

int main() {
    Investors investor;
    cout << "交易成本是：" << Investors::transaction_cost << endl;
    cout << "投资者数量是：" << investor.num << endl;
    cout << "投资者收益率是：";
    for (int i = 0; i < investor.num; i++) {
        cout << fixed << cout.precision(6) <<investor.rors[i] << " ";
    }
    cout << endl;
    return 0;
}
