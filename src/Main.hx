package;

import io.colyseus.Client;
import io.colyseus.Room;

import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class Container extends Schema {
	@:type("map", "string")
	public var testMap: MapSchema<String> = new MapSchema<String>();

	@:type("array", "number")
	public var testArray: ArraySchema<Dynamic> = new ArraySchema<Dynamic>();

}

class State extends Schema {
	@:type("ref", Container)
	public var container: Container = new Container();

}

class Main extends hxd.App {
	private var client = new Client("ws://localhost:2567");
	private var room: Room<State>;

	override function init() {
		this.client.joinOrCreate("lobby", [], State, function(err, room) {
      if (err != null) {
        trace(err);
        return;
      }
			room.state.container.onChange = function(v) trace('Root.onChange', v);
			room.state.container.testMap.onChange = function(v, k) trace('Map.onChange', v, 'key', k);
			room.state.container.testMap.onAdd = function(v, k) trace('Map.onAdd', v, 'key', k);
      room.state.container.testMap.onRemove = function(v, k) trace('Map.onRemove', v, 'key', k);
			room.state.container.testArray.onChange = function(v, k) trace('Array.onChange', v, 'key', k);
			room.state.container.testArray.onAdd = function(v, k) trace('Array.onAdd', v, 'key', k);
			room.state.container.testArray.onRemove = function(v, k) trace('Array.onRemove', v, 'key', k);

      this.room = room;
    });

    var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		tf.text = "Hello World !";
	}

	public static function main() {
		new Main();
	}
}
