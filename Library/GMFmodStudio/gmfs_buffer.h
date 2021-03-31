#pragma once
#include <cstdint>
#include <map>
#include <iostream>

extern unsigned int strcounter;
extern std::map<int, std::string>storedstrs;

// Helper object that interfaces with a GMS2-generated buffer.
class Buffer
{
public:
    Buffer() = delete;
    explicit Buffer(char *buf): pos(buf), start(buf)
    {

    }

    // Read data from the buffer, moves the buffer head sizeof T bytes.
    template<typename T>
    T read()
    {
        T ret = *(T *)pos;
        pos += sizeof(T);
        return ret;
    }

    // Read string from the buffer, moves the buffer head past string
    char *read_string()
    {
        char *ret = pos;
        while (*pos++ != '\0');

        return ret;
    }

    // Reset seek to starting point of the buffer
    void goto_start()
    {
        pos = start;
    }

    // Write an item into the buffer
    template<typename T>
    void write(T item)
    {
        *(T *)pos = item;
        pos += sizeof(T);
    }

    // Write a pointer to the c-string into the buffer (GM uses helper function 
    // GMFMS_InterpretString(double ptr) to get this string)
    void write_char_star(const char *str)
    {
        *(uint64_t *)pos = (uint64_t)strcounter;
        pos += sizeof(uint64_t);

        storedstrs[strcounter] = std::move(std::string(str));
        ++strcounter;
    }

    // Write the entire string into the buffer.
    void write_string(const char *str)
    {
        while (*str != '\0')
        {
            *pos++ = *str++;
        }
        *pos++ = '\0'; // append null terminator to end
    }

private:
    char *pos;
    char *start;
};
