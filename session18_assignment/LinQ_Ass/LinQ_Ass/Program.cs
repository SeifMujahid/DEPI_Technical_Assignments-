using System;
using LibraryManagementSystem;
using LINQ_DATA;
using System.Linq;

namespace LinQ_Ass
{
    class Program
    {
        static void Main(string[] args)
        {
            Task1_FindAllAvailableBooks();
            Task2_GetAllBookTitles();
            Task3_FindBooksByGenre();
            Task4_SortBooksByTitle();
            Task5_FindExpensiveBooks();
            Task6_GetUniqueGenres();
            Task7_CountBooksByGenre();
            Task8_FindRecentBooks();
            Task9_GetFirst5Books();
            Task10_CheckAnyExpensiveBooksExist();
            Task11_BooksWithAuthorInformation();
            Task12_AveragePriceByGenre();
            Task13_MostExpensiveBook();
            Task14_GroupBooksByDecade();
            Task15_MembersWithActiveLoans();
            Task16_BooksBorrowedMoreThanOnce();
            Task17_OverdueBooks();
            Task18_AuthorBookCounts();
            Task19_PriceRangeAnalysis();
            Task20_MemberLoanStatistics();
        }

        static public void Task1_FindAllAvailableBooks()
        {
            var result = LibraryData.Books.Where(b => b.IsAvailable);
            result.ToConsoleTable("Available Books");
        }

        static public void Task2_GetAllBookTitles()
        {
            var result = LibraryData.Books.Select(b => b.Title);
            result.ToConsoleTable("Title", "Book Titles");
        }

        static public void Task3_FindBooksByGenre()
        {
            var result = LibraryData.Books.Where(b => b.Genre == "Programming");
            result.ToConsoleTable("Programming Books");
        }

        static public void Task4_SortBooksByTitle()
        {
            var result = LibraryData.Books.OrderBy(b => b.Title);
            result.ToConsoleTable("Books Sorted by Title");
        }

        static public void Task5_FindExpensiveBooks()
        {
            var result = LibraryData.Books.Where(b => b.Price > 30);
            result.ToConsoleTable("Expensive Books (> $30)");
        }

        static public void Task6_GetUniqueGenres()
        {
            var result = LibraryData.Books.Select(b => b.Genre).Distinct();
            result.ToConsoleTable("Genre", "Unique Genres");
        }

        static void Task7_CountBooksByGenre()
        {
            var result = LibraryData.Books
                .GroupBy(b => b.Genre)
                .Select(g => new { Genre = g.Key, Count = g.Count() });
            result.ToConsoleTable("Books Count by Genre");
        }

        static public void Task8_FindRecentBooks()
        {
            var result = LibraryData.Books.Where(b => b.PublishedYear > 2010);
            result.ToConsoleTable("Recent Books (>2010)");
        }

        static public void Task9_GetFirst5Books()
        {
            var result = LibraryData.Books.Take(5);
            result.ToConsoleTable("First 5 Books");
        }

        static public void Task10_CheckAnyExpensiveBooksExist()
        {
            var result = LibraryData.Books.Any(b => b.Price > 50);
            Console.WriteLine($"Any books over $50? {result}\n");
        }

        static public void Task11_BooksWithAuthorInformation()
        {
            var result = LibraryData.Books
                .Join(LibraryData.Authors,
                      b => b.AuthorId,
                      a => a.Id,
                      (b, a) => new { b.Title, AuthorName = a.Name, b.Genre });
            result.ToConsoleTable("Books with Author Information");
        }

        static public void Task12_AveragePriceByGenre()
        {
            var result = LibraryData.Books
                .GroupBy(b => b.Genre)
                .Select(g => new { Genre = g.Key, AveragePrice = g.Average(b => b.Price) });
            result.ToConsoleTable("Average Price by Genre");
        }

        static public void Task13_MostExpensiveBook()
        {
            var result = LibraryData.Books.OrderByDescending(b => b.Price).FirstOrDefault();
            new[] { result }.ToConsoleTable("Most Expensive Book");
        }

        static public void Task14_GroupBooksByDecade()
        {
            var result = LibraryData.Books
                .GroupBy(b => (b.PublishedYear / 10) * 10)
                .Select(g => new { Decade = g.Key, Books = g.ToList() });

            foreach (var group in result)
            {
                Console.WriteLine($"\n{group.Decade}s");
                Console.WriteLine(new string('-', 20));
                group.Books.ToConsoleTable();
            }
        }

        static public void Task15_MembersWithActiveLoans()
        {
            var result = LibraryData.Loans
                .Where(l => l.ReturnDate == null)
                .Join(LibraryData.Members,
                      l => l.MemberId,
                      m => m.Id,
                      (l, m) => m)
                .Distinct();
            result.ToConsoleTable("Members with Active Loans");
        }

        static public void Task16_BooksBorrowedMoreThanOnce()
        {
            var result = LibraryData.Loans
                .GroupBy(l => l.BookId)
                .Where(g => g.Count() > 1)
                .Join(LibraryData.Books,
                      g => g.Key,
                      b => b.Id,
                      (g, b) => new { b.Title, LoanCount = g.Count() });
            result.ToConsoleTable("Books Borrowed More Than Once");
        }

        static public void Task17_OverdueBooks()
        {
            var result = LibraryData.Loans
                .Where(l => l.DueDate < DateTime.Now && l.ReturnDate == null)
                .Join(LibraryData.Books,
                      l => l.BookId,
                      b => b.Id,
                      (l, b) => b)
                .Distinct();
            result.ToConsoleTable("Overdue Books");
        }

        static public void Task18_AuthorBookCounts()
        {
            var result = LibraryData.Books
                .GroupBy(b => b.AuthorId)
                .Join(LibraryData.Authors,
                      g => g.Key,
                      a => a.Id,
                      (g, a) => new { AuthorName = a.Name, Count = g.Count() })
                .OrderByDescending(x => x.Count);
            result.ToConsoleTable("Author Book Counts");
        }

        static public void Task19_PriceRangeAnalysis()
        {
            var result = LibraryData.Books
                .GroupBy(b =>
                    b.Price < 20 ? "Cheap" :
                    b.Price <= 40 ? "Medium" : "Expensive")
                .Select(g => new { Range = g.Key, Count = g.Count() });
            result.ToConsoleTable("Price Range Analysis");
        }

        static public void Task20_MemberLoanStatistics()
        {
            var result = LibraryData.Members
                .Select(m => new
                {
                    m.FullName,
                    TotalLoans = LibraryData.Loans.Count(l => l.MemberId == m.Id),
                    ActiveLoans = LibraryData.Loans.Count(l => l.MemberId == m.Id && l.ReturnDate == null),
                    AverageDaysBorrowed = LibraryData.Loans
                        .Where(l => l.MemberId == m.Id && l.ReturnDate != null)
                        .Select(l => (l.ReturnDate.Value - l.LoanDate).TotalDays)
                        .DefaultIfEmpty(0)
                        .Average()
                });
            result.ToConsoleTable("Member Loan Statistics");
        }
    }
}
