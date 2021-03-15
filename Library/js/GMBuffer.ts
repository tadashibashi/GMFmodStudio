const charStars = new Map<number, string>();
let charStarCounter = 0;

function gmfms_interpret_string(charPtr: number)
{
    return charStars.get(charPtr);
}


class GMBuffer
{
    private view: DataView;
    private pos: number;
    private endianness: boolean = true; // 1=little, 0=big
    constructor(buf: ArrayBuffer)
    {
        this.view = new DataView(buf);
        this.pos = 0;
    }

    public readInt8(): number
    {
        return this.view.getInt8(this.pos++);
    }

    public readInt16(): number
    {
        var val = this.view.getInt16(this.pos, this.endianness);
        this.pos += 2;
        return val;
    }

    public readInt32(): number
    {
        var val = this.view.getInt32(this.pos, this.endianness);
        this.pos += 4;
        return val;
    }

    public readInt64(): bigint
    {
        var val = this.view.getBigInt64(this.pos, this.endianness);
        this.pos += 8;
        return val;
    }

    public readFloat32(): number
    {
        var val = this.view.getFloat32(this.pos, this.endianness);
        this.pos += 4;
        return val;
    }

    public readFloat64(): number
    {
        var val = this.view.getFloat64(this.pos, this.endianness);
        this.pos += 8;
        return val;
    }

    public readUint8(): number
    {
        return this.view.getUint8(this.pos++);
    }

    public readUint16(): number
    {
        var val = this.view.getUint16(this.pos, this.endianness);
        this.pos += 2;
        return val;
    }

    public readUint32(): number
    {
        var val = this.view.getUint32(this.pos, this.endianness);
        this.pos += 4;
        return val;
    }

    public readUint64(): bigint
    {
        var val = this.view.getBigUint64(this.pos, this.endianness);
        this.pos += 8;
        return val;
    }

    public readString(): string
    {
        var str = '';
        var char = '';
        while (char != '\0') {
            char = String.fromCharCode(this.view.getUint8(this.pos++));
            str += char;
        }
        this.pos++; // move one past the null terminator
        
        return str;
    }

    public writeInt8(value: number): void
    {
        this.view.setInt8(this.pos++, value);
    }

    public writeInt16(value: number): void
    {
        this.view.setInt16(this.pos, value, this.endianness);
        this.pos += 2;
    }

    public writeInt32(value: number): void
    {
        this.view.setInt32(this.pos, value, this.endianness);
        this.pos += 4;
    }

    public writeInt64(value: bigint): void
    {
        this.view.setBigInt64(this.pos, value, this.endianness);
        this.pos += 8;
    }

    public writeUint8(value: number): void
    {
        this.view.setInt8(this.pos++, value);
    }

    public writeUint16(value: number): void
    {
        this.view.setUint16(this.pos, value, this.endianness);
        this.pos += 2;
    }

    public writeUint32(value: number): void
    {
        this.view.setUint32(this.pos, value, this.endianness);
        this.pos += 4;
    }

    public writeUint64(value: bigint): void
    {
        this.view.setBigUint64(this.pos, value, this.endianness);
        this.pos += 8;
    }

    public writeFloat32(value: number): void
    {
        this.view.setFloat32(this.pos, value, this.endianness);
        this.pos += 4;
    }

    public writeFloat64(value: number): void
    {
        this.view.setFloat64(this.pos, value, this.endianness);
        this.pos += 8;
    }

    public writeString(value: string): void
    {
        var len = value.length;
        for (var i = 0; i < len; ++i)
        {
            this.view.setUint8(this.pos++, value.charCodeAt(i));
        }

        // Add null terminator
        this.view.setUint8(this.pos++, 0);
    }

    public writeCharStar(str: string): void
    {
        var ptr = charStarCounter++;
        charStars.set(ptr, str);
        this.view.setBigUint64(this.pos, BigInt(ptr));
        this.pos += 8;
    }

    public rewind(): void
    {
        this.pos = 0;
    }
}

