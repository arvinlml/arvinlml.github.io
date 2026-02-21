# React Interview Questions

Comprehensive React interview preparation covering all difficulty levels with practical code examples.

---

## 🟢 **Junior/Beginner Level**

### React Fundamentals

**Q1: What is React?**

React is a JavaScript library for building user interfaces using components. It uses a virtual DOM for efficient updates and follows a declarative programming paradigm.

**Q2: What's the difference between a component and an element?**

```jsx
// Element - plain object describing what to render
const element = <MyComponent prop="value" />;

// Component - function or class that returns/renders elements
function MyComponent(props) {
  return <div>{props.prop}</div>;
}
```

**Q3: What are props? Can you modify them?**

Props are read-only data passed from parent to child. They cannot be modified (immutable) - they're one-way data flow.

```jsx
// Props cannot be changed here
function ChildComponent({ name, age }) {
  // ❌ age = 30;  // Throws error in strict mode
  return <div>{name}, {age}</div>;
}
```

**Q4: What is state? How is it different from props?**

| State | Props |
|-------|-------|
| Mutable | Immutable |
| Internal to component | Passed from parent |
| Updated via setState | Read-only |
| Causes re-render on change | Triggers re-render if changed |

```jsx
function Counter() {
  const [count, setCount] = useState(0);  // State
  
  return <Child count={count} />;  // Props
}
```

**Q5: What are controlled and uncontrolled components?**

```jsx
// Controlled - React controls input value
function ControlledInput() {
  const [input, setInput] = useState('');
  return (
    <input 
      value={input}
      onChange={(e) => setInput(e.target.value)}
    />
  );
}

// Uncontrolled - DOM controls input value
function UncontrolledInput() {
  const inputRef = useRef(null);
  const handleSubmit = () => {
    console.log(inputRef.current.value);  // Get value from DOM
  };
  return (
    <>
      <input ref={inputRef} />
      <button onClick={handleSubmit}>Submit</button>
    </>
  );
}
```

---

## 🟡 **Mid-Level**

### Hooks

**Q6: Explain the useEffect hook. When does it run?**

```jsx
function Component() {
  // Runs after every render
  useEffect(() => {
    console.log('After render');
  });

  // Runs only on mount and unmount
  useEffect(() => {
    console.log('Mounted');
    return () => console.log('Unmounted');
  }, []);

  // Runs when dependencies change
  useEffect(() => {
    console.log('dependency changed');
  }, [dependency]);
}
```

**Q7: What are dependencies in useEffect? Why are they important?**

Dependencies determine when the effect runs. Missing dependencies can cause bugs:

```jsx
// ❌ Infinite loop - no dependencies
useEffect(() => {
  setData(fetchData());
});

// ✅ Runs once on mount
useEffect(() => {
  setData(fetchData());
}, []);

// ✅ Runs when id changes
useEffect(() => {
  setData(fetchData(id));
}, [id]);
```

**Q8: What's the difference between useCallback and useMemo?**

```jsx
// useCallback - memoizes function
const handleClick = useCallback(() => {
  doSomething(value);
}, [value]);  // Returns same function if value hasn't changed

// useMemo - memoizes value/result
const memoizedValue = useMemo(() => {
  return expensiveCalculation(value);
}, [value]);  // Only recalculates if value changes
```

**Q9: When would you use useCallback?**

When passing callback functions to optimized child components:

```jsx
function Parent({ id }) {
  // Without useCallback - new function each render - child re-renders
  const handleDelete = () => deleteItem(id);

  // With useCallback - same function if id unchanged - no re-render
  const memoizedDelete = useCallback(() => {
    deleteItem(id);
  }, [id]);

  return <OptimizedChild onDelete={memoizedDelete} />;
}

function OptimizedChild({ onDelete }) {
  // React.memo prevents re-render if props haven't changed
  return <button onClick={onDelete}>Delete</button>;
}

export default React.memo(OptimizedChild);
```

**Q10: Explain useContext. When do you need it?**

For passing data through component tree without prop drilling:

```jsx
// Create context
const ThemeContext = React.createContext();

// Provider component
function App() {
  const [theme, setTheme] = useState('light');
  
  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      <Header />
      <Content />
    </ThemeContext.Provider>
  );
}

// Consume anywhere in tree
function DeepComponent() {
  const { theme, setTheme } = useContext(ThemeContext);
  
  return (
    <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}>
      Current: {theme}
    </button>
  );
}
```

### State Management

**Q11: What are the pros and cons of useState vs useReducer?**

```jsx
// useState - simple state
const [count, setCount] = useState(0);
setCount(count + 1);

// useReducer - complex state logic
const [state, dispatch] = useReducer(reducer, initialState);

function reducer(state, action) {
  switch(action.type) {
    case 'INCREMENT':
      return { count: state.count + 1 };
    case 'DECREMENT':
      return { count: state.count - 1 };
    default:
      return state;
  }
}

dispatch({ type: 'INCREMENT' });
```

| useState | useReducer |
|----------|-----------|
| Simple state | Complex state logic |
| Direct updates | Action dispatching |
| Tight coupling | Decoupled logic |
| Good for single values | Good for multiple related values |

**Q12: Should you lift state up? When?**

Lift state when multiple components need to share it:

```jsx
// ❌ Bad - state isolated
function Parent() {
  return (
    <>
      <LeftChild />
      <RightChild />
    </>
  );
}

// ✅ Good - shared state lifted
function Parent() {
  const [sharedData, setSharedData] = useState('');
  
  return (
    <>
      <LeftChild data={sharedData} />
      <RightChild data={sharedData} onChange={setSharedData} />
    </>
  );
}
```

---

## 🔴 **Senior/Advanced Level**

### Performance

**Q13: When would you use React.memo?**

```jsx
// Without memo - re-renders whenever parent re-renders
function Greeting({ name }) {
  console.log('Greeting rendered');
  return <div>Hello {name}</div>;
}

// With memo - only re-renders if props change
export default React.memo(Greeting);

// With custom comparison
export default React.memo(Greeting, (prevProps, nextProps) => {
  return prevProps.name === nextProps.name;  // True = don't re-render
});
```

**Q14: How does React's reconciliation (diffing) algorithm work?**

React uses a virtual DOM and reconciliation:

1. Create virtual DOM representation
2. Compare (diff) with previous virtual DOM
3. Calculate minimal changes needed
4. Update real DOM efficiently

```jsx
// ❌ Bad - key causes unnecessary re-renders
{items.map((item, index) => <Item key={index} {...item} />)}

// ✅ Good - stable key prevents re-renders
{items.map(item => <Item key={item.id} {...item} />)}
```

**Q15: What are common performance issues in React?**

```jsx
// Issue 1: Inline function on every render
<Child onClick={() => doSomething()} />  // Creates new function each render

// Solution: useCallback
const handleClick = useCallback(() => doSomething(), []);
<Child onClick={handleClick} />

// Issue 2: Unnecessary re-renders
function List({ items }) {
  return items.map(item => <Item item={item} />);  // Re-renders all if any item changes
}

// Solution: React.memo on Item, stable keys
export default React.memo(Item);

// Issue 3: Large lists without virtualization
// Solution: Use react-window or react-virtualized
```

### Hooks Advanced

**Q16: What is a custom hook? Create one.**

```jsx
// Custom hook for fetching data
function useFetch(url) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    setLoading(true);
    
    fetch(url)
      .then(res => res.json())
      .then(data => {
        setData(data);
        setError(null);
      })
      .catch(err => {
        setError(err);
        setData(null);
      })
      .finally(() => setLoading(false));
  }, [url]);

  return { data, loading, error };
}

// Usage
function UserProfile() {
  const { data: user, loading, error } = useFetch(`/api/user/1`);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error!</div>;
  return <div>{user.name}</div>;
}
```

**Q17: Explain the Rules of Hooks.**

1. **Only call at top level** - not in loops, conditions, or nested functions
2. **Only in React functions** - only in components and custom hooks

```jsx
// ❌ Bad - hook in condition
function Component({ shouldFetch }) {
  if (shouldFetch) {
    useEffect(() => {
      fetch();
    }, []);  // This breaks hook order!
  }
}

// ✅ Good - hook always called
function Component({ shouldFetch }) {
  useEffect(() => {
    if (shouldFetch) {
      fetch();
    }
  }, [shouldFetch]);
}
```

### Advanced Patterns

**Q18: What is render props pattern?**

```jsx
// Render props - function as child
function DataFetcher({ render, url }) {
  const { data, loading } = useFetch(url);
  return render({ data, loading });
}

function App() {
  return (
    <DataFetcher 
      url="/api/data"
      render={({ data, loading }) => (
        loading ? <div>Loading</div> : <div>{data}</div>
      )}
    />
  );
}
```

**Q19: What is a Higher Order Component (HOC)?**

```jsx
// HOC pattern - function that returns enhanced component
function withAuth(WrappedComponent) {
  return function WithAuthComponent(props) {
    const [isAuthenticated, setIsAuthenticated] = useState(false);

    useEffect(() => {
      checkAuth().then(setIsAuthenticated);
    }, []);

    if (!isAuthenticated) {
      return <redirect to="/login" />;
    }

    return <WrappedComponent {...props} />;
  };
}

// Usage
const ProtectedPage = withAuth(Page);
```

**Q20: What's the difference between controlled and uncontrolled forms?**

```jsx
// Controlled form
function ControlledForm() {
  const [formData, setFormData] = useState({ name: '', email: '' });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    // Form data is in state
    console.log(formData);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input 
        name="name"
        value={formData.name}
        onChange={handleChange}
      />
      <input 
        name="email"
        value={formData.email}
        onChange={handleChange}
      />
      <button>Submit</button>
    </form>
  );
}

// Uncontrolled form
function UncontrolledForm() {
  const formRef = useRef(null);

  const handleSubmit = (e) => {
    e.preventDefault();
    // Get data from DOM
    const formData = new FormData(formRef.current);
    console.log(Object.fromEntries(formData));
  };

  return (
    <form ref={formRef} onSubmit={handleSubmit}>
      <input name="name" />
      <input name="email" />
      <button>Submit</button>
    </form>
  );
}
```

---

## 🎯 **Tricky Questions**

**Q21: Why do you need keys in lists?**

```jsx
// Without keys - React assumes order
const items = ['Apple', 'Banana', 'Cherry'];

items.map((item, index) => (
  <input key={index} defaultValue={item} />
));

// If you insert item at beginning, indices change and state gets mixed up!
// Insert 'Mango' → ['Mango', 'Apple', 'Banana', 'Cherry']
// The input for 'Apple' now has index 1 (was 0) - wrong value persists!

// With stable keys - React tracks by identity
items.map(item => (
  <input key={item} defaultValue={item} />
));
// Now React knows 'Apple' is still 'Apple' regardless of position
```

**Q22: What is strict mode and why use it?**

```jsx
// Strict mode catches issues in development
function App() {
  return (
    <React.StrictMode>
      <Component />
    </React.StrictMode>
  );
}

// Strict mode will:
// - Double-invoke render functions (catch impure renders)
// - Double-invoke effect functions (catch cleanup issues)
// - Warn about deprecated APIs
// - Warn about missing keys
```

**Q23: How does event delegation work in React?**

```jsx
// React automatically delegates events to root
// Event listeners attached at top level, not each element

function List({ items, onItemClick }) {
  const handleClick = (e) => {
    if (e.target.closest('[data-id]')) {
      const id = e.target.closest('[data-id]').dataset.id;
      onItemClick(id);
    }
  };

  return (
    <ul onClick={handleClick}>
      {items.map(item => (
        <li key={item.id} data-id={item.id}>
          {item.name}
        </li>
      ))}
    </ul>
  );
}
```

**Q24: What happens if you don't return anything from useEffect?**

```jsx
// Effect without cleanup
useEffect(() => {
  console.log('mounted');
  // Missing return = no cleanup
});

// Effect with cleanup (better)
useEffect(() => {
  const unsubscribe = subscribe();
  
  return () => {
    unsubscribe();  // Cleanup on unmount
  };
}, []);

// If you don't clean up:
// - Event listeners remain
// - Subscriptions continue
// - Memory leaks possible
// - Multiple events trigger
```

**Q25: What is the "stale closure" problem?**

```jsx
// Stale closure issue
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      console.log(count);  // Always logs 0 (captured at mount)
    }, 1000);

    return () => clearInterval(interval);
  }, []);  // Missing dependency!
}

// Solution 1: Add dependency
useEffect(() => {
  const interval = setInterval(() => {
    console.log(count);  // Logs correct value
  }, 1000);

  return () => clearInterval(interval);
}, [count]);  // Added dependency

// Solution 2: Use functional update
useEffect(() => {
  const interval = setInterval(() => {
    setCount(c => c + 1);  // Always gets latest count
  }, 1000);

  return () => clearInterval(interval);
}, []);
```

---

## 📚 **Advanced Topics**

**Q26: What is Context API and when should you use Redux instead?**

```jsx
// Context API - good for simple state
// Redux - for complex state with many actions

// Use Context when:
// - Simple theme/language settings
// - User authentication
// - Moderate state complexity

// Use Redux when:
// - Complex state with many interactions
// - Need time-travel debugging
// - Large application with many components
// - Need middleware (logging, analytics)
```

**Q27: Explain lazy loading and code splitting.**

```jsx
// Lazy loading with React.lazy
const HeavyComponent = React.lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <HeavyComponent />
    </Suspense>
  );
}

// Route-based code splitting
const Home = React.lazy(() => import('./pages/Home'));
const About = React.lazy(() => import('./pages/About'));

function Router() {
  return (
    <Suspense fallback={<div>Loading page...</div>}>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
      </Routes>
    </Suspense>
  );
}
```

**Q28: What is the difference between shallow and deep comparison?**

```jsx
// Shallow comparison - only compares immediate properties
const obj1 = { a: 1, b: { c: 2 } };
const obj2 = { a: 1, b: { c: 2 } };

console.log(obj1 === obj2);  // false (different reference)
console.log(obj1.b === obj2.b);  // false (different reference)

// React.memo does shallow comparison
// For deep objects, use custom comparison

export default React.memo(Component, (prevProps, nextProps) => {
  return JSON.stringify(prevProps) === JSON.stringify(nextProps);
});
```

**Q29: How do you handle errors in React components?**

```jsx
// Error Boundary (class component only)
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    console.log('Error caught:', error);
  }

  render() {
    if (this.state.hasError) {
      return <div>Error: {this.state.error.message}</div>;
    }
    return this.props.children;
  }
}

// Usage
<ErrorBoundary>
  <ProblematicComponent />
</ErrorBoundary>
```

**Q30: What are synthetic events in React?**

```jsx
// React wraps browser events in synthetic events
function handleClick(e) {
  // e is a SyntheticEvent (wrapper around native event)
  console.log(e.type);  // 'click'
  console.log(e.nativeEvent);  // Access native event if needed
  
  // Event pooling was removed in React 17
  // No need to call e.persist()
}

// Keyboard event
function handleKeyDown(e) {
  if (e.key === 'Enter') {
    // Handle enter key
  }
}

// Form event
function handleChange(e) {
  const { name, value, type, checked } = e.target;
  // e.target same as native event
}
```

---

## ✅ **Interview Tips**

### Common Follow-ups to Prepare For
- "How would you optimize this?"
- "Where would you use this pattern?"
- "What are the trade-offs?"
- "How does this work under the hood?"
- "What happens if...?"

### Answering Strategy

1. **Show your thinking** - Explain your thought process
2. **Ask clarifying questions** - "Do you mean in class components or hooks?"
3. **Provide code examples** - Demonstrate with good/bad patterns
4. **Mention performance** - How does it affect app?
5. **Discuss trade-offs** - No perfect solution

### React Interview Checklist

- [ ] Know hooks better than class components
- [ ] Understand component lifecycle
- [ ] Know reconciliation algorithm basics
- [ ] Understand refs and when to use them
- [ ] Know context API and prop drilling
- [ ] Understand performance patterns
- [ ] Know common libraries (React Router, etc.)
- [ ] Have project examples ready
- [ ] Know TypeScript basics with React
- [ ] Understand lazy loading and code splitting
- [ ] Know testing libraries (Jest, React Testing Library)
- [ ] Understand error boundaries
- [ ] Know about fragments, portals
- [ ] Understand controlled vs uncontrolled
- [ ] Know common hooks well

### What Interviewers Look For

✅ Problem-solving approach
✅ Code quality and best practices
✅ Understanding of React fundamentals
✅ Real-world experience
✅ Ability to communicate
✅ Willingness to learn
✅ Passion for React

❌ Memorization without understanding
❌ Overly complex solutions
❌ Not asking clarifying questions
❌ Not admitting knowledge gaps
❌ Poor code organization

---

## 📖 **Resources**

- [React Official Docs](https://react.dev)
- [React Hooks Reference](https://react.dev/reference/react)
- [Common Pitfalls](https://react.dev/reference/rules)
- [Advanced Patterns](https://react.dev/learn/thinking-in-react)

---

**Good luck with your React interviews!** 🚀

Remember: Practice coding, build projects, and understand the "why" behind concepts, not just the "how".
