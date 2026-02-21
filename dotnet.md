# .NET Interview Questions

Comprehensive .NET and C# interview preparation covering all difficulty levels with practical code examples.

---

## 🟢 **Junior/Beginner Level**

### C# Fundamentals

**Q1: What is .NET and what platforms does it run on?**

.NET is a free, open-source, cross-platform framework developed by Microsoft for building applications.

**Platforms:**
- Windows (.NET Framework, .NET Core, .NET 5+)
- Linux (.NET Core, .NET 5+)
- macOS (.NET Core, .NET 5+)
- Cloud (Azure)

**.NET Versions:**
- .NET Framework (Windows-only, legacy)
- .NET Core 3.1 (cross-platform)
- .NET 5, 6, 7, 8+ (modern, unified)

**Q2: What's the difference between .NET Framework and .NET Core?**

| .NET Framework | .NET Core |
|---|---|
| Windows only | Cross-platform |
| Mature, stable | Faster, modern |
| Legacy | Future |
| Removed from support | Current support |
| Not recommended for new projects | Recommended for all new projects |

**Q3: What are the main differences between C# value types and reference types?**

```csharp
// Value types - stored on stack
int age = 25;
double salary = 50000.50;
bool isActive = true;
DateTime date = DateTime.Now;
struct Point { public int X, Y; }

// Reference types - stored on heap
string name = "John";
class Person { public string Name; }
object obj = new object();
int[] numbers = new int[10];

// Key difference
int a = 10;
int b = a;
b = 20;
Console.WriteLine(a); // 10 - independent copies

Person p1 = new Person { Name = "John" };
Person p2 = p1;
p2.Name = "Jane";
Console.WriteLine(p1.Name); // "Jane" - same reference
```

**Q4: What are nullable types and how do you use them?**

```csharp
// Nullable value types
int? age = null;
double? salary = 50000.50;
bool? isActive = null;

// Check if has value
if (age.HasValue)
{
    Console.WriteLine(age.Value);
}

// Null-coalescing operator
int actualAge = age ?? 0;  // Use 0 if age is null

// Null-conditional operator
string? nullableName = null;
int length = nullableName?.Length ?? 0;  // Access if not null

// Nullable reference types (C# 8+)
#nullable enable
string? name = null;  // Can be null
string title = "Mr";  // Cannot be null (compiler warning if assigned null)
```

**Q5: What's the difference between const, readonly, and static?**

```csharp
public class MyClass
{
    // const - compile-time constant, must be initialized at declaration
    public const int MaxRetries = 3;  // Cannot be changed
    
    // readonly - runtime constant, can be set in constructor
    public readonly int Id;
    public readonly string Name = "Default";
    
    public MyClass(int id)
    {
        Id = id;  // Can set in constructor
        // Name = "Changed";  // ERROR: Cannot reassign readonly
    }
    
    // static - shared across all instances
    public static int InstanceCount = 0;
    
    public MyClass()
    {
        InstanceCount++;  // All instances share this
    }
}

// Differences:
// const: Compile-time, inlined, must be primitive or string
// readonly: Runtime, not inlined, can be any type
// static: Shared state, not instance-specific
```

**Q6: Explain boxing and unboxing.**

```csharp
// Boxing - converting value type to reference type
int num = 42;
object boxedNum = num;  // Boxing: copies value to object on heap

// Unboxing - converting reference type back to value type
object obj = 42;
int unboxedNum = (int)obj;  // Unboxing: extracts value

// Performance consideration: Avoid unnecessary boxing
int[] numbers = new int[3];
for (int i = 0; i < numbers.Length; i++)
{
    object boxed = i;  // Boxing - performance cost
}

// Better: Use generics to avoid boxing
List<int> list = new List<int>();  // No boxing needed
for (int i = 0; i < 3; i++)
{
    list.Add(i);  // No boxing
}
```

---

## 🟡 **Mid-Level**

### Object-Oriented Programming

**Q7: What are access modifiers and their differences?**

```csharp
public class Parent
{
    // public - accessible from anywhere
    public string PublicField = "Public";
    
    // private - accessible only within this class
    private string privateField = "Private";
    
    // protected - accessible in this class and derived classes
    protected string protectedField = "Protected";
    
    // internal - accessible within same assembly
    internal string internalField = "Internal";
    
    // protected internal - protected OR internal
    protected internal string protInternalField = "ProtInternal";
    
    // private protected - protected AND internal (C# 7.2+)
    private protected string privProtField = "PrivProt";
}

public class Child : Parent
{
    public void Test()
    {
        // Can access public
        var pub = PublicField;  // ✓
        
        // Cannot access private
        // var priv = privateField;  // ✗
        
        // Can access protected
        var prot = protectedField;  // ✓
        
        // Can access internal (same assembly)
        var inter = internalField;  // ✓
    }
}
```

**Q8: What is the difference between abstract class and interface?**

```csharp
// Abstract class - can have implementation, constructors, state
public abstract class Animal
{
    public string Name { get; set; }
    
    // Constructor
    protected Animal(string name) { Name = name; }
    
    // Abstract method - must be implemented
    public abstract void MakeSound();
    
    // Virtual method - can be overridden
    public virtual void Move() { Console.WriteLine("Moving"); }
    
    // Concrete method
    public void Eat() { Console.WriteLine("Eating"); }
}

public class Dog : Animal
{
    public Dog(string name) : base(name) { }
    
    public override void MakeSound() { Console.WriteLine("Woof"); }
    
    public override void Move() 
    { 
        Console.WriteLine("Dog running");
        base.Move();  // Can call base
    }
}

// Interface - only abstract members (no state, no constructors)
public interface IComparable
{
    int CompareTo(object obj);
}

public interface IAnimal
{
    void MakeSound();
    void Move();
}

public class Cat : IAnimal
{
    public void MakeSound() { Console.WriteLine("Meow"); }
    public void Move() { Console.WriteLine("Cat walking"); }
}

// Key differences:
// Abstract: single inheritance, can have state, constructors, access modifiers
// Interface: multiple inheritance, no state, no constructors, members are public
```

**Q9: What are properties and why use them instead of fields?**

```csharp
public class Person
{
    // ❌ Bad: public field - no encapsulation
    public int age;
    
    // ✅ Good: property with backing field
    private int _age;
    public int Age
    {
        get { return _age; }
        set { _age = value >= 0 ? value : 0; }  // Validation
    }
    
    // ✅ Auto-property (C# 3+)
    public string Name { get; set; }
    
    // ✅ Init-only property (C# 9+)
    public string Id { get; init; }  // Can only be set during initialization
    
    // ✅ Property with validation
    private string _email;
    public string Email
    {
        get => _email;
        set => _email = value.Contains("@") ? value : throw new ArgumentException("Invalid email");
    }
    
    // ✅ Computed property
    public string FullInfo => $"{Name}, Age {Age}";
    
    // ✅ Property with different access levels
    public string Secret { get; private set; }  // Readable by all, settable only in class
}

var person = new Person { Name = "John", Age = 30, Id = "123" };
// person.Id = "456";  // Error: property is init-only
```

**Q10: Explain inheritance and method overriding.**

```csharp
public class Vehicle
{
    public string Brand { get; set; }
    
    public virtual void Start()
    {
        Console.WriteLine("Vehicle starting");
    }
    
    public virtual void Drive()
    {
        Console.WriteLine("Vehicle driving");
    }
}

public class Car : Vehicle
{
    // Override method
    public override void Start()
    {
        Console.WriteLine("Car engine starting");
        base.Start();  // Call base implementation
    }
    
    // Not overriding Drive
    public void Accelerate()
    {
        Console.WriteLine("Car accelerating");
    }
}

public class ElectricCar : Car
{
    // Can override overridden method
    public override void Start()
    {
        Console.WriteLine("Electric motor starting");
        base.Start();  // Calls Car's Start, which calls Vehicle's Start
    }
}

var car = new Car { Brand = "Toyota" };
car.Start();  // "Car engine starting" then "Vehicle starting"
car.Drive();  // "Vehicle driving" (not overridden)
```

### LINQ (Language Integrated Query)

**Q11: What is LINQ and provide common examples.**

```csharp
List<int> numbers = new() { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

// Where - filter
var evens = numbers.Where(n => n % 2 == 0);

// Select - transform
var squares = numbers.Select(n => n * n);

// FirstOrDefault - get first or default
var first = numbers.FirstOrDefault(n => n > 5) ?? -1;

// Any - check if any matches
bool hasEven = numbers.Any(n => n % 2 == 0);

// All - check if all match
bool allPositive = numbers.All(n => n > 0);

// Count - count matching
int evenCount = numbers.Count(n => n % 2 == 0);

// Sum, Average, Min, Max
int sum = numbers.Sum();
double avg = numbers.Average();
int min = numbers.Min();
int max = numbers.Max();

// OrderBy, OrderByDescending
var sorted = numbers.OrderBy(n => n).ThenByDescending(n => n % 2);

// GroupBy - group elements
var grouped = numbers.GroupBy(n => n % 2);  // Group by even/odd

// Join - combine collections
List<Person> people = new() { new() { Id = 1, Name = "John" } };
List<Order> orders = new() { new() { PersonId = 1, Amount = 100 } };

var joined = people.Join(orders, p => p.Id, o => o.PersonId, 
    (p, o) => new { Person = p.Name, Order = o.Amount });

// Distinct - remove duplicates
var unique = numbers.Distinct();

// Skip, Take - pagination
var page2 = numbers.Skip(5).Take(3);
```

**Q12: What's the difference between LINQ to Objects, LINQ to SQL, and LINQ to Entities?**

```csharp
// LINQ to Objects - in-memory collections
var numbers = new[] { 1, 2, 3, 4, 5 };
var result = numbers.Where(n => n > 2).ToList();  // Executed in-memory

// LINQ to Entities - database queries (Entity Framework)
using var context = new ApplicationDbContext();
var users = context.Users
    .Where(u => u.Age > 18)
    .ToList();  // Translated to SQL

// LINQ to SQL (legacy, but same concept)
var categories = new DataContext().Categories
    .Where(c => c.ProductCount > 5)
    .ToList();

// Deferred execution - query not executed until enumeration
IQueryable<User> query = context.Users.Where(u => u.IsActive);
// No database call yet

List<User> activeUsers = query.ToList();  // Now database is queried

// Query vs method syntax
// Query syntax
var result1 = from n in numbers
              where n > 2
              select n * 2;

// Method syntax (same result)
var result2 = numbers.Where(n => n > 2).Select(n => n * 2);
```

### Async/Await

**Q13: Explain async/await and when to use it.**

```csharp
// Asynchronous method - returns Task
public async Task<string> FetchDataAsync()
{
    // Await pauses execution until task completes
    var data = await GetDataFromApiAsync();
    return data;
}

// Method returning value
public async Task<int> CalculateAsync()
{
    int result = await LongOperationAsync();
    return result;
}

public async Task<string> GetDataFromApiAsync()
{
    using var httpClient = new HttpClient();
    var response = await httpClient.GetAsync("https://api.example.com/data");
    return await response.Content.ReadAsStringAsync();
}

// Calling async methods
public async Task Main()
{
    // Must await async method
    var data = await FetchDataAsync();
    
    // Or use .Result (blocks - avoid in UI)
    // var data = FetchDataAsync().Result;  // Not recommended
}

// Multiple async operations
public async Task<(string, string)> FetchMultipleAsync()
{
    // Sequential (one after another)
    var data1 = await FetchData1Async();
    var data2 = await FetchData2Async();
    
    return (data1, data2);
}

public async Task<(string, string)> FetchMultipleParallelAsync()
{
    // Parallel execution
    var task1 = FetchData1Async();
    var task2 = FetchData2Async();
    
    var results = await Task.WhenAll(task1, task2);
    return (results[0], results[1]);
}

// Task.WhenAny - wait for first to complete
var firstCompleted = await Task.WhenAny(task1, task2);
```

---

## 🔴 **Senior/Advanced Level**

### Entity Framework Core

**Q14: What is Entity Framework Core and how do you use it?**

```csharp
// DbContext - represents database session
public class ApplicationDbContext : DbContext
{
    public DbSet<User> Users { get; set; }
    public DbSet<Post> Posts { get; set; }
    
    protected override void OnConfiguring(DbContextOptionsBuilder options)
    {
        options.UseSqlServer("Server=.;Database=MyDb;Trusted_Connection=true");
    }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Configure relationships, constraints, etc.
        modelBuilder.Entity<User>()
            .HasMany(u => u.Posts)
            .WithOne(p => p.User)
            .HasForeignKey(p => p.UserId);
        
        modelBuilder.Entity<User>()
            .HasIndex(u => u.Email)
            .IsUnique();
    }
}

// Models
public class User
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
    
    // Navigation property
    public ICollection<Post> Posts { get; } = new List<Post>();
}

public class Post
{
    public int Id { get; set; }
    public string Title { get; set; }
    public int UserId { get; set; }
    
    public User User { get; set; }
}

// Usage
using var context = new ApplicationDbContext();

// Create
var user = new User { Name = "John", Email = "john@example.com" };
context.Users.Add(user);
await context.SaveChangesAsync();

// Read
var allUsers = await context.Users.ToListAsync();
var user = await context.Users.FirstOrDefaultAsync(u => u.Email == "john@example.com");

// Update
user.Name = "Jane";
await context.SaveChangesAsync();

// Delete
context.Users.Remove(user);
await context.SaveChangesAsync();

// Include related data
var usersWithPosts = await context.Users
    .Include(u => u.Posts)
    .ToListAsync();
```

**Q15: What are migrations in Entity Framework Core?**

```csharp
// After changing model, create migration
// Command: dotnet ef migrations add InitialCreate

// Migration file
public partial class InitialCreate : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "Users",
            columns: table => new
            {
                Id = table.Column<int>(nullable: false)
                    .Annotation("SqlServer:Identity", "1, 1"),
                Name = table.Column<string>(nullable: true),
                Email = table.Column<string>(nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Users", x => x.Id);
                table.UniqueConstraint("UQ_Users_Email", x => x.Email);
            });
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(name: "Users");
    }
}

// Apply migration
// Command: dotnet ef database update

// Rollback migration
// Command: dotnet ef database update PreviousMigrationName
```

### Dependency Injection

**Q16: Explain Dependency Injection and how to implement it.**

```csharp
// Without DI (tightly coupled)
public class UserService
{
    private readonly SqlDatabase _database = new SqlDatabase();  // Hard dependency
    
    public User GetUser(int id)
    {
        return _database.GetUser(id);
    }
}

// With DI (loosely coupled)
public interface IDatabase
{
    User GetUser(int id);
}

public class UserService
{
    private readonly IDatabase _database;  // Injected dependency
    
    public UserService(IDatabase database)  // Constructor injection
    {
        _database = database;
    }
    
    public User GetUser(int id)
    {
        return _database.GetUser(id);
    }
}

// Property injection
public class MyService
{
    public ILogger Logger { get; set; }  // Injected
}

// Method injection
public void ProcessUser(User user, ILogger logger)
{
    logger.Log("Processing user");
}

// Configuration in Program.cs (.NET 6+)
var builder = WebApplication.CreateBuilder(args);

// Register services
builder.Services.AddScoped<IDatabase, SqlDatabase>();  // Create new per request
builder.Services.AddSingleton<ICache, MemoryCache>();  // Single instance forever
builder.Services.AddTransient<ILogger, ConsoleLogger>();  // Create new each time

var app = builder.Build();

// Inject in controller
[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private readonly IUserService _userService;
    
    public UserController(IUserService userService)
    {
        _userService = userService;  // Injected by DI container
    }
    
    [HttpGet("{id}")]
    public async Task<ActionResult<User>> GetUser(int id)
    {
        var user = await _userService.GetUserAsync(id);
        return Ok(user);
    }
}
```

**Q17: What are the lifetimes of services in DI?**

```csharp
// Transient - new instance every time
services.AddTransient<IService, Service>();
// Use when: stateless services, each request needs fresh instance

// Scoped - new instance per scope (typically per HTTP request)
services.AddScoped<IService, Service>();
// Use when: DbContext, UnitOfWork, per-request state

// Singleton - single instance for entire application lifetime
services.AddSingleton<IService, Service>();
// Use when: stateless utilities, thread-safe caching, configuration

// For API controllers (scoped by default)
[ApiController]
public class MyController : ControllerBase
{
    private readonly ITransientService _transient;
    private readonly IScopedService _scoped;
    private readonly ISingletonService _singleton;
    
    public MyController(ITransientService transient, 
                       IScopedService scoped, 
                       ISingletonService singleton)
    {
        _transient = transient;
        _scoped = scoped;
        _singleton = singleton;
    }
}
```

### Web API Development

**Q18: Build a simple REST API in ASP.NET Core.**

```csharp
// Program.cs (.NET 6+)
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddDbContext<ApplicationDbContext>();
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(builder =>
    {
        builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
    });
});

var app = builder.Build();

app.UseHttpsRedirection();
app.UseCors();
app.UseAuthorization();
app.MapControllers();

app.Run();

// Controller
[ApiController]
[Route("api/[controller]")]
public class UsersController : ControllerBase
{
    private readonly IUserService _userService;
    
    public UsersController(IUserService userService)
    {
        _userService = userService;
    }
    
    [HttpGet]
    public async Task<ActionResult<IEnumerable<UserDto>>> GetUsers()
    {
        var users = await _userService.GetAllUsersAsync();
        return Ok(users);
    }
    
    [HttpGet("{id}")]
    public async Task<ActionResult<UserDto>> GetUser(int id)
    {
        var user = await _userService.GetUserAsync(id);
        if (user == null)
            return NotFound();
        return Ok(user);
    }
    
    [HttpPost]
    public async Task<ActionResult<UserDto>> CreateUser(CreateUserRequest request)
    {
        var user = await _userService.CreateUserAsync(request);
        return CreatedAtAction(nameof(GetUser), new { id = user.Id }, user);
    }
    
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateUser(int id, UpdateUserRequest request)
    {
        var result = await _userService.UpdateUserAsync(id, request);
        if (!result)
            return NotFound();
        return NoContent();
    }
    
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteUser(int id)
    {
        var result = await _userService.DeleteUserAsync(id);
        if (!result)
            return NotFound();
        return NoContent();
    }
}

// Service
public interface IUserService
{
    Task<IEnumerable<UserDto>> GetAllUsersAsync();
    Task<UserDto> GetUserAsync(int id);
    Task<UserDto> CreateUserAsync(CreateUserRequest request);
    Task<bool> UpdateUserAsync(int id, UpdateUserRequest request);
    Task<bool> DeleteUserAsync(int id);
}

public class UserService : IUserService
{
    private readonly ApplicationDbContext _context;
    
    public UserService(ApplicationDbContext context)
    {
        _context = context;
    }
    
    public async Task<IEnumerable<UserDto>> GetAllUsersAsync()
    {
        return await _context.Users
            .Select(u => new UserDto { Id = u.Id, Name = u.Name, Email = u.Email })
            .ToListAsync();
    }
    
    // ... other methods
}
```

**Q19: How do you handle authentication and authorization in ASP.NET Core?**

```csharp
// Configure authentication in Program.cs
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = "your-issuer",
            ValidAudience = "your-audience",
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes("your-secret-key"))
        };
    });

builder.Services.AddAuthorization();

var app = builder.Build();
app.UseAuthentication();
app.UseAuthorization();

// Generate JWT token
public class AuthController : ControllerBase
{
    private readonly IConfiguration _config;
    
    [HttpPost("login")]
    public IActionResult Login(LoginRequest request)
    {
        // Validate credentials
        var user = ValidateUser(request.Username, request.Password);
        if (user == null)
            return Unauthorized();
        
        var token = GenerateJwtToken(user);
        return Ok(new { token });
    }
    
    private string GenerateJwtToken(User user)
    {
        var securityKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(_config["Jwt:SecretKey"]));
        var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);
        
        var claims = new[]
        {
            new Claim(ClaimTypes.Sub, user.Id.ToString()),
            new Claim(ClaimTypes.Name, user.Username),
            new Claim(ClaimTypes.Email, user.Email)
        };
        
        var token = new JwtSecurityToken(
            issuer: _config["Jwt:Issuer"],
            audience: _config["Jwt:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddHours(24),
            signingCredentials: credentials);
        
        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}

// Authorize controller/action
[ApiController]
[Authorize]
public class ProtectedController : ControllerBase
{
    [HttpGet]
    [Authorize(Roles = "Admin")]  // Role-based authorization
    public IActionResult AdminOnly()
    {
        return Ok("Admin access granted");
    }
    
    [HttpGet]
    [Authorize(Policy = "MustBeVerified")]  // Policy-based
    public IActionResult VerifiedOnly()
    {
        return Ok("Verified user access");
    }
}
```

### Performance & Memory

**Q20: How do you optimize .NET application performance?**

```csharp
// 1. Use async/await to free up threads
public async Task<List<User>> GetUsersAsync()
{
    return await _context.Users.ToListAsync();  // Frees thread while waiting
}

// 2. Implement connection pooling
builder.Services.AddDbContext<AppContext>(options =>
    options.UseSqlServer(connectionString));

// 3. Use caching
public class UserService
{
    private readonly IMemoryCache _cache;
    
    public async Task<User> GetUserAsync(int id)
    {
        if (_cache.TryGetValue($"user_{id}", out User user))
            return user;
        
        user = await _context.Users.FindAsync(id);
        _cache.Set($"user_{id}", user, TimeSpan.FromMinutes(5));
        return user;
    }
}

// 4. Use select projection (get only needed fields)
// ❌ Bad: Gets all fields
var users = await _context.Users.ToListAsync();

// ✅ Good: Gets only needed fields
var users = await _context.Users
    .Select(u => new { u.Id, u.Name })
    .ToListAsync();

// 5. Use pagination for large datasets
public async Task<List<User>> GetUsersAsync(int page, int pageSize)
{
    return await _context.Users
        .Skip((page - 1) * pageSize)
        .Take(pageSize)
        .ToListAsync();
}

// 6. Use proper indexing
builder.Entity<User>()
    .HasIndex(u => u.Email)
    .IsUnique();

// 7. Use NoTracking for read-only queries
var users = await _context.Users
    .AsNoTracking()  // Doesn't track for changes
    .ToListAsync();

// 8. Batch operations
var users = new List<User> { ... };
_context.Users.AddRange(users);  // Batch insert
await _context.SaveChangesAsync();
```

---

## 🎯 **Tricky Questions**

**Q21: What's the difference between var, dynamic, and object?**

```csharp
// var - compile-time type inference, type-safe
var name = "John";  // var is string, determined at compile time
// name = 123;  // Error at compile time

// dynamic - runtime type checking, not type-safe
dynamic value = "John";
value = 123;  // OK at compile time, runtime decides
value.NonExistentMethod();  // OK at compile time, error at runtime

// object - base type, must be cast back
object obj = "John";
object obj2 = 123;
// string name = obj;  // Error: must cast
string name = (string)obj;  // Must cast explicitly

// Performance
var x = 10;  // No boxing
dynamic d = 10;  // Reflection overhead
object o = 10;  // Boxing
```

**Q22: Explain reference vs value type parameter passing.**

```csharp
public class Program
{
    public static void Main()
    {
        // Value type parameter (by value)
        int a = 10;
        ModifyByValue(a);
        Console.WriteLine(a);  // 10 (unchanged)
        
        // Reference type parameter (by reference)
        var person = new Person { Name = "John" };
        ModifyByReference(person);
        Console.WriteLine(person.Name);  // "Jane" (changed)
        
        // Using ref keyword (pass by reference)
        int b = 10;
        ModifyByRef(ref b);
        Console.WriteLine(b);  // 20 (changed)
        
        // Using out keyword (output parameter)
        if (TryGetValue(out int result))
        {
            Console.WriteLine(result);
        }
    }
    
    private static void ModifyByValue(int num)
    {
        num = 20;  // Only modifies copy
    }
    
    private static void ModifyByReference(Person person)
    {
        person.Name = "Jane";  // Modifies referenced object
    }
    
    private static void ModifyByRef(ref int num)
    {
        num = 20;  // Modifies original variable
    }
    
    private static bool TryGetValue(out int value)
    {
        value = 42;
        return true;
    }
}

public class Person
{
    public string Name { get; set; }
}
```

**Q23: What's the difference between Stack and Heap?**

```csharp
// Stack - Last In First Out (LIFO), stores value types
int a = 10;
int b = a;  // Copy value
b = 20;  // Doesn't affect a
// Stack automatically freed when scope ends

// Heap - stores reference types
var person1 = new Person { Name = "John" };
var person2 = person1;  // Copy reference
person2.Name = "Jane";  // Affects both
// Heap freed by garbage collector

// Stack allocation efficiency
for (int i = 0; i < 1000; i++)
{
    int value = i;  // ✓ Stack allocation - fast, auto-freed
}

// Heap allocation overhead
for (int i = 0; i < 1000; i++)
{
    var obj = new object();  // ✗ Heap allocation - slower, GC cleanup needed
}

// Stack overflow
public void RecursiveMethod(int depth)
{
    byte[] largeArray = new byte[1024 * 1024];  // 1MB on stack
    RecursiveMethod(depth + 1);  // Stack overflow if too deep
}
```

**Q24: What's the difference between string and StringBuilder?**

```csharp
// String - immutable, creates new object each concatenation
public string BadConcatenation()
{
    string result = "";
    for (int i = 0; i < 1000; i++)
    {
        result += i;  // ✗ Creates new string object 1000 times
    }
    return result;  // Very inefficient
}

// StringBuilder - mutable, single buffer
public string GoodConcatenation()
{
    var sb = new StringBuilder();
    for (int i = 0; i < 1000; i++)
    {
        sb.Append(i);  // ✓ Appends to same buffer
    }
    return sb.ToString();  // One string created
}

// Performance comparison:
// String: O(n²) - quadratic time
// StringBuilder: O(n) - linear time

// When to use:
// String: Small fixed concatenations, single operation
// StringBuilder: Many concatenations in loop
```

**Q25: Explain garbage collection in .NET.**

```csharp
// Garbage Collection is automatic
public class DisposableResource : IDisposable
{
    private IntPtr unmanagedResource;
    
    public DisposableResource()
    {
        unmanagedResource = Marshal.AllocHGlobal(1024);
    }
    
    // Finalizer - called by GC before object is collected
    ~DisposableResource()
    {
        // Cleanup unmanaged resources
        if (unmanagedResource != IntPtr.Zero)
        {
            Marshal.FreeHGlobal(unmanagedResource);
        }
    }
    
    // IDisposable - explicit cleanup
    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);  // Finalizer won't be called
    }
    
    protected virtual void Dispose(bool disposing)
    {
        if (disposing)
        {
            // Cleanup managed resources
        }
        
        // Cleanup unmanaged resources
        if (unmanagedResource != IntPtr.Zero)
        {
            Marshal.FreeHGlobal(unmanagedResource);
            unmanagedResource = IntPtr.Zero;
        }
    }
}

// Usage - using statement ensures Dispose is called
using (var resource = new DisposableResource())
{
    // Use resource
}  // Dispose called automatically

// Or using declaration (C# 8+)
using DisposableResource resource = new DisposableResource();
// Dispose called at end of scope

// GC Generations
// Gen 0: Recently created objects
// Gen 1: Survived one collection
// Gen 2: Long-lived objects
// Collections happen when generation fills up
```

---

## 📚 **Advanced Patterns**

**Q26: Explain dependency injection with factory pattern.**

```csharp
// Factory pattern with DI
public interface IServiceFactory
{
    T CreateService<T>() where T : class;
}

public class ServiceFactory : IServiceFactory
{
    private readonly IServiceProvider _serviceProvider;
    
    public ServiceFactory(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }
    
    public T CreateService<T>() where T : class
    {
        return _serviceProvider.GetService(typeof(T)) as T;
    }
}

// Configuration
services.AddSingleton<IServiceFactory, ServiceFactory>();
```

**Q27: What is middleware and how does it work?**

```csharp
// Custom middleware
public class RequestLoggingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<RequestLoggingMiddleware> _logger;
    
    public RequestLoggingMiddleware(RequestDelegate next, 
                                    ILogger<RequestLoggingMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }
    
    public async Task InvokeAsync(HttpContext context)
    {
        _logger.LogInformation($"Request: {context.Request.Method} {context.Request.Path}");
        
        await _next(context);  // Call next middleware
        
        _logger.LogInformation($"Response: {context.Response.StatusCode}");
    }
}

// Register middleware in Program.cs
app.UseMiddleware<RequestLoggingMiddleware>();

// Middleware pipeline is linear:
// Request → Middleware1 → Middleware2 → Middleware3 → Handler
// Response ← Middleware1 ← Middleware2 ← Middleware3 ← Handler
```

---

## ✅ **Interview Checklist**

- [ ] Understand C# fundamentals (types, OOP, properties)
- [ ] Know LINQ well (query syntax, methods, uses)
- [ ] Understand async/await patterns
- [ ] Know Entity Framework Core basics and migrations
- [ ] Understand dependency injection and lifetimes
- [ ] Know how to build REST APIs
- [ ] Understand authentication and authorization
- [ ] Know performance optimization techniques
- [ ] Understand middleware and request pipeline
- [ ] Know memory management (stack, heap, GC)
- [ ] Have experience with abstract classes vs interfaces
- [ ] Know design patterns (factory, singleton, repository)
- [ ] Have built complete projects
- [ ] Know common libraries (Dapper, AutoMapper, etc.)
- [ ] Understand error handling and logging

---

## 🎯 **Pro Tips for .NET Interviews**

1. **Show your experience** - Talk about real projects
2. **Discuss trade-offs** - Different solutions have pros/cons
3. **Know async/await** - Critical for modern .NET
4. **Understand LINQ** - Asked frequently
5. **Know EF Core** - Most common ORM
6. **Discuss architecture** - Clean code, SOLID principles
7. **Performance matters** - Be aware of performance implications
8. **Ask clarifying questions** - ".NET Framework or .NET Core?"
9. **Be honest** - Admit knowledge gaps
10. **Stay current** - Know latest .NET versions

---

**Good luck with your .NET interviews!** 🚀

Remember: Deep understanding beats memorization. Build projects, solve problems, and practice coding.
