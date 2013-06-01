
type IORBPos{T}
    buffer::IORBBuffer{T}
    ptr::Integer
end

type IORBReaderWriter{T} <: IO
    ptr::IORBPos{T}
    mark::IORBPos{T}
    marklen::Integer
    marked_elems::Integer
    readable::Bool
    writeable::Bool
    seekable::Bool
end

type IORBBuffer{T}
    ord::Integer
    datasize::Integer
    pinned::Bool
    readercount::Integer
    writercount::Integer
    markcount::Integer
    buffer::AbstractArray{T}
end

IORBBuffer{T}(size::Integer) = IORBBuffer{T}(0, 0, 0, 0, 0, False, Array(T, size))
IORBBuffer(size::Integer) = IORBBuffer{Uint8}(size)

type IORingBuffer{T}
    buffers::Vector{IORBBuffer{T}}
    readers::Vector{IORBReader}
    writers::Vector{IORBWriter}
    first::IORBBuffer{T}
    last::IORBBuffer{T}
end

function IORingBuffer{T}(bufsize::Integer=65536, count::Integer=16)
    buffers = Vector(IORBBuffer{T}, count)
    for i in 1:count
        buffer[i] = IORBBuffer{T}(bufsize)
    end
    IORingBuffer{T}(buffers, IORBReader[], IORBWriter[], buffers[1], buffers[1])
end

function open{T}(rb::IORingBuffer{T}, mode="r")
    if mode == "r":
        return IORBReaderWriter{T}(IORBPos(rb.first, 0), IORBPos(rb.first, 0), 0, 0, true, false, true)
end