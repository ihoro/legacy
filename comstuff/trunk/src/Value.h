// $Id$


#pragma once


template <typename T>
class Value
{
public:

	Value(T begin, T end, T diff)
	:
		value(begin),
		begin(begin),
		end(end),
		diff(diff)
	{}

	void reset() { value = begin; }

	// returns current value
	T operator()() { return value; }

	// incrementation
	T operator++() { inc(); return value; }
	T operator++(int) { T old = value; inc(); return old; }

private:

	T value;
	T begin;
	T end;
	T diff;

	void inc()
	{
		value += diff;
		if ( begin < end ? value > end : value < end )
				value = begin;
	}
};
