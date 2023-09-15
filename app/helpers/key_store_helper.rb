module KeyStoreHelper
    class ListNode
        attr_accessor :next
        attr_accessor :prev
        attr_accessor :timestamp
        attr_reader :value

        def initialize(value, timestamp)
            @value = value
            @timestamp = timestamp
            @next = nil
            @prev = nil
        end
    end

    class List
        def initialize
            @head = nil
            @tail = nil
        end

        def add(value, timestamp)
            node = ListNode.new(value, timestamp)
            addNode(node)
            return node
        end

        def addNode(node)
            if @head == nil
                @head = node
                @tail = node
            else
                node.prev = @tail
                @tail.next = node
                @tail = node
            end
        end

        def remove(node)
            if node.next != nil
                node.next.prev = node.prev
            else
                @tail = node.prev
            end

            if node.prev != nil
                node.prev.next = node.next
            else
                @head = node.next
            end
        end

        def update(node)
            if node.prev != nil
                node.prev.next = node.next
            else
                @head = node.next
            end

            if node.next != nil
                node.next.prev = node.prev
            else
                @tail = node.prev
            end

            if head == nil
                @head = node
                @tail = node
            else
                node.prev = @tail
                @tail.next = node
                @tail = node
            end
        end
    end

    class Cache
        def initialize
            @array = []
            @list = List.new
            @map = {}
        end

        def add(key, timestamp)
            node = @list.add(key, timestamp)
            @array.push(node)
            @map[key] = @array.length() -1

            return node
        end

        def remove(key)
            index = @map[key]
            if index == nil
                return false
            end

            node = @array[index]
            @list.remove(node)

            #remove from array
            last_node = @array.last
            @array[index] = last_node
            @map[last_node.value] = index
            @array.pop

            return true
        end

        def update(key)
            node = @map[key]
            if node
                node.timestamp = Time.now
                @list.update(node)

                return true
            end

            return false
        end

        def getRandom
            node = @array.sample
            if node == nil
                return nil
            end

            return { key: node.value, lastUpdate: node.timestamp}
        end

        def length
            @array.length()
        end

        def purgeOld(timeout)
            current_node = @list.head
            current_time = Time.now

            purge_list = []
            while current_node != nil
                if (current_time - current_node.timestamp).in_milliseconds > timeout
                    purge_list.push(current_node.value)
                else
                    break
                end
                current_node = current_node.next
            end

            purge_list.each do |key|
                remove(key)
            end
        end
    end

    AVAILABLE_KEYS = Cache.new
    BLOCKED_KEYS = Cache.new
end
