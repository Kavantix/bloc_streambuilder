# bloc_streambuilder

 A stream builder that uses the value of a ValueObservable as initial data.
 This builder in combination with ValueSubject makes sure that the streambuilder does not need to build twice when the stream already has a value.
 
## Example

```dart

     ValueObservable<int> stream = ValueSubject(seedValue: 0);

     ValueObservableBuilder(
       builder: (context, snapshot) { // Only called once and immediately with data if the stream has data

         print(
             "Build called with data: ${snapshot.data}, connectionState: ${snapshot.connectionState}"
         ); // First time it prints "Build called with data: 0, connectionState: ConnectionState.active"

         return new Text('${snapshot.data}');
       },
       stream: stream,
     )
```
