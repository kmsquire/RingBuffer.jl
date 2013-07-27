
type IOBuffer
    bufnum::Int
    data::Vector{Uint8}
    datasize::Integer
end

IOBuffer(num::Int, bufsize::Int) = IOBuffer(num, Array(Uint8, bufsize), bufsize)

type IORingBuffer
    buffers::Vector{IOBuffer}
    read_buffer::Int
    read_ptr::Int
    write_buffer::Int
    write_ptr::Int
end

function IORingBuffer(bufsize::Int=65536, count::Int=16)
    buffers = Vector(IOBuffer, count)
    for i in 1:count
        buffer[i] = IOBuffer(i, bufsize)
    end
    IORingBuffer(buffers, 1, 1, 1, 1)
end

function open{T}(rb::IORingBuffer{T}, mode="r")
    readable = contains(mode, 'r') || contains(mode, 'a')
    writeable = contains(mode, 'w') || contains(mode, 'a')
    return IORBReaderWriter{T}(IORBPos(rb.first, 0), IORBPos(rb.first, 0), 0, 0, readable, writeable, true)
end
