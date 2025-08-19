abstract class BaseMapper<I, O> {
  O from(I input);
  I to(O output);
}