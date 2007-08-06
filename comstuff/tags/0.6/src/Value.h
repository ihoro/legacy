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

	void set(T value) { Value::value = value; /* TODO: bounds check */ }
	void reset() { value = begin; }

	// returns current value
	T operator()() { return value; }

	// returns current value with some offset (inc/dec)
	T operator()(T offset)
	{
		T res = value + offset;
		res =
			offset > 0
			?
				( begin < end ? res > end : res < end )
				?
					res - end + begin - diff
				:
					res
			:
				( begin < end ? res < begin : res > begin )
				?
					res - begin + end + diff
				:
					res;
		if (res < begin)
			res = end;
		if (res > end)
			res = begin;

		return res;
	}

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
		if ( begin < end ? value >= end+diff : value <= end+diff )	// +diff for float-values
				value = begin;
	}
};
