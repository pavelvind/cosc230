#include <iostream>
extern "C"
{
    int sum_array(const int values[], int num_values);
}

int main()
{
    int values[] = {1, 2, 3, 4, 5}; // Example array
    int num_values = 5;             // Number of elements in the array

    // Call the assembly function
    int result = sum_array(values, num_values);

    // Print the result
    std::cout << "Sum: " << result << std::endl;
    return 0;
}