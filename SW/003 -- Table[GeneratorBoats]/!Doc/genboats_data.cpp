///----------------------------------------------------------------------------|
/// Морской бой[ГЕНЕРАТОР РАССТАНОВКИ]. С++17
///
/// Расстановка кораблей на поле клеток C x R.
///
/// Правила:
///   - палубы должны соединяться строго по вертикали или строго по горизонтали.
///   - палубы соседних лодок должны иметь расстояние между собой в одну клетку.
///   - нет требования расположения всех палуб лодки в одну линию.
///
/// Алгоритм:
///   - на вход генератора подаётся само поле + состав флотилии.
///   - точка - место на поле адресуемое двумя числами по X и Y.
///   - аура  - соседние 8 точек рядом с выделенной.
///   - ...
///
/// Гарантия успешной генерации:
///   - опытным путём на 100'000 генерациях было установленно,
///     что общее кол-во палуб к кол-ву клеток поля должно быть < ~24.3%
///
///----------------------------------------------------------------------------:
#include <algorithm>
#include <iostream>
#include <numeric>
#include <vector>
#include <string>
#include <tuple>

#define ASSERT(u) if(!(u))  \
                  std::cout << myl::to_string("ASSERT: -> line: ", __LINE__)\
                            << '\n'
#define ERROR(v)  myl::to_string("ERROR: ", v, " -> line: ", __LINE__)
#define l(v)      std::cout << #v << " = " << v << "\n";

namespace std
{
    std::string to_string(const char*       s) { return s; }
    std::string to_string(const std::string s) { return s; }
}

#include <ctime>
#include <cstdlib>
///---------|
/// my lib  |
///---------:
namespace myl
{
    template <typename... TT>
    std::string to_string(TT&& ... a)
    {   return (std::to_string(a) + ...) + "\n";
    }

    template <typename ... TT>
    void BANNER(TT&&   ... a )
    {   ((std::cout    <<  a << std::endl), ...);
    }

    static int rrand(int range_min, int range_max)
    {   return rand() % (range_max - range_min) + range_min;
    }
}

inline void testfoo_rrand()
{
    for(int    i = 0; i < 100; ++i)
    {   auto   r = myl::rrand(0, 5);
        auto   b = 0 <= r && r < 5 ;
        ASSERT(b);
        if   (!b) return;
    }
    std::cout << __FUNCTION__ << " success!\n";
}

///------------------------------------|
/// Правило на состав флотилии.        |
/// Размер -> кол-во лодок.            |
/// Число  -> кол-во палуб в лодке.    |
///------------------------------------:
  inline std::vector<size_t> rule = {5, 4,4, 3,3,3, 2,2,2,2, 1,1,1,1,1};
//inline std::vector<size_t> rule = {5, 4,4,4, 1,1};

struct Point2i
{   size_t x, y;

    bool operator==(const Point2i& p) const { return p.x == x && p.y == y; }
};

///----------------------------------------------------------------------------|
/// Генератор расстановки.
///----------------------------------------------------------------------------:
struct  FieldRanking : public std::vector<std::string>
{       FieldRanking(const size_t C, const size_t R)
            : std::vector<std::string>(R, std::string(C, '.')),
              F(*this)
        {
            ASSERT(C > 1 && R > 1);

            ///------------------------------|
            /// Сначла с большим кол. палуб. |
            ///------------------------------:
            if(!std::is_sorted(std::begin(rule), std::end(rule)))
            {   std::   sort  (std::begin(rule), std::end(rule),
                               std::greater<int>());
            }

            generator();
        }

private:
    FieldRanking& F;

    /// (!)
    ///--------------------------------------------------|
    /// Генератор.                                       |<------ Генератор ТУТ!
    ///--------------------------------------------------:
    void generator()
    {
        for(const size_t n : rule)
        {
            ///------------------------------|
            /// Счётчик попыток(для защиты). |
            ///------------------------------:
            int cnt = 0;

            ///------------------------------|
            /// Ставим корабль.              |
            ///------------------------------:
            bool ready = true;
            do
            {
                ///------------------------------|
                /// На поле только такое ".z*"   |
                /// mayused должен быть пустой.  |
                ///------------------------------:
                ship_start_set();

                ///------------------------------|
                /// Ставим первую палубу-макет...|
                ///------------------------------:
                Point2i p;
                {   do
                    {   ///------------------------------|
                        /// Защита от вечного цикла.     |
                        ///------------------------------:
                        if( 500 ==++ cnt )
                        {   throw(ERROR ("generate fail"));
                        }

                        p = this->rrand();
                    } while(F[p.y][p.x] != '.');
                }
                F[p.y][p.x] = '!'; ///<------ тут.

                ///------------------------------|
                /// Варианты для остальных палуб.|
                ///------------------------------:
                add2mayused(p);

                ///------------------------------|
                /// Ставим остальные палубы.     |
                ///------------------------------:
                for(size_t i = 0, N = n - 1; i < N; ++i)
                {
                    ///------------------------------|
                    /// Нет места - Начать заново!   |
                    ///------------------------------:
                    if(mayused.empty())
                    {   ready = false; break;
                    }

                    ///------------------------------|
                    /// Рандом возможного варианта.  |
                    ///------------------------------:
                    size_t      k = (size_t)myl::rrand(0, (int)mayused.size());
                    p = mayused[k];

                    ///------------------------------|
                    /// Удаляем использованный варик.|
                    ///------------------------------:
                    del_from_mayused(k);

                    ///------------------------------|
                    /// Добавляем варианты для палуб.|
                    ///------------------------------:
                    add2mayused(p);

                    ///------------------------------|
                    /// Ставим палубу-макет.         |
                    ///------------------------------:
                    F[p.y][p.x] = '!';
                }

            } while(!ready);

            ///------------------------------|
            /// Узакониваем макет: '!' -> '*'|
            /// Ауру переводим в запрет.     |
            ///------------------------------:
            ship_end_set();
        }

        ///------------------------------|
        /// Все корабли расставлены!     |
        ///------------------------------:
        clear_for_user();
    }

    ///--------------------------|
    /// Рандомная точка на поле. |
    ///--------------------------:
    Point2i rrand() const
    {   return { (size_t)myl::rrand(0, F[0].size()),
                 (size_t)myl::rrand(0, F   .size())};
    }

    ///--------------------------|
    /// Сбор разрешенных точек.  |
    ///--------------------------:
    std::vector<Point2i>  mayused;
    void add2mayused(const Point2i& p)
    {
        Point2i m[] =
        {
            {p.x - 1, p.y    },
            {p.x    , p.y - 1},
            {p.x    , p.y + 1},
            {p.x + 1, p.y    },

            {p.x - 1, p.y - 1},
            {p.x - 1, p.y + 1},
            {p.x + 1, p.y - 1},
            {p.x + 1, p.y + 1}
        };

        aura(m);

        const auto& R = F   .size();
        const auto& C = F[0].size();

        std::copy_if(m, m + 4, std::back_inserter(mayused),
            [&](const auto& p)
            {   return  p.x < C &&
                        p.y < R && F[p.y][p.x] == 'a' && is_noexist(p);
            }
        );
    }

    typedef Point2i Point2i_8t[8];

    ///--------------------------|
    /// Аура вокруг палубы.      |
    ///--------------------------:
    void aura(const Point2i_8t& m)
    {
        const auto& R = F   .size();
        const auto& C = F[0].size();

        for(const auto& p : m)
        {   if( auto& e = F[p.y][p.x]; p.x < C && p.y < R && e == '.')
            {   e = 'a';
            }
        }
    }

    ///--------------------------|
    /// Перед установкой лодки.  |
    ///--------------------------:
    void ship_start_set()
    {   for(auto& s :  F)
        {   std::replace_if(std::begin(s), std::end(s),
                [](auto c){return c == 'a' || c == '!';}, '.'
            );
        }
        mayused.clear();
    }

    ///--------------------------|
    /// Завершение установки.    |
    ///--------------------------:
    void ship_end_set()
    {   for    (auto& s : F)
        {   for(auto& c : s)
            {        if(c == 'a') c = 'z';
                else if(c == '!') c = '*';
            }
        }
    }

    ///--------------------------|
    /// Удаление исп. точки.     |
    ///--------------------------:
    void del_from_mayused(size_t i)
    {   std::swap(mayused[i], mayused.back());
        mayused.pop_back();
    }

    ///--------------------------|
    /// Очистка от служебн. инфы.|
    ///--------------------------:
    void clear_for_user   ()
    {   for    (auto& s : F)
        {   for(auto& c : s)
            {
                switch(c)
                {
                  //case '.':
                    case 'a':
                    case 'z': c = '.';
                }
            }
        }
    }

    ///--------------------------|
    /// Без повторов.            |
    ///--------------------------:
    bool is_noexist(const Point2i& P) const
    {   return std::find(mayused.begin(), mayused.end(), P) == mayused.end();
    }

public:
    ///--------------------------|
    /// Оценка надежности генера.|
    ///--------------------------:
    std::string is_guarantee_success() const
    {
        const  auto&[cells, palubs, persent] = get_info();
        return persent > 24.35f ? "WARNING: is_guarantee_success == FALSE!"
                                : "Good is_guarantee_success!";
    }

    void info() const
    {   const auto&[cells, palubs, persent] = get_info();
        l(cells)
        l(palubs)
        l(persent)
    }

private:
    std::tuple<size_t, size_t, float> get_info() const
    {
        const size_t  cells = F[0].size() * F.size();
        const size_t palubs = std::accumulate(rule.begin(), rule.end(), 0);
        const float persent = float(100) * palubs / cells;

        return std::make_tuple(cells, palubs, persent);
    }
};

///------------------------------------|
/// Вывод на экран / в файл.           |
///------------------------------------:
std::ostream& operator<<(std::ostream& o, const FieldRanking& F)
{   std::string line(F[0].size(), '-');
                             o << '-' << line << "|\n";
    for(const auto& s : F) { o << '|' << s    << "|\n"; }
                             o << '|' << line << "-\n";
    return                   o;
}

///----------------------------------------------------------------------------|
/// Тесты.
///----------------------------------------------------------------------------:
///------------------------------------|
/// Тест генератора на 1 запуске.      |
///------------------------------------:
inline void testclass_FieldRanking()
{
    FieldRanking field(12, 12);
                 field.info ();
    std::cout << field.is_guarantee_success() << '\n'
              << field                        << '\n';
}

///------------------------------------|
/// Проверка на успешность генерации.  |
///------------------------------------:
inline void testclass_FieldRanking_1000()
{
    for(int i = 1; i < 100'000; ++i)
    {   std::cout << "\r        \r" << i;
        FieldRanking  field(12, 12);
    }

    std::cout << '\n' << __FUNCTION__ << " success!\n";
}

///------------------------------------|
/// Present 5 расстановок.             |
///------------------------------------:
inline void testclass_FieldRanking_Present()
{
    for(int i = 1; i < 6; ++i)
    {
        FieldRanking field(18, 8);

        if(1 == i) std::cout << field.is_guarantee_success() << "\n\n";

        std::cout << i     << ":\n"
                  << field << " \n";
    }
}

///------------------------------------|
/// Все тесты тут.                     |
///------------------------------------:
inline void testall()
{
  //testfoo_rrand                 ();
  //testclass_FieldRanking        ();
  //testclass_FieldRanking_1000   ();
    testclass_FieldRanking_Present();
}

///----------------------------------------------------------------------------|
/// Старт.
///----------------------------------------------------------------------------:
int main()
{ //srand((unsigned)time(0));
    srand(1003);

    myl::BANNER(
    "///-----------------------------------|" ,
    "///          SeaWar-2022!             |" ,
    "///-----------------------------------:");

    try
    {   testall();
    }
    catch(std::string& err){ std::cout << err    << '\n'; }
    catch(...)             { std::cout << "ERROR: ???\n"; }

    myl::BANNER(
    "///-----------------------------------|" ,
    "///        Programm FINISHED!         |" ,
    "///-----------------------------------.");

    /// std::cin.get();
}
